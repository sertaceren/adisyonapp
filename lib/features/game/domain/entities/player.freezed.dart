// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Player _$PlayerFromJson(Map<String, dynamic> json) {
  return _Player.fromJson(json);
}

/// @nodoc
mixin _$Player {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get totalScore => throw _privateConstructorUsedError;
  List<int> get roundScores => throw _privateConstructorUsedError;
  bool get isDealer => throw _privateConstructorUsedError;

  /// Serializes this Player to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Player
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlayerCopyWith<Player> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerCopyWith<$Res> {
  factory $PlayerCopyWith(Player value, $Res Function(Player) then) =
      _$PlayerCopyWithImpl<$Res, Player>;
  @useResult
  $Res call(
      {String id,
      String name,
      int totalScore,
      List<int> roundScores,
      bool isDealer});
}

/// @nodoc
class _$PlayerCopyWithImpl<$Res, $Val extends Player>
    implements $PlayerCopyWith<$Res> {
  _$PlayerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Player
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? totalScore = null,
    Object? roundScores = null,
    Object? isDealer = null,
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
      totalScore: null == totalScore
          ? _value.totalScore
          : totalScore // ignore: cast_nullable_to_non_nullable
              as int,
      roundScores: null == roundScores
          ? _value.roundScores
          : roundScores // ignore: cast_nullable_to_non_nullable
              as List<int>,
      isDealer: null == isDealer
          ? _value.isDealer
          : isDealer // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlayerImplCopyWith<$Res> implements $PlayerCopyWith<$Res> {
  factory _$$PlayerImplCopyWith(
          _$PlayerImpl value, $Res Function(_$PlayerImpl) then) =
      __$$PlayerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      int totalScore,
      List<int> roundScores,
      bool isDealer});
}

/// @nodoc
class __$$PlayerImplCopyWithImpl<$Res>
    extends _$PlayerCopyWithImpl<$Res, _$PlayerImpl>
    implements _$$PlayerImplCopyWith<$Res> {
  __$$PlayerImplCopyWithImpl(
      _$PlayerImpl _value, $Res Function(_$PlayerImpl) _then)
      : super(_value, _then);

  /// Create a copy of Player
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? totalScore = null,
    Object? roundScores = null,
    Object? isDealer = null,
  }) {
    return _then(_$PlayerImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      totalScore: null == totalScore
          ? _value.totalScore
          : totalScore // ignore: cast_nullable_to_non_nullable
              as int,
      roundScores: null == roundScores
          ? _value._roundScores
          : roundScores // ignore: cast_nullable_to_non_nullable
              as List<int>,
      isDealer: null == isDealer
          ? _value.isDealer
          : isDealer // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlayerImpl implements _Player {
  const _$PlayerImpl(
      {required this.id,
      required this.name,
      this.totalScore = 0,
      final List<int> roundScores = const [],
      this.isDealer = false})
      : _roundScores = roundScores;

  factory _$PlayerImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlayerImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  @JsonKey()
  final int totalScore;
  final List<int> _roundScores;
  @override
  @JsonKey()
  List<int> get roundScores {
    if (_roundScores is EqualUnmodifiableListView) return _roundScores;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_roundScores);
  }

  @override
  @JsonKey()
  final bool isDealer;

  @override
  String toString() {
    return 'Player(id: $id, name: $name, totalScore: $totalScore, roundScores: $roundScores, isDealer: $isDealer)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.totalScore, totalScore) ||
                other.totalScore == totalScore) &&
            const DeepCollectionEquality()
                .equals(other._roundScores, _roundScores) &&
            (identical(other.isDealer, isDealer) ||
                other.isDealer == isDealer));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, totalScore,
      const DeepCollectionEquality().hash(_roundScores), isDealer);

  /// Create a copy of Player
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerImplCopyWith<_$PlayerImpl> get copyWith =>
      __$$PlayerImplCopyWithImpl<_$PlayerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlayerImplToJson(
      this,
    );
  }
}

abstract class _Player implements Player {
  const factory _Player(
      {required final String id,
      required final String name,
      final int totalScore,
      final List<int> roundScores,
      final bool isDealer}) = _$PlayerImpl;

  factory _Player.fromJson(Map<String, dynamic> json) = _$PlayerImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  int get totalScore;
  @override
  List<int> get roundScores;
  @override
  bool get isDealer;

  /// Create a copy of Player
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayerImplCopyWith<_$PlayerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SavedPlayer _$SavedPlayerFromJson(Map<String, dynamic> json) {
  return _SavedPlayer.fromJson(json);
}

/// @nodoc
mixin _$SavedPlayer {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;

  /// Serializes this SavedPlayer to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SavedPlayer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SavedPlayerCopyWith<SavedPlayer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SavedPlayerCopyWith<$Res> {
  factory $SavedPlayerCopyWith(
          SavedPlayer value, $Res Function(SavedPlayer) then) =
      _$SavedPlayerCopyWithImpl<$Res, SavedPlayer>;
  @useResult
  $Res call({String id, String name, bool isActive, String createdAt});
}

/// @nodoc
class _$SavedPlayerCopyWithImpl<$Res, $Val extends SavedPlayer>
    implements $SavedPlayerCopyWith<$Res> {
  _$SavedPlayerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SavedPlayer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? isActive = null,
    Object? createdAt = null,
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
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SavedPlayerImplCopyWith<$Res>
    implements $SavedPlayerCopyWith<$Res> {
  factory _$$SavedPlayerImplCopyWith(
          _$SavedPlayerImpl value, $Res Function(_$SavedPlayerImpl) then) =
      __$$SavedPlayerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, bool isActive, String createdAt});
}

/// @nodoc
class __$$SavedPlayerImplCopyWithImpl<$Res>
    extends _$SavedPlayerCopyWithImpl<$Res, _$SavedPlayerImpl>
    implements _$$SavedPlayerImplCopyWith<$Res> {
  __$$SavedPlayerImplCopyWithImpl(
      _$SavedPlayerImpl _value, $Res Function(_$SavedPlayerImpl) _then)
      : super(_value, _then);

  /// Create a copy of SavedPlayer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? isActive = null,
    Object? createdAt = null,
  }) {
    return _then(_$SavedPlayerImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SavedPlayerImpl implements _SavedPlayer {
  const _$SavedPlayerImpl(
      {required this.id,
      required this.name,
      this.isActive = true,
      this.createdAt = ''});

  factory _$SavedPlayerImpl.fromJson(Map<String, dynamic> json) =>
      _$$SavedPlayerImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final String createdAt;

  @override
  String toString() {
    return 'SavedPlayer(id: $id, name: $name, isActive: $isActive, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SavedPlayerImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, isActive, createdAt);

  /// Create a copy of SavedPlayer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SavedPlayerImplCopyWith<_$SavedPlayerImpl> get copyWith =>
      __$$SavedPlayerImplCopyWithImpl<_$SavedPlayerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SavedPlayerImplToJson(
      this,
    );
  }
}

abstract class _SavedPlayer implements SavedPlayer {
  const factory _SavedPlayer(
      {required final String id,
      required final String name,
      final bool isActive,
      final String createdAt}) = _$SavedPlayerImpl;

  factory _SavedPlayer.fromJson(Map<String, dynamic> json) =
      _$SavedPlayerImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  bool get isActive;
  @override
  String get createdAt;

  /// Create a copy of SavedPlayer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SavedPlayerImplCopyWith<_$SavedPlayerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
