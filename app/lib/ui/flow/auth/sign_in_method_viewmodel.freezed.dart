// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sign_in_method_viewmodel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SignInMethodsScreenState {
  bool get showAppleLoading => throw _privateConstructorUsedError;
  bool get showGoogleLoading => throw _privateConstructorUsedError;
  dynamic get socialSignInCompleted => throw _privateConstructorUsedError;
  bool get isNewUser => throw _privateConstructorUsedError;
  Object? get error => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SignInMethodsScreenStateCopyWith<SignInMethodsScreenState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SignInMethodsScreenStateCopyWith<$Res> {
  factory $SignInMethodsScreenStateCopyWith(SignInMethodsScreenState value,
          $Res Function(SignInMethodsScreenState) then) =
      _$SignInMethodsScreenStateCopyWithImpl<$Res, SignInMethodsScreenState>;
  @useResult
  $Res call(
      {bool showAppleLoading,
      bool showGoogleLoading,
      dynamic socialSignInCompleted,
      bool isNewUser,
      Object? error});
}

/// @nodoc
class _$SignInMethodsScreenStateCopyWithImpl<$Res,
        $Val extends SignInMethodsScreenState>
    implements $SignInMethodsScreenStateCopyWith<$Res> {
  _$SignInMethodsScreenStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? showAppleLoading = null,
    Object? showGoogleLoading = null,
    Object? socialSignInCompleted = freezed,
    Object? isNewUser = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      showAppleLoading: null == showAppleLoading
          ? _value.showAppleLoading
          : showAppleLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      showGoogleLoading: null == showGoogleLoading
          ? _value.showGoogleLoading
          : showGoogleLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      socialSignInCompleted: freezed == socialSignInCompleted
          ? _value.socialSignInCompleted
          : socialSignInCompleted // ignore: cast_nullable_to_non_nullable
              as dynamic,
      isNewUser: null == isNewUser
          ? _value.isNewUser
          : isNewUser // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error ? _value.error : error,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SignInMethodsScreenStateImplCopyWith<$Res>
    implements $SignInMethodsScreenStateCopyWith<$Res> {
  factory _$$SignInMethodsScreenStateImplCopyWith(
          _$SignInMethodsScreenStateImpl value,
          $Res Function(_$SignInMethodsScreenStateImpl) then) =
      __$$SignInMethodsScreenStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool showAppleLoading,
      bool showGoogleLoading,
      dynamic socialSignInCompleted,
      bool isNewUser,
      Object? error});
}

/// @nodoc
class __$$SignInMethodsScreenStateImplCopyWithImpl<$Res>
    extends _$SignInMethodsScreenStateCopyWithImpl<$Res,
        _$SignInMethodsScreenStateImpl>
    implements _$$SignInMethodsScreenStateImplCopyWith<$Res> {
  __$$SignInMethodsScreenStateImplCopyWithImpl(
      _$SignInMethodsScreenStateImpl _value,
      $Res Function(_$SignInMethodsScreenStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? showAppleLoading = null,
    Object? showGoogleLoading = null,
    Object? socialSignInCompleted = freezed,
    Object? isNewUser = null,
    Object? error = freezed,
  }) {
    return _then(_$SignInMethodsScreenStateImpl(
      showAppleLoading: null == showAppleLoading
          ? _value.showAppleLoading
          : showAppleLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      showGoogleLoading: null == showGoogleLoading
          ? _value.showGoogleLoading
          : showGoogleLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      socialSignInCompleted: freezed == socialSignInCompleted
          ? _value.socialSignInCompleted!
          : socialSignInCompleted,
      isNewUser: null == isNewUser
          ? _value.isNewUser
          : isNewUser // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error ? _value.error : error,
    ));
  }
}

/// @nodoc

class _$SignInMethodsScreenStateImpl implements _SignInMethodsScreenState {
  const _$SignInMethodsScreenStateImpl(
      {this.showAppleLoading = false,
      this.showGoogleLoading = false,
      this.socialSignInCompleted = false,
      this.isNewUser = false,
      this.error});

  @override
  @JsonKey()
  final bool showAppleLoading;
  @override
  @JsonKey()
  final bool showGoogleLoading;
  @override
  @JsonKey()
  final dynamic socialSignInCompleted;
  @override
  @JsonKey()
  final bool isNewUser;
  @override
  final Object? error;

  @override
  String toString() {
    return 'SignInMethodsScreenState(showAppleLoading: $showAppleLoading, showGoogleLoading: $showGoogleLoading, socialSignInCompleted: $socialSignInCompleted, isNewUser: $isNewUser, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SignInMethodsScreenStateImpl &&
            (identical(other.showAppleLoading, showAppleLoading) ||
                other.showAppleLoading == showAppleLoading) &&
            (identical(other.showGoogleLoading, showGoogleLoading) ||
                other.showGoogleLoading == showGoogleLoading) &&
            const DeepCollectionEquality()
                .equals(other.socialSignInCompleted, socialSignInCompleted) &&
            (identical(other.isNewUser, isNewUser) ||
                other.isNewUser == isNewUser) &&
            const DeepCollectionEquality().equals(other.error, error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      showAppleLoading,
      showGoogleLoading,
      const DeepCollectionEquality().hash(socialSignInCompleted),
      isNewUser,
      const DeepCollectionEquality().hash(error));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SignInMethodsScreenStateImplCopyWith<_$SignInMethodsScreenStateImpl>
      get copyWith => __$$SignInMethodsScreenStateImplCopyWithImpl<
          _$SignInMethodsScreenStateImpl>(this, _$identity);
}

abstract class _SignInMethodsScreenState implements SignInMethodsScreenState {
  const factory _SignInMethodsScreenState(
      {final bool showAppleLoading,
      final bool showGoogleLoading,
      final dynamic socialSignInCompleted,
      final bool isNewUser,
      final Object? error}) = _$SignInMethodsScreenStateImpl;

  @override
  bool get showAppleLoading;
  @override
  bool get showGoogleLoading;
  @override
  dynamic get socialSignInCompleted;
  @override
  bool get isNewUser;
  @override
  Object? get error;
  @override
  @JsonKey(ignore: true)
  _$$SignInMethodsScreenStateImplCopyWith<_$SignInMethodsScreenStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
