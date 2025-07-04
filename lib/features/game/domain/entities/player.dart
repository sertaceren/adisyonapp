import 'package:freezed_annotation/freezed_annotation.dart';

part 'player.freezed.dart';
part 'player.g.dart';

@freezed
class Player with _$Player {
  const factory Player({
    required String id,
    required String name,
    @Default(0) int totalScore,
    @Default([]) List<int> roundScores,
    @Default(false) bool isDealer,
  }) = _Player;

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);
}

@freezed
class SavedPlayer with _$SavedPlayer {
  const factory SavedPlayer({
    required String id,
    required String name,
    @Default(true) bool isActive,
    @Default('') String createdAt,
  }) = _SavedPlayer;

  factory SavedPlayer.fromJson(Map<String, dynamic> json) => _$SavedPlayerFromJson(json);
} 