// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'join_space_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$JoinSpaceViewState {
  bool get allowSave => throw _privateConstructorUsedError;
  String get invitationCode => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $JoinSpaceViewStateCopyWith<JoinSpaceViewState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JoinSpaceViewStateCopyWith<$Res> {
  factory $JoinSpaceViewStateCopyWith(
          JoinSpaceViewState value, $Res Function(JoinSpaceViewState) then) =
      _$JoinSpaceViewStateCopyWithImpl<$Res, JoinSpaceViewState>;
  @useResult
  $Res call({bool allowSave, String invitationCode});
}

/// @nodoc
class _$JoinSpaceViewStateCopyWithImpl<$Res, $Val extends JoinSpaceViewState>
    implements $JoinSpaceViewStateCopyWith<$Res> {
  _$JoinSpaceViewStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? allowSave = null,
    Object? invitationCode = null,
  }) {
    return _then(_value.copyWith(
      allowSave: null == allowSave
          ? _value.allowSave
          : allowSave // ignore: cast_nullable_to_non_nullable
              as bool,
      invitationCode: null == invitationCode
          ? _value.invitationCode
          : invitationCode // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$JoinSpaceViewStateImplCopyWith<$Res>
    implements $JoinSpaceViewStateCopyWith<$Res> {
  factory _$$JoinSpaceViewStateImplCopyWith(_$JoinSpaceViewStateImpl value,
          $Res Function(_$JoinSpaceViewStateImpl) then) =
      __$$JoinSpaceViewStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool allowSave, String invitationCode});
}

/// @nodoc
class __$$JoinSpaceViewStateImplCopyWithImpl<$Res>
    extends _$JoinSpaceViewStateCopyWithImpl<$Res, _$JoinSpaceViewStateImpl>
    implements _$$JoinSpaceViewStateImplCopyWith<$Res> {
  __$$JoinSpaceViewStateImplCopyWithImpl(_$JoinSpaceViewStateImpl _value,
      $Res Function(_$JoinSpaceViewStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? allowSave = null,
    Object? invitationCode = null,
  }) {
    return _then(_$JoinSpaceViewStateImpl(
      allowSave: null == allowSave
          ? _value.allowSave
          : allowSave // ignore: cast_nullable_to_non_nullable
              as bool,
      invitationCode: null == invitationCode
          ? _value.invitationCode
          : invitationCode // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$JoinSpaceViewStateImpl implements _JoinSpaceViewState {
  const _$JoinSpaceViewStateImpl(
      {this.allowSave = false, this.invitationCode = ''});

  @override
  @JsonKey()
  final bool allowSave;
  @override
  @JsonKey()
  final String invitationCode;

  @override
  String toString() {
    return 'JoinSpaceViewState(allowSave: $allowSave, invitationCode: $invitationCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JoinSpaceViewStateImpl &&
            (identical(other.allowSave, allowSave) ||
                other.allowSave == allowSave) &&
            (identical(other.invitationCode, invitationCode) ||
                other.invitationCode == invitationCode));
  }

  @override
  int get hashCode => Object.hash(runtimeType, allowSave, invitationCode);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$JoinSpaceViewStateImplCopyWith<_$JoinSpaceViewStateImpl> get copyWith =>
      __$$JoinSpaceViewStateImplCopyWithImpl<_$JoinSpaceViewStateImpl>(
          this, _$identity);
}

abstract class _JoinSpaceViewState implements JoinSpaceViewState {
  const factory _JoinSpaceViewState(
      {final bool allowSave,
      final String invitationCode}) = _$JoinSpaceViewStateImpl;

  @override
  bool get allowSave;
  @override
  String get invitationCode;
  @override
  @JsonKey(ignore: true)
  _$$JoinSpaceViewStateImplCopyWith<_$JoinSpaceViewStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
