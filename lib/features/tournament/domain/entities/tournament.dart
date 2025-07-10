import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:adisyonapp/features/game/domain/entities/player.dart';

part 'tournament.freezed.dart';
part 'tournament.g.dart';

enum TournamentStatus {
  upcoming,
  inProgress,
  completed
}

enum TournamentType {
  individual,
  team
}

@freezed
class Tournament with _$Tournament {
  const factory Tournament({
    required String id,
    required String name,
    required TournamentType type,
    @Default(TournamentStatus.upcoming) TournamentStatus status,
    required List<SavedPlayer> participants,
    @Default('') String createdAt,
    @Default('') String updatedAt,
    @Default('') String startedAt,
    @Default('') String completedAt,
  }) = _Tournament;

  factory Tournament.fromJson(Map<String, dynamic> json) => _$TournamentFromJson(json);
}

@freezed
class TournamentScore with _$TournamentScore {
  const factory TournamentScore({
    required String id,
    required String tournamentId,
    required String playerName,
    @Default(0) int totalPoints,
    @Default(0) int gamesPlayed,
    @Default(0) int firstPlaceCount,
    @Default(0) int secondPlaceCount,
    @Default(0) int thirdPlaceCount,
    @Default('') String createdAt,
  }) = _TournamentScore;

  factory TournamentScore.fromJson(Map<String, dynamic> json) => _$TournamentScoreFromJson(json);
} 