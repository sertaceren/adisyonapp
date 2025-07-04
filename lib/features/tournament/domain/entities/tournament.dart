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
  }) = _Tournament;

  factory Tournament.fromJson(Map<String, dynamic> json) => _$TournamentFromJson(json);
} 