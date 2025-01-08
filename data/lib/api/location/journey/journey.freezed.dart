// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'journey.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ApiLocationJourney _$ApiLocationJourneyFromJson(Map<String, dynamic> json) {
  return _LocationJourney.fromJson(json);
}

/// @nodoc
mixin _$ApiLocationJourney {
  String? get id => throw _privateConstructorUsedError;
  String get user_id => throw _privateConstructorUsedError;
  double get from_latitude => throw _privateConstructorUsedError;
  double get from_longitude => throw _privateConstructorUsedError;
  double? get to_latitude => throw _privateConstructorUsedError;
  double? get to_longitude => throw _privateConstructorUsedError;
  List<JourneyRoute> get routes => throw _privateConstructorUsedError;
  double? get route_distance => throw _privateConstructorUsedError;
  int? get route_duration => throw _privateConstructorUsedError;
  int get created_at => throw _privateConstructorUsedError;
  int get updated_at => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;

  /// Serializes this ApiLocationJourney to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ApiLocationJourney
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApiLocationJourneyCopyWith<ApiLocationJourney> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiLocationJourneyCopyWith<$Res> {
  factory $ApiLocationJourneyCopyWith(
          ApiLocationJourney value, $Res Function(ApiLocationJourney) then) =
      _$ApiLocationJourneyCopyWithImpl<$Res, ApiLocationJourney>;
  @useResult
  $Res call(
      {String? id,
      String user_id,
      double from_latitude,
      double from_longitude,
      double? to_latitude,
      double? to_longitude,
      List<JourneyRoute> routes,
      double? route_distance,
      int? route_duration,
      int created_at,
      int updated_at,
      String type});
}

/// @nodoc
class _$ApiLocationJourneyCopyWithImpl<$Res, $Val extends ApiLocationJourney>
    implements $ApiLocationJourneyCopyWith<$Res> {
  _$ApiLocationJourneyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApiLocationJourney
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? user_id = null,
    Object? from_latitude = null,
    Object? from_longitude = null,
    Object? to_latitude = freezed,
    Object? to_longitude = freezed,
    Object? routes = null,
    Object? route_distance = freezed,
    Object? route_duration = freezed,
    Object? created_at = null,
    Object? updated_at = null,
    Object? type = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      user_id: null == user_id
          ? _value.user_id
          : user_id // ignore: cast_nullable_to_non_nullable
              as String,
      from_latitude: null == from_latitude
          ? _value.from_latitude
          : from_latitude // ignore: cast_nullable_to_non_nullable
              as double,
      from_longitude: null == from_longitude
          ? _value.from_longitude
          : from_longitude // ignore: cast_nullable_to_non_nullable
              as double,
      to_latitude: freezed == to_latitude
          ? _value.to_latitude
          : to_latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      to_longitude: freezed == to_longitude
          ? _value.to_longitude
          : to_longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      routes: null == routes
          ? _value.routes
          : routes // ignore: cast_nullable_to_non_nullable
              as List<JourneyRoute>,
      route_distance: freezed == route_distance
          ? _value.route_distance
          : route_distance // ignore: cast_nullable_to_non_nullable
              as double?,
      route_duration: freezed == route_duration
          ? _value.route_duration
          : route_duration // ignore: cast_nullable_to_non_nullable
              as int?,
      created_at: null == created_at
          ? _value.created_at
          : created_at // ignore: cast_nullable_to_non_nullable
              as int,
      updated_at: null == updated_at
          ? _value.updated_at
          : updated_at // ignore: cast_nullable_to_non_nullable
              as int,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LocationJourneyImplCopyWith<$Res>
    implements $ApiLocationJourneyCopyWith<$Res> {
  factory _$$LocationJourneyImplCopyWith(_$LocationJourneyImpl value,
          $Res Function(_$LocationJourneyImpl) then) =
      __$$LocationJourneyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      String user_id,
      double from_latitude,
      double from_longitude,
      double? to_latitude,
      double? to_longitude,
      List<JourneyRoute> routes,
      double? route_distance,
      int? route_duration,
      int created_at,
      int updated_at,
      String type});
}

/// @nodoc
class __$$LocationJourneyImplCopyWithImpl<$Res>
    extends _$ApiLocationJourneyCopyWithImpl<$Res, _$LocationJourneyImpl>
    implements _$$LocationJourneyImplCopyWith<$Res> {
  __$$LocationJourneyImplCopyWithImpl(
      _$LocationJourneyImpl _value, $Res Function(_$LocationJourneyImpl) _then)
      : super(_value, _then);

  /// Create a copy of ApiLocationJourney
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? user_id = null,
    Object? from_latitude = null,
    Object? from_longitude = null,
    Object? to_latitude = freezed,
    Object? to_longitude = freezed,
    Object? routes = null,
    Object? route_distance = freezed,
    Object? route_duration = freezed,
    Object? created_at = null,
    Object? updated_at = null,
    Object? type = null,
  }) {
    return _then(_$LocationJourneyImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      user_id: null == user_id
          ? _value.user_id
          : user_id // ignore: cast_nullable_to_non_nullable
              as String,
      from_latitude: null == from_latitude
          ? _value.from_latitude
          : from_latitude // ignore: cast_nullable_to_non_nullable
              as double,
      from_longitude: null == from_longitude
          ? _value.from_longitude
          : from_longitude // ignore: cast_nullable_to_non_nullable
              as double,
      to_latitude: freezed == to_latitude
          ? _value.to_latitude
          : to_latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      to_longitude: freezed == to_longitude
          ? _value.to_longitude
          : to_longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      routes: null == routes
          ? _value._routes
          : routes // ignore: cast_nullable_to_non_nullable
              as List<JourneyRoute>,
      route_distance: freezed == route_distance
          ? _value.route_distance
          : route_distance // ignore: cast_nullable_to_non_nullable
              as double?,
      route_duration: freezed == route_duration
          ? _value.route_duration
          : route_duration // ignore: cast_nullable_to_non_nullable
              as int?,
      created_at: null == created_at
          ? _value.created_at
          : created_at // ignore: cast_nullable_to_non_nullable
              as int,
      updated_at: null == updated_at
          ? _value.updated_at
          : updated_at // ignore: cast_nullable_to_non_nullable
              as int,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LocationJourneyImpl extends _LocationJourney {
  const _$LocationJourneyImpl(
      {this.id,
      required this.user_id,
      required this.from_latitude,
      required this.from_longitude,
      this.to_latitude,
      this.to_longitude,
      final List<JourneyRoute> routes = const [],
      this.route_distance,
      this.route_duration,
      required this.created_at,
      required this.updated_at,
      required this.type})
      : _routes = routes,
        super._();

  factory _$LocationJourneyImpl.fromJson(Map<String, dynamic> json) =>
      _$$LocationJourneyImplFromJson(json);

  @override
  final String? id;
  @override
  final String user_id;
  @override
  final double from_latitude;
  @override
  final double from_longitude;
  @override
  final double? to_latitude;
  @override
  final double? to_longitude;
  final List<JourneyRoute> _routes;
  @override
  @JsonKey()
  List<JourneyRoute> get routes {
    if (_routes is EqualUnmodifiableListView) return _routes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_routes);
  }

  @override
  final double? route_distance;
  @override
  final int? route_duration;
  @override
  final int created_at;
  @override
  final int updated_at;
  @override
  final String type;

  @override
  String toString() {
    return 'ApiLocationJourney(id: $id, user_id: $user_id, from_latitude: $from_latitude, from_longitude: $from_longitude, to_latitude: $to_latitude, to_longitude: $to_longitude, routes: $routes, route_distance: $route_distance, route_duration: $route_duration, created_at: $created_at, updated_at: $updated_at, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocationJourneyImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.user_id, user_id) || other.user_id == user_id) &&
            (identical(other.from_latitude, from_latitude) ||
                other.from_latitude == from_latitude) &&
            (identical(other.from_longitude, from_longitude) ||
                other.from_longitude == from_longitude) &&
            (identical(other.to_latitude, to_latitude) ||
                other.to_latitude == to_latitude) &&
            (identical(other.to_longitude, to_longitude) ||
                other.to_longitude == to_longitude) &&
            const DeepCollectionEquality().equals(other._routes, _routes) &&
            (identical(other.route_distance, route_distance) ||
                other.route_distance == route_distance) &&
            (identical(other.route_duration, route_duration) ||
                other.route_duration == route_duration) &&
            (identical(other.created_at, created_at) ||
                other.created_at == created_at) &&
            (identical(other.updated_at, updated_at) ||
                other.updated_at == updated_at) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      user_id,
      from_latitude,
      from_longitude,
      to_latitude,
      to_longitude,
      const DeepCollectionEquality().hash(_routes),
      route_distance,
      route_duration,
      created_at,
      updated_at,
      type);

  /// Create a copy of ApiLocationJourney
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LocationJourneyImplCopyWith<_$LocationJourneyImpl> get copyWith =>
      __$$LocationJourneyImplCopyWithImpl<_$LocationJourneyImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LocationJourneyImplToJson(
      this,
    );
  }
}

abstract class _LocationJourney extends ApiLocationJourney {
  const factory _LocationJourney(
      {final String? id,
      required final String user_id,
      required final double from_latitude,
      required final double from_longitude,
      final double? to_latitude,
      final double? to_longitude,
      final List<JourneyRoute> routes,
      final double? route_distance,
      final int? route_duration,
      required final int created_at,
      required final int updated_at,
      required final String type}) = _$LocationJourneyImpl;
  const _LocationJourney._() : super._();

  factory _LocationJourney.fromJson(Map<String, dynamic> json) =
      _$LocationJourneyImpl.fromJson;

  @override
  String? get id;
  @override
  String get user_id;
  @override
  double get from_latitude;
  @override
  double get from_longitude;
  @override
  double? get to_latitude;
  @override
  double? get to_longitude;
  @override
  List<JourneyRoute> get routes;
  @override
  double? get route_distance;
  @override
  int? get route_duration;
  @override
  int get created_at;
  @override
  int get updated_at;
  @override
  String get type;

  /// Create a copy of ApiLocationJourney
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LocationJourneyImplCopyWith<_$LocationJourneyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

JourneyRoute _$JourneyRouteFromJson(Map<String, dynamic> json) {
  return _JourneyRoute.fromJson(json);
}

/// @nodoc
mixin _$JourneyRoute {
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;

  /// Serializes this JourneyRoute to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of JourneyRoute
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JourneyRouteCopyWith<JourneyRoute> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JourneyRouteCopyWith<$Res> {
  factory $JourneyRouteCopyWith(
          JourneyRoute value, $Res Function(JourneyRoute) then) =
      _$JourneyRouteCopyWithImpl<$Res, JourneyRoute>;
  @useResult
  $Res call({double latitude, double longitude});
}

/// @nodoc
class _$JourneyRouteCopyWithImpl<$Res, $Val extends JourneyRoute>
    implements $JourneyRouteCopyWith<$Res> {
  _$JourneyRouteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of JourneyRoute
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = null,
    Object? longitude = null,
  }) {
    return _then(_value.copyWith(
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$JourneyRouteImplCopyWith<$Res>
    implements $JourneyRouteCopyWith<$Res> {
  factory _$$JourneyRouteImplCopyWith(
          _$JourneyRouteImpl value, $Res Function(_$JourneyRouteImpl) then) =
      __$$JourneyRouteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double latitude, double longitude});
}

/// @nodoc
class __$$JourneyRouteImplCopyWithImpl<$Res>
    extends _$JourneyRouteCopyWithImpl<$Res, _$JourneyRouteImpl>
    implements _$$JourneyRouteImplCopyWith<$Res> {
  __$$JourneyRouteImplCopyWithImpl(
      _$JourneyRouteImpl _value, $Res Function(_$JourneyRouteImpl) _then)
      : super(_value, _then);

  /// Create a copy of JourneyRoute
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = null,
    Object? longitude = null,
  }) {
    return _then(_$JourneyRouteImpl(
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$JourneyRouteImpl implements _JourneyRoute {
  const _$JourneyRouteImpl({required this.latitude, required this.longitude});

  factory _$JourneyRouteImpl.fromJson(Map<String, dynamic> json) =>
      _$$JourneyRouteImplFromJson(json);

  @override
  final double latitude;
  @override
  final double longitude;

  @override
  String toString() {
    return 'JourneyRoute(latitude: $latitude, longitude: $longitude)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JourneyRouteImpl &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, latitude, longitude);

  /// Create a copy of JourneyRoute
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JourneyRouteImplCopyWith<_$JourneyRouteImpl> get copyWith =>
      __$$JourneyRouteImplCopyWithImpl<_$JourneyRouteImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$JourneyRouteImplToJson(
      this,
    );
  }
}

abstract class _JourneyRoute implements JourneyRoute {
  const factory _JourneyRoute(
      {required final double latitude,
      required final double longitude}) = _$JourneyRouteImpl;

  factory _JourneyRoute.fromJson(Map<String, dynamic> json) =
      _$JourneyRouteImpl.fromJson;

  @override
  double get latitude;
  @override
  double get longitude;

  /// Create a copy of JourneyRoute
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JourneyRouteImplCopyWith<_$JourneyRouteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EncryptedLocationJourney _$EncryptedLocationJourneyFromJson(
    Map<String, dynamic> json) {
  return _EncryptedLocationJourney.fromJson(json);
}

/// @nodoc
mixin _$EncryptedLocationJourney {
  String? get id => throw _privateConstructorUsedError;
  String get user_id => throw _privateConstructorUsedError;
  @BlobConverter()
  Blob get from_latitude => throw _privateConstructorUsedError;
  @BlobConverter()
  Blob get from_longitude => throw _privateConstructorUsedError;
  @BlobConverter()
  Blob? get to_latitude => throw _privateConstructorUsedError;
  @BlobConverter()
  Blob? get to_longitude => throw _privateConstructorUsedError;
  List<EncryptedJourneyRoute> get routes => throw _privateConstructorUsedError;
  double? get route_distance => throw _privateConstructorUsedError;
  int? get route_duration => throw _privateConstructorUsedError;
  int get created_at => throw _privateConstructorUsedError;
  int get updated_at => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;

  /// Serializes this EncryptedLocationJourney to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EncryptedLocationJourney
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EncryptedLocationJourneyCopyWith<EncryptedLocationJourney> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EncryptedLocationJourneyCopyWith<$Res> {
  factory $EncryptedLocationJourneyCopyWith(EncryptedLocationJourney value,
          $Res Function(EncryptedLocationJourney) then) =
      _$EncryptedLocationJourneyCopyWithImpl<$Res, EncryptedLocationJourney>;
  @useResult
  $Res call(
      {String? id,
      String user_id,
      @BlobConverter() Blob from_latitude,
      @BlobConverter() Blob from_longitude,
      @BlobConverter() Blob? to_latitude,
      @BlobConverter() Blob? to_longitude,
      List<EncryptedJourneyRoute> routes,
      double? route_distance,
      int? route_duration,
      int created_at,
      int updated_at,
      String type});
}

/// @nodoc
class _$EncryptedLocationJourneyCopyWithImpl<$Res,
        $Val extends EncryptedLocationJourney>
    implements $EncryptedLocationJourneyCopyWith<$Res> {
  _$EncryptedLocationJourneyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EncryptedLocationJourney
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? user_id = null,
    Object? from_latitude = null,
    Object? from_longitude = null,
    Object? to_latitude = freezed,
    Object? to_longitude = freezed,
    Object? routes = null,
    Object? route_distance = freezed,
    Object? route_duration = freezed,
    Object? created_at = null,
    Object? updated_at = null,
    Object? type = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      user_id: null == user_id
          ? _value.user_id
          : user_id // ignore: cast_nullable_to_non_nullable
              as String,
      from_latitude: null == from_latitude
          ? _value.from_latitude
          : from_latitude // ignore: cast_nullable_to_non_nullable
              as Blob,
      from_longitude: null == from_longitude
          ? _value.from_longitude
          : from_longitude // ignore: cast_nullable_to_non_nullable
              as Blob,
      to_latitude: freezed == to_latitude
          ? _value.to_latitude
          : to_latitude // ignore: cast_nullable_to_non_nullable
              as Blob?,
      to_longitude: freezed == to_longitude
          ? _value.to_longitude
          : to_longitude // ignore: cast_nullable_to_non_nullable
              as Blob?,
      routes: null == routes
          ? _value.routes
          : routes // ignore: cast_nullable_to_non_nullable
              as List<EncryptedJourneyRoute>,
      route_distance: freezed == route_distance
          ? _value.route_distance
          : route_distance // ignore: cast_nullable_to_non_nullable
              as double?,
      route_duration: freezed == route_duration
          ? _value.route_duration
          : route_duration // ignore: cast_nullable_to_non_nullable
              as int?,
      created_at: null == created_at
          ? _value.created_at
          : created_at // ignore: cast_nullable_to_non_nullable
              as int,
      updated_at: null == updated_at
          ? _value.updated_at
          : updated_at // ignore: cast_nullable_to_non_nullable
              as int,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EncryptedLocationJourneyImplCopyWith<$Res>
    implements $EncryptedLocationJourneyCopyWith<$Res> {
  factory _$$EncryptedLocationJourneyImplCopyWith(
          _$EncryptedLocationJourneyImpl value,
          $Res Function(_$EncryptedLocationJourneyImpl) then) =
      __$$EncryptedLocationJourneyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      String user_id,
      @BlobConverter() Blob from_latitude,
      @BlobConverter() Blob from_longitude,
      @BlobConverter() Blob? to_latitude,
      @BlobConverter() Blob? to_longitude,
      List<EncryptedJourneyRoute> routes,
      double? route_distance,
      int? route_duration,
      int created_at,
      int updated_at,
      String type});
}

/// @nodoc
class __$$EncryptedLocationJourneyImplCopyWithImpl<$Res>
    extends _$EncryptedLocationJourneyCopyWithImpl<$Res,
        _$EncryptedLocationJourneyImpl>
    implements _$$EncryptedLocationJourneyImplCopyWith<$Res> {
  __$$EncryptedLocationJourneyImplCopyWithImpl(
      _$EncryptedLocationJourneyImpl _value,
      $Res Function(_$EncryptedLocationJourneyImpl) _then)
      : super(_value, _then);

  /// Create a copy of EncryptedLocationJourney
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? user_id = null,
    Object? from_latitude = null,
    Object? from_longitude = null,
    Object? to_latitude = freezed,
    Object? to_longitude = freezed,
    Object? routes = null,
    Object? route_distance = freezed,
    Object? route_duration = freezed,
    Object? created_at = null,
    Object? updated_at = null,
    Object? type = null,
  }) {
    return _then(_$EncryptedLocationJourneyImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      user_id: null == user_id
          ? _value.user_id
          : user_id // ignore: cast_nullable_to_non_nullable
              as String,
      from_latitude: null == from_latitude
          ? _value.from_latitude
          : from_latitude // ignore: cast_nullable_to_non_nullable
              as Blob,
      from_longitude: null == from_longitude
          ? _value.from_longitude
          : from_longitude // ignore: cast_nullable_to_non_nullable
              as Blob,
      to_latitude: freezed == to_latitude
          ? _value.to_latitude
          : to_latitude // ignore: cast_nullable_to_non_nullable
              as Blob?,
      to_longitude: freezed == to_longitude
          ? _value.to_longitude
          : to_longitude // ignore: cast_nullable_to_non_nullable
              as Blob?,
      routes: null == routes
          ? _value._routes
          : routes // ignore: cast_nullable_to_non_nullable
              as List<EncryptedJourneyRoute>,
      route_distance: freezed == route_distance
          ? _value.route_distance
          : route_distance // ignore: cast_nullable_to_non_nullable
              as double?,
      route_duration: freezed == route_duration
          ? _value.route_duration
          : route_duration // ignore: cast_nullable_to_non_nullable
              as int?,
      created_at: null == created_at
          ? _value.created_at
          : created_at // ignore: cast_nullable_to_non_nullable
              as int,
      updated_at: null == updated_at
          ? _value.updated_at
          : updated_at // ignore: cast_nullable_to_non_nullable
              as int,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EncryptedLocationJourneyImpl extends _EncryptedLocationJourney {
  const _$EncryptedLocationJourneyImpl(
      {this.id,
      required this.user_id,
      @BlobConverter() required this.from_latitude,
      @BlobConverter() required this.from_longitude,
      @BlobConverter() this.to_latitude,
      @BlobConverter() this.to_longitude,
      final List<EncryptedJourneyRoute> routes = const [],
      this.route_distance,
      this.route_duration,
      required this.created_at,
      required this.updated_at,
      required this.type})
      : _routes = routes,
        super._();

  factory _$EncryptedLocationJourneyImpl.fromJson(Map<String, dynamic> json) =>
      _$$EncryptedLocationJourneyImplFromJson(json);

  @override
  final String? id;
  @override
  final String user_id;
  @override
  @BlobConverter()
  final Blob from_latitude;
  @override
  @BlobConverter()
  final Blob from_longitude;
  @override
  @BlobConverter()
  final Blob? to_latitude;
  @override
  @BlobConverter()
  final Blob? to_longitude;
  final List<EncryptedJourneyRoute> _routes;
  @override
  @JsonKey()
  List<EncryptedJourneyRoute> get routes {
    if (_routes is EqualUnmodifiableListView) return _routes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_routes);
  }

  @override
  final double? route_distance;
  @override
  final int? route_duration;
  @override
  final int created_at;
  @override
  final int updated_at;
  @override
  final String type;

  @override
  String toString() {
    return 'EncryptedLocationJourney(id: $id, user_id: $user_id, from_latitude: $from_latitude, from_longitude: $from_longitude, to_latitude: $to_latitude, to_longitude: $to_longitude, routes: $routes, route_distance: $route_distance, route_duration: $route_duration, created_at: $created_at, updated_at: $updated_at, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EncryptedLocationJourneyImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.user_id, user_id) || other.user_id == user_id) &&
            (identical(other.from_latitude, from_latitude) ||
                other.from_latitude == from_latitude) &&
            (identical(other.from_longitude, from_longitude) ||
                other.from_longitude == from_longitude) &&
            (identical(other.to_latitude, to_latitude) ||
                other.to_latitude == to_latitude) &&
            (identical(other.to_longitude, to_longitude) ||
                other.to_longitude == to_longitude) &&
            const DeepCollectionEquality().equals(other._routes, _routes) &&
            (identical(other.route_distance, route_distance) ||
                other.route_distance == route_distance) &&
            (identical(other.route_duration, route_duration) ||
                other.route_duration == route_duration) &&
            (identical(other.created_at, created_at) ||
                other.created_at == created_at) &&
            (identical(other.updated_at, updated_at) ||
                other.updated_at == updated_at) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      user_id,
      from_latitude,
      from_longitude,
      to_latitude,
      to_longitude,
      const DeepCollectionEquality().hash(_routes),
      route_distance,
      route_duration,
      created_at,
      updated_at,
      type);

  /// Create a copy of EncryptedLocationJourney
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EncryptedLocationJourneyImplCopyWith<_$EncryptedLocationJourneyImpl>
      get copyWith => __$$EncryptedLocationJourneyImplCopyWithImpl<
          _$EncryptedLocationJourneyImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EncryptedLocationJourneyImplToJson(
      this,
    );
  }
}

abstract class _EncryptedLocationJourney extends EncryptedLocationJourney {
  const factory _EncryptedLocationJourney(
      {final String? id,
      required final String user_id,
      @BlobConverter() required final Blob from_latitude,
      @BlobConverter() required final Blob from_longitude,
      @BlobConverter() final Blob? to_latitude,
      @BlobConverter() final Blob? to_longitude,
      final List<EncryptedJourneyRoute> routes,
      final double? route_distance,
      final int? route_duration,
      required final int created_at,
      required final int updated_at,
      required final String type}) = _$EncryptedLocationJourneyImpl;
  const _EncryptedLocationJourney._() : super._();

  factory _EncryptedLocationJourney.fromJson(Map<String, dynamic> json) =
      _$EncryptedLocationJourneyImpl.fromJson;

  @override
  String? get id;
  @override
  String get user_id;
  @override
  @BlobConverter()
  Blob get from_latitude;
  @override
  @BlobConverter()
  Blob get from_longitude;
  @override
  @BlobConverter()
  Blob? get to_latitude;
  @override
  @BlobConverter()
  Blob? get to_longitude;
  @override
  List<EncryptedJourneyRoute> get routes;
  @override
  double? get route_distance;
  @override
  int? get route_duration;
  @override
  int get created_at;
  @override
  int get updated_at;
  @override
  String get type;

  /// Create a copy of EncryptedLocationJourney
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EncryptedLocationJourneyImplCopyWith<_$EncryptedLocationJourneyImpl>
      get copyWith => throw _privateConstructorUsedError;
}

EncryptedJourneyRoute _$EncryptedJourneyRouteFromJson(
    Map<String, dynamic> json) {
  return _EncryptedJourneyRoute.fromJson(json);
}

/// @nodoc
mixin _$EncryptedJourneyRoute {
  @BlobConverter()
  Blob get latitude => throw _privateConstructorUsedError;
  @BlobConverter()
  Blob get longitude => throw _privateConstructorUsedError;

  /// Serializes this EncryptedJourneyRoute to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EncryptedJourneyRoute
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EncryptedJourneyRouteCopyWith<EncryptedJourneyRoute> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EncryptedJourneyRouteCopyWith<$Res> {
  factory $EncryptedJourneyRouteCopyWith(EncryptedJourneyRoute value,
          $Res Function(EncryptedJourneyRoute) then) =
      _$EncryptedJourneyRouteCopyWithImpl<$Res, EncryptedJourneyRoute>;
  @useResult
  $Res call({@BlobConverter() Blob latitude, @BlobConverter() Blob longitude});
}

/// @nodoc
class _$EncryptedJourneyRouteCopyWithImpl<$Res,
        $Val extends EncryptedJourneyRoute>
    implements $EncryptedJourneyRouteCopyWith<$Res> {
  _$EncryptedJourneyRouteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EncryptedJourneyRoute
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = null,
    Object? longitude = null,
  }) {
    return _then(_value.copyWith(
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as Blob,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as Blob,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EncryptedJourneyRouteImplCopyWith<$Res>
    implements $EncryptedJourneyRouteCopyWith<$Res> {
  factory _$$EncryptedJourneyRouteImplCopyWith(
          _$EncryptedJourneyRouteImpl value,
          $Res Function(_$EncryptedJourneyRouteImpl) then) =
      __$$EncryptedJourneyRouteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@BlobConverter() Blob latitude, @BlobConverter() Blob longitude});
}

/// @nodoc
class __$$EncryptedJourneyRouteImplCopyWithImpl<$Res>
    extends _$EncryptedJourneyRouteCopyWithImpl<$Res,
        _$EncryptedJourneyRouteImpl>
    implements _$$EncryptedJourneyRouteImplCopyWith<$Res> {
  __$$EncryptedJourneyRouteImplCopyWithImpl(_$EncryptedJourneyRouteImpl _value,
      $Res Function(_$EncryptedJourneyRouteImpl) _then)
      : super(_value, _then);

  /// Create a copy of EncryptedJourneyRoute
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = null,
    Object? longitude = null,
  }) {
    return _then(_$EncryptedJourneyRouteImpl(
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as Blob,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as Blob,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EncryptedJourneyRouteImpl implements _EncryptedJourneyRoute {
  const _$EncryptedJourneyRouteImpl(
      {@BlobConverter() required this.latitude,
      @BlobConverter() required this.longitude});

  factory _$EncryptedJourneyRouteImpl.fromJson(Map<String, dynamic> json) =>
      _$$EncryptedJourneyRouteImplFromJson(json);

  @override
  @BlobConverter()
  final Blob latitude;
  @override
  @BlobConverter()
  final Blob longitude;

  @override
  String toString() {
    return 'EncryptedJourneyRoute(latitude: $latitude, longitude: $longitude)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EncryptedJourneyRouteImpl &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, latitude, longitude);

  /// Create a copy of EncryptedJourneyRoute
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EncryptedJourneyRouteImplCopyWith<_$EncryptedJourneyRouteImpl>
      get copyWith => __$$EncryptedJourneyRouteImplCopyWithImpl<
          _$EncryptedJourneyRouteImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EncryptedJourneyRouteImplToJson(
      this,
    );
  }
}

abstract class _EncryptedJourneyRoute implements EncryptedJourneyRoute {
  const factory _EncryptedJourneyRoute(
          {@BlobConverter() required final Blob latitude,
          @BlobConverter() required final Blob longitude}) =
      _$EncryptedJourneyRouteImpl;

  factory _EncryptedJourneyRoute.fromJson(Map<String, dynamic> json) =
      _$EncryptedJourneyRouteImpl.fromJson;

  @override
  @BlobConverter()
  Blob get latitude;
  @override
  @BlobConverter()
  Blob get longitude;

  /// Create a copy of EncryptedJourneyRoute
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EncryptedJourneyRouteImplCopyWith<_$EncryptedJourneyRouteImpl>
      get copyWith => throw _privateConstructorUsedError;
}
