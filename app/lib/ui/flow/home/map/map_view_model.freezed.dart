// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'map_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MapViewState {
  dynamic get loading => throw _privateConstructorUsedError;
  bool get fetchingInviteCode => throw _privateConstructorUsedError;
  List<ApiUserInfo> get userInfo => throw _privateConstructorUsedError;
  List<ApiPlace> get places => throw _privateConstructorUsedError;
  List<UserMarker> get markers => throw _privateConstructorUsedError;
  ApiUserInfo? get selectedUser => throw _privateConstructorUsedError;
  LatLng? get defaultPosition => throw _privateConstructorUsedError;
  String get spaceInvitationCode => throw _privateConstructorUsedError;
  Object? get error => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MapViewStateCopyWith<MapViewState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MapViewStateCopyWith<$Res> {
  factory $MapViewStateCopyWith(
          MapViewState value, $Res Function(MapViewState) then) =
      _$MapViewStateCopyWithImpl<$Res, MapViewState>;
  @useResult
  $Res call(
      {dynamic loading,
      bool fetchingInviteCode,
      List<ApiUserInfo> userInfo,
      List<ApiPlace> places,
      List<UserMarker> markers,
      ApiUserInfo? selectedUser,
      LatLng? defaultPosition,
      String spaceInvitationCode,
      Object? error});

  $ApiUserInfoCopyWith<$Res>? get selectedUser;
}

/// @nodoc
class _$MapViewStateCopyWithImpl<$Res, $Val extends MapViewState>
    implements $MapViewStateCopyWith<$Res> {
  _$MapViewStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = freezed,
    Object? fetchingInviteCode = null,
    Object? userInfo = null,
    Object? places = null,
    Object? markers = null,
    Object? selectedUser = freezed,
    Object? defaultPosition = freezed,
    Object? spaceInvitationCode = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      loading: freezed == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as dynamic,
      fetchingInviteCode: null == fetchingInviteCode
          ? _value.fetchingInviteCode
          : fetchingInviteCode // ignore: cast_nullable_to_non_nullable
              as bool,
      userInfo: null == userInfo
          ? _value.userInfo
          : userInfo // ignore: cast_nullable_to_non_nullable
              as List<ApiUserInfo>,
      places: null == places
          ? _value.places
          : places // ignore: cast_nullable_to_non_nullable
              as List<ApiPlace>,
      markers: null == markers
          ? _value.markers
          : markers // ignore: cast_nullable_to_non_nullable
              as List<UserMarker>,
      selectedUser: freezed == selectedUser
          ? _value.selectedUser
          : selectedUser // ignore: cast_nullable_to_non_nullable
              as ApiUserInfo?,
      defaultPosition: freezed == defaultPosition
          ? _value.defaultPosition
          : defaultPosition // ignore: cast_nullable_to_non_nullable
              as LatLng?,
      spaceInvitationCode: null == spaceInvitationCode
          ? _value.spaceInvitationCode
          : spaceInvitationCode // ignore: cast_nullable_to_non_nullable
              as String,
      error: freezed == error ? _value.error : error,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ApiUserInfoCopyWith<$Res>? get selectedUser {
    if (_value.selectedUser == null) {
      return null;
    }

    return $ApiUserInfoCopyWith<$Res>(_value.selectedUser!, (value) {
      return _then(_value.copyWith(selectedUser: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MapViewStateImplCopyWith<$Res>
    implements $MapViewStateCopyWith<$Res> {
  factory _$$MapViewStateImplCopyWith(
          _$MapViewStateImpl value, $Res Function(_$MapViewStateImpl) then) =
      __$$MapViewStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {dynamic loading,
      bool fetchingInviteCode,
      List<ApiUserInfo> userInfo,
      List<ApiPlace> places,
      List<UserMarker> markers,
      ApiUserInfo? selectedUser,
      LatLng? defaultPosition,
      String spaceInvitationCode,
      Object? error});

  @override
  $ApiUserInfoCopyWith<$Res>? get selectedUser;
}

/// @nodoc
class __$$MapViewStateImplCopyWithImpl<$Res>
    extends _$MapViewStateCopyWithImpl<$Res, _$MapViewStateImpl>
    implements _$$MapViewStateImplCopyWith<$Res> {
  __$$MapViewStateImplCopyWithImpl(
      _$MapViewStateImpl _value, $Res Function(_$MapViewStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = freezed,
    Object? fetchingInviteCode = null,
    Object? userInfo = null,
    Object? places = null,
    Object? markers = null,
    Object? selectedUser = freezed,
    Object? defaultPosition = freezed,
    Object? spaceInvitationCode = null,
    Object? error = freezed,
  }) {
    return _then(_$MapViewStateImpl(
      loading: freezed == loading ? _value.loading! : loading,
      fetchingInviteCode: null == fetchingInviteCode
          ? _value.fetchingInviteCode
          : fetchingInviteCode // ignore: cast_nullable_to_non_nullable
              as bool,
      userInfo: null == userInfo
          ? _value._userInfo
          : userInfo // ignore: cast_nullable_to_non_nullable
              as List<ApiUserInfo>,
      places: null == places
          ? _value._places
          : places // ignore: cast_nullable_to_non_nullable
              as List<ApiPlace>,
      markers: null == markers
          ? _value._markers
          : markers // ignore: cast_nullable_to_non_nullable
              as List<UserMarker>,
      selectedUser: freezed == selectedUser
          ? _value.selectedUser
          : selectedUser // ignore: cast_nullable_to_non_nullable
              as ApiUserInfo?,
      defaultPosition: freezed == defaultPosition
          ? _value.defaultPosition
          : defaultPosition // ignore: cast_nullable_to_non_nullable
              as LatLng?,
      spaceInvitationCode: null == spaceInvitationCode
          ? _value.spaceInvitationCode
          : spaceInvitationCode // ignore: cast_nullable_to_non_nullable
              as String,
      error: freezed == error ? _value.error : error,
    ));
  }
}

/// @nodoc

class _$MapViewStateImpl implements _MapViewState {
  const _$MapViewStateImpl(
      {this.loading = false,
      this.fetchingInviteCode = false,
      final List<ApiUserInfo> userInfo = const [],
      final List<ApiPlace> places = const [],
      final List<UserMarker> markers = const [],
      this.selectedUser,
      this.defaultPosition,
      this.spaceInvitationCode = '',
      this.error})
      : _userInfo = userInfo,
        _places = places,
        _markers = markers;

  @override
  @JsonKey()
  final dynamic loading;
  @override
  @JsonKey()
  final bool fetchingInviteCode;
  final List<ApiUserInfo> _userInfo;
  @override
  @JsonKey()
  List<ApiUserInfo> get userInfo {
    if (_userInfo is EqualUnmodifiableListView) return _userInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_userInfo);
  }

  final List<ApiPlace> _places;
  @override
  @JsonKey()
  List<ApiPlace> get places {
    if (_places is EqualUnmodifiableListView) return _places;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_places);
  }

  final List<UserMarker> _markers;
  @override
  @JsonKey()
  List<UserMarker> get markers {
    if (_markers is EqualUnmodifiableListView) return _markers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_markers);
  }

  @override
  final ApiUserInfo? selectedUser;
  @override
  final LatLng? defaultPosition;
  @override
  @JsonKey()
  final String spaceInvitationCode;
  @override
  final Object? error;

  @override
  String toString() {
    return 'MapViewState(loading: $loading, fetchingInviteCode: $fetchingInviteCode, userInfo: $userInfo, places: $places, markers: $markers, selectedUser: $selectedUser, defaultPosition: $defaultPosition, spaceInvitationCode: $spaceInvitationCode, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MapViewStateImpl &&
            const DeepCollectionEquality().equals(other.loading, loading) &&
            (identical(other.fetchingInviteCode, fetchingInviteCode) ||
                other.fetchingInviteCode == fetchingInviteCode) &&
            const DeepCollectionEquality().equals(other._userInfo, _userInfo) &&
            const DeepCollectionEquality().equals(other._places, _places) &&
            const DeepCollectionEquality().equals(other._markers, _markers) &&
            (identical(other.selectedUser, selectedUser) ||
                other.selectedUser == selectedUser) &&
            (identical(other.defaultPosition, defaultPosition) ||
                other.defaultPosition == defaultPosition) &&
            (identical(other.spaceInvitationCode, spaceInvitationCode) ||
                other.spaceInvitationCode == spaceInvitationCode) &&
            const DeepCollectionEquality().equals(other.error, error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(loading),
      fetchingInviteCode,
      const DeepCollectionEquality().hash(_userInfo),
      const DeepCollectionEquality().hash(_places),
      const DeepCollectionEquality().hash(_markers),
      selectedUser,
      defaultPosition,
      spaceInvitationCode,
      const DeepCollectionEquality().hash(error));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MapViewStateImplCopyWith<_$MapViewStateImpl> get copyWith =>
      __$$MapViewStateImplCopyWithImpl<_$MapViewStateImpl>(this, _$identity);
}

abstract class _MapViewState implements MapViewState {
  const factory _MapViewState(
      {final dynamic loading,
      final bool fetchingInviteCode,
      final List<ApiUserInfo> userInfo,
      final List<ApiPlace> places,
      final List<UserMarker> markers,
      final ApiUserInfo? selectedUser,
      final LatLng? defaultPosition,
      final String spaceInvitationCode,
      final Object? error}) = _$MapViewStateImpl;

  @override
  dynamic get loading;
  @override
  bool get fetchingInviteCode;
  @override
  List<ApiUserInfo> get userInfo;
  @override
  List<ApiPlace> get places;
  @override
  List<UserMarker> get markers;
  @override
  ApiUserInfo? get selectedUser;
  @override
  LatLng? get defaultPosition;
  @override
  String get spaceInvitationCode;
  @override
  Object? get error;
  @override
  @JsonKey(ignore: true)
  _$$MapViewStateImplCopyWith<_$MapViewStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$UserMarker {
  String get userId => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  bool get isSelected => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UserMarkerCopyWith<UserMarker> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserMarkerCopyWith<$Res> {
  factory $UserMarkerCopyWith(
          UserMarker value, $Res Function(UserMarker) then) =
      _$UserMarkerCopyWithImpl<$Res, UserMarker>;
  @useResult
  $Res call(
      {String userId,
      String userName,
      String? imageUrl,
      double latitude,
      double longitude,
      bool isSelected});
}

/// @nodoc
class _$UserMarkerCopyWithImpl<$Res, $Val extends UserMarker>
    implements $UserMarkerCopyWith<$Res> {
  _$UserMarkerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? userName = null,
    Object? imageUrl = freezed,
    Object? latitude = null,
    Object? longitude = null,
    Object? isSelected = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      isSelected: null == isSelected
          ? _value.isSelected
          : isSelected // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserMarkerImplCopyWith<$Res>
    implements $UserMarkerCopyWith<$Res> {
  factory _$$UserMarkerImplCopyWith(
          _$UserMarkerImpl value, $Res Function(_$UserMarkerImpl) then) =
      __$$UserMarkerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      String userName,
      String? imageUrl,
      double latitude,
      double longitude,
      bool isSelected});
}

/// @nodoc
class __$$UserMarkerImplCopyWithImpl<$Res>
    extends _$UserMarkerCopyWithImpl<$Res, _$UserMarkerImpl>
    implements _$$UserMarkerImplCopyWith<$Res> {
  __$$UserMarkerImplCopyWithImpl(
      _$UserMarkerImpl _value, $Res Function(_$UserMarkerImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? userName = null,
    Object? imageUrl = freezed,
    Object? latitude = null,
    Object? longitude = null,
    Object? isSelected = null,
  }) {
    return _then(_$UserMarkerImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      isSelected: null == isSelected
          ? _value.isSelected
          : isSelected // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$UserMarkerImpl implements _UserMarker {
  const _$UserMarkerImpl(
      {required this.userId,
      required this.userName,
      required this.imageUrl,
      required this.latitude,
      required this.longitude,
      required this.isSelected});

  @override
  final String userId;
  @override
  final String userName;
  @override
  final String? imageUrl;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final bool isSelected;

  @override
  String toString() {
    return 'UserMarker(userId: $userId, userName: $userName, imageUrl: $imageUrl, latitude: $latitude, longitude: $longitude, isSelected: $isSelected)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserMarkerImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.isSelected, isSelected) ||
                other.isSelected == isSelected));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, userId, userName, imageUrl, latitude, longitude, isSelected);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserMarkerImplCopyWith<_$UserMarkerImpl> get copyWith =>
      __$$UserMarkerImplCopyWithImpl<_$UserMarkerImpl>(this, _$identity);
}

abstract class _UserMarker implements UserMarker {
  const factory _UserMarker(
      {required final String userId,
      required final String userName,
      required final String? imageUrl,
      required final double latitude,
      required final double longitude,
      required final bool isSelected}) = _$UserMarkerImpl;

  @override
  String get userId;
  @override
  String get userName;
  @override
  String? get imageUrl;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  bool get isSelected;
  @override
  @JsonKey(ignore: true)
  _$$UserMarkerImplCopyWith<_$UserMarkerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
