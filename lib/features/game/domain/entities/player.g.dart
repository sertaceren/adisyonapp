// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlayerImpl _$$PlayerImplFromJson(Map<String, dynamic> json) => _$PlayerImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      totalScore: (json['totalScore'] as num?)?.toInt() ?? 0,
      roundScores: (json['roundScores'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      isDealer: json['isDealer'] as bool? ?? false,
    );

Map<String, dynamic> _$$PlayerImplToJson(_$PlayerImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'totalScore': instance.totalScore,
      'roundScores': instance.roundScores,
      'isDealer': instance.isDealer,
    };

_$SavedPlayerImpl _$$SavedPlayerImplFromJson(Map<String, dynamic> json) =>
    _$SavedPlayerImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] as String? ?? '',
    );

Map<String, dynamic> _$$SavedPlayerImplToJson(_$SavedPlayerImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt,
    };
