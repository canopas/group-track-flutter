// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_sender_key_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ApiSenderKeyRecord _$ApiSenderKeyRecordFromJson(Map<String, dynamic> json) {
  return _ApiSenderKeyRecord.fromJson(json);
}

/// @nodoc
mixin _$ApiSenderKeyRecord {
  String get id => throw _privateConstructorUsedError;
  int get deviceId => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  String get distributionId => throw _privateConstructorUsedError;
  int get created_at => throw _privateConstructorUsedError;
  @BlobConverter()
  Blob get record => throw _privateConstructorUsedError;

  /// Serializes this ApiSenderKeyRecord to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ApiSenderKeyRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApiSenderKeyRecordCopyWith<ApiSenderKeyRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiSenderKeyRecordCopyWith<$Res> {
  factory $ApiSenderKeyRecordCopyWith(
          ApiSenderKeyRecord value, $Res Function(ApiSenderKeyRecord) then) =
      _$ApiSenderKeyRecordCopyWithImpl<$Res, ApiSenderKeyRecord>;
  @useResult
  $Res call(
      {String id,
      int deviceId,
      String address,
      String distributionId,
      int created_at,
      @BlobConverter() Blob record});
}

/// @nodoc
class _$ApiSenderKeyRecordCopyWithImpl<$Res, $Val extends ApiSenderKeyRecord>
    implements $ApiSenderKeyRecordCopyWith<$Res> {
  _$ApiSenderKeyRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApiSenderKeyRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? deviceId = null,
    Object? address = null,
    Object? distributionId = null,
    Object? created_at = null,
    Object? record = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      deviceId: null == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as int,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      distributionId: null == distributionId
          ? _value.distributionId
          : distributionId // ignore: cast_nullable_to_non_nullable
              as String,
      created_at: null == created_at
          ? _value.created_at
          : created_at // ignore: cast_nullable_to_non_nullable
              as int,
      record: null == record
          ? _value.record
          : record // ignore: cast_nullable_to_non_nullable
              as Blob,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ApiSenderKeyRecordImplCopyWith<$Res>
    implements $ApiSenderKeyRecordCopyWith<$Res> {
  factory _$$ApiSenderKeyRecordImplCopyWith(_$ApiSenderKeyRecordImpl value,
          $Res Function(_$ApiSenderKeyRecordImpl) then) =
      __$$ApiSenderKeyRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      int deviceId,
      String address,
      String distributionId,
      int created_at,
      @BlobConverter() Blob record});
}

/// @nodoc
class __$$ApiSenderKeyRecordImplCopyWithImpl<$Res>
    extends _$ApiSenderKeyRecordCopyWithImpl<$Res, _$ApiSenderKeyRecordImpl>
    implements _$$ApiSenderKeyRecordImplCopyWith<$Res> {
  __$$ApiSenderKeyRecordImplCopyWithImpl(_$ApiSenderKeyRecordImpl _value,
      $Res Function(_$ApiSenderKeyRecordImpl) _then)
      : super(_value, _then);

  /// Create a copy of ApiSenderKeyRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? deviceId = null,
    Object? address = null,
    Object? distributionId = null,
    Object? created_at = null,
    Object? record = null,
  }) {
    return _then(_$ApiSenderKeyRecordImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      deviceId: null == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as int,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      distributionId: null == distributionId
          ? _value.distributionId
          : distributionId // ignore: cast_nullable_to_non_nullable
              as String,
      created_at: null == created_at
          ? _value.created_at
          : created_at // ignore: cast_nullable_to_non_nullable
              as int,
      record: null == record
          ? _value.record
          : record // ignore: cast_nullable_to_non_nullable
              as Blob,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ApiSenderKeyRecordImpl extends _ApiSenderKeyRecord {
  const _$ApiSenderKeyRecordImpl(
      {required this.id,
      this.deviceId = 0,
      this.address = '',
      this.distributionId = '',
      required this.created_at,
      @BlobConverter() required this.record})
      : super._();

  factory _$ApiSenderKeyRecordImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApiSenderKeyRecordImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey()
  final int deviceId;
  @override
  @JsonKey()
  final String address;
  @override
  @JsonKey()
  final String distributionId;
  @override
  final int created_at;
  @override
  @BlobConverter()
  final Blob record;

  @override
  String toString() {
    return 'ApiSenderKeyRecord(id: $id, deviceId: $deviceId, address: $address, distributionId: $distributionId, created_at: $created_at, record: $record)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApiSenderKeyRecordImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.distributionId, distributionId) ||
                other.distributionId == distributionId) &&
            (identical(other.created_at, created_at) ||
                other.created_at == created_at) &&
            (identical(other.record, record) || other.record == record));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, deviceId, address, distributionId, created_at, record);

  /// Create a copy of ApiSenderKeyRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApiSenderKeyRecordImplCopyWith<_$ApiSenderKeyRecordImpl> get copyWith =>
      __$$ApiSenderKeyRecordImplCopyWithImpl<_$ApiSenderKeyRecordImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApiSenderKeyRecordImplToJson(
      this,
    );
  }
}

abstract class _ApiSenderKeyRecord extends ApiSenderKeyRecord {
  const factory _ApiSenderKeyRecord(
      {required final String id,
      final int deviceId,
      final String address,
      final String distributionId,
      required final int created_at,
      @BlobConverter() required final Blob record}) = _$ApiSenderKeyRecordImpl;
  const _ApiSenderKeyRecord._() : super._();

  factory _ApiSenderKeyRecord.fromJson(Map<String, dynamic> json) =
      _$ApiSenderKeyRecordImpl.fromJson;

  @override
  String get id;
  @override
  int get deviceId;
  @override
  String get address;
  @override
  String get distributionId;
  @override
  int get created_at;
  @override
  @BlobConverter()
  Blob get record;

  /// Create a copy of ApiSenderKeyRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApiSenderKeyRecordImplCopyWith<_$ApiSenderKeyRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
