// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tournament.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Tournament _$TournamentFromJson(Map<String, dynamic> json) {
  return _Tournament.fromJson(json);
}

/// @nodoc
mixin _$Tournament {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  TournamentType get type => throw _privateConstructorUsedError;
  TournamentStatus get status => throw _privateConstructorUsedError;
  List<SavedPlayer> get participants => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  String get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Tournament to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Tournament
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TournamentCopyWith<Tournament> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TournamentCopyWith<$Res> {
  factory $TournamentCopyWith(
          Tournament value, $Res Function(Tournament) then) =
      _$TournamentCopyWithImpl<$Res, Tournament>;
  @useResult
  $Res call(
      {String id,
      String name,
      TournamentType type,
      TournamentStatus status,
      List<SavedPlayer> participants,
      String createdAt,
      String updatedAt});
}

/// @nodoc
class _$TournamentCopyWithImpl<$Res, $Val extends Tournament>
    implements $TournamentCopyWith<$Res> {
  _$TournamentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Tournament
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? status = null,
    Object? participants = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TournamentType,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TournamentStatus,
      participants: null == participants
          ? _value.participants
          : participants // ignore: cast_nullable_to_non_nullable
              as List<SavedPlayer>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TournamentImplCopyWith<$Res>
    implements $TournamentCopyWith<$Res> {
  factory _$$TournamentImplCopyWith(
          _$TournamentImpl value, $Res Function(_$TournamentImpl) then) =
      __$$TournamentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      TournamentType type,
      TournamentStatus status,
      List<SavedPlayer> participants,
      String createdAt,
      String updatedAt});
}

/// @nodoc
class __$$TournamentImplCopyWithImpl<$Res>
    extends _$TournamentCopyWithImpl<$Res, _$TournamentImpl>
    implements _$$TournamentImplCopyWith<$Res> {
  __$$TournamentImplCopyWithImpl(
      _$TournamentImpl _value, $Res Function(_$TournamentImpl) _then)
      : super(_value, _then);

  /// Create a copy of Tournament
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? status = null,
    Object? participants = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$TournamentImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TournamentType,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TournamentStatus,
      participants: null == participants
          ? _value._participants
          : participants // ignore: cast_nullable_to_non_nullable
              as List<SavedPlayer>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TournamentImpl implements _Tournament {
  const _$TournamentImpl(
      {required this.id,
      required this.name,
      required this.type,
      this.status = TournamentStatus.upcoming,
      required final List<SavedPlayer> participants,
      this.createdAt = '',
      this.updatedAt = ''})
      : _participants = participants;

  factory _$TournamentImpl.fromJson(Map<String, dynamic> json) =>
      _$$TournamentImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final TournamentType type;
  @override
  @JsonKey()
  final TournamentStatus status;
  final List<SavedPlayer> _participants;
  @override
  List<SavedPlayer> get participants {
    if (_participants is EqualUnmodifiableListView) return _participants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_participants);
  }

  @override
  @JsonKey()
  final String createdAt;
  @override
  @JsonKey()
  final String updatedAt;

  @override
  String toString() {
    return 'Tournament(id: $id, name: $name, type: $type, status: $status, participants: $participants, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TournamentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality()
                .equals(other._participants, _participants) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, type, status,
      const DeepCollectionEquality().hash(_participants), createdAt, updatedAt);

  /// Create a copy of Tournament
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TournamentImplCopyWith<_$TournamentImpl> get copyWith =>
      __$$TournamentImplCopyWithImpl<_$TournamentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TournamentImplToJson(
      this,
    );
  }
}

abstract class _Tournament implements Tournament {
  const factory _Tournament(
      {required final String id,
      required final String name,
      required final TournamentType type,
      final TournamentStatus status,
      required final List<SavedPlayer> participants,
      final String createdAt,
      final String updatedAt}) = _$TournamentImpl;

  factory _Tournament.fromJson(Map<String, dynamic> json) =
      _$TournamentImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  TournamentType get type;
  @override
  TournamentStatus get status;
  @override
  List<SavedPlayer> get participants;
  @override
  String get createdAt;
  @override
  String get updatedAt;

  /// Create a copy of Tournament
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TournamentImplCopyWith<_$TournamentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
