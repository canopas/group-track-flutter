// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_space_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CreateSpaceViewState {
  bool get creating => throw _privateConstructorUsedError;
  String get selectedSpaceName => throw _privateConstructorUsedError;
  String get invitationCode => throw _privateConstructorUsedError;
  TextEditingController get spaceName => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CreateSpaceViewStateCopyWith<CreateSpaceViewState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateSpaceViewStateCopyWith<$Res> {
  factory $CreateSpaceViewStateCopyWith(CreateSpaceViewState value,
          $Res Function(CreateSpaceViewState) then) =
      _$CreateSpaceViewStateCopyWithImpl<$Res, CreateSpaceViewState>;
  @useResult
  $Res call(
      {bool creating,
      String selectedSpaceName,
      String invitationCode,
      TextEditingController spaceName});
}

/// @nodoc
class _$CreateSpaceViewStateCopyWithImpl<$Res,
        $Val extends CreateSpaceViewState>
    implements $CreateSpaceViewStateCopyWith<$Res> {
  _$CreateSpaceViewStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? creating = null,
    Object? selectedSpaceName = null,
    Object? invitationCode = null,
    Object? spaceName = null,
  }) {
    return _then(_value.copyWith(
      creating: null == creating
          ? _value.creating
          : creating // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedSpaceName: null == selectedSpaceName
          ? _value.selectedSpaceName
          : selectedSpaceName // ignore: cast_nullable_to_non_nullable
              as String,
      invitationCode: null == invitationCode
          ? _value.invitationCode
          : invitationCode // ignore: cast_nullable_to_non_nullable
              as String,
      spaceName: null == spaceName
          ? _value.spaceName
          : spaceName // ignore: cast_nullable_to_non_nullable
              as TextEditingController,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateSpaceViewStateImplCopyWith<$Res>
    implements $CreateSpaceViewStateCopyWith<$Res> {
  factory _$$CreateSpaceViewStateImplCopyWith(_$CreateSpaceViewStateImpl value,
          $Res Function(_$CreateSpaceViewStateImpl) then) =
      __$$CreateSpaceViewStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool creating,
      String selectedSpaceName,
      String invitationCode,
      TextEditingController spaceName});
}

/// @nodoc
class __$$CreateSpaceViewStateImplCopyWithImpl<$Res>
    extends _$CreateSpaceViewStateCopyWithImpl<$Res, _$CreateSpaceViewStateImpl>
    implements _$$CreateSpaceViewStateImplCopyWith<$Res> {
  __$$CreateSpaceViewStateImplCopyWithImpl(_$CreateSpaceViewStateImpl _value,
      $Res Function(_$CreateSpaceViewStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? creating = null,
    Object? selectedSpaceName = null,
    Object? invitationCode = null,
    Object? spaceName = null,
  }) {
    return _then(_$CreateSpaceViewStateImpl(
      creating: null == creating
          ? _value.creating
          : creating // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedSpaceName: null == selectedSpaceName
          ? _value.selectedSpaceName
          : selectedSpaceName // ignore: cast_nullable_to_non_nullable
              as String,
      invitationCode: null == invitationCode
          ? _value.invitationCode
          : invitationCode // ignore: cast_nullable_to_non_nullable
              as String,
      spaceName: null == spaceName
          ? _value.spaceName
          : spaceName // ignore: cast_nullable_to_non_nullable
              as TextEditingController,
    ));
  }
}

/// @nodoc

class _$CreateSpaceViewStateImpl implements _CreateSpaceViewState {
  const _$CreateSpaceViewStateImpl(
      {this.creating = false,
      this.selectedSpaceName = '',
      this.invitationCode = '',
      required this.spaceName});

  @override
  @JsonKey()
  final bool creating;
  @override
  @JsonKey()
  final String selectedSpaceName;
  @override
  @JsonKey()
  final String invitationCode;
  @override
  final TextEditingController spaceName;

  @override
  String toString() {
    return 'CreateSpaceViewState(creating: $creating, selectedSpaceName: $selectedSpaceName, invitationCode: $invitationCode, spaceName: $spaceName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateSpaceViewStateImpl &&
            (identical(other.creating, creating) ||
                other.creating == creating) &&
            (identical(other.selectedSpaceName, selectedSpaceName) ||
                other.selectedSpaceName == selectedSpaceName) &&
            (identical(other.invitationCode, invitationCode) ||
                other.invitationCode == invitationCode) &&
            (identical(other.spaceName, spaceName) ||
                other.spaceName == spaceName));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, creating, selectedSpaceName, invitationCode, spaceName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateSpaceViewStateImplCopyWith<_$CreateSpaceViewStateImpl>
      get copyWith =>
          __$$CreateSpaceViewStateImplCopyWithImpl<_$CreateSpaceViewStateImpl>(
              this, _$identity);
}

abstract class _CreateSpaceViewState implements CreateSpaceViewState {
  const factory _CreateSpaceViewState(
          {final bool creating,
          final String selectedSpaceName,
          final String invitationCode,
          required final TextEditingController spaceName}) =
      _$CreateSpaceViewStateImpl;

  @override
  bool get creating;
  @override
  String get selectedSpaceName;
  @override
  String get invitationCode;
  @override
  TextEditingController get spaceName;
  @override
  @JsonKey(ignore: true)
  _$$CreateSpaceViewStateImplCopyWith<_$CreateSpaceViewStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
