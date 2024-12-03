// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_place.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ApiPlace _$ApiPlaceFromJson(Map<String, dynamic> json) {
  return _ApiPlace.fromJson(json);
}

/// @nodoc
mixin _$ApiPlace {
  String get id => throw _privateConstructorUsedError;
  String get created_by => throw _privateConstructorUsedError;
  String get space_id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  double get radius => throw _privateConstructorUsedError;
  @TimeStampJsonConverter()
  DateTime? get created_at => throw _privateConstructorUsedError;
  List<String> get space_member_ids => throw _privateConstructorUsedError;

  /// Serializes this ApiPlace to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ApiPlace
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApiPlaceCopyWith<ApiPlace> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiPlaceCopyWith<$Res> {
  factory $ApiPlaceCopyWith(ApiPlace value, $Res Function(ApiPlace) then) =
      _$ApiPlaceCopyWithImpl<$Res, ApiPlace>;
  @useResult
  $Res call(
      {String id,
      String created_by,
      String space_id,
      String name,
      double latitude,
      double longitude,
      double radius,
      @TimeStampJsonConverter() DateTime? created_at,
      List<String> space_member_ids});
}

/// @nodoc
class _$ApiPlaceCopyWithImpl<$Res, $Val extends ApiPlace>
    implements $ApiPlaceCopyWith<$Res> {
  _$ApiPlaceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApiPlace
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? created_by = null,
    Object? space_id = null,
    Object? name = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? radius = null,
    Object? created_at = freezed,
    Object? space_member_ids = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      created_by: null == created_by
          ? _value.created_by
          : created_by // ignore: cast_nullable_to_non_nullable
              as String,
      space_id: null == space_id
          ? _value.space_id
          : space_id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      radius: null == radius
          ? _value.radius
          : radius // ignore: cast_nullable_to_non_nullable
              as double,
      created_at: freezed == created_at
          ? _value.created_at
          : created_at // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      space_member_ids: null == space_member_ids
          ? _value.space_member_ids
          : space_member_ids // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ApiPlaceImplCopyWith<$Res>
    implements $ApiPlaceCopyWith<$Res> {
  factory _$$ApiPlaceImplCopyWith(
          _$ApiPlaceImpl value, $Res Function(_$ApiPlaceImpl) then) =
      __$$ApiPlaceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String created_by,
      String space_id,
      String name,
      double latitude,
      double longitude,
      double radius,
      @TimeStampJsonConverter() DateTime? created_at,
      List<String> space_member_ids});
}

/// @nodoc
class __$$ApiPlaceImplCopyWithImpl<$Res>
    extends _$ApiPlaceCopyWithImpl<$Res, _$ApiPlaceImpl>
    implements _$$ApiPlaceImplCopyWith<$Res> {
  __$$ApiPlaceImplCopyWithImpl(
      _$ApiPlaceImpl _value, $Res Function(_$ApiPlaceImpl) _then)
      : super(_value, _then);

  /// Create a copy of ApiPlace
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? created_by = null,
    Object? space_id = null,
    Object? name = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? radius = null,
    Object? created_at = freezed,
    Object? space_member_ids = null,
  }) {
    return _then(_$ApiPlaceImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      created_by: null == created_by
          ? _value.created_by
          : created_by // ignore: cast_nullable_to_non_nullable
              as String,
      space_id: null == space_id
          ? _value.space_id
          : space_id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      radius: null == radius
          ? _value.radius
          : radius // ignore: cast_nullable_to_non_nullable
              as double,
      created_at: freezed == created_at
          ? _value.created_at
          : created_at // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      space_member_ids: null == space_member_ids
          ? _value._space_member_ids
          : space_member_ids // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ApiPlaceImpl extends _ApiPlace {
  const _$ApiPlaceImpl(
      {required this.id,
      required this.created_by,
      required this.space_id,
      required this.name,
      required this.latitude,
      required this.longitude,
      this.radius = 200.0,
      @TimeStampJsonConverter() this.created_at,
      final List<String> space_member_ids = const []})
      : _space_member_ids = space_member_ids,
        super._();

  factory _$ApiPlaceImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApiPlaceImplFromJson(json);

  @override
  final String id;
  @override
  final String created_by;
  @override
  final String space_id;
  @override
  final String name;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  @JsonKey()
  final double radius;
  @override
  @TimeStampJsonConverter()
  final DateTime? created_at;
  final List<String> _space_member_ids;
  @override
  @JsonKey()
  List<String> get space_member_ids {
    if (_space_member_ids is EqualUnmodifiableListView)
      return _space_member_ids;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_space_member_ids);
  }

  @override
  String toString() {
    return 'ApiPlace(id: $id, created_by: $created_by, space_id: $space_id, name: $name, latitude: $latitude, longitude: $longitude, radius: $radius, created_at: $created_at, space_member_ids: $space_member_ids)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApiPlaceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.created_by, created_by) ||
                other.created_by == created_by) &&
            (identical(other.space_id, space_id) ||
                other.space_id == space_id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.radius, radius) || other.radius == radius) &&
            (identical(other.created_at, created_at) ||
                other.created_at == created_at) &&
            const DeepCollectionEquality()
                .equals(other._space_member_ids, _space_member_ids));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      created_by,
      space_id,
      name,
      latitude,
      longitude,
      radius,
      created_at,
      const DeepCollectionEquality().hash(_space_member_ids));

  /// Create a copy of ApiPlace
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApiPlaceImplCopyWith<_$ApiPlaceImpl> get copyWith =>
      __$$ApiPlaceImplCopyWithImpl<_$ApiPlaceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApiPlaceImplToJson(
      this,
    );
  }
}

abstract class _ApiPlace extends ApiPlace {
  const factory _ApiPlace(
      {required final String id,
      required final String created_by,
      required final String space_id,
      required final String name,
      required final double latitude,
      required final double longitude,
      final double radius,
      @TimeStampJsonConverter() final DateTime? created_at,
      final List<String> space_member_ids}) = _$ApiPlaceImpl;
  const _ApiPlace._() : super._();

  factory _ApiPlace.fromJson(Map<String, dynamic> json) =
      _$ApiPlaceImpl.fromJson;

  @override
  String get id;
  @override
  String get created_by;
  @override
  String get space_id;
  @override
  String get name;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  double get radius;
  @override
  @TimeStampJsonConverter()
  DateTime? get created_at;
  @override
  List<String> get space_member_ids;

  /// Create a copy of ApiPlace
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApiPlaceImplCopyWith<_$ApiPlaceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ApiPlaceMemberSetting _$ApiPlaceMemberSettingFromJson(
    Map<String, dynamic> json) {
  return _ApiPlaceMemberSetting.fromJson(json);
}

/// @nodoc
mixin _$ApiPlaceMemberSetting {
  String get user_id => throw _privateConstructorUsedError;
  String get place_id => throw _privateConstructorUsedError;
  bool get alert_enable => throw _privateConstructorUsedError;
  List<String> get arrival_alert_for => throw _privateConstructorUsedError;
  List<String> get leave_alert_for => throw _privateConstructorUsedError;

  /// Serializes this ApiPlaceMemberSetting to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ApiPlaceMemberSetting
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApiPlaceMemberSettingCopyWith<ApiPlaceMemberSetting> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiPlaceMemberSettingCopyWith<$Res> {
  factory $ApiPlaceMemberSettingCopyWith(ApiPlaceMemberSetting value,
          $Res Function(ApiPlaceMemberSetting) then) =
      _$ApiPlaceMemberSettingCopyWithImpl<$Res, ApiPlaceMemberSetting>;
  @useResult
  $Res call(
      {String user_id,
      String place_id,
      bool alert_enable,
      List<String> arrival_alert_for,
      List<String> leave_alert_for});
}

/// @nodoc
class _$ApiPlaceMemberSettingCopyWithImpl<$Res,
        $Val extends ApiPlaceMemberSetting>
    implements $ApiPlaceMemberSettingCopyWith<$Res> {
  _$ApiPlaceMemberSettingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApiPlaceMemberSetting
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user_id = null,
    Object? place_id = null,
    Object? alert_enable = null,
    Object? arrival_alert_for = null,
    Object? leave_alert_for = null,
  }) {
    return _then(_value.copyWith(
      user_id: null == user_id
          ? _value.user_id
          : user_id // ignore: cast_nullable_to_non_nullable
              as String,
      place_id: null == place_id
          ? _value.place_id
          : place_id // ignore: cast_nullable_to_non_nullable
              as String,
      alert_enable: null == alert_enable
          ? _value.alert_enable
          : alert_enable // ignore: cast_nullable_to_non_nullable
              as bool,
      arrival_alert_for: null == arrival_alert_for
          ? _value.arrival_alert_for
          : arrival_alert_for // ignore: cast_nullable_to_non_nullable
              as List<String>,
      leave_alert_for: null == leave_alert_for
          ? _value.leave_alert_for
          : leave_alert_for // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ApiPlaceMemberSettingImplCopyWith<$Res>
    implements $ApiPlaceMemberSettingCopyWith<$Res> {
  factory _$$ApiPlaceMemberSettingImplCopyWith(
          _$ApiPlaceMemberSettingImpl value,
          $Res Function(_$ApiPlaceMemberSettingImpl) then) =
      __$$ApiPlaceMemberSettingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String user_id,
      String place_id,
      bool alert_enable,
      List<String> arrival_alert_for,
      List<String> leave_alert_for});
}

/// @nodoc
class __$$ApiPlaceMemberSettingImplCopyWithImpl<$Res>
    extends _$ApiPlaceMemberSettingCopyWithImpl<$Res,
        _$ApiPlaceMemberSettingImpl>
    implements _$$ApiPlaceMemberSettingImplCopyWith<$Res> {
  __$$ApiPlaceMemberSettingImplCopyWithImpl(_$ApiPlaceMemberSettingImpl _value,
      $Res Function(_$ApiPlaceMemberSettingImpl) _then)
      : super(_value, _then);

  /// Create a copy of ApiPlaceMemberSetting
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user_id = null,
    Object? place_id = null,
    Object? alert_enable = null,
    Object? arrival_alert_for = null,
    Object? leave_alert_for = null,
  }) {
    return _then(_$ApiPlaceMemberSettingImpl(
      user_id: null == user_id
          ? _value.user_id
          : user_id // ignore: cast_nullable_to_non_nullable
              as String,
      place_id: null == place_id
          ? _value.place_id
          : place_id // ignore: cast_nullable_to_non_nullable
              as String,
      alert_enable: null == alert_enable
          ? _value.alert_enable
          : alert_enable // ignore: cast_nullable_to_non_nullable
              as bool,
      arrival_alert_for: null == arrival_alert_for
          ? _value._arrival_alert_for
          : arrival_alert_for // ignore: cast_nullable_to_non_nullable
              as List<String>,
      leave_alert_for: null == leave_alert_for
          ? _value._leave_alert_for
          : leave_alert_for // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ApiPlaceMemberSettingImpl extends _ApiPlaceMemberSetting {
  const _$ApiPlaceMemberSettingImpl(
      {required this.user_id,
      required this.place_id,
      this.alert_enable = false,
      final List<String> arrival_alert_for = const [],
      final List<String> leave_alert_for = const []})
      : _arrival_alert_for = arrival_alert_for,
        _leave_alert_for = leave_alert_for,
        super._();

  factory _$ApiPlaceMemberSettingImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApiPlaceMemberSettingImplFromJson(json);

  @override
  final String user_id;
  @override
  final String place_id;
  @override
  @JsonKey()
  final bool alert_enable;
  final List<String> _arrival_alert_for;
  @override
  @JsonKey()
  List<String> get arrival_alert_for {
    if (_arrival_alert_for is EqualUnmodifiableListView)
      return _arrival_alert_for;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_arrival_alert_for);
  }

  final List<String> _leave_alert_for;
  @override
  @JsonKey()
  List<String> get leave_alert_for {
    if (_leave_alert_for is EqualUnmodifiableListView) return _leave_alert_for;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_leave_alert_for);
  }

  @override
  String toString() {
    return 'ApiPlaceMemberSetting(user_id: $user_id, place_id: $place_id, alert_enable: $alert_enable, arrival_alert_for: $arrival_alert_for, leave_alert_for: $leave_alert_for)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApiPlaceMemberSettingImpl &&
            (identical(other.user_id, user_id) || other.user_id == user_id) &&
            (identical(other.place_id, place_id) ||
                other.place_id == place_id) &&
            (identical(other.alert_enable, alert_enable) ||
                other.alert_enable == alert_enable) &&
            const DeepCollectionEquality()
                .equals(other._arrival_alert_for, _arrival_alert_for) &&
            const DeepCollectionEquality()
                .equals(other._leave_alert_for, _leave_alert_for));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      user_id,
      place_id,
      alert_enable,
      const DeepCollectionEquality().hash(_arrival_alert_for),
      const DeepCollectionEquality().hash(_leave_alert_for));

  /// Create a copy of ApiPlaceMemberSetting
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApiPlaceMemberSettingImplCopyWith<_$ApiPlaceMemberSettingImpl>
      get copyWith => __$$ApiPlaceMemberSettingImplCopyWithImpl<
          _$ApiPlaceMemberSettingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApiPlaceMemberSettingImplToJson(
      this,
    );
  }
}

abstract class _ApiPlaceMemberSetting extends ApiPlaceMemberSetting {
  const factory _ApiPlaceMemberSetting(
      {required final String user_id,
      required final String place_id,
      final bool alert_enable,
      final List<String> arrival_alert_for,
      final List<String> leave_alert_for}) = _$ApiPlaceMemberSettingImpl;
  const _ApiPlaceMemberSetting._() : super._();

  factory _ApiPlaceMemberSetting.fromJson(Map<String, dynamic> json) =
      _$ApiPlaceMemberSettingImpl.fromJson;

  @override
  String get user_id;
  @override
  String get place_id;
  @override
  bool get alert_enable;
  @override
  List<String> get arrival_alert_for;
  @override
  List<String> get leave_alert_for;

  /// Create a copy of ApiPlaceMemberSetting
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApiPlaceMemberSettingImplCopyWith<_$ApiPlaceMemberSettingImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ApiNearbyPlace _$ApiNearbyPlaceFromJson(Map<String, dynamic> json) {
  return _ApiNearbyPlace.fromJson(json);
}

/// @nodoc
mixin _$ApiNearbyPlace {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get formatted_address => throw _privateConstructorUsedError;
  double get lat => throw _privateConstructorUsedError;
  double get lng => throw _privateConstructorUsedError;

  /// Serializes this ApiNearbyPlace to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ApiNearbyPlace
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApiNearbyPlaceCopyWith<ApiNearbyPlace> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiNearbyPlaceCopyWith<$Res> {
  factory $ApiNearbyPlaceCopyWith(
          ApiNearbyPlace value, $Res Function(ApiNearbyPlace) then) =
      _$ApiNearbyPlaceCopyWithImpl<$Res, ApiNearbyPlace>;
  @useResult
  $Res call(
      {String id,
      String name,
      String formatted_address,
      double lat,
      double lng});
}

/// @nodoc
class _$ApiNearbyPlaceCopyWithImpl<$Res, $Val extends ApiNearbyPlace>
    implements $ApiNearbyPlaceCopyWith<$Res> {
  _$ApiNearbyPlaceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApiNearbyPlace
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? formatted_address = null,
    Object? lat = null,
    Object? lng = null,
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
      formatted_address: null == formatted_address
          ? _value.formatted_address
          : formatted_address // ignore: cast_nullable_to_non_nullable
              as String,
      lat: null == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double,
      lng: null == lng
          ? _value.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ApiNearbyPlaceImplCopyWith<$Res>
    implements $ApiNearbyPlaceCopyWith<$Res> {
  factory _$$ApiNearbyPlaceImplCopyWith(_$ApiNearbyPlaceImpl value,
          $Res Function(_$ApiNearbyPlaceImpl) then) =
      __$$ApiNearbyPlaceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String formatted_address,
      double lat,
      double lng});
}

/// @nodoc
class __$$ApiNearbyPlaceImplCopyWithImpl<$Res>
    extends _$ApiNearbyPlaceCopyWithImpl<$Res, _$ApiNearbyPlaceImpl>
    implements _$$ApiNearbyPlaceImplCopyWith<$Res> {
  __$$ApiNearbyPlaceImplCopyWithImpl(
      _$ApiNearbyPlaceImpl _value, $Res Function(_$ApiNearbyPlaceImpl) _then)
      : super(_value, _then);

  /// Create a copy of ApiNearbyPlace
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? formatted_address = null,
    Object? lat = null,
    Object? lng = null,
  }) {
    return _then(_$ApiNearbyPlaceImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      formatted_address: null == formatted_address
          ? _value.formatted_address
          : formatted_address // ignore: cast_nullable_to_non_nullable
              as String,
      lat: null == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double,
      lng: null == lng
          ? _value.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ApiNearbyPlaceImpl extends _ApiNearbyPlace {
  const _$ApiNearbyPlaceImpl(
      {required this.id,
      required this.name,
      required this.formatted_address,
      required this.lat,
      required this.lng})
      : super._();

  factory _$ApiNearbyPlaceImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApiNearbyPlaceImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String formatted_address;
  @override
  final double lat;
  @override
  final double lng;

  @override
  String toString() {
    return 'ApiNearbyPlace(id: $id, name: $name, formatted_address: $formatted_address, lat: $lat, lng: $lng)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApiNearbyPlaceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.formatted_address, formatted_address) ||
                other.formatted_address == formatted_address) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, formatted_address, lat, lng);

  /// Create a copy of ApiNearbyPlace
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApiNearbyPlaceImplCopyWith<_$ApiNearbyPlaceImpl> get copyWith =>
      __$$ApiNearbyPlaceImplCopyWithImpl<_$ApiNearbyPlaceImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApiNearbyPlaceImplToJson(
      this,
    );
  }
}

abstract class _ApiNearbyPlace extends ApiNearbyPlace {
  const factory _ApiNearbyPlace(
      {required final String id,
      required final String name,
      required final String formatted_address,
      required final double lat,
      required final double lng}) = _$ApiNearbyPlaceImpl;
  const _ApiNearbyPlace._() : super._();

  factory _ApiNearbyPlace.fromJson(Map<String, dynamic> json) =
      _$ApiNearbyPlaceImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get formatted_address;
  @override
  double get lat;
  @override
  double get lng;

  /// Create a copy of ApiNearbyPlace
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApiNearbyPlaceImplCopyWith<_$ApiNearbyPlaceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
