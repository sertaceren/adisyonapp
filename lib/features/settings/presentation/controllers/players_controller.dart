import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:adisyonapp/features/game/domain/entities/player.dart';
import 'package:adisyonapp/core/utils/ui_state.dart';
import 'package:adisyonapp/core/database/database_helper.dart';
import 'package:adisyonapp/core/errors/failures.dart';

final playersControllerProvider =
    StateNotifierProvider<PlayersController, UiState<List<SavedPlayer>>>((ref) {
  return PlayersController(ref);
});

class PlayersController extends StateNotifier<UiState<List<SavedPlayer>>> {
  final _dbHelper = DatabaseHelper();
  final Ref ref;

  PlayersController(this.ref) : super(const UiState.initial()) {
    loadPlayers();
  }

  Future<void> loadPlayers() async {
    state = const UiState.loading();
    try {
      final players = await _dbHelper.getAllSavedPlayers();
      state = UiState.success(players);
    } catch (e) {
      state = UiState.error(UnexpectedFailure(message: e.toString()));
    }
  }

  Future<void> addPlayer(String name) async {
    final newPlayer = SavedPlayer(
      id: const Uuid().v4(),
      name: name,
      createdAt: DateTime.now().toIso8601String(),
    );

    try {
      await _dbHelper.saveSavedPlayer(newPlayer);
      await loadPlayers();
    } catch (e) {
      state = UiState.error(UnexpectedFailure(message: e.toString()));
    }
  }

  Future<void> updatePlayer(String id, String name) async {
    state.maybeWhen(
      success: (players) async {
        final updatedPlayers = players.map((player) {
          if (player.id == id) {
            return player.copyWith(name: name);
          }
          return player;
        }).toList();

        try {
          final updatedPlayer = updatedPlayers.firstWhere((p) => p.id == id);
          await _dbHelper.saveSavedPlayer(updatedPlayer);
          state = UiState.success(updatedPlayers);
        } catch (e) {
          state = UiState.error(UnexpectedFailure(message: e.toString()));
        }
      },
      orElse: () {},
    );
  }

  Future<void> togglePlayerStatus(String id) async {
    state.maybeWhen(
      success: (players) async {
        final updatedPlayers = players.map((player) {
          if (player.id == id) {
            return player.copyWith(isActive: !player.isActive);
          }
          return player;
        }).toList();

        try {
          final updatedPlayer = updatedPlayers.firstWhere((p) => p.id == id);
          await _dbHelper.saveSavedPlayer(updatedPlayer);
          state = UiState.success(updatedPlayers);
        } catch (e) {
          state = UiState.error(UnexpectedFailure(message: e.toString()));
        }
      },
      orElse: () {},
    );
  }

  Future<void> deletePlayer(String id) async {
    try {
      await _dbHelper.deleteSavedPlayer(id);
      await loadPlayers();
    } catch (e) {
      state = UiState.error(UnexpectedFailure(message: e.toString()));
    }
  }
} 