// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'timeline_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TimelineViewState {
  bool get isCurrentUserTimeline => throw _privateConstructorUsedError;
  ApiUser? get selectedUser => throw _privateConstructorUsedError;
  int? get selectedTimeForm => throw _privateConstructorUsedError;
  int? get selectedTimeTo => throw _privateConstructorUsedError;
  bool get loading => throw _privateConstructorUsedError;
  bool get appending => throw _privateConstructorUsedError;
  bool get hasMoreLocations => throw _privateConstructorUsedError;
  List<ApiLocation> get locations => throw _privateConstructorUsedError;
  Object? get error => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TimelineViewStateCopyWith<TimelineViewState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimelineViewStateCopyWith<$Res> {
  factory $TimelineViewStateCopyWith(
          TimelineViewState value, $Res Function(TimelineViewState) then) =
      _$TimelineViewStateCopyWithImpl<$Res, TimelineViewState>;
  @useResult
  $Res call(
      {bool isCurrentUserTimeline,
      ApiUser? selectedUser,
      int? selectedTimeForm,
      int? selectedTimeTo,
      bool loading,
      bool appending,
      bool hasMoreLocations,
      List<ApiLocation> locations,
      Object? error});

  $ApiUserCopyWith<$Res>? get selectedUser;
}

/// @nodoc
class _$TimelineViewStateCopyWithImpl<$Res, $Val extends TimelineViewState>
    implements $TimelineViewStateCopyWith<$Res> {
  _$TimelineViewStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isCurrentUserTimeline = null,
    Object? selectedUser = freezed,
    Object? selectedTimeForm = freezed,
    Object? selectedTimeTo = freezed,
    Object? loading = null,
    Object? appending = null,
    Object? hasMoreLocations = null,
    Object? locations = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      isCurrentUserTimeline: null == isCurrentUserTimeline
          ? _value.isCurrentUserTimeline
          : isCurrentUserTimeline // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedUser: freezed == selectedUser
          ? _value.selectedUser
          : selectedUser // ignore: cast_nullable_to_non_nullable
              as ApiUser?,
      selectedTimeForm: freezed == selectedTimeForm
          ? _value.selectedTimeForm
          : selectedTimeForm // ignore: cast_nullable_to_non_nullable
              as int?,
      selectedTimeTo: freezed == selectedTimeTo
          ? _value.selectedTimeTo
          : selectedTimeTo // ignore: cast_nullable_to_non_nullable
              as int?,
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      appending: null == appending
          ? _value.appending
          : appending // ignore: cast_nullable_to_non_nullable
              as bool,
      hasMoreLocations: null == hasMoreLocations
          ? _value.hasMoreLocations
          : hasMoreLocations // ignore: cast_nullable_to_non_nullable
              as bool,
      locations: null == locations
          ? _value.locations
          : locations // ignore: cast_nullable_to_non_nullable
              as List<ApiLocation>,
      error: freezed == error ? _value.error : error,
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
abstract class _$$TimelineViewStateImplCopyWith<$Res>
    implements $TimelineViewStateCopyWith<$Res> {
  factory _$$TimelineViewStateImplCopyWith(_$TimelineViewStateImpl value,
          $Res Function(_$TimelineViewStateImpl) then) =
      __$$TimelineViewStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isCurrentUserTimeline,
      ApiUser? selectedUser,
      int? selectedTimeForm,
      int? selectedTimeTo,
      bool loading,
      bool appending,
      bool hasMoreLocations,
      List<ApiLocation> locations,
      Object? error});

  @override
  $ApiUserCopyWith<$Res>? get selectedUser;
}

/// @nodoc
class __$$TimelineViewStateImplCopyWithImpl<$Res>
    extends _$TimelineViewStateCopyWithImpl<$Res, _$TimelineViewStateImpl>
    implements _$$TimelineViewStateImplCopyWith<$Res> {
  __$$TimelineViewStateImplCopyWithImpl(_$TimelineViewStateImpl _value,
      $Res Function(_$TimelineViewStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isCurrentUserTimeline = null,
    Object? selectedUser = freezed,
    Object? selectedTimeForm = freezed,
    Object? selectedTimeTo = freezed,
    Object? loading = null,
    Object? appending = null,
    Object? hasMoreLocations = null,
    Object? locations = null,
    Object? error = freezed,
  }) {
    return _then(_$TimelineViewStateImpl(
      isCurrentUserTimeline: null == isCurrentUserTimeline
          ? _value.isCurrentUserTimeline
          : isCurrentUserTimeline // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedUser: freezed == selectedUser
          ? _value.selectedUser
          : selectedUser // ignore: cast_nullable_to_non_nullable
              as ApiUser?,
      selectedTimeForm: freezed == selectedTimeForm
          ? _value.selectedTimeForm
          : selectedTimeForm // ignore: cast_nullable_to_non_nullable
              as int?,
      selectedTimeTo: freezed == selectedTimeTo
          ? _value.selectedTimeTo
          : selectedTimeTo // ignore: cast_nullable_to_non_nullable
              as int?,
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      appending: null == appending
          ? _value.appending
          : appending // ignore: cast_nullable_to_non_nullable
              as bool,
      hasMoreLocations: null == hasMoreLocations
          ? _value.hasMoreLocations
          : hasMoreLocations // ignore: cast_nullable_to_non_nullable
              as bool,
      locations: null == locations
          ? _value._locations
          : locations // ignore: cast_nullable_to_non_nullable
              as List<ApiLocation>,
      error: freezed == error ? _value.error : error,
    ));
  }
}

/// @nodoc

class _$TimelineViewStateImpl implements _TimelineViewState {
  const _$TimelineViewStateImpl(
      {this.isCurrentUserTimeline = false,
      this.selectedUser,
      this.selectedTimeForm,
      this.selectedTimeTo,
      this.loading = false,
      this.appending = false,
      this.hasMoreLocations = false,
      final List<ApiLocation> locations = const [],
      this.error})
      : _locations = locations;

  @override
  @JsonKey()
  final bool isCurrentUserTimeline;
  @override
  final ApiUser? selectedUser;
  @override
  final int? selectedTimeForm;
  @override
  final int? selectedTimeTo;
  @override
  @JsonKey()
  final bool loading;
  @override
  @JsonKey()
  final bool appending;
  @override
  @JsonKey()
  final bool hasMoreLocations;
  final List<ApiLocation> _locations;
  @override
  @JsonKey()
  List<ApiLocation> get locations {
    if (_locations is EqualUnmodifiableListView) return _locations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_locations);
  }

  @override
  final Object? error;

  @override
  String toString() {
    return 'TimelineViewState(isCurrentUserTimeline: $isCurrentUserTimeline, selectedUser: $selectedUser, selectedTimeForm: $selectedTimeForm, selectedTimeTo: $selectedTimeTo, loading: $loading, appending: $appending, hasMoreLocations: $hasMoreLocations, locations: $locations, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimelineViewStateImpl &&
            (identical(other.isCurrentUserTimeline, isCurrentUserTimeline) ||
                other.isCurrentUserTimeline == isCurrentUserTimeline) &&
            (identical(other.selectedUser, selectedUser) ||
                other.selectedUser == selectedUser) &&
            (identical(other.selectedTimeForm, selectedTimeForm) ||
                other.selectedTimeForm == selectedTimeForm) &&
            (identical(other.selectedTimeTo, selectedTimeTo) ||
                other.selectedTimeTo == selectedTimeTo) &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.appending, appending) ||
                other.appending == appending) &&
            (identical(other.hasMoreLocations, hasMoreLocations) ||
                other.hasMoreLocations == hasMoreLocations) &&
            const DeepCollectionEquality()
                .equals(other._locations, _locations) &&
            const DeepCollectionEquality().equals(other.error, error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isCurrentUserTimeline,
      selectedUser,
      selectedTimeForm,
      selectedTimeTo,
      loading,
      appending,
      hasMoreLocations,
      const DeepCollectionEquality().hash(_locations),
      const DeepCollectionEquality().hash(error));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TimelineViewStateImplCopyWith<_$TimelineViewStateImpl> get copyWith =>
      __$$TimelineViewStateImplCopyWithImpl<_$TimelineViewStateImpl>(
          this, _$identity);
}

abstract class _TimelineViewState implements TimelineViewState {
  const factory _TimelineViewState(
      {final bool isCurrentUserTimeline,
      final ApiUser? selectedUser,
      final int? selectedTimeForm,
      final int? selectedTimeTo,
      final bool loading,
      final bool appending,
      final bool hasMoreLocations,
      final List<ApiLocation> locations,
      final Object? error}) = _$TimelineViewStateImpl;

  @override
  bool get isCurrentUserTimeline;
  @override
  ApiUser? get selectedUser;
  @override
  int? get selectedTimeForm;
  @override
  int? get selectedTimeTo;
  @override
  bool get loading;
  @override
  bool get appending;
  @override
  bool get hasMoreLocations;
  @override
  List<ApiLocation> get locations;
  @override
  Object? get error;
  @override
  @JsonKey(ignore: true)
  _$$TimelineViewStateImplCopyWith<_$TimelineViewStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
