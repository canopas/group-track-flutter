// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'setting_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SettingViewState {
  bool get loading => throw _privateConstructorUsedError;
  bool get signingOut => throw _privateConstructorUsedError;
  bool get logOut => throw _privateConstructorUsedError;
  String get selectedSpaceName => throw _privateConstructorUsedError;
  List<ApiSpace> get spaces => throw _privateConstructorUsedError;
  ApiUser? get currentUser => throw _privateConstructorUsedError;
  Object? get error => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SettingViewStateCopyWith<SettingViewState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettingViewStateCopyWith<$Res> {
  factory $SettingViewStateCopyWith(
          SettingViewState value, $Res Function(SettingViewState) then) =
      _$SettingViewStateCopyWithImpl<$Res, SettingViewState>;
  @useResult
  $Res call(
      {bool loading,
      bool signingOut,
      bool logOut,
      String selectedSpaceName,
      List<ApiSpace> spaces,
      ApiUser? currentUser,
      Object? error});

  $ApiUserCopyWith<$Res>? get currentUser;
}

/// @nodoc
class _$SettingViewStateCopyWithImpl<$Res, $Val extends SettingViewState>
    implements $SettingViewStateCopyWith<$Res> {
  _$SettingViewStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = null,
    Object? signingOut = null,
    Object? logOut = null,
    Object? selectedSpaceName = null,
    Object? spaces = null,
    Object? currentUser = freezed,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      signingOut: null == signingOut
          ? _value.signingOut
          : signingOut // ignore: cast_nullable_to_non_nullable
              as bool,
      logOut: null == logOut
          ? _value.logOut
          : logOut // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedSpaceName: null == selectedSpaceName
          ? _value.selectedSpaceName
          : selectedSpaceName // ignore: cast_nullable_to_non_nullable
              as String,
      spaces: null == spaces
          ? _value.spaces
          : spaces // ignore: cast_nullable_to_non_nullable
              as List<ApiSpace>,
      currentUser: freezed == currentUser
          ? _value.currentUser
          : currentUser // ignore: cast_nullable_to_non_nullable
              as ApiUser?,
      error: freezed == error ? _value.error : error,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ApiUserCopyWith<$Res>? get currentUser {
    if (_value.currentUser == null) {
      return null;
    }

    return $ApiUserCopyWith<$Res>(_value.currentUser!, (value) {
      return _then(_value.copyWith(currentUser: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SettingViewStateImplCopyWith<$Res>
    implements $SettingViewStateCopyWith<$Res> {
  factory _$$SettingViewStateImplCopyWith(_$SettingViewStateImpl value,
          $Res Function(_$SettingViewStateImpl) then) =
      __$$SettingViewStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool loading,
      bool signingOut,
      bool logOut,
      String selectedSpaceName,
      List<ApiSpace> spaces,
      ApiUser? currentUser,
      Object? error});

  @override
  $ApiUserCopyWith<$Res>? get currentUser;
}

/// @nodoc
class __$$SettingViewStateImplCopyWithImpl<$Res>
    extends _$SettingViewStateCopyWithImpl<$Res, _$SettingViewStateImpl>
    implements _$$SettingViewStateImplCopyWith<$Res> {
  __$$SettingViewStateImplCopyWithImpl(_$SettingViewStateImpl _value,
      $Res Function(_$SettingViewStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = null,
    Object? signingOut = null,
    Object? logOut = null,
    Object? selectedSpaceName = null,
    Object? spaces = null,
    Object? currentUser = freezed,
    Object? error = freezed,
  }) {
    return _then(_$SettingViewStateImpl(
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      signingOut: null == signingOut
          ? _value.signingOut
          : signingOut // ignore: cast_nullable_to_non_nullable
              as bool,
      logOut: null == logOut
          ? _value.logOut
          : logOut // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedSpaceName: null == selectedSpaceName
          ? _value.selectedSpaceName
          : selectedSpaceName // ignore: cast_nullable_to_non_nullable
              as String,
      spaces: null == spaces
          ? _value._spaces
          : spaces // ignore: cast_nullable_to_non_nullable
              as List<ApiSpace>,
      currentUser: freezed == currentUser
          ? _value.currentUser
          : currentUser // ignore: cast_nullable_to_non_nullable
              as ApiUser?,
      error: freezed == error ? _value.error : error,
    ));
  }
}

/// @nodoc

class _$SettingViewStateImpl implements _SettingViewState {
  const _$SettingViewStateImpl(
      {this.loading = false,
      this.signingOut = false,
      this.logOut = false,
      this.selectedSpaceName = '',
      final List<ApiSpace> spaces = const [],
      this.currentUser,
      this.error})
      : _spaces = spaces;

  @override
  @JsonKey()
  final bool loading;
  @override
  @JsonKey()
  final bool signingOut;
  @override
  @JsonKey()
  final bool logOut;
  @override
  @JsonKey()
  final String selectedSpaceName;
  final List<ApiSpace> _spaces;
  @override
  @JsonKey()
  List<ApiSpace> get spaces {
    if (_spaces is EqualUnmodifiableListView) return _spaces;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_spaces);
  }

  @override
  final ApiUser? currentUser;
  @override
  final Object? error;

  @override
  String toString() {
    return 'SettingViewState(loading: $loading, signingOut: $signingOut, logOut: $logOut, selectedSpaceName: $selectedSpaceName, spaces: $spaces, currentUser: $currentUser, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SettingViewStateImpl &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.signingOut, signingOut) ||
                other.signingOut == signingOut) &&
            (identical(other.logOut, logOut) || other.logOut == logOut) &&
            (identical(other.selectedSpaceName, selectedSpaceName) ||
                other.selectedSpaceName == selectedSpaceName) &&
            const DeepCollectionEquality().equals(other._spaces, _spaces) &&
            (identical(other.currentUser, currentUser) ||
                other.currentUser == currentUser) &&
            const DeepCollectionEquality().equals(other.error, error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      loading,
      signingOut,
      logOut,
      selectedSpaceName,
      const DeepCollectionEquality().hash(_spaces),
      currentUser,
      const DeepCollectionEquality().hash(error));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SettingViewStateImplCopyWith<_$SettingViewStateImpl> get copyWith =>
      __$$SettingViewStateImplCopyWithImpl<_$SettingViewStateImpl>(
          this, _$identity);
}

abstract class _SettingViewState implements SettingViewState {
  const factory _SettingViewState(
      {final bool loading,
      final bool signingOut,
      final bool logOut,
      final String selectedSpaceName,
      final List<ApiSpace> spaces,
      final ApiUser? currentUser,
      final Object? error}) = _$SettingViewStateImpl;

  @override
  bool get loading;
  @override
  bool get signingOut;
  @override
  bool get logOut;
  @override
  String get selectedSpaceName;
  @override
  List<ApiSpace> get spaces;
  @override
  ApiUser? get currentUser;
  @override
  Object? get error;
  @override
  @JsonKey(ignore: true)
  _$$SettingViewStateImplCopyWith<_$SettingViewStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
