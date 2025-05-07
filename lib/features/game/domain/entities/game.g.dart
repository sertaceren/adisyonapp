// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GameImpl _$$GameImplFromJson(Map<String, dynamic> json) => _$GameImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      mode: $enumDecode(_$GameModeEnumMap, json['mode']),
      status: $enumDecodeNullable(_$GameStatusEnumMap, json['status']) ??
          GameStatus.inProgress,
      players: (json['players'] as List<dynamic>)
          .map((e) => Player.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentRound: (json['currentRound'] as num?)?.toInt() ?? 1,
      totalRounds: (json['totalRounds'] as num?)?.toInt() ?? 10,
      winnerId: json['winnerId'] as String?,
      createdAt: json['createdAt'] as String? ?? '',
    );

Map<String, dynamic> _$$GameImplToJson(_$GameImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'mode': _$GameModeEnumMap[instance.mode]!,
      'status': _$GameStatusEnumMap[instance.status]!,
      'players': instance.players,
      'currentRound': instance.currentRound,
      'totalRounds': instance.totalRounds,
      'winnerId': instance.winnerId,
      'createdAt': instance.createdAt,
    };

const _$GameModeEnumMap = {
  GameMode.individual: 'individual',
  GameMode.team: 'team',
};

const _$GameStatusEnumMap = {
  GameStatus.inProgress: 'inProgress',
  GameStatus.completed: 'completed',
};

_$TeamImpl _$$TeamImplFromJson(Map<String, dynamic> json) => _$TeamImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      players: (json['players'] as List<dynamic>)
          .map((e) => Player.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalScore: (json['totalScore'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$TeamImplToJson(_$TeamImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'players': instance.players,
      'totalScore': instance.totalScore,
    };
