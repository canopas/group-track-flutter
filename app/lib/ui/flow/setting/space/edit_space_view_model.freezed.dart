// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'edit_space_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$EditSpaceViewState {
  bool get loading => throw _privateConstructorUsedError;
  bool get allowSave => throw _privateConstructorUsedError;
  bool get saving => throw _privateConstructorUsedError;
  bool get isAdmin => throw _privateConstructorUsedError;
  bool get deleting => throw _privateConstructorUsedError;
  bool get deleted => throw _privateConstructorUsedError;
  bool get locationEnabled => throw _privateConstructorUsedError;
  bool get isNetworkOff => throw _privateConstructorUsedError;
  bool get adminRemovingMember => throw _privateConstructorUsedError;
  String get selectedSpaceName => throw _privateConstructorUsedError;
  String get currentUserId => throw _privateConstructorUsedError;
  ApiUserInfo? get currentUserInfo => throw _privateConstructorUsedError;
  List<ApiUserInfo> get userInfo => throw _privateConstructorUsedError;
  TextEditingController get spaceName => throw _privateConstructorUsedError;
  SpaceInfo? get spaceInfo => throw _privateConstructorUsedError;
  ApiSpaceInvitation? get invitationCode => throw _privateConstructorUsedError;
  bool get refreshingInviteCode => throw _privateConstructorUsedError;
  Object? get error => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $EditSpaceViewStateCopyWith<EditSpaceViewState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EditSpaceViewStateCopyWith<$Res> {
  factory $EditSpaceViewStateCopyWith(
          EditSpaceViewState value, $Res Function(EditSpaceViewState) then) =
      _$EditSpaceViewStateCopyWithImpl<$Res, EditSpaceViewState>;
  @useResult
  $Res call(
      {bool loading,
      bool allowSave,
      bool saving,
      bool isAdmin,
      bool deleting,
      bool deleted,
      bool locationEnabled,
      bool isNetworkOff,
      bool adminRemovingMember,
      String selectedSpaceName,
      String currentUserId,
      ApiUserInfo? currentUserInfo,
      List<ApiUserInfo> userInfo,
      TextEditingController spaceName,
      SpaceInfo? spaceInfo,
      ApiSpaceInvitation? invitationCode,
      bool refreshingInviteCode,
      Object? error});

  $ApiUserInfoCopyWith<$Res>? get currentUserInfo;
  $SpaceInfoCopyWith<$Res>? get spaceInfo;
  $ApiSpaceInvitationCopyWith<$Res>? get invitationCode;
}

/// @nodoc
class _$EditSpaceViewStateCopyWithImpl<$Res, $Val extends EditSpaceViewState>
    implements $EditSpaceViewStateCopyWith<$Res> {
  _$EditSpaceViewStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = null,
    Object? allowSave = null,
    Object? saving = null,
    Object? isAdmin = null,
    Object? deleting = null,
    Object? deleted = null,
    Object? locationEnabled = null,
    Object? isNetworkOff = null,
    Object? adminRemovingMember = null,
    Object? selectedSpaceName = null,
    Object? currentUserId = null,
    Object? currentUserInfo = freezed,
    Object? userInfo = null,
    Object? spaceName = null,
    Object? spaceInfo = freezed,
    Object? invitationCode = freezed,
    Object? refreshingInviteCode = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      allowSave: null == allowSave
          ? _value.allowSave
          : allowSave // ignore: cast_nullable_to_non_nullable
              as bool,
      saving: null == saving
          ? _value.saving
          : saving // ignore: cast_nullable_to_non_nullable
              as bool,
      isAdmin: null == isAdmin
          ? _value.isAdmin
          : isAdmin // ignore: cast_nullable_to_non_nullable
              as bool,
      deleting: null == deleting
          ? _value.deleting
          : deleting // ignore: cast_nullable_to_non_nullable
              as bool,
      deleted: null == deleted
          ? _value.deleted
          : deleted // ignore: cast_nullable_to_non_nullable
              as bool,
      locationEnabled: null == locationEnabled
          ? _value.locationEnabled
          : locationEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isNetworkOff: null == isNetworkOff
          ? _value.isNetworkOff
          : isNetworkOff // ignore: cast_nullable_to_non_nullable
              as bool,
      adminRemovingMember: null == adminRemovingMember
          ? _value.adminRemovingMember
          : adminRemovingMember // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedSpaceName: null == selectedSpaceName
          ? _value.selectedSpaceName
          : selectedSpaceName // ignore: cast_nullable_to_non_nullable
              as String,
      currentUserId: null == currentUserId
          ? _value.currentUserId
          : currentUserId // ignore: cast_nullable_to_non_nullable
              as String,
      currentUserInfo: freezed == currentUserInfo
          ? _value.currentUserInfo
          : currentUserInfo // ignore: cast_nullable_to_non_nullable
              as ApiUserInfo?,
      userInfo: null == userInfo
          ? _value.userInfo
          : userInfo // ignore: cast_nullable_to_non_nullable
              as List<ApiUserInfo>,
      spaceName: null == spaceName
          ? _value.spaceName
          : spaceName // ignore: cast_nullable_to_non_nullable
              as TextEditingController,
      spaceInfo: freezed == spaceInfo
          ? _value.spaceInfo
          : spaceInfo // ignore: cast_nullable_to_non_nullable
              as SpaceInfo?,
      invitationCode: freezed == invitationCode
          ? _value.invitationCode
          : invitationCode // ignore: cast_nullable_to_non_nullable
              as ApiSpaceInvitation?,
      refreshingInviteCode: null == refreshingInviteCode
          ? _value.refreshingInviteCode
          : refreshingInviteCode // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error ? _value.error : error,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ApiUserInfoCopyWith<$Res>? get currentUserInfo {
    if (_value.currentUserInfo == null) {
      return null;
    }

    return $ApiUserInfoCopyWith<$Res>(_value.currentUserInfo!, (value) {
      return _then(_value.copyWith(currentUserInfo: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $SpaceInfoCopyWith<$Res>? get spaceInfo {
    if (_value.spaceInfo == null) {
      return null;
    }

    return $SpaceInfoCopyWith<$Res>(_value.spaceInfo!, (value) {
      return _then(_value.copyWith(spaceInfo: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ApiSpaceInvitationCopyWith<$Res>? get invitationCode {
    if (_value.invitationCode == null) {
      return null;
    }

    return $ApiSpaceInvitationCopyWith<$Res>(_value.invitationCode!, (value) {
      return _then(_value.copyWith(invitationCode: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$EditSpaceViewStateImplCopyWith<$Res>
    implements $EditSpaceViewStateCopyWith<$Res> {
  factory _$$EditSpaceViewStateImplCopyWith(_$EditSpaceViewStateImpl value,
          $Res Function(_$EditSpaceViewStateImpl) then) =
      __$$EditSpaceViewStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool loading,
      bool allowSave,
      bool saving,
      bool isAdmin,
      bool deleting,
      bool deleted,
      bool locationEnabled,
      bool isNetworkOff,
      bool adminRemovingMember,
      String selectedSpaceName,
      String currentUserId,
      ApiUserInfo? currentUserInfo,
      List<ApiUserInfo> userInfo,
      TextEditingController spaceName,
      SpaceInfo? spaceInfo,
      ApiSpaceInvitation? invitationCode,
      bool refreshingInviteCode,
      Object? error});

  @override
  $ApiUserInfoCopyWith<$Res>? get currentUserInfo;
  @override
  $SpaceInfoCopyWith<$Res>? get spaceInfo;
  @override
  $ApiSpaceInvitationCopyWith<$Res>? get invitationCode;
}

/// @nodoc
class __$$EditSpaceViewStateImplCopyWithImpl<$Res>
    extends _$EditSpaceViewStateCopyWithImpl<$Res, _$EditSpaceViewStateImpl>
    implements _$$EditSpaceViewStateImplCopyWith<$Res> {
  __$$EditSpaceViewStateImplCopyWithImpl(_$EditSpaceViewStateImpl _value,
      $Res Function(_$EditSpaceViewStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = null,
    Object? allowSave = null,
    Object? saving = null,
    Object? isAdmin = null,
    Object? deleting = null,
    Object? deleted = null,
    Object? locationEnabled = null,
    Object? isNetworkOff = null,
    Object? adminRemovingMember = null,
    Object? selectedSpaceName = null,
    Object? currentUserId = null,
    Object? currentUserInfo = freezed,
    Object? userInfo = null,
    Object? spaceName = null,
    Object? spaceInfo = freezed,
    Object? invitationCode = freezed,
    Object? refreshingInviteCode = null,
    Object? error = freezed,
  }) {
    return _then(_$EditSpaceViewStateImpl(
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      allowSave: null == allowSave
          ? _value.allowSave
          : allowSave // ignore: cast_nullable_to_non_nullable
              as bool,
      saving: null == saving
          ? _value.saving
          : saving // ignore: cast_nullable_to_non_nullable
              as bool,
      isAdmin: null == isAdmin
          ? _value.isAdmin
          : isAdmin // ignore: cast_nullable_to_non_nullable
              as bool,
      deleting: null == deleting
          ? _value.deleting
          : deleting // ignore: cast_nullable_to_non_nullable
              as bool,
      deleted: null == deleted
          ? _value.deleted
          : deleted // ignore: cast_nullable_to_non_nullable
              as bool,
      locationEnabled: null == locationEnabled
          ? _value.locationEnabled
          : locationEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isNetworkOff: null == isNetworkOff
          ? _value.isNetworkOff
          : isNetworkOff // ignore: cast_nullable_to_non_nullable
              as bool,
      adminRemovingMember: null == adminRemovingMember
          ? _value.adminRemovingMember
          : adminRemovingMember // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedSpaceName: null == selectedSpaceName
          ? _value.selectedSpaceName
          : selectedSpaceName // ignore: cast_nullable_to_non_nullable
              as String,
      currentUserId: null == currentUserId
          ? _value.currentUserId
          : currentUserId // ignore: cast_nullable_to_non_nullable
              as String,
      currentUserInfo: freezed == currentUserInfo
          ? _value.currentUserInfo
          : currentUserInfo // ignore: cast_nullable_to_non_nullable
              as ApiUserInfo?,
      userInfo: null == userInfo
          ? _value._userInfo
          : userInfo // ignore: cast_nullable_to_non_nullable
              as List<ApiUserInfo>,
      spaceName: null == spaceName
          ? _value.spaceName
          : spaceName // ignore: cast_nullable_to_non_nullable
              as TextEditingController,
      spaceInfo: freezed == spaceInfo
          ? _value.spaceInfo
          : spaceInfo // ignore: cast_nullable_to_non_nullable
              as SpaceInfo?,
      invitationCode: freezed == invitationCode
          ? _value.invitationCode
          : invitationCode // ignore: cast_nullable_to_non_nullable
              as ApiSpaceInvitation?,
      refreshingInviteCode: null == refreshingInviteCode
          ? _value.refreshingInviteCode
          : refreshingInviteCode // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error ? _value.error : error,
    ));
  }
}

/// @nodoc

class _$EditSpaceViewStateImpl implements _EditSpaceViewState {
  const _$EditSpaceViewStateImpl(
      {this.loading = false,
      this.allowSave = false,
      this.saving = false,
      this.isAdmin = false,
      this.deleting = false,
      this.deleted = false,
      this.locationEnabled = false,
      this.isNetworkOff = false,
      this.adminRemovingMember = false,
      this.selectedSpaceName = '',
      this.currentUserId = '',
      this.currentUserInfo,
      final List<ApiUserInfo> userInfo = const [],
      required this.spaceName,
      this.spaceInfo,
      this.invitationCode,
      this.refreshingInviteCode = false,
      this.error})
      : _userInfo = userInfo;

  @override
  @JsonKey()
  final bool loading;
  @override
  @JsonKey()
  final bool allowSave;
  @override
  @JsonKey()
  final bool saving;
  @override
  @JsonKey()
  final bool isAdmin;
  @override
  @JsonKey()
  final bool deleting;
  @override
  @JsonKey()
  final bool deleted;
  @override
  @JsonKey()
  final bool locationEnabled;
  @override
  @JsonKey()
  final bool isNetworkOff;
  @override
  @JsonKey()
  final bool adminRemovingMember;
  @override
  @JsonKey()
  final String selectedSpaceName;
  @override
  @JsonKey()
  final String currentUserId;
  @override
  final ApiUserInfo? currentUserInfo;
  final List<ApiUserInfo> _userInfo;
  @override
  @JsonKey()
  List<ApiUserInfo> get userInfo {
    if (_userInfo is EqualUnmodifiableListView) return _userInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_userInfo);
  }

  @override
  final TextEditingController spaceName;
  @override
  final SpaceInfo? spaceInfo;
  @override
  final ApiSpaceInvitation? invitationCode;
  @override
  @JsonKey()
  final bool refreshingInviteCode;
  @override
  final Object? error;

  @override
  String toString() {
    return 'EditSpaceViewState(loading: $loading, allowSave: $allowSave, saving: $saving, isAdmin: $isAdmin, deleting: $deleting, deleted: $deleted, locationEnabled: $locationEnabled, isNetworkOff: $isNetworkOff, adminRemovingMember: $adminRemovingMember, selectedSpaceName: $selectedSpaceName, currentUserId: $currentUserId, currentUserInfo: $currentUserInfo, userInfo: $userInfo, spaceName: $spaceName, spaceInfo: $spaceInfo, invitationCode: $invitationCode, refreshingInviteCode: $refreshingInviteCode, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EditSpaceViewStateImpl &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.allowSave, allowSave) ||
                other.allowSave == allowSave) &&
            (identical(other.saving, saving) || other.saving == saving) &&
            (identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin) &&
            (identical(other.deleting, deleting) ||
                other.deleting == deleting) &&
            (identical(other.deleted, deleted) || other.deleted == deleted) &&
            (identical(other.locationEnabled, locationEnabled) ||
                other.locationEnabled == locationEnabled) &&
            (identical(other.isNetworkOff, isNetworkOff) ||
                other.isNetworkOff == isNetworkOff) &&
            (identical(other.adminRemovingMember, adminRemovingMember) ||
                other.adminRemovingMember == adminRemovingMember) &&
            (identical(other.selectedSpaceName, selectedSpaceName) ||
                other.selectedSpaceName == selectedSpaceName) &&
            (identical(other.currentUserId, currentUserId) ||
                other.currentUserId == currentUserId) &&
            (identical(other.currentUserInfo, currentUserInfo) ||
                other.currentUserInfo == currentUserInfo) &&
            const DeepCollectionEquality().equals(other._userInfo, _userInfo) &&
            (identical(other.spaceName, spaceName) ||
                other.spaceName == spaceName) &&
            (identical(other.spaceInfo, spaceInfo) ||
                other.spaceInfo == spaceInfo) &&
            (identical(other.invitationCode, invitationCode) ||
                other.invitationCode == invitationCode) &&
            (identical(other.refreshingInviteCode, refreshingInviteCode) ||
                other.refreshingInviteCode == refreshingInviteCode) &&
            const DeepCollectionEquality().equals(other.error, error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      loading,
      allowSave,
      saving,
      isAdmin,
      deleting,
      deleted,
      locationEnabled,
      isNetworkOff,
      adminRemovingMember,
      selectedSpaceName,
      currentUserId,
      currentUserInfo,
      const DeepCollectionEquality().hash(_userInfo),
      spaceName,
      spaceInfo,
      invitationCode,
      refreshingInviteCode,
      const DeepCollectionEquality().hash(error));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EditSpaceViewStateImplCopyWith<_$EditSpaceViewStateImpl> get copyWith =>
      __$$EditSpaceViewStateImplCopyWithImpl<_$EditSpaceViewStateImpl>(
          this, _$identity);
}

abstract class _EditSpaceViewState implements EditSpaceViewState {
  const factory _EditSpaceViewState(
      {final bool loading,
      final bool allowSave,
      final bool saving,
      final bool isAdmin,
      final bool deleting,
      final bool deleted,
      final bool locationEnabled,
      final bool isNetworkOff,
      final bool adminRemovingMember,
      final String selectedSpaceName,
      final String currentUserId,
      final ApiUserInfo? currentUserInfo,
      final List<ApiUserInfo> userInfo,
      required final TextEditingController spaceName,
      final SpaceInfo? spaceInfo,
      final ApiSpaceInvitation? invitationCode,
      final bool refreshingInviteCode,
      final Object? error}) = _$EditSpaceViewStateImpl;

  @override
  bool get loading;
  @override
  bool get allowSave;
  @override
  bool get saving;
  @override
  bool get isAdmin;
  @override
  bool get deleting;
  @override
  bool get deleted;
  @override
  bool get locationEnabled;
  @override
  bool get isNetworkOff;
  @override
  bool get adminRemovingMember;
  @override
  String get selectedSpaceName;
  @override
  String get currentUserId;
  @override
  ApiUserInfo? get currentUserInfo;
  @override
  List<ApiUserInfo> get userInfo;
  @override
  TextEditingController get spaceName;
  @override
  SpaceInfo? get spaceInfo;
  @override
  ApiSpaceInvitation? get invitationCode;
  @override
  bool get refreshingInviteCode;
  @override
  Object? get error;
  @override
  @JsonKey(ignore: true)
  _$$EditSpaceViewStateImplCopyWith<_$EditSpaceViewStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
