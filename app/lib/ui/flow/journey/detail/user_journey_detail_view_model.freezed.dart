// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_journey_detail_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$UserJourneyDetailState {
  bool get loading => throw _privateConstructorUsedError;
  bool get isNetworkOff => throw _privateConstructorUsedError;
  ApiLocationJourney? get journey => throw _privateConstructorUsedError;
  String? get journeyId => throw _privateConstructorUsedError;
  String get mapType => throw _privateConstructorUsedError;
  List<Placemark> get addressFrom => throw _privateConstructorUsedError;
  List<Placemark> get addressTo => throw _privateConstructorUsedError;
  Object? get error => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UserJourneyDetailStateCopyWith<UserJourneyDetailState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserJourneyDetailStateCopyWith<$Res> {
  factory $UserJourneyDetailStateCopyWith(UserJourneyDetailState value,
          $Res Function(UserJourneyDetailState) then) =
      _$UserJourneyDetailStateCopyWithImpl<$Res, UserJourneyDetailState>;
  @useResult
  $Res call(
      {bool loading,
      bool isNetworkOff,
      ApiLocationJourney? journey,
      String? journeyId,
      String mapType,
      List<Placemark> addressFrom,
      List<Placemark> addressTo,
      Object? error});

  $ApiLocationJourneyCopyWith<$Res>? get journey;
}

/// @nodoc
class _$UserJourneyDetailStateCopyWithImpl<$Res,
        $Val extends UserJourneyDetailState>
    implements $UserJourneyDetailStateCopyWith<$Res> {
  _$UserJourneyDetailStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = null,
    Object? isNetworkOff = null,
    Object? journey = freezed,
    Object? journeyId = freezed,
    Object? mapType = null,
    Object? addressFrom = null,
    Object? addressTo = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      isNetworkOff: null == isNetworkOff
          ? _value.isNetworkOff
          : isNetworkOff // ignore: cast_nullable_to_non_nullable
              as bool,
      journey: freezed == journey
          ? _value.journey
          : journey // ignore: cast_nullable_to_non_nullable
              as ApiLocationJourney?,
      journeyId: freezed == journeyId
          ? _value.journeyId
          : journeyId // ignore: cast_nullable_to_non_nullable
              as String?,
      mapType: null == mapType
          ? _value.mapType
          : mapType // ignore: cast_nullable_to_non_nullable
              as String,
      addressFrom: null == addressFrom
          ? _value.addressFrom
          : addressFrom // ignore: cast_nullable_to_non_nullable
              as List<Placemark>,
      addressTo: null == addressTo
          ? _value.addressTo
          : addressTo // ignore: cast_nullable_to_non_nullable
              as List<Placemark>,
      error: freezed == error ? _value.error : error,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ApiLocationJourneyCopyWith<$Res>? get journey {
    if (_value.journey == null) {
      return null;
    }

    return $ApiLocationJourneyCopyWith<$Res>(_value.journey!, (value) {
      return _then(_value.copyWith(journey: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserJourneyDetailStateImplCopyWith<$Res>
    implements $UserJourneyDetailStateCopyWith<$Res> {
  factory _$$UserJourneyDetailStateImplCopyWith(
          _$UserJourneyDetailStateImpl value,
          $Res Function(_$UserJourneyDetailStateImpl) then) =
      __$$UserJourneyDetailStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool loading,
      bool isNetworkOff,
      ApiLocationJourney? journey,
      String? journeyId,
      String mapType,
      List<Placemark> addressFrom,
      List<Placemark> addressTo,
      Object? error});

  @override
  $ApiLocationJourneyCopyWith<$Res>? get journey;
}

/// @nodoc
class __$$UserJourneyDetailStateImplCopyWithImpl<$Res>
    extends _$UserJourneyDetailStateCopyWithImpl<$Res,
        _$UserJourneyDetailStateImpl>
    implements _$$UserJourneyDetailStateImplCopyWith<$Res> {
  __$$UserJourneyDetailStateImplCopyWithImpl(
      _$UserJourneyDetailStateImpl _value,
      $Res Function(_$UserJourneyDetailStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = null,
    Object? isNetworkOff = null,
    Object? journey = freezed,
    Object? journeyId = freezed,
    Object? mapType = null,
    Object? addressFrom = null,
    Object? addressTo = null,
    Object? error = freezed,
  }) {
    return _then(_$UserJourneyDetailStateImpl(
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      isNetworkOff: null == isNetworkOff
          ? _value.isNetworkOff
          : isNetworkOff // ignore: cast_nullable_to_non_nullable
              as bool,
      journey: freezed == journey
          ? _value.journey
          : journey // ignore: cast_nullable_to_non_nullable
              as ApiLocationJourney?,
      journeyId: freezed == journeyId
          ? _value.journeyId
          : journeyId // ignore: cast_nullable_to_non_nullable
              as String?,
      mapType: null == mapType
          ? _value.mapType
          : mapType // ignore: cast_nullable_to_non_nullable
              as String,
      addressFrom: null == addressFrom
          ? _value._addressFrom
          : addressFrom // ignore: cast_nullable_to_non_nullable
              as List<Placemark>,
      addressTo: null == addressTo
          ? _value._addressTo
          : addressTo // ignore: cast_nullable_to_non_nullable
              as List<Placemark>,
      error: freezed == error ? _value.error : error,
    ));
  }
}

/// @nodoc

class _$UserJourneyDetailStateImpl implements _UserJourneyDetailState {
  const _$UserJourneyDetailStateImpl(
      {this.loading = false,
      this.isNetworkOff = false,
      this.journey,
      this.journeyId,
      this.mapType = "Normal",
      final List<Placemark> addressFrom = const [],
      final List<Placemark> addressTo = const [],
      this.error})
      : _addressFrom = addressFrom,
        _addressTo = addressTo;

  @override
  @JsonKey()
  final bool loading;
  @override
  @JsonKey()
  final bool isNetworkOff;
  @override
  final ApiLocationJourney? journey;
  @override
  final String? journeyId;
  @override
  @JsonKey()
  final String mapType;
  final List<Placemark> _addressFrom;
  @override
  @JsonKey()
  List<Placemark> get addressFrom {
    if (_addressFrom is EqualUnmodifiableListView) return _addressFrom;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_addressFrom);
  }

  final List<Placemark> _addressTo;
  @override
  @JsonKey()
  List<Placemark> get addressTo {
    if (_addressTo is EqualUnmodifiableListView) return _addressTo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_addressTo);
  }

  @override
  final Object? error;

  @override
  String toString() {
    return 'UserJourneyDetailState(loading: $loading, isNetworkOff: $isNetworkOff, journey: $journey, journeyId: $journeyId, mapType: $mapType, addressFrom: $addressFrom, addressTo: $addressTo, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserJourneyDetailStateImpl &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.isNetworkOff, isNetworkOff) ||
                other.isNetworkOff == isNetworkOff) &&
            (identical(other.journey, journey) || other.journey == journey) &&
            (identical(other.journeyId, journeyId) ||
                other.journeyId == journeyId) &&
            (identical(other.mapType, mapType) || other.mapType == mapType) &&
            const DeepCollectionEquality()
                .equals(other._addressFrom, _addressFrom) &&
            const DeepCollectionEquality()
                .equals(other._addressTo, _addressTo) &&
            const DeepCollectionEquality().equals(other.error, error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      loading,
      isNetworkOff,
      journey,
      journeyId,
      mapType,
      const DeepCollectionEquality().hash(_addressFrom),
      const DeepCollectionEquality().hash(_addressTo),
      const DeepCollectionEquality().hash(error));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserJourneyDetailStateImplCopyWith<_$UserJourneyDetailStateImpl>
      get copyWith => __$$UserJourneyDetailStateImplCopyWithImpl<
          _$UserJourneyDetailStateImpl>(this, _$identity);
}

abstract class _UserJourneyDetailState implements UserJourneyDetailState {
  const factory _UserJourneyDetailState(
      {final bool loading,
      final bool isNetworkOff,
      final ApiLocationJourney? journey,
      final String? journeyId,
      final String mapType,
      final List<Placemark> addressFrom,
      final List<Placemark> addressTo,
      final Object? error}) = _$UserJourneyDetailStateImpl;

  @override
  bool get loading;
  @override
  bool get isNetworkOff;
  @override
  ApiLocationJourney? get journey;
  @override
  String? get journeyId;
  @override
  String get mapType;
  @override
  List<Placemark> get addressFrom;
  @override
  List<Placemark> get addressTo;
  @override
  Object? get error;
  @override
  @JsonKey(ignore: true)
  _$$UserJourneyDetailStateImplCopyWith<_$UserJourneyDetailStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
