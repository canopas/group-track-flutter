// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'horizontal_calendar_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CalendarViewState {
  DateTime get selectedDate => throw _privateConstructorUsedError;
  DateTime get weekStartDate => throw _privateConstructorUsedError;
  bool get containsToday => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CalendarViewStateCopyWith<CalendarViewState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CalendarViewStateCopyWith<$Res> {
  factory $CalendarViewStateCopyWith(
          CalendarViewState value, $Res Function(CalendarViewState) then) =
      _$CalendarViewStateCopyWithImpl<$Res, CalendarViewState>;
  @useResult
  $Res call(
      {DateTime selectedDate, DateTime weekStartDate, bool containsToday});
}

/// @nodoc
class _$CalendarViewStateCopyWithImpl<$Res, $Val extends CalendarViewState>
    implements $CalendarViewStateCopyWith<$Res> {
  _$CalendarViewStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedDate = null,
    Object? weekStartDate = null,
    Object? containsToday = null,
  }) {
    return _then(_value.copyWith(
      selectedDate: null == selectedDate
          ? _value.selectedDate
          : selectedDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      weekStartDate: null == weekStartDate
          ? _value.weekStartDate
          : weekStartDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      containsToday: null == containsToday
          ? _value.containsToday
          : containsToday // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CalendarViewStateImplCopyWith<$Res>
    implements $CalendarViewStateCopyWith<$Res> {
  factory _$$CalendarViewStateImplCopyWith(_$CalendarViewStateImpl value,
          $Res Function(_$CalendarViewStateImpl) then) =
      __$$CalendarViewStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime selectedDate, DateTime weekStartDate, bool containsToday});
}

/// @nodoc
class __$$CalendarViewStateImplCopyWithImpl<$Res>
    extends _$CalendarViewStateCopyWithImpl<$Res, _$CalendarViewStateImpl>
    implements _$$CalendarViewStateImplCopyWith<$Res> {
  __$$CalendarViewStateImplCopyWithImpl(_$CalendarViewStateImpl _value,
      $Res Function(_$CalendarViewStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedDate = null,
    Object? weekStartDate = null,
    Object? containsToday = null,
  }) {
    return _then(_$CalendarViewStateImpl(
      selectedDate: null == selectedDate
          ? _value.selectedDate
          : selectedDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      weekStartDate: null == weekStartDate
          ? _value.weekStartDate
          : weekStartDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      containsToday: null == containsToday
          ? _value.containsToday
          : containsToday // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$CalendarViewStateImpl implements _CalendarViewState {
  const _$CalendarViewStateImpl(
      {required this.selectedDate,
      required this.weekStartDate,
      this.containsToday = true});

  @override
  final DateTime selectedDate;
  @override
  final DateTime weekStartDate;
  @override
  @JsonKey()
  final bool containsToday;

  @override
  String toString() {
    return 'CalendarViewState(selectedDate: $selectedDate, weekStartDate: $weekStartDate, containsToday: $containsToday)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CalendarViewStateImpl &&
            (identical(other.selectedDate, selectedDate) ||
                other.selectedDate == selectedDate) &&
            (identical(other.weekStartDate, weekStartDate) ||
                other.weekStartDate == weekStartDate) &&
            (identical(other.containsToday, containsToday) ||
                other.containsToday == containsToday));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, selectedDate, weekStartDate, containsToday);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CalendarViewStateImplCopyWith<_$CalendarViewStateImpl> get copyWith =>
      __$$CalendarViewStateImplCopyWithImpl<_$CalendarViewStateImpl>(
          this, _$identity);
}

abstract class _CalendarViewState implements CalendarViewState {
  const factory _CalendarViewState(
      {required final DateTime selectedDate,
      required final DateTime weekStartDate,
      final bool containsToday}) = _$CalendarViewStateImpl;

  @override
  DateTime get selectedDate;
  @override
  DateTime get weekStartDate;
  @override
  bool get containsToday;
  @override
  @JsonKey(ignore: true)
  _$$CalendarViewStateImplCopyWith<_$CalendarViewStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
