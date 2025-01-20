// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'buffered_sender_keystore.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$StoreKey {
  SignalProtocolAddress get address => throw _privateConstructorUsedError;
  String get groupId => throw _privateConstructorUsedError;
  int get senderDeviceId => throw _privateConstructorUsedError;

  /// Create a copy of StoreKey
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StoreKeyCopyWith<StoreKey> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoreKeyCopyWith<$Res> {
  factory $StoreKeyCopyWith(StoreKey value, $Res Function(StoreKey) then) =
      _$StoreKeyCopyWithImpl<$Res, StoreKey>;
  @useResult
  $Res call(
      {SignalProtocolAddress address, String groupId, int senderDeviceId});
}

/// @nodoc
class _$StoreKeyCopyWithImpl<$Res, $Val extends StoreKey>
    implements $StoreKeyCopyWith<$Res> {
  _$StoreKeyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StoreKey
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? address = null,
    Object? groupId = null,
    Object? senderDeviceId = null,
  }) {
    return _then(_value.copyWith(
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as SignalProtocolAddress,
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String,
      senderDeviceId: null == senderDeviceId
          ? _value.senderDeviceId
          : senderDeviceId // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StoreKeyImplCopyWith<$Res>
    implements $StoreKeyCopyWith<$Res> {
  factory _$$StoreKeyImplCopyWith(
          _$StoreKeyImpl value, $Res Function(_$StoreKeyImpl) then) =
      __$$StoreKeyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {SignalProtocolAddress address, String groupId, int senderDeviceId});
}

/// @nodoc
class __$$StoreKeyImplCopyWithImpl<$Res>
    extends _$StoreKeyCopyWithImpl<$Res, _$StoreKeyImpl>
    implements _$$StoreKeyImplCopyWith<$Res> {
  __$$StoreKeyImplCopyWithImpl(
      _$StoreKeyImpl _value, $Res Function(_$StoreKeyImpl) _then)
      : super(_value, _then);

  /// Create a copy of StoreKey
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? address = null,
    Object? groupId = null,
    Object? senderDeviceId = null,
  }) {
    return _then(_$StoreKeyImpl(
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as SignalProtocolAddress,
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String,
      senderDeviceId: null == senderDeviceId
          ? _value.senderDeviceId
          : senderDeviceId // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$StoreKeyImpl implements _StoreKey {
  const _$StoreKeyImpl(
      {required this.address,
      required this.groupId,
      required this.senderDeviceId});

  @override
  final SignalProtocolAddress address;
  @override
  final String groupId;
  @override
  final int senderDeviceId;

  @override
  String toString() {
    return 'StoreKey(address: $address, groupId: $groupId, senderDeviceId: $senderDeviceId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoreKeyImpl &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.senderDeviceId, senderDeviceId) ||
                other.senderDeviceId == senderDeviceId));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, address, groupId, senderDeviceId);

  /// Create a copy of StoreKey
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoreKeyImplCopyWith<_$StoreKeyImpl> get copyWith =>
      __$$StoreKeyImplCopyWithImpl<_$StoreKeyImpl>(this, _$identity);
}

abstract class _StoreKey implements StoreKey {
  const factory _StoreKey(
      {required final SignalProtocolAddress address,
      required final String groupId,
      required final int senderDeviceId}) = _$StoreKeyImpl;

  @override
  SignalProtocolAddress get address;
  @override
  String get groupId;
  @override
  int get senderDeviceId;

  /// Create a copy of StoreKey
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoreKeyImplCopyWith<_$StoreKeyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
