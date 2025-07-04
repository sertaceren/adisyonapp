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
