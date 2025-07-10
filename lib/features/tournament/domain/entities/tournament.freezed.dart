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
  String get startedAt => throw _privateConstructorUsedError;
  String get completedAt => throw _privateConstructorUsedError;

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
      String updatedAt,
      String startedAt,
      String completedAt});
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
    Object? startedAt = null,
    Object? completedAt = null,
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
      startedAt: null == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as String,
      completedAt: null == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
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
      String updatedAt,
      String startedAt,
      String completedAt});
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
    Object? startedAt = null,
    Object? completedAt = null,
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
      startedAt: null == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as String,
      completedAt: null == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
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
      this.updatedAt = '',
      this.startedAt = '',
      this.completedAt = ''})
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
  @JsonKey()
  final String startedAt;
  @override
  @JsonKey()
  final String completedAt;

  @override
  String toString() {
    return 'Tournament(id: $id, name: $name, type: $type, status: $status, participants: $participants, createdAt: $createdAt, updatedAt: $updatedAt, startedAt: $startedAt, completedAt: $completedAt)';
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
                other.updatedAt == updatedAt) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      type,
      status,
      const DeepCollectionEquality().hash(_participants),
      createdAt,
      updatedAt,
      startedAt,
      completedAt);

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
      final String updatedAt,
      final String startedAt,
      final String completedAt}) = _$TournamentImpl;

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
  @override
  String get startedAt;
  @override
  String get completedAt;

  /// Create a copy of Tournament
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TournamentImplCopyWith<_$TournamentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TournamentScore _$TournamentScoreFromJson(Map<String, dynamic> json) {
  return _TournamentScore.fromJson(json);
}

/// @nodoc
mixin _$TournamentScore {
  String get id => throw _privateConstructorUsedError;
  String get tournamentId => throw _privateConstructorUsedError;
  String get playerName => throw _privateConstructorUsedError;
  int get totalPoints => throw _privateConstructorUsedError;
  int get gamesPlayed => throw _privateConstructorUsedError;
  int get firstPlaceCount => throw _privateConstructorUsedError;
  int get secondPlaceCount => throw _privateConstructorUsedError;
  int get thirdPlaceCount => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;

  /// Serializes this TournamentScore to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TournamentScore
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TournamentScoreCopyWith<TournamentScore> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TournamentScoreCopyWith<$Res> {
  factory $TournamentScoreCopyWith(
          TournamentScore value, $Res Function(TournamentScore) then) =
      _$TournamentScoreCopyWithImpl<$Res, TournamentScore>;
  @useResult
  $Res call(
      {String id,
      String tournamentId,
      String playerName,
      int totalPoints,
      int gamesPlayed,
      int firstPlaceCount,
      int secondPlaceCount,
      int thirdPlaceCount,
      String createdAt});
}

/// @nodoc
class _$TournamentScoreCopyWithImpl<$Res, $Val extends TournamentScore>
    implements $TournamentScoreCopyWith<$Res> {
  _$TournamentScoreCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TournamentScore
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tournamentId = null,
    Object? playerName = null,
    Object? totalPoints = null,
    Object? gamesPlayed = null,
    Object? firstPlaceCount = null,
    Object? secondPlaceCount = null,
    Object? thirdPlaceCount = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      tournamentId: null == tournamentId
          ? _value.tournamentId
          : tournamentId // ignore: cast_nullable_to_non_nullable
              as String,
      playerName: null == playerName
          ? _value.playerName
          : playerName // ignore: cast_nullable_to_non_nullable
              as String,
      totalPoints: null == totalPoints
          ? _value.totalPoints
          : totalPoints // ignore: cast_nullable_to_non_nullable
              as int,
      gamesPlayed: null == gamesPlayed
          ? _value.gamesPlayed
          : gamesPlayed // ignore: cast_nullable_to_non_nullable
              as int,
      firstPlaceCount: null == firstPlaceCount
          ? _value.firstPlaceCount
          : firstPlaceCount // ignore: cast_nullable_to_non_nullable
              as int,
      secondPlaceCount: null == secondPlaceCount
          ? _value.secondPlaceCount
          : secondPlaceCount // ignore: cast_nullable_to_non_nullable
              as int,
      thirdPlaceCount: null == thirdPlaceCount
          ? _value.thirdPlaceCount
          : thirdPlaceCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TournamentScoreImplCopyWith<$Res>
    implements $TournamentScoreCopyWith<$Res> {
  factory _$$TournamentScoreImplCopyWith(_$TournamentScoreImpl value,
          $Res Function(_$TournamentScoreImpl) then) =
      __$$TournamentScoreImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String tournamentId,
      String playerName,
      int totalPoints,
      int gamesPlayed,
      int firstPlaceCount,
      int secondPlaceCount,
      int thirdPlaceCount,
      String createdAt});
}

/// @nodoc
class __$$TournamentScoreImplCopyWithImpl<$Res>
    extends _$TournamentScoreCopyWithImpl<$Res, _$TournamentScoreImpl>
    implements _$$TournamentScoreImplCopyWith<$Res> {
  __$$TournamentScoreImplCopyWithImpl(
      _$TournamentScoreImpl _value, $Res Function(_$TournamentScoreImpl) _then)
      : super(_value, _then);

  /// Create a copy of TournamentScore
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tournamentId = null,
    Object? playerName = null,
    Object? totalPoints = null,
    Object? gamesPlayed = null,
    Object? firstPlaceCount = null,
    Object? secondPlaceCount = null,
    Object? thirdPlaceCount = null,
    Object? createdAt = null,
  }) {
    return _then(_$TournamentScoreImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      tournamentId: null == tournamentId
          ? _value.tournamentId
          : tournamentId // ignore: cast_nullable_to_non_nullable
              as String,
      playerName: null == playerName
          ? _value.playerName
          : playerName // ignore: cast_nullable_to_non_nullable
              as String,
      totalPoints: null == totalPoints
          ? _value.totalPoints
          : totalPoints // ignore: cast_nullable_to_non_nullable
              as int,
      gamesPlayed: null == gamesPlayed
          ? _value.gamesPlayed
          : gamesPlayed // ignore: cast_nullable_to_non_nullable
              as int,
      firstPlaceCount: null == firstPlaceCount
          ? _value.firstPlaceCount
          : firstPlaceCount // ignore: cast_nullable_to_non_nullable
              as int,
      secondPlaceCount: null == secondPlaceCount
          ? _value.secondPlaceCount
          : secondPlaceCount // ignore: cast_nullable_to_non_nullable
              as int,
      thirdPlaceCount: null == thirdPlaceCount
          ? _value.thirdPlaceCount
          : thirdPlaceCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TournamentScoreImpl implements _TournamentScore {
  const _$TournamentScoreImpl(
      {required this.id,
      required this.tournamentId,
      required this.playerName,
      this.totalPoints = 0,
      this.gamesPlayed = 0,
      this.firstPlaceCount = 0,
      this.secondPlaceCount = 0,
      this.thirdPlaceCount = 0,
      this.createdAt = ''});

  factory _$TournamentScoreImpl.fromJson(Map<String, dynamic> json) =>
      _$$TournamentScoreImplFromJson(json);

  @override
  final String id;
  @override
  final String tournamentId;
  @override
  final String playerName;
  @override
  @JsonKey()
  final int totalPoints;
  @override
  @JsonKey()
  final int gamesPlayed;
  @override
  @JsonKey()
  final int firstPlaceCount;
  @override
  @JsonKey()
  final int secondPlaceCount;
  @override
  @JsonKey()
  final int thirdPlaceCount;
  @override
  @JsonKey()
  final String createdAt;

  @override
  String toString() {
    return 'TournamentScore(id: $id, tournamentId: $tournamentId, playerName: $playerName, totalPoints: $totalPoints, gamesPlayed: $gamesPlayed, firstPlaceCount: $firstPlaceCount, secondPlaceCount: $secondPlaceCount, thirdPlaceCount: $thirdPlaceCount, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TournamentScoreImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tournamentId, tournamentId) ||
                other.tournamentId == tournamentId) &&
            (identical(other.playerName, playerName) ||
                other.playerName == playerName) &&
            (identical(other.totalPoints, totalPoints) ||
                other.totalPoints == totalPoints) &&
            (identical(other.gamesPlayed, gamesPlayed) ||
                other.gamesPlayed == gamesPlayed) &&
            (identical(other.firstPlaceCount, firstPlaceCount) ||
                other.firstPlaceCount == firstPlaceCount) &&
            (identical(other.secondPlaceCount, secondPlaceCount) ||
                other.secondPlaceCount == secondPlaceCount) &&
            (identical(other.thirdPlaceCount, thirdPlaceCount) ||
                other.thirdPlaceCount == thirdPlaceCount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      tournamentId,
      playerName,
      totalPoints,
      gamesPlayed,
      firstPlaceCount,
      secondPlaceCount,
      thirdPlaceCount,
      createdAt);

  /// Create a copy of TournamentScore
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TournamentScoreImplCopyWith<_$TournamentScoreImpl> get copyWith =>
      __$$TournamentScoreImplCopyWithImpl<_$TournamentScoreImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TournamentScoreImplToJson(
      this,
    );
  }
}

abstract class _TournamentScore implements TournamentScore {
  const factory _TournamentScore(
      {required final String id,
      required final String tournamentId,
      required final String playerName,
      final int totalPoints,
      final int gamesPlayed,
      final int firstPlaceCount,
      final int secondPlaceCount,
      final int thirdPlaceCount,
      final String createdAt}) = _$TournamentScoreImpl;

  factory _TournamentScore.fromJson(Map<String, dynamic> json) =
      _$TournamentScoreImpl.fromJson;

  @override
  String get id;
  @override
  String get tournamentId;
  @override
  String get playerName;
  @override
  int get totalPoints;
  @override
  int get gamesPlayed;
  @override
  int get firstPlaceCount;
  @override
  int get secondPlaceCount;
  @override
  int get thirdPlaceCount;
  @override
  String get createdAt;

  /// Create a copy of TournamentScore
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TournamentScoreImplCopyWith<_$TournamentScoreImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
