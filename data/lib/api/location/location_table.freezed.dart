// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'location_table.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LocationTable _$LocationTableFromJson(Map<String, dynamic> json) {
  return _LocationTable.fromJson(json);
}

/// @nodoc
mixin _$LocationTable {
  String get userId => throw _privateConstructorUsedError;
  String? get lastFiveMinutesLocations => throw _privateConstructorUsedError;
  String? get lastLocationJourney => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LocationTableCopyWith<LocationTable> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocationTableCopyWith<$Res> {
  factory $LocationTableCopyWith(
          LocationTable value, $Res Function(LocationTable) then) =
      _$LocationTableCopyWithImpl<$Res, LocationTable>;
  @useResult
  $Res call(
      {String userId,
      String? lastFiveMinutesLocations,
      String? lastLocationJourney});
}

/// @nodoc
class _$LocationTableCopyWithImpl<$Res, $Val extends LocationTable>
    implements $LocationTableCopyWith<$Res> {
  _$LocationTableCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? lastFiveMinutesLocations = freezed,
    Object? lastLocationJourney = freezed,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      lastFiveMinutesLocations: freezed == lastFiveMinutesLocations
          ? _value.lastFiveMinutesLocations
          : lastFiveMinutesLocations // ignore: cast_nullable_to_non_nullable
              as String?,
      lastLocationJourney: freezed == lastLocationJourney
          ? _value.lastLocationJourney
          : lastLocationJourney // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LocationTableImplCopyWith<$Res>
    implements $LocationTableCopyWith<$Res> {
  factory _$$LocationTableImplCopyWith(
          _$LocationTableImpl value, $Res Function(_$LocationTableImpl) then) =
      __$$LocationTableImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      String? lastFiveMinutesLocations,
      String? lastLocationJourney});
}

/// @nodoc
class __$$LocationTableImplCopyWithImpl<$Res>
    extends _$LocationTableCopyWithImpl<$Res, _$LocationTableImpl>
    implements _$$LocationTableImplCopyWith<$Res> {
  __$$LocationTableImplCopyWithImpl(
      _$LocationTableImpl _value, $Res Function(_$LocationTableImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? lastFiveMinutesLocations = freezed,
    Object? lastLocationJourney = freezed,
  }) {
    return _then(_$LocationTableImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      lastFiveMinutesLocations: freezed == lastFiveMinutesLocations
          ? _value.lastFiveMinutesLocations
          : lastFiveMinutesLocations // ignore: cast_nullable_to_non_nullable
              as String?,
      lastLocationJourney: freezed == lastLocationJourney
          ? _value.lastLocationJourney
          : lastLocationJourney // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LocationTableImpl extends _LocationTable {
  const _$LocationTableImpl(
      {required this.userId,
      this.lastFiveMinutesLocations,
      this.lastLocationJourney})
      : super._();

  factory _$LocationTableImpl.fromJson(Map<String, dynamic> json) =>
      _$$LocationTableImplFromJson(json);

  @override
  final String userId;
  @override
  final String? lastFiveMinutesLocations;
  @override
  final String? lastLocationJourney;

  @override
  String toString() {
    return 'LocationTable(userId: $userId, lastFiveMinutesLocations: $lastFiveMinutesLocations, lastLocationJourney: $lastLocationJourney)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocationTableImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(
                    other.lastFiveMinutesLocations, lastFiveMinutesLocations) ||
                other.lastFiveMinutesLocations == lastFiveMinutesLocations) &&
            (identical(other.lastLocationJourney, lastLocationJourney) ||
                other.lastLocationJourney == lastLocationJourney));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, userId, lastFiveMinutesLocations, lastLocationJourney);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LocationTableImplCopyWith<_$LocationTableImpl> get copyWith =>
      __$$LocationTableImplCopyWithImpl<_$LocationTableImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LocationTableImplToJson(
      this,
    );
  }
}

abstract class _LocationTable extends LocationTable {
  const factory _LocationTable(
      {required final String userId,
      final String? lastFiveMinutesLocations,
      final String? lastLocationJourney}) = _$LocationTableImpl;
  const _LocationTable._() : super._();

  factory _LocationTable.fromJson(Map<String, dynamic> json) =
      _$LocationTableImpl.fromJson;

  @override
  String get userId;
  @override
  String? get lastFiveMinutesLocations;
  @override
  String? get lastLocationJourney;
  @override
  @JsonKey(ignore: true)
  _$$LocationTableImplCopyWith<_$LocationTableImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
