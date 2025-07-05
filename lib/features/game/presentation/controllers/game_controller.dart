import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:adisyonapp/features/game/domain/entities/game.dart';
import 'package:adisyonapp/features/game/domain/entities/player.dart';
import 'package:adisyonapp/core/utils/ui_state.dart';
import 'package:adisyonapp/core/database/database_helper.dart';
import 'package:adisyonapp/features/tournament/presentation/controllers/tournament_controller.dart';

final gameControllerProvider =
    StateNotifierProvider<GameController, UiState<Game>>((ref) {
  return GameController(ref);
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

final ongoingTournamentGameProvider = FutureProvider.family<Game?, String?>((ref, tournamentId) async {
  final dbHelper = DatabaseHelper();
  final games = await dbHelper.getAllGames();
  try {
    return games.firstWhere((game) => 
      game.status == GameStatus.inProgress && 
      game.tournamentId == tournamentId
    );
  } catch (e) {
    return null;
  }
});

final ongoingRegularGameProvider = FutureProvider<Game?>((ref) async {
  final dbHelper = DatabaseHelper();
  final games = await dbHelper.getAllGames();
  try {
    return games.firstWhere((game) => 
      game.status == GameStatus.inProgress && 
      game.tournamentId == null
    );
  } catch (e) {
    return null;
  }
});

final showScoresProvider = StateNotifierProvider<ShowScoresNotifier, bool>((ref) {
  return ShowScoresNotifier();
});

final sortScoresProvider = StateNotifierProvider<SortScoresNotifier, bool>((ref) {
  return SortScoresNotifier();
});

class GameController extends StateNotifier<UiState<Game>> {
  final _dbHelper = DatabaseHelper();
  final Ref ref;

  GameController(this.ref) : super(const UiState.initial());

  void createGame({
    required String name,
    required GameMode mode,
    required List<String> playerNames,
    int? totalRounds,
    Game? existingGame, // Mevcut oyunu devam ettirmek için
    String? tournamentId, // Turnuva ID'si
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

    // İlk oyuncuyu dağıtıcı olarak ayarla
    final playersWithDealer = players.asMap().entries.map((entry) {
      final index = entry.key;
      final player = entry.value;
      return player.copyWith(isDealer: index == 0);
    }).toList();

    final game = Game(
      id: const Uuid().v4(),
      name: name,
      mode: mode,
      players: playersWithDealer,
      totalRounds: totalRounds ?? 11,
      createdAt: DateTime.now().toIso8601String(),
      currentDealerIndex: 0,
      tournamentId: tournamentId,
    );

    state = UiState.success(game);
    saveGame(game);
    
    // Skor sıralamasını devre dışı bırak
    ref.read(sortScoresProvider.notifier).disableSorting();
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
        saveGame(updatedGame); // Skor eklendiğinde kaydet
      },
      orElse: () {},
    );
  }

  void nextRound() {
    state.maybeWhen(
      success: (game) async {
        if (game.currentRound <= game.totalRounds && canMoveToNextRound(game)) {
          if (game.currentRound == game.totalRounds) {
            final winner = determineWinner(game.players);
            final completedGame = game.copyWith(
              status: GameStatus.completed,
              winnerId: winner,
            );
            
            await saveGame(completedGame); // Oyun bittiğinde kaydet
            state = UiState.success(completedGame);
          } else {
            // Dağıtıcıyı bir sonraki oyuncuya geçir
            final nextDealerIndex = (game.currentDealerIndex + 1) % game.players.length;
            
            final updatedPlayers = game.players.asMap().entries.map((entry) {
              final index = entry.key;
              final player = entry.value;
              return player.copyWith(isDealer: index == nextDealerIndex);
            }).toList();
            
            final nextRoundGame = game.copyWith(
              currentRound: game.currentRound + 1,
              players: updatedPlayers,
              currentDealerIndex: nextDealerIndex,
            );
            await saveGame(nextRoundGame); // Yeni ele geçildiğinde kaydet
            state = UiState.success(nextRoundGame);
            
            // Skor sıralamasını etkinleştir
            ref.read(sortScoresProvider.notifier).enableSorting();
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

  String determineWinner(List<Player> players) {
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

          saveGame(updatedGame); // Son skoru geri alındığında kaydet
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

          saveGame(updatedGame); // Son skoru geri alındığında kaydet
          state = UiState.success(updatedGame);
        }
      },
      orElse: () {},
    );
  }

  void resetGame() {
    state.maybeWhen(
      success: (game) {
        final updatedPlayers = game.players.asMap().entries.map((entry) {
          final index = entry.key;
          final player = entry.value;
          return player.copyWith(
            roundScores: [],
            totalScore: 0,
            isDealer: index == 0,
          );
        }).toList();

        final updatedGame = game.copyWith(
          players: updatedPlayers,
          currentRound: 1,
          status: GameStatus.inProgress,
          winnerId: null,
          currentDealerIndex: 0,
        );

        saveGame(updatedGame); // Oyun sıfırlandığında kaydet
        state = UiState.success(updatedGame);
        
        // Skor sıralamasını devre dışı bırak
        ref.read(sortScoresProvider.notifier).disableSorting();
      },
      orElse: () {},
    );
  }

  Future<void> deleteGame(String gameId) async {
    await _dbHelper.deleteGame(gameId);
  }

  Future<void> saveGame(Game game) async {
    await _dbHelper.saveGame(game);
    if (game.status == GameStatus.completed) {
      ref.invalidate(gameHistoryProvider);
      // Turnuva oyunları için de invalidate et
      if (game.tournamentId != null) {
        ref.invalidate(ongoingTournamentGameProvider(game.tournamentId!));
        // Turnuva puanlarını güncelle
        await _dbHelper.updateTournamentScores(game.tournamentId!, game);
        // Turnuva puanları provider'ını invalidate et
        ref.invalidate(tournamentScoresProvider(game.tournamentId!));
      } else {
        ref.invalidate(ongoingRegularGameProvider);
      }
    }
  }
}

class ShowScoresNotifier extends StateNotifier<bool> {
  ShowScoresNotifier() : super(false);

  void toggle() {
    state = !state;
  }
}

class SortScoresNotifier extends StateNotifier<bool> {
  SortScoresNotifier() : super(false);

  void enableSorting() {
    state = true;
  }

  void disableSorting() {
    state = false;
  }
} 