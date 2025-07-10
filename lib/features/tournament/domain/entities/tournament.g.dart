// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tournament.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TournamentImpl _$$TournamentImplFromJson(Map<String, dynamic> json) =>
    _$TournamentImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      type: $enumDecode(_$TournamentTypeEnumMap, json['type']),
      status: $enumDecodeNullable(_$TournamentStatusEnumMap, json['status']) ??
          TournamentStatus.upcoming,
      participants: (json['participants'] as List<dynamic>)
          .map((e) => SavedPlayer.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
      startedAt: json['startedAt'] as String? ?? '',
      completedAt: json['completedAt'] as String? ?? '',
    );

Map<String, dynamic> _$$TournamentImplToJson(_$TournamentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': _$TournamentTypeEnumMap[instance.type]!,
      'status': _$TournamentStatusEnumMap[instance.status]!,
      'participants': instance.participants,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'startedAt': instance.startedAt,
      'completedAt': instance.completedAt,
    };

const _$TournamentTypeEnumMap = {
  TournamentType.individual: 'individual',
  TournamentType.team: 'team',
};

const _$TournamentStatusEnumMap = {
  TournamentStatus.upcoming: 'upcoming',
  TournamentStatus.inProgress: 'inProgress',
  TournamentStatus.completed: 'completed',
};

_$TournamentScoreImpl _$$TournamentScoreImplFromJson(
        Map<String, dynamic> json) =>
    _$TournamentScoreImpl(
      id: json['id'] as String,
      tournamentId: json['tournamentId'] as String,
      playerName: json['playerName'] as String,
      totalPoints: (json['totalPoints'] as num?)?.toInt() ?? 0,
      gamesPlayed: (json['gamesPlayed'] as num?)?.toInt() ?? 0,
      firstPlaceCount: (json['firstPlaceCount'] as num?)?.toInt() ?? 0,
      secondPlaceCount: (json['secondPlaceCount'] as num?)?.toInt() ?? 0,
      thirdPlaceCount: (json['thirdPlaceCount'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] as String? ?? '',
    );

Map<String, dynamic> _$$TournamentScoreImplToJson(
        _$TournamentScoreImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tournamentId': instance.tournamentId,
      'playerName': instance.playerName,
      'totalPoints': instance.totalPoints,
      'gamesPlayed': instance.gamesPlayed,
      'firstPlaceCount': instance.firstPlaceCount,
      'secondPlaceCount': instance.secondPlaceCount,
      'thirdPlaceCount': instance.thirdPlaceCount,
      'createdAt': instance.createdAt,
    };
