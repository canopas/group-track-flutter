// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_screen_viewmodel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$HomeViewState {
  bool get allowSave => throw _privateConstructorUsedError;
  bool get isCreating => throw _privateConstructorUsedError;
  bool get loading => throw _privateConstructorUsedError;
  bool get isCodeGetting => throw _privateConstructorUsedError;
  SpaceInfo? get selectedSpace => throw _privateConstructorUsedError;
  String get spaceInvitationCode => throw _privateConstructorUsedError;
  List<SpaceInfo> get spaceList => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $HomeViewStateCopyWith<HomeViewState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeViewStateCopyWith<$Res> {
  factory $HomeViewStateCopyWith(
          HomeViewState value, $Res Function(HomeViewState) then) =
      _$HomeViewStateCopyWithImpl<$Res, HomeViewState>;
  @useResult
  $Res call(
      {bool allowSave,
      bool isCreating,
      bool loading,
      bool isCodeGetting,
      SpaceInfo? selectedSpace,
      String spaceInvitationCode,
      List<SpaceInfo> spaceList});

  $SpaceInfoCopyWith<$Res>? get selectedSpace;
}

/// @nodoc
class _$HomeViewStateCopyWithImpl<$Res, $Val extends HomeViewState>
    implements $HomeViewStateCopyWith<$Res> {
  _$HomeViewStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? allowSave = null,
    Object? isCreating = null,
    Object? loading = null,
    Object? isCodeGetting = null,
    Object? selectedSpace = freezed,
    Object? spaceInvitationCode = null,
    Object? spaceList = null,
  }) {
    return _then(_value.copyWith(
      allowSave: null == allowSave
          ? _value.allowSave
          : allowSave // ignore: cast_nullable_to_non_nullable
              as bool,
      isCreating: null == isCreating
          ? _value.isCreating
          : isCreating // ignore: cast_nullable_to_non_nullable
              as bool,
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      isCodeGetting: null == isCodeGetting
          ? _value.isCodeGetting
          : isCodeGetting // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedSpace: freezed == selectedSpace
          ? _value.selectedSpace
          : selectedSpace // ignore: cast_nullable_to_non_nullable
              as SpaceInfo?,
      spaceInvitationCode: null == spaceInvitationCode
          ? _value.spaceInvitationCode
          : spaceInvitationCode // ignore: cast_nullable_to_non_nullable
              as String,
      spaceList: null == spaceList
          ? _value.spaceList
          : spaceList // ignore: cast_nullable_to_non_nullable
              as List<SpaceInfo>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $SpaceInfoCopyWith<$Res>? get selectedSpace {
    if (_value.selectedSpace == null) {
      return null;
    }

    return $SpaceInfoCopyWith<$Res>(_value.selectedSpace!, (value) {
      return _then(_value.copyWith(selectedSpace: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$HomeViewStateImplCopyWith<$Res>
    implements $HomeViewStateCopyWith<$Res> {
  factory _$$HomeViewStateImplCopyWith(
          _$HomeViewStateImpl value, $Res Function(_$HomeViewStateImpl) then) =
      __$$HomeViewStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool allowSave,
      bool isCreating,
      bool loading,
      bool isCodeGetting,
      SpaceInfo? selectedSpace,
      String spaceInvitationCode,
      List<SpaceInfo> spaceList});

  @override
  $SpaceInfoCopyWith<$Res>? get selectedSpace;
}

/// @nodoc
class __$$HomeViewStateImplCopyWithImpl<$Res>
    extends _$HomeViewStateCopyWithImpl<$Res, _$HomeViewStateImpl>
    implements _$$HomeViewStateImplCopyWith<$Res> {
  __$$HomeViewStateImplCopyWithImpl(
      _$HomeViewStateImpl _value, $Res Function(_$HomeViewStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? allowSave = null,
    Object? isCreating = null,
    Object? loading = null,
    Object? isCodeGetting = null,
    Object? selectedSpace = freezed,
    Object? spaceInvitationCode = null,
    Object? spaceList = null,
  }) {
    return _then(_$HomeViewStateImpl(
      allowSave: null == allowSave
          ? _value.allowSave
          : allowSave // ignore: cast_nullable_to_non_nullable
              as bool,
      isCreating: null == isCreating
          ? _value.isCreating
          : isCreating // ignore: cast_nullable_to_non_nullable
              as bool,
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      isCodeGetting: null == isCodeGetting
          ? _value.isCodeGetting
          : isCodeGetting // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedSpace: freezed == selectedSpace
          ? _value.selectedSpace
          : selectedSpace // ignore: cast_nullable_to_non_nullable
              as SpaceInfo?,
      spaceInvitationCode: null == spaceInvitationCode
          ? _value.spaceInvitationCode
          : spaceInvitationCode // ignore: cast_nullable_to_non_nullable
              as String,
      spaceList: null == spaceList
          ? _value._spaceList
          : spaceList // ignore: cast_nullable_to_non_nullable
              as List<SpaceInfo>,
    ));
  }
}

/// @nodoc

class _$HomeViewStateImpl implements _HomeViewState {
  const _$HomeViewStateImpl(
      {this.allowSave = false,
      this.isCreating = false,
      this.loading = false,
      this.isCodeGetting = false,
      this.selectedSpace,
      this.spaceInvitationCode = '',
      final List<SpaceInfo> spaceList = const []})
      : _spaceList = spaceList;

  @override
  @JsonKey()
  final bool allowSave;
  @override
  @JsonKey()
  final bool isCreating;
  @override
  @JsonKey()
  final bool loading;
  @override
  @JsonKey()
  final bool isCodeGetting;
  @override
  final SpaceInfo? selectedSpace;
  @override
  @JsonKey()
  final String spaceInvitationCode;
  final List<SpaceInfo> _spaceList;
  @override
  @JsonKey()
  List<SpaceInfo> get spaceList {
    if (_spaceList is EqualUnmodifiableListView) return _spaceList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_spaceList);
  }

  @override
  String toString() {
    return 'HomeViewState(allowSave: $allowSave, isCreating: $isCreating, loading: $loading, isCodeGetting: $isCodeGetting, selectedSpace: $selectedSpace, spaceInvitationCode: $spaceInvitationCode, spaceList: $spaceList)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeViewStateImpl &&
            (identical(other.allowSave, allowSave) ||
                other.allowSave == allowSave) &&
            (identical(other.isCreating, isCreating) ||
                other.isCreating == isCreating) &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.isCodeGetting, isCodeGetting) ||
                other.isCodeGetting == isCodeGetting) &&
            (identical(other.selectedSpace, selectedSpace) ||
                other.selectedSpace == selectedSpace) &&
            (identical(other.spaceInvitationCode, spaceInvitationCode) ||
                other.spaceInvitationCode == spaceInvitationCode) &&
            const DeepCollectionEquality()
                .equals(other._spaceList, _spaceList));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      allowSave,
      isCreating,
      loading,
      isCodeGetting,
      selectedSpace,
      spaceInvitationCode,
      const DeepCollectionEquality().hash(_spaceList));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeViewStateImplCopyWith<_$HomeViewStateImpl> get copyWith =>
      __$$HomeViewStateImplCopyWithImpl<_$HomeViewStateImpl>(this, _$identity);
}

abstract class _HomeViewState implements HomeViewState {
  const factory _HomeViewState(
      {final bool allowSave,
      final bool isCreating,
      final bool loading,
      final bool isCodeGetting,
      final SpaceInfo? selectedSpace,
      final String spaceInvitationCode,
      final List<SpaceInfo> spaceList}) = _$HomeViewStateImpl;

  @override
  bool get allowSave;
  @override
  bool get isCreating;
  @override
  bool get loading;
  @override
  bool get isCodeGetting;
  @override
  SpaceInfo? get selectedSpace;
  @override
  String get spaceInvitationCode;
  @override
  List<SpaceInfo> get spaceList;
  @override
  @JsonKey(ignore: true)
  _$$HomeViewStateImplCopyWith<_$HomeViewStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
