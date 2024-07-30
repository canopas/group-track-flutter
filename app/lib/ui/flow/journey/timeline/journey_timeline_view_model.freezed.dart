// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'journey_timeline_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$JourneyTimelineState {
  bool get isLoading => throw _privateConstructorUsedError;
  bool get appending => throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;
  bool get isCurrentUser => throw _privateConstructorUsedError;
  bool get showDatePicker => throw _privateConstructorUsedError;
  ApiUser? get selectedUser => throw _privateConstructorUsedError;
  List<ApiLocationJourney> get sortedJourney =>
      throw _privateConstructorUsedError;
  int? get selectedTimeFrom => throw _privateConstructorUsedError;
  int? get selectedTimeTo => throw _privateConstructorUsedError;
  Object? get error => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $JourneyTimelineStateCopyWith<JourneyTimelineState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JourneyTimelineStateCopyWith<$Res> {
  factory $JourneyTimelineStateCopyWith(JourneyTimelineState value,
          $Res Function(JourneyTimelineState) then) =
      _$JourneyTimelineStateCopyWithImpl<$Res, JourneyTimelineState>;
  @useResult
  $Res call(
      {bool isLoading,
      bool appending,
      bool hasMore,
      bool isCurrentUser,
      bool showDatePicker,
      ApiUser? selectedUser,
      List<ApiLocationJourney> sortedJourney,
      int? selectedTimeFrom,
      int? selectedTimeTo,
      Object? error});

  $ApiUserCopyWith<$Res>? get selectedUser;
}

/// @nodoc
class _$JourneyTimelineStateCopyWithImpl<$Res,
        $Val extends JourneyTimelineState>
    implements $JourneyTimelineStateCopyWith<$Res> {
  _$JourneyTimelineStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? appending = null,
    Object? hasMore = null,
    Object? isCurrentUser = null,
    Object? showDatePicker = null,
    Object? selectedUser = freezed,
    Object? sortedJourney = null,
    Object? selectedTimeFrom = freezed,
    Object? selectedTimeTo = freezed,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      appending: null == appending
          ? _value.appending
          : appending // ignore: cast_nullable_to_non_nullable
              as bool,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      isCurrentUser: null == isCurrentUser
          ? _value.isCurrentUser
          : isCurrentUser // ignore: cast_nullable_to_non_nullable
              as bool,
      showDatePicker: null == showDatePicker
          ? _value.showDatePicker
          : showDatePicker // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedUser: freezed == selectedUser
          ? _value.selectedUser
          : selectedUser // ignore: cast_nullable_to_non_nullable
              as ApiUser?,
      sortedJourney: null == sortedJourney
          ? _value.sortedJourney
          : sortedJourney // ignore: cast_nullable_to_non_nullable
              as List<ApiLocationJourney>,
      selectedTimeFrom: freezed == selectedTimeFrom
          ? _value.selectedTimeFrom
          : selectedTimeFrom // ignore: cast_nullable_to_non_nullable
              as int?,
      selectedTimeTo: freezed == selectedTimeTo
          ? _value.selectedTimeTo
          : selectedTimeTo // ignore: cast_nullable_to_non_nullable
              as int?,
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
abstract class _$$JourneyTimelineStateImplCopyWith<$Res>
    implements $JourneyTimelineStateCopyWith<$Res> {
  factory _$$JourneyTimelineStateImplCopyWith(_$JourneyTimelineStateImpl value,
          $Res Function(_$JourneyTimelineStateImpl) then) =
      __$$JourneyTimelineStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      bool appending,
      bool hasMore,
      bool isCurrentUser,
      bool showDatePicker,
      ApiUser? selectedUser,
      List<ApiLocationJourney> sortedJourney,
      int? selectedTimeFrom,
      int? selectedTimeTo,
      Object? error});

  @override
  $ApiUserCopyWith<$Res>? get selectedUser;
}

/// @nodoc
class __$$JourneyTimelineStateImplCopyWithImpl<$Res>
    extends _$JourneyTimelineStateCopyWithImpl<$Res, _$JourneyTimelineStateImpl>
    implements _$$JourneyTimelineStateImplCopyWith<$Res> {
  __$$JourneyTimelineStateImplCopyWithImpl(_$JourneyTimelineStateImpl _value,
      $Res Function(_$JourneyTimelineStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? appending = null,
    Object? hasMore = null,
    Object? isCurrentUser = null,
    Object? showDatePicker = null,
    Object? selectedUser = freezed,
    Object? sortedJourney = null,
    Object? selectedTimeFrom = freezed,
    Object? selectedTimeTo = freezed,
    Object? error = freezed,
  }) {
    return _then(_$JourneyTimelineStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      appending: null == appending
          ? _value.appending
          : appending // ignore: cast_nullable_to_non_nullable
              as bool,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      isCurrentUser: null == isCurrentUser
          ? _value.isCurrentUser
          : isCurrentUser // ignore: cast_nullable_to_non_nullable
              as bool,
      showDatePicker: null == showDatePicker
          ? _value.showDatePicker
          : showDatePicker // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedUser: freezed == selectedUser
          ? _value.selectedUser
          : selectedUser // ignore: cast_nullable_to_non_nullable
              as ApiUser?,
      sortedJourney: null == sortedJourney
          ? _value._sortedJourney
          : sortedJourney // ignore: cast_nullable_to_non_nullable
              as List<ApiLocationJourney>,
      selectedTimeFrom: freezed == selectedTimeFrom
          ? _value.selectedTimeFrom
          : selectedTimeFrom // ignore: cast_nullable_to_non_nullable
              as int?,
      selectedTimeTo: freezed == selectedTimeTo
          ? _value.selectedTimeTo
          : selectedTimeTo // ignore: cast_nullable_to_non_nullable
              as int?,
      error: freezed == error ? _value.error : error,
    ));
  }
}

/// @nodoc

class _$JourneyTimelineStateImpl implements _JourneyTimelineState {
  const _$JourneyTimelineStateImpl(
      {this.isLoading = false,
      this.appending = false,
      this.hasMore = true,
      this.isCurrentUser = false,
      this.showDatePicker = false,
      this.selectedUser,
      final List<ApiLocationJourney> sortedJourney = const [],
      this.selectedTimeFrom,
      this.selectedTimeTo,
      this.error})
      : _sortedJourney = sortedJourney;

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool appending;
  @override
  @JsonKey()
  final bool hasMore;
  @override
  @JsonKey()
  final bool isCurrentUser;
  @override
  @JsonKey()
  final bool showDatePicker;
  @override
  final ApiUser? selectedUser;
  final List<ApiLocationJourney> _sortedJourney;
  @override
  @JsonKey()
  List<ApiLocationJourney> get sortedJourney {
    if (_sortedJourney is EqualUnmodifiableListView) return _sortedJourney;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sortedJourney);
  }

  @override
  final int? selectedTimeFrom;
  @override
  final int? selectedTimeTo;
  @override
  final Object? error;

  @override
  String toString() {
    return 'JourneyTimelineState(isLoading: $isLoading, appending: $appending, hasMore: $hasMore, isCurrentUser: $isCurrentUser, showDatePicker: $showDatePicker, selectedUser: $selectedUser, sortedJourney: $sortedJourney, selectedTimeFrom: $selectedTimeFrom, selectedTimeTo: $selectedTimeTo, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JourneyTimelineStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.appending, appending) ||
                other.appending == appending) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.isCurrentUser, isCurrentUser) ||
                other.isCurrentUser == isCurrentUser) &&
            (identical(other.showDatePicker, showDatePicker) ||
                other.showDatePicker == showDatePicker) &&
            (identical(other.selectedUser, selectedUser) ||
                other.selectedUser == selectedUser) &&
            const DeepCollectionEquality()
                .equals(other._sortedJourney, _sortedJourney) &&
            (identical(other.selectedTimeFrom, selectedTimeFrom) ||
                other.selectedTimeFrom == selectedTimeFrom) &&
            (identical(other.selectedTimeTo, selectedTimeTo) ||
                other.selectedTimeTo == selectedTimeTo) &&
            const DeepCollectionEquality().equals(other.error, error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLoading,
      appending,
      hasMore,
      isCurrentUser,
      showDatePicker,
      selectedUser,
      const DeepCollectionEquality().hash(_sortedJourney),
      selectedTimeFrom,
      selectedTimeTo,
      const DeepCollectionEquality().hash(error));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$JourneyTimelineStateImplCopyWith<_$JourneyTimelineStateImpl>
      get copyWith =>
          __$$JourneyTimelineStateImplCopyWithImpl<_$JourneyTimelineStateImpl>(
              this, _$identity);
}

abstract class _JourneyTimelineState implements JourneyTimelineState {
  const factory _JourneyTimelineState(
      {final bool isLoading,
      final bool appending,
      final bool hasMore,
      final bool isCurrentUser,
      final bool showDatePicker,
      final ApiUser? selectedUser,
      final List<ApiLocationJourney> sortedJourney,
      final int? selectedTimeFrom,
      final int? selectedTimeTo,
      final Object? error}) = _$JourneyTimelineStateImpl;

  @override
  bool get isLoading;
  @override
  bool get appending;
  @override
  bool get hasMore;
  @override
  bool get isCurrentUser;
  @override
  bool get showDatePicker;
  @override
  ApiUser? get selectedUser;
  @override
  List<ApiLocationJourney> get sortedJourney;
  @override
  int? get selectedTimeFrom;
  @override
  int? get selectedTimeTo;
  @override
  Object? get error;
  @override
  @JsonKey(ignore: true)
  _$$JourneyTimelineStateImplCopyWith<_$JourneyTimelineStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
