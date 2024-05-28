// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'location.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ApiLocation _$ApiLocationFromJson(Map<String, dynamic> json) {
  return _ApiLocation.fromJson(json);
}

/// @nodoc
mixin _$ApiLocation {
  String get id => throw _privateConstructorUsedError;
  String get user_id => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  int? get user_state => throw _privateConstructorUsedError;
  int? get created_at => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ApiLocationCopyWith<ApiLocation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiLocationCopyWith<$Res> {
  factory $ApiLocationCopyWith(
          ApiLocation value, $Res Function(ApiLocation) then) =
      _$ApiLocationCopyWithImpl<$Res, ApiLocation>;
  @useResult
  $Res call(
      {String id,
      String user_id,
      double latitude,
      double longitude,
      int? user_state,
      int? created_at});
}

/// @nodoc
class _$ApiLocationCopyWithImpl<$Res, $Val extends ApiLocation>
    implements $ApiLocationCopyWith<$Res> {
  _$ApiLocationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? user_id = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? user_state = freezed,
    Object? created_at = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      user_id: null == user_id
          ? _value.user_id
          : user_id // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      user_state: freezed == user_state
          ? _value.user_state
          : user_state // ignore: cast_nullable_to_non_nullable
              as int?,
      created_at: freezed == created_at
          ? _value.created_at
          : created_at // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ApiLocationImplCopyWith<$Res>
    implements $ApiLocationCopyWith<$Res> {
  factory _$$ApiLocationImplCopyWith(
          _$ApiLocationImpl value, $Res Function(_$ApiLocationImpl) then) =
      __$$ApiLocationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String user_id,
      double latitude,
      double longitude,
      int? user_state,
      int? created_at});
}

/// @nodoc
class __$$ApiLocationImplCopyWithImpl<$Res>
    extends _$ApiLocationCopyWithImpl<$Res, _$ApiLocationImpl>
    implements _$$ApiLocationImplCopyWith<$Res> {
  __$$ApiLocationImplCopyWithImpl(
      _$ApiLocationImpl _value, $Res Function(_$ApiLocationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? user_id = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? user_state = freezed,
    Object? created_at = freezed,
  }) {
    return _then(_$ApiLocationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      user_id: null == user_id
          ? _value.user_id
          : user_id // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      user_state: freezed == user_state
          ? _value.user_state
          : user_state // ignore: cast_nullable_to_non_nullable
              as int?,
      created_at: freezed == created_at
          ? _value.created_at
          : created_at // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ApiLocationImpl extends _ApiLocation with DiagnosticableTreeMixin {
  const _$ApiLocationImpl(
      {required this.id,
      required this.user_id,
      required this.latitude,
      required this.longitude,
      this.user_state,
      this.created_at})
      : super._();

  factory _$ApiLocationImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApiLocationImplFromJson(json);

  @override
  final String id;
  @override
  final String user_id;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final int? user_state;
  @override
  final int? created_at;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ApiLocation(id: $id, user_id: $user_id, latitude: $latitude, longitude: $longitude, user_state: $user_state, created_at: $created_at)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ApiLocation'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('user_id', user_id))
      ..add(DiagnosticsProperty('latitude', latitude))
      ..add(DiagnosticsProperty('longitude', longitude))
      ..add(DiagnosticsProperty('user_state', user_state))
      ..add(DiagnosticsProperty('created_at', created_at));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApiLocationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.user_id, user_id) || other.user_id == user_id) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.user_state, user_state) ||
                other.user_state == user_state) &&
            (identical(other.created_at, created_at) ||
                other.created_at == created_at));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, user_id, latitude, longitude, user_state, created_at);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ApiLocationImplCopyWith<_$ApiLocationImpl> get copyWith =>
      __$$ApiLocationImplCopyWithImpl<_$ApiLocationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApiLocationImplToJson(
      this,
    );
  }
}

abstract class _ApiLocation extends ApiLocation {
  const factory _ApiLocation(
      {required final String id,
      required final String user_id,
      required final double latitude,
      required final double longitude,
      final int? user_state,
      final int? created_at}) = _$ApiLocationImpl;
  const _ApiLocation._() : super._();

  factory _ApiLocation.fromJson(Map<String, dynamic> json) =
      _$ApiLocationImpl.fromJson;

  @override
  String get id;
  @override
  String get user_id;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  int? get user_state;
  @override
  int? get created_at;
  @override
  @JsonKey(ignore: true)
  _$$ApiLocationImplCopyWith<_$ApiLocationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
