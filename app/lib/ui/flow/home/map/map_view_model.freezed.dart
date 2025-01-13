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
  bool get hasLocationEnabled => throw _privateConstructorUsedError;
  bool get hasLocationServiceEnabled => throw _privateConstructorUsedError;
  bool get hasNotificationEnabled => throw _privateConstructorUsedError;
  bool get hasFineLocationEnabled => throw _privateConstructorUsedError;
  List<ApiPlace> get places => throw _privateConstructorUsedError;
  Map<String, MapUserInfo> get userInfos => throw _privateConstructorUsedError;
  ApiUser? get selectedUser => throw _privateConstructorUsedError;
  LatLng? get currentUserLocation => throw _privateConstructorUsedError;
  CameraPosition get defaultPosition => throw _privateConstructorUsedError;
  String get spaceInvitationCode => throw _privateConstructorUsedError;
  String get mapType => throw _privateConstructorUsedError;
  Object? get error => throw _privateConstructorUsedError;
  DateTime? get showLocationDialog => throw _privateConstructorUsedError;
  bool get isDarMode => throw _privateConstructorUsedError;
  GoogleMapController? get mapController => throw _privateConstructorUsedError;

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
      bool hasLocationEnabled,
      bool hasLocationServiceEnabled,
      bool hasNotificationEnabled,
      bool hasFineLocationEnabled,
      List<ApiPlace> places,
      Map<String, MapUserInfo> userInfos,
      ApiUser? selectedUser,
      LatLng? currentUserLocation,
      CameraPosition defaultPosition,
      String spaceInvitationCode,
      String mapType,
      Object? error,
      DateTime? showLocationDialog,
      bool isDarMode,
      GoogleMapController? mapController});

  $ApiUserCopyWith<$Res>? get selectedUser;
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
    Object? hasLocationEnabled = null,
    Object? hasLocationServiceEnabled = null,
    Object? hasNotificationEnabled = null,
    Object? hasFineLocationEnabled = null,
    Object? places = null,
    Object? userInfos = null,
    Object? selectedUser = freezed,
    Object? currentUserLocation = freezed,
    Object? defaultPosition = null,
    Object? spaceInvitationCode = null,
    Object? mapType = null,
    Object? error = freezed,
    Object? showLocationDialog = freezed,
    Object? isDarMode = null,
    Object? mapController = freezed,
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
      hasLocationEnabled: null == hasLocationEnabled
          ? _value.hasLocationEnabled
          : hasLocationEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      hasLocationServiceEnabled: null == hasLocationServiceEnabled
          ? _value.hasLocationServiceEnabled
          : hasLocationServiceEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      hasNotificationEnabled: null == hasNotificationEnabled
          ? _value.hasNotificationEnabled
          : hasNotificationEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      hasFineLocationEnabled: null == hasFineLocationEnabled
          ? _value.hasFineLocationEnabled
          : hasFineLocationEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      places: null == places
          ? _value.places
          : places // ignore: cast_nullable_to_non_nullable
              as List<ApiPlace>,
      userInfos: null == userInfos
          ? _value.userInfos
          : userInfos // ignore: cast_nullable_to_non_nullable
              as Map<String, MapUserInfo>,
      selectedUser: freezed == selectedUser
          ? _value.selectedUser
          : selectedUser // ignore: cast_nullable_to_non_nullable
              as ApiUser?,
      currentUserLocation: freezed == currentUserLocation
          ? _value.currentUserLocation
          : currentUserLocation // ignore: cast_nullable_to_non_nullable
              as LatLng?,
      defaultPosition: null == defaultPosition
          ? _value.defaultPosition
          : defaultPosition // ignore: cast_nullable_to_non_nullable
              as CameraPosition,
      spaceInvitationCode: null == spaceInvitationCode
          ? _value.spaceInvitationCode
          : spaceInvitationCode // ignore: cast_nullable_to_non_nullable
              as String,
      mapType: null == mapType
          ? _value.mapType
          : mapType // ignore: cast_nullable_to_non_nullable
              as String,
      error: freezed == error ? _value.error : error,
      showLocationDialog: freezed == showLocationDialog
          ? _value.showLocationDialog
          : showLocationDialog // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isDarMode: null == isDarMode
          ? _value.isDarMode
          : isDarMode // ignore: cast_nullable_to_non_nullable
              as bool,
      mapController: freezed == mapController
          ? _value.mapController
          : mapController // ignore: cast_nullable_to_non_nullable
              as GoogleMapController?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ApiUserCopyWith<$Res>? get selectedUser {
    if (_value.selectedUser == null) {
      return null;
    }

    return $ApiUserCopyWith<$Res>(_value.selectedUser!, (value) {
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
      bool hasLocationEnabled,
      bool hasLocationServiceEnabled,
      bool hasNotificationEnabled,
      bool hasFineLocationEnabled,
      List<ApiPlace> places,
      Map<String, MapUserInfo> userInfos,
      ApiUser? selectedUser,
      LatLng? currentUserLocation,
      CameraPosition defaultPosition,
      String spaceInvitationCode,
      String mapType,
      Object? error,
      DateTime? showLocationDialog,
      bool isDarMode,
      GoogleMapController? mapController});

  @override
  $ApiUserCopyWith<$Res>? get selectedUser;
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
    Object? hasLocationEnabled = null,
    Object? hasLocationServiceEnabled = null,
    Object? hasNotificationEnabled = null,
    Object? hasFineLocationEnabled = null,
    Object? places = null,
    Object? userInfos = null,
    Object? selectedUser = freezed,
    Object? currentUserLocation = freezed,
    Object? defaultPosition = null,
    Object? spaceInvitationCode = null,
    Object? mapType = null,
    Object? error = freezed,
    Object? showLocationDialog = freezed,
    Object? isDarMode = null,
    Object? mapController = freezed,
  }) {
    return _then(_$MapViewStateImpl(
      loading: freezed == loading ? _value.loading! : loading,
      fetchingInviteCode: null == fetchingInviteCode
          ? _value.fetchingInviteCode
          : fetchingInviteCode // ignore: cast_nullable_to_non_nullable
              as bool,
      hasLocationEnabled: null == hasLocationEnabled
          ? _value.hasLocationEnabled
          : hasLocationEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      hasLocationServiceEnabled: null == hasLocationServiceEnabled
          ? _value.hasLocationServiceEnabled
          : hasLocationServiceEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      hasNotificationEnabled: null == hasNotificationEnabled
          ? _value.hasNotificationEnabled
          : hasNotificationEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      hasFineLocationEnabled: null == hasFineLocationEnabled
          ? _value.hasFineLocationEnabled
          : hasFineLocationEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      places: null == places
          ? _value._places
          : places // ignore: cast_nullable_to_non_nullable
              as List<ApiPlace>,
      userInfos: null == userInfos
          ? _value._userInfos
          : userInfos // ignore: cast_nullable_to_non_nullable
              as Map<String, MapUserInfo>,
      selectedUser: freezed == selectedUser
          ? _value.selectedUser
          : selectedUser // ignore: cast_nullable_to_non_nullable
              as ApiUser?,
      currentUserLocation: freezed == currentUserLocation
          ? _value.currentUserLocation
          : currentUserLocation // ignore: cast_nullable_to_non_nullable
              as LatLng?,
      defaultPosition: null == defaultPosition
          ? _value.defaultPosition
          : defaultPosition // ignore: cast_nullable_to_non_nullable
              as CameraPosition,
      spaceInvitationCode: null == spaceInvitationCode
          ? _value.spaceInvitationCode
          : spaceInvitationCode // ignore: cast_nullable_to_non_nullable
              as String,
      mapType: null == mapType
          ? _value.mapType
          : mapType // ignore: cast_nullable_to_non_nullable
              as String,
      error: freezed == error ? _value.error : error,
      showLocationDialog: freezed == showLocationDialog
          ? _value.showLocationDialog
          : showLocationDialog // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isDarMode: null == isDarMode
          ? _value.isDarMode
          : isDarMode // ignore: cast_nullable_to_non_nullable
              as bool,
      mapController: freezed == mapController
          ? _value.mapController
          : mapController // ignore: cast_nullable_to_non_nullable
              as GoogleMapController?,
    ));
  }
}

/// @nodoc

class _$MapViewStateImpl implements _MapViewState {
  const _$MapViewStateImpl(
      {this.loading = false,
      this.fetchingInviteCode = false,
      this.hasLocationEnabled = false,
      this.hasLocationServiceEnabled = false,
      this.hasNotificationEnabled = false,
      this.hasFineLocationEnabled = false,
      final List<ApiPlace> places = const [],
      final Map<String, MapUserInfo> userInfos = const {},
      this.selectedUser,
      this.currentUserLocation,
      required this.defaultPosition,
      this.spaceInvitationCode = '',
      required this.mapType,
      this.error,
      this.showLocationDialog,
      this.isDarMode = false,
      this.mapController})
      : _places = places,
        _userInfos = userInfos;

  @override
  @JsonKey()
  final dynamic loading;
  @override
  @JsonKey()
  final bool fetchingInviteCode;
  @override
  @JsonKey()
  final bool hasLocationEnabled;
  @override
  @JsonKey()
  final bool hasLocationServiceEnabled;
  @override
  @JsonKey()
  final bool hasNotificationEnabled;
  @override
  @JsonKey()
  final bool hasFineLocationEnabled;
  final List<ApiPlace> _places;
  @override
  @JsonKey()
  List<ApiPlace> get places {
    if (_places is EqualUnmodifiableListView) return _places;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_places);
  }

  final Map<String, MapUserInfo> _userInfos;
  @override
  @JsonKey()
  Map<String, MapUserInfo> get userInfos {
    if (_userInfos is EqualUnmodifiableMapView) return _userInfos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_userInfos);
  }

  @override
  final ApiUser? selectedUser;
  @override
  final LatLng? currentUserLocation;
  @override
  final CameraPosition defaultPosition;
  @override
  @JsonKey()
  final String spaceInvitationCode;
  @override
  final String mapType;
  @override
  final Object? error;
  @override
  final DateTime? showLocationDialog;
  @override
  @JsonKey()
  final bool isDarMode;
  @override
  final GoogleMapController? mapController;

  @override
  String toString() {
    return 'MapViewState(loading: $loading, fetchingInviteCode: $fetchingInviteCode, hasLocationEnabled: $hasLocationEnabled, hasLocationServiceEnabled: $hasLocationServiceEnabled, hasNotificationEnabled: $hasNotificationEnabled, hasFineLocationEnabled: $hasFineLocationEnabled, places: $places, userInfos: $userInfos, selectedUser: $selectedUser, currentUserLocation: $currentUserLocation, defaultPosition: $defaultPosition, spaceInvitationCode: $spaceInvitationCode, mapType: $mapType, error: $error, showLocationDialog: $showLocationDialog, isDarMode: $isDarMode, mapController: $mapController)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MapViewStateImpl &&
            const DeepCollectionEquality().equals(other.loading, loading) &&
            (identical(other.fetchingInviteCode, fetchingInviteCode) ||
                other.fetchingInviteCode == fetchingInviteCode) &&
            (identical(other.hasLocationEnabled, hasLocationEnabled) ||
                other.hasLocationEnabled == hasLocationEnabled) &&
            (identical(other.hasLocationServiceEnabled,
                    hasLocationServiceEnabled) ||
                other.hasLocationServiceEnabled == hasLocationServiceEnabled) &&
            (identical(other.hasNotificationEnabled, hasNotificationEnabled) ||
                other.hasNotificationEnabled == hasNotificationEnabled) &&
            (identical(other.hasFineLocationEnabled, hasFineLocationEnabled) ||
                other.hasFineLocationEnabled == hasFineLocationEnabled) &&
            const DeepCollectionEquality().equals(other._places, _places) &&
            const DeepCollectionEquality()
                .equals(other._userInfos, _userInfos) &&
            (identical(other.selectedUser, selectedUser) ||
                other.selectedUser == selectedUser) &&
            (identical(other.currentUserLocation, currentUserLocation) ||
                other.currentUserLocation == currentUserLocation) &&
            (identical(other.defaultPosition, defaultPosition) ||
                other.defaultPosition == defaultPosition) &&
            (identical(other.spaceInvitationCode, spaceInvitationCode) ||
                other.spaceInvitationCode == spaceInvitationCode) &&
            (identical(other.mapType, mapType) || other.mapType == mapType) &&
            const DeepCollectionEquality().equals(other.error, error) &&
            (identical(other.showLocationDialog, showLocationDialog) ||
                other.showLocationDialog == showLocationDialog) &&
            (identical(other.isDarMode, isDarMode) ||
                other.isDarMode == isDarMode) &&
            (identical(other.mapController, mapController) ||
                other.mapController == mapController));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(loading),
      fetchingInviteCode,
      hasLocationEnabled,
      hasLocationServiceEnabled,
      hasNotificationEnabled,
      hasFineLocationEnabled,
      const DeepCollectionEquality().hash(_places),
      const DeepCollectionEquality().hash(_userInfos),
      selectedUser,
      currentUserLocation,
      defaultPosition,
      spaceInvitationCode,
      mapType,
      const DeepCollectionEquality().hash(error),
      showLocationDialog,
      isDarMode,
      mapController);

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
      final bool hasLocationEnabled,
      final bool hasLocationServiceEnabled,
      final bool hasNotificationEnabled,
      final bool hasFineLocationEnabled,
      final List<ApiPlace> places,
      final Map<String, MapUserInfo> userInfos,
      final ApiUser? selectedUser,
      final LatLng? currentUserLocation,
      required final CameraPosition defaultPosition,
      final String spaceInvitationCode,
      required final String mapType,
      final Object? error,
      final DateTime? showLocationDialog,
      final bool isDarMode,
      final GoogleMapController? mapController}) = _$MapViewStateImpl;

  @override
  dynamic get loading;
  @override
  bool get fetchingInviteCode;
  @override
  bool get hasLocationEnabled;
  @override
  bool get hasLocationServiceEnabled;
  @override
  bool get hasNotificationEnabled;
  @override
  bool get hasFineLocationEnabled;
  @override
  List<ApiPlace> get places;
  @override
  Map<String, MapUserInfo> get userInfos;
  @override
  ApiUser? get selectedUser;
  @override
  LatLng? get currentUserLocation;
  @override
  CameraPosition get defaultPosition;
  @override
  String get spaceInvitationCode;
  @override
  String get mapType;
  @override
  Object? get error;
  @override
  DateTime? get showLocationDialog;
  @override
  bool get isDarMode;
  @override
  GoogleMapController? get mapController;
  @override
  @JsonKey(ignore: true)
  _$$MapViewStateImplCopyWith<_$MapViewStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$MapUserInfo {
  String get userId => throw _privateConstructorUsedError;
  ApiUser get user => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  bool get isSelected => throw _privateConstructorUsedError;
  int? get updatedLocationAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MapUserInfoCopyWith<MapUserInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MapUserInfoCopyWith<$Res> {
  factory $MapUserInfoCopyWith(
          MapUserInfo value, $Res Function(MapUserInfo) then) =
      _$MapUserInfoCopyWithImpl<$Res, MapUserInfo>;
  @useResult
  $Res call(
      {String userId,
      ApiUser user,
      String? imageUrl,
      double latitude,
      double longitude,
      bool isSelected,
      int? updatedLocationAt});

  $ApiUserCopyWith<$Res> get user;
}

/// @nodoc
class _$MapUserInfoCopyWithImpl<$Res, $Val extends MapUserInfo>
    implements $MapUserInfoCopyWith<$Res> {
  _$MapUserInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? user = null,
    Object? imageUrl = freezed,
    Object? latitude = null,
    Object? longitude = null,
    Object? isSelected = null,
    Object? updatedLocationAt = freezed,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as ApiUser,
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
      updatedLocationAt: freezed == updatedLocationAt
          ? _value.updatedLocationAt
          : updatedLocationAt // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ApiUserCopyWith<$Res> get user {
    return $ApiUserCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MapUserInfoImplCopyWith<$Res>
    implements $MapUserInfoCopyWith<$Res> {
  factory _$$MapUserInfoImplCopyWith(
          _$MapUserInfoImpl value, $Res Function(_$MapUserInfoImpl) then) =
      __$$MapUserInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      ApiUser user,
      String? imageUrl,
      double latitude,
      double longitude,
      bool isSelected,
      int? updatedLocationAt});

  @override
  $ApiUserCopyWith<$Res> get user;
}

/// @nodoc
class __$$MapUserInfoImplCopyWithImpl<$Res>
    extends _$MapUserInfoCopyWithImpl<$Res, _$MapUserInfoImpl>
    implements _$$MapUserInfoImplCopyWith<$Res> {
  __$$MapUserInfoImplCopyWithImpl(
      _$MapUserInfoImpl _value, $Res Function(_$MapUserInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? user = null,
    Object? imageUrl = freezed,
    Object? latitude = null,
    Object? longitude = null,
    Object? isSelected = null,
    Object? updatedLocationAt = freezed,
  }) {
    return _then(_$MapUserInfoImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as ApiUser,
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
      updatedLocationAt: freezed == updatedLocationAt
          ? _value.updatedLocationAt
          : updatedLocationAt // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$MapUserInfoImpl extends _MapUserInfo {
  const _$MapUserInfoImpl(
      {required this.userId,
      required this.user,
      required this.imageUrl,
      required this.latitude,
      required this.longitude,
      required this.isSelected,
      this.updatedLocationAt = 0})
      : super._();

  @override
  final String userId;
  @override
  final ApiUser user;
  @override
  final String? imageUrl;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final bool isSelected;
  @override
  @JsonKey()
  final int? updatedLocationAt;

  @override
  String toString() {
    return 'MapUserInfo(userId: $userId, user: $user, imageUrl: $imageUrl, latitude: $latitude, longitude: $longitude, isSelected: $isSelected, updatedLocationAt: $updatedLocationAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MapUserInfoImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.isSelected, isSelected) ||
                other.isSelected == isSelected) &&
            (identical(other.updatedLocationAt, updatedLocationAt) ||
                other.updatedLocationAt == updatedLocationAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, userId, user, imageUrl, latitude,
      longitude, isSelected, updatedLocationAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MapUserInfoImplCopyWith<_$MapUserInfoImpl> get copyWith =>
      __$$MapUserInfoImplCopyWithImpl<_$MapUserInfoImpl>(this, _$identity);
}

abstract class _MapUserInfo extends MapUserInfo {
  const factory _MapUserInfo(
      {required final String userId,
      required final ApiUser user,
      required final String? imageUrl,
      required final double latitude,
      required final double longitude,
      required final bool isSelected,
      final int? updatedLocationAt}) = _$MapUserInfoImpl;
  const _MapUserInfo._() : super._();

  @override
  String get userId;
  @override
  ApiUser get user;
  @override
  String? get imageUrl;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  bool get isSelected;
  @override
  int? get updatedLocationAt;
  @override
  @JsonKey(ignore: true)
  _$$MapUserInfoImplCopyWith<_$MapUserInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
