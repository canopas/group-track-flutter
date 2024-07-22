// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pick_name_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PickNameState {
  bool get enableBtn => throw _privateConstructorUsedError;
  bool get savingUser => throw _privateConstructorUsedError;
  bool get saved => throw _privateConstructorUsedError;
  Object? get error => throw _privateConstructorUsedError;
  TextEditingController get firstName => throw _privateConstructorUsedError;
  TextEditingController get lastName => throw _privateConstructorUsedError;
  ApiUser get user => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PickNameStateCopyWith<PickNameState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PickNameStateCopyWith<$Res> {
  factory $PickNameStateCopyWith(
          PickNameState value, $Res Function(PickNameState) then) =
      _$PickNameStateCopyWithImpl<$Res, PickNameState>;
  @useResult
  $Res call(
      {bool enableBtn,
      bool savingUser,
      bool saved,
      Object? error,
      TextEditingController firstName,
      TextEditingController lastName,
      ApiUser user});

  $ApiUserCopyWith<$Res> get user;
}

/// @nodoc
class _$PickNameStateCopyWithImpl<$Res, $Val extends PickNameState>
    implements $PickNameStateCopyWith<$Res> {
  _$PickNameStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enableBtn = null,
    Object? savingUser = null,
    Object? saved = null,
    Object? error = freezed,
    Object? firstName = null,
    Object? lastName = null,
    Object? user = null,
  }) {
    return _then(_value.copyWith(
      enableBtn: null == enableBtn
          ? _value.enableBtn
          : enableBtn // ignore: cast_nullable_to_non_nullable
              as bool,
      savingUser: null == savingUser
          ? _value.savingUser
          : savingUser // ignore: cast_nullable_to_non_nullable
              as bool,
      saved: null == saved
          ? _value.saved
          : saved // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error ? _value.error : error,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as TextEditingController,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as TextEditingController,
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as ApiUser,
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
abstract class _$$PickNameStateImplCopyWith<$Res>
    implements $PickNameStateCopyWith<$Res> {
  factory _$$PickNameStateImplCopyWith(
          _$PickNameStateImpl value, $Res Function(_$PickNameStateImpl) then) =
      __$$PickNameStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool enableBtn,
      bool savingUser,
      bool saved,
      Object? error,
      TextEditingController firstName,
      TextEditingController lastName,
      ApiUser user});

  @override
  $ApiUserCopyWith<$Res> get user;
}

/// @nodoc
class __$$PickNameStateImplCopyWithImpl<$Res>
    extends _$PickNameStateCopyWithImpl<$Res, _$PickNameStateImpl>
    implements _$$PickNameStateImplCopyWith<$Res> {
  __$$PickNameStateImplCopyWithImpl(
      _$PickNameStateImpl _value, $Res Function(_$PickNameStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enableBtn = null,
    Object? savingUser = null,
    Object? saved = null,
    Object? error = freezed,
    Object? firstName = null,
    Object? lastName = null,
    Object? user = null,
  }) {
    return _then(_$PickNameStateImpl(
      enableBtn: null == enableBtn
          ? _value.enableBtn
          : enableBtn // ignore: cast_nullable_to_non_nullable
              as bool,
      savingUser: null == savingUser
          ? _value.savingUser
          : savingUser // ignore: cast_nullable_to_non_nullable
              as bool,
      saved: null == saved
          ? _value.saved
          : saved // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error ? _value.error : error,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as TextEditingController,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as TextEditingController,
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as ApiUser,
    ));
  }
}

/// @nodoc

class _$PickNameStateImpl implements _PickNameState {
  const _$PickNameStateImpl(
      {this.enableBtn = false,
      this.savingUser = false,
      this.saved = false,
      this.error,
      required this.firstName,
      required this.lastName,
      required this.user});

  @override
  @JsonKey()
  final bool enableBtn;
  @override
  @JsonKey()
  final bool savingUser;
  @override
  @JsonKey()
  final bool saved;
  @override
  final Object? error;
  @override
  final TextEditingController firstName;
  @override
  final TextEditingController lastName;
  @override
  final ApiUser user;

  @override
  String toString() {
    return 'PickNameState(enableBtn: $enableBtn, savingUser: $savingUser, saved: $saved, error: $error, firstName: $firstName, lastName: $lastName, user: $user)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PickNameStateImpl &&
            (identical(other.enableBtn, enableBtn) ||
                other.enableBtn == enableBtn) &&
            (identical(other.savingUser, savingUser) ||
                other.savingUser == savingUser) &&
            (identical(other.saved, saved) || other.saved == saved) &&
            const DeepCollectionEquality().equals(other.error, error) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(runtimeType, enableBtn, savingUser, saved,
      const DeepCollectionEquality().hash(error), firstName, lastName, user);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PickNameStateImplCopyWith<_$PickNameStateImpl> get copyWith =>
      __$$PickNameStateImplCopyWithImpl<_$PickNameStateImpl>(this, _$identity);
}

abstract class _PickNameState implements PickNameState {
  const factory _PickNameState(
      {final bool enableBtn,
      final bool savingUser,
      final bool saved,
      final Object? error,
      required final TextEditingController firstName,
      required final TextEditingController lastName,
      required final ApiUser user}) = _$PickNameStateImpl;

  @override
  bool get enableBtn;
  @override
  bool get savingUser;
  @override
  bool get saved;
  @override
  Object? get error;
  @override
  TextEditingController get firstName;
  @override
  TextEditingController get lastName;
  @override
  ApiUser get user;
  @override
  @JsonKey(ignore: true)
  _$$PickNameStateImplCopyWith<_$PickNameStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
