// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'change_admin_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ChangeAdminViewState {
  bool get allowSave => throw _privateConstructorUsedError;
  bool get saving => throw _privateConstructorUsedError;
  bool get adminIdChanged => throw _privateConstructorUsedError;
  String get newAdminId => throw _privateConstructorUsedError;
  String get currentUserId => throw _privateConstructorUsedError;
  Object? get error => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ChangeAdminViewStateCopyWith<ChangeAdminViewState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChangeAdminViewStateCopyWith<$Res> {
  factory $ChangeAdminViewStateCopyWith(ChangeAdminViewState value,
          $Res Function(ChangeAdminViewState) then) =
      _$ChangeAdminViewStateCopyWithImpl<$Res, ChangeAdminViewState>;
  @useResult
  $Res call(
      {bool allowSave,
      bool saving,
      bool adminIdChanged,
      String newAdminId,
      String currentUserId,
      Object? error});
}

/// @nodoc
class _$ChangeAdminViewStateCopyWithImpl<$Res,
        $Val extends ChangeAdminViewState>
    implements $ChangeAdminViewStateCopyWith<$Res> {
  _$ChangeAdminViewStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? allowSave = null,
    Object? saving = null,
    Object? adminIdChanged = null,
    Object? newAdminId = null,
    Object? currentUserId = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      allowSave: null == allowSave
          ? _value.allowSave
          : allowSave // ignore: cast_nullable_to_non_nullable
              as bool,
      saving: null == saving
          ? _value.saving
          : saving // ignore: cast_nullable_to_non_nullable
              as bool,
      adminIdChanged: null == adminIdChanged
          ? _value.adminIdChanged
          : adminIdChanged // ignore: cast_nullable_to_non_nullable
              as bool,
      newAdminId: null == newAdminId
          ? _value.newAdminId
          : newAdminId // ignore: cast_nullable_to_non_nullable
              as String,
      currentUserId: null == currentUserId
          ? _value.currentUserId
          : currentUserId // ignore: cast_nullable_to_non_nullable
              as String,
      error: freezed == error ? _value.error : error,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChangeAdminViewStateImplCopyWith<$Res>
    implements $ChangeAdminViewStateCopyWith<$Res> {
  factory _$$ChangeAdminViewStateImplCopyWith(_$ChangeAdminViewStateImpl value,
          $Res Function(_$ChangeAdminViewStateImpl) then) =
      __$$ChangeAdminViewStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool allowSave,
      bool saving,
      bool adminIdChanged,
      String newAdminId,
      String currentUserId,
      Object? error});
}

/// @nodoc
class __$$ChangeAdminViewStateImplCopyWithImpl<$Res>
    extends _$ChangeAdminViewStateCopyWithImpl<$Res, _$ChangeAdminViewStateImpl>
    implements _$$ChangeAdminViewStateImplCopyWith<$Res> {
  __$$ChangeAdminViewStateImplCopyWithImpl(_$ChangeAdminViewStateImpl _value,
      $Res Function(_$ChangeAdminViewStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? allowSave = null,
    Object? saving = null,
    Object? adminIdChanged = null,
    Object? newAdminId = null,
    Object? currentUserId = null,
    Object? error = freezed,
  }) {
    return _then(_$ChangeAdminViewStateImpl(
      allowSave: null == allowSave
          ? _value.allowSave
          : allowSave // ignore: cast_nullable_to_non_nullable
              as bool,
      saving: null == saving
          ? _value.saving
          : saving // ignore: cast_nullable_to_non_nullable
              as bool,
      adminIdChanged: null == adminIdChanged
          ? _value.adminIdChanged
          : adminIdChanged // ignore: cast_nullable_to_non_nullable
              as bool,
      newAdminId: null == newAdminId
          ? _value.newAdminId
          : newAdminId // ignore: cast_nullable_to_non_nullable
              as String,
      currentUserId: null == currentUserId
          ? _value.currentUserId
          : currentUserId // ignore: cast_nullable_to_non_nullable
              as String,
      error: freezed == error ? _value.error : error,
    ));
  }
}

/// @nodoc

class _$ChangeAdminViewStateImpl implements _ChangeAdminViewState {
  const _$ChangeAdminViewStateImpl(
      {this.allowSave = false,
      this.saving = false,
      this.adminIdChanged = false,
      this.newAdminId = '',
      this.currentUserId = '',
      this.error});

  @override
  @JsonKey()
  final bool allowSave;
  @override
  @JsonKey()
  final bool saving;
  @override
  @JsonKey()
  final bool adminIdChanged;
  @override
  @JsonKey()
  final String newAdminId;
  @override
  @JsonKey()
  final String currentUserId;
  @override
  final Object? error;

  @override
  String toString() {
    return 'ChangeAdminViewState(allowSave: $allowSave, saving: $saving, adminIdChanged: $adminIdChanged, newAdminId: $newAdminId, currentUserId: $currentUserId, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChangeAdminViewStateImpl &&
            (identical(other.allowSave, allowSave) ||
                other.allowSave == allowSave) &&
            (identical(other.saving, saving) || other.saving == saving) &&
            (identical(other.adminIdChanged, adminIdChanged) ||
                other.adminIdChanged == adminIdChanged) &&
            (identical(other.newAdminId, newAdminId) ||
                other.newAdminId == newAdminId) &&
            (identical(other.currentUserId, currentUserId) ||
                other.currentUserId == currentUserId) &&
            const DeepCollectionEquality().equals(other.error, error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      allowSave,
      saving,
      adminIdChanged,
      newAdminId,
      currentUserId,
      const DeepCollectionEquality().hash(error));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChangeAdminViewStateImplCopyWith<_$ChangeAdminViewStateImpl>
      get copyWith =>
          __$$ChangeAdminViewStateImplCopyWithImpl<_$ChangeAdminViewStateImpl>(
              this, _$identity);
}

abstract class _ChangeAdminViewState implements ChangeAdminViewState {
  const factory _ChangeAdminViewState(
      {final bool allowSave,
      final bool saving,
      final bool adminIdChanged,
      final String newAdminId,
      final String currentUserId,
      final Object? error}) = _$ChangeAdminViewStateImpl;

  @override
  bool get allowSave;
  @override
  bool get saving;
  @override
  bool get adminIdChanged;
  @override
  String get newAdminId;
  @override
  String get currentUserId;
  @override
  Object? get error;
  @override
  @JsonKey(ignore: true)
  _$$ChangeAdminViewStateImplCopyWith<_$ChangeAdminViewStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
