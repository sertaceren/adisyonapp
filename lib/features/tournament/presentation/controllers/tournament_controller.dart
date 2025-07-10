import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:adisyonapp/features/tournament/domain/entities/tournament.dart';
import 'package:adisyonapp/features/game/domain/entities/player.dart';
import 'package:adisyonapp/core/utils/ui_state.dart';
import 'package:adisyonapp/core/database/database_helper.dart';
import 'package:adisyonapp/core/errors/failures.dart';

final tournamentsControllerProvider =
    StateNotifierProvider<TournamentsController, UiState<List<Tournament>>>((ref) {
  return TournamentsController(ref);
});

final tournamentScoresProvider = FutureProvider.family<List<TournamentScore>, String>((ref, tournamentId) async {
  final dbHelper = DatabaseHelper();
  return await dbHelper.getTournamentScores(tournamentId);
});

class TournamentsController extends StateNotifier<UiState<List<Tournament>>> {
  final _dbHelper = DatabaseHelper();
  final Ref ref;

  TournamentsController(this.ref) : super(const UiState.initial()) {
    loadTournaments();
  }

  Future<void> loadTournaments() async {
    state = const UiState.loading();
    try {
      final tournaments = await _dbHelper.getAllTournaments();
      state = UiState.success(tournaments);
    } catch (e) {
      state = UiState.error(UnexpectedFailure(message: e.toString()));
    }
  }

  Future<void> addTournament({
    required String name,
    required TournamentType type,
    required List<SavedPlayer> participants,
  }) async {
    final newTournament = Tournament(
      id: const Uuid().v4(),
      name: name,
      type: type,
      participants: participants,
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
    );

    try {
      await _dbHelper.saveTournament(newTournament);
      await loadTournaments();
    } catch (e) {
      state = UiState.error(UnexpectedFailure(message: e.toString()));
    }
  }

  Future<void> updateTournament(Tournament tournament) async {
    final updatedTournament = tournament.copyWith(
      updatedAt: DateTime.now().toIso8601String(),
    );

    try {
      await _dbHelper.saveTournament(updatedTournament);
      await loadTournaments();
    } catch (e) {
      state = UiState.error(UnexpectedFailure(message: e.toString()));
    }
  }

  Future<void> deleteTournament(String tournamentId) async {
    try {
      await _dbHelper.deleteTournament(tournamentId);
      await loadTournaments();
    } catch (e) {
      state = UiState.error(UnexpectedFailure(message: e.toString()));
    }
  }

  Future<void> startTournament(String tournamentId) async {
    state.maybeWhen(
      success: (tournaments) async {
        final updatedTournaments = tournaments.map((tournament) {
          if (tournament.id == tournamentId) {
            return tournament.copyWith(
              status: TournamentStatus.inProgress,
              updatedAt: DateTime.now().toIso8601String(),
              startedAt: DateTime.now().toIso8601String(),
            );
          }
          return tournament;
        }).toList();

        try {
          final updatedTournament = updatedTournaments.firstWhere((t) => t.id == tournamentId);
          await _dbHelper.saveTournament(updatedTournament);
          state = UiState.success(updatedTournaments);
        } catch (e) {
          state = UiState.error(UnexpectedFailure(message: e.toString()));
        }
      },
      orElse: () {},
    );
  }

  Future<void> completeTournament(String tournamentId) async {
    state.maybeWhen(
      success: (tournaments) async {
        final updatedTournaments = tournaments.map((tournament) {
          if (tournament.id == tournamentId) {
            return tournament.copyWith(
              status: TournamentStatus.completed,
              updatedAt: DateTime.now().toIso8601String(),
              completedAt: DateTime.now().toIso8601String(),
            );
          }
          return tournament;
        }).toList();

        try {
          final updatedTournament = updatedTournaments.firstWhere((t) => t.id == tournamentId);
          await _dbHelper.saveTournament(updatedTournament);
          state = UiState.success(updatedTournaments);
        } catch (e) {
          state = UiState.error(UnexpectedFailure(message: e.toString()));
        }
      },
      orElse: () {},
    );
  }
} 