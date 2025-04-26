import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:adisyonapp/features/game/domain/entities/game.dart';
import 'package:adisyonapp/features/game/domain/entities/player.dart';
import 'package:adisyonapp/core/utils/ui_state.dart';
import 'package:adisyonapp/core/database/database_helper.dart';

final gameControllerProvider =
    StateNotifierProvider<GameController, UiState<Game>>((ref) {
  return GameController();
});

final gameHistoryProvider = FutureProvider<List<Game>>((ref) async {
  final dbHelper = DatabaseHelper();
  return await dbHelper.getAllGames();
});

final ongoingGameProvider = FutureProvider<Game?>((ref) async {
  final dbHelper = DatabaseHelper();
  final games = await dbHelper.getAllGames();
  try {
    return games.firstWhere((game) => game.status == GameStatus.inProgress);
  } catch (e) {
    return null;
  }
});

class GameController extends StateNotifier<UiState<Game>> {
  final _dbHelper = DatabaseHelper();

  GameController() : super(const UiState.initial());

  void createGame({
    required String name,
    required GameMode mode,
    required List<String> playerNames,
    int? totalRounds,
    Game? existingGame, // Mevcut oyunu devam ettirmek için
  }) {
    if (existingGame != null) {
      // Mevcut oyunu devam ettir
      state = UiState.success(existingGame);
      return;
    }

    final players = playerNames
        .map((name) => Player(
              id: const Uuid().v4(),
              name: name,
            ))
        .toList();

    final game = Game(
      id: const Uuid().v4(),
      name: name,
      mode: mode,
      players: players,
      totalRounds: totalRounds ?? 10,
    );

    state = UiState.success(game);
    _saveGame(game);
  }

  void addScore(String playerId, int score) {
    state.maybeWhen(
      success: (game) {
        if (game.status == GameStatus.completed) return;

        final updatedPlayers = game.players.map((player) {
          if (player.id == playerId) {
            final newRoundScores = [...player.roundScores, score];
            final newTotalScore =
                newRoundScores.fold<int>(0, (sum, score) => sum + score);

            return player.copyWith(
              roundScores: newRoundScores,
              totalScore: newTotalScore,
            );
          }
          return player;
        }).toList();

        final updatedGame = game.copyWith(
          players: updatedPlayers,
        );

        state = UiState.success(updatedGame);
        _saveGame(updatedGame); // Skor eklendiğinde kaydet
      },
      orElse: () {},
    );
  }

  void nextRound() {
    state.maybeWhen(
      success: (game) async {
        if (game.currentRound <= game.totalRounds && canMoveToNextRound(game)) {
          if (game.currentRound == game.totalRounds) {
            final winner = _determineWinner(game.players);
            final completedGame = game.copyWith(
              status: GameStatus.completed,
              winnerId: winner,
            );
            
            await _saveGame(completedGame); // Oyun bittiğinde kaydet
            state = UiState.success(completedGame);
          } else {
            final nextRoundGame = game.copyWith(
              currentRound: game.currentRound + 1,
            );
            await _saveGame(nextRoundGame); // Yeni ele geçildiğinde kaydet
            state = UiState.success(nextRoundGame);
          }
        }
      },
      orElse: () {},
    );
  }

  bool canMoveToNextRound(Game game) {
    return game.players.every((player) => 
      player.roundScores.length == game.currentRound);
  }

  String _determineWinner(List<Player> players) {
    if (players.isEmpty) return '';
    
    Player winner = players.first;
    for (var player in players) {
      if (player.totalScore < winner.totalScore) {
        winner = player;
      }
    }
    return winner.id;
  }

  void undoLastScore(String playerId) {
    state.maybeWhen(
      success: (game) {
        if (game.status == GameStatus.completed) {
          final updatedPlayers = game.players.map((player) {
            if (player.id == playerId && player.roundScores.isNotEmpty) {
              final newRoundScores = [...player.roundScores]..removeLast();
              final newTotalScore =
                  newRoundScores.fold<int>(0, (sum, score) => sum + score);

              return player.copyWith(
                roundScores: newRoundScores,
                totalScore: newTotalScore,
              );
            }
            return player;
          }).toList();

          final updatedGame = game.copyWith(
            players: updatedPlayers,
            status: GameStatus.inProgress,
            winnerId: null,
          );

          _saveGame(updatedGame); // Son skoru geri alındığında kaydet
          state = UiState.success(updatedGame);
        } else {
          final updatedPlayers = game.players.map((player) {
            if (player.id == playerId && player.roundScores.isNotEmpty) {
              final newRoundScores = [...player.roundScores]..removeLast();
              final newTotalScore =
                  newRoundScores.fold<int>(0, (sum, score) => sum + score);

              return player.copyWith(
                roundScores: newRoundScores,
                totalScore: newTotalScore,
              );
            }
            return player;
          }).toList();

          final updatedGame = game.copyWith(
            players: updatedPlayers,
          );

          _saveGame(updatedGame); // Son skoru geri alındığında kaydet
          state = UiState.success(updatedGame);
        }
      },
      orElse: () {},
    );
  }

  void resetGame() {
    state.maybeWhen(
      success: (game) {
        final updatedPlayers = game.players.map((player) {
          return player.copyWith(
            roundScores: [],
            totalScore: 0,
          );
        }).toList();

        final updatedGame = game.copyWith(
          players: updatedPlayers,
          currentRound: 1,
          status: GameStatus.inProgress,
          winnerId: null,
        );

        _saveGame(updatedGame); // Oyun sıfırlandığında kaydet
        state = UiState.success(updatedGame);
      },
      orElse: () {},
    );
  }

  Future<void> deleteGame(String gameId) async {
    await _dbHelper.deleteGame(gameId);
  }

  Future<void> _saveGame(Game game) async {
    await _dbHelper.saveGame(game);
  }
} 