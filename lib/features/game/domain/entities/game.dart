import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:adisyonapp/features/game/domain/entities/player.dart';

part 'game.freezed.dart';
part 'game.g.dart';

enum GameMode {
  individual,
  team
}

enum GameStatus {
  inProgress,
  completed
}

@freezed
class Game with _$Game {
  const factory Game({
    required String id,
    required String name,
    required GameMode mode,
    @Default(GameStatus.inProgress) GameStatus status,
    required List<Player> players,
    @Default(1) int currentRound,
    @Default(10) int totalRounds,
    String? winnerId,
    @Default('') String createdAt,
  }) = _Game;

  factory Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);
}

@freezed
class Team with _$Team {
  const factory Team({
    required String id,
    required String name,
    required List<Player> players,
    @Default(0) int totalScore,
  }) = _Team;

  factory Team.fromJson(Map<String, dynamic> json) => _$TeamFromJson(json);
} 