// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_group_key_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ApiGroupKey _$ApiGroupKeyFromJson(Map<String, dynamic> json) {
  return _ApiGroupKey.fromJson(json);
}

/// @nodoc
mixin _$ApiGroupKey {
  int get docUpdatedAt => throw _privateConstructorUsedError;
  Map<String, ApiMemberKeyData> get memberKeys =>
      throw _privateConstructorUsedError;

  /// Serializes this ApiGroupKey to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ApiGroupKey
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApiGroupKeyCopyWith<ApiGroupKey> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiGroupKeyCopyWith<$Res> {
  factory $ApiGroupKeyCopyWith(
          ApiGroupKey value, $Res Function(ApiGroupKey) then) =
      _$ApiGroupKeyCopyWithImpl<$Res, ApiGroupKey>;
  @useResult
  $Res call({int docUpdatedAt, Map<String, ApiMemberKeyData> memberKeys});
}

/// @nodoc
class _$ApiGroupKeyCopyWithImpl<$Res, $Val extends ApiGroupKey>
    implements $ApiGroupKeyCopyWith<$Res> {
  _$ApiGroupKeyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApiGroupKey
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? docUpdatedAt = null,
    Object? memberKeys = null,
  }) {
    return _then(_value.copyWith(
      docUpdatedAt: null == docUpdatedAt
          ? _value.docUpdatedAt
          : docUpdatedAt // ignore: cast_nullable_to_non_nullable
              as int,
      memberKeys: null == memberKeys
          ? _value.memberKeys
          : memberKeys // ignore: cast_nullable_to_non_nullable
              as Map<String, ApiMemberKeyData>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ApiGroupKeyImplCopyWith<$Res>
    implements $ApiGroupKeyCopyWith<$Res> {
  factory _$$ApiGroupKeyImplCopyWith(
          _$ApiGroupKeyImpl value, $Res Function(_$ApiGroupKeyImpl) then) =
      __$$ApiGroupKeyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int docUpdatedAt, Map<String, ApiMemberKeyData> memberKeys});
}

/// @nodoc
class __$$ApiGroupKeyImplCopyWithImpl<$Res>
    extends _$ApiGroupKeyCopyWithImpl<$Res, _$ApiGroupKeyImpl>
    implements _$$ApiGroupKeyImplCopyWith<$Res> {
  __$$ApiGroupKeyImplCopyWithImpl(
      _$ApiGroupKeyImpl _value, $Res Function(_$ApiGroupKeyImpl) _then)
      : super(_value, _then);

  /// Create a copy of ApiGroupKey
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? docUpdatedAt = null,
    Object? memberKeys = null,
  }) {
    return _then(_$ApiGroupKeyImpl(
      docUpdatedAt: null == docUpdatedAt
          ? _value.docUpdatedAt
          : docUpdatedAt // ignore: cast_nullable_to_non_nullable
              as int,
      memberKeys: null == memberKeys
          ? _value._memberKeys
          : memberKeys // ignore: cast_nullable_to_non_nullable
              as Map<String, ApiMemberKeyData>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ApiGroupKeyImpl extends _ApiGroupKey {
  const _$ApiGroupKeyImpl(
      {required this.docUpdatedAt,
      final Map<String, ApiMemberKeyData> memberKeys = const {}})
      : _memberKeys = memberKeys,
        super._();

  factory _$ApiGroupKeyImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApiGroupKeyImplFromJson(json);

  @override
  final int docUpdatedAt;
  final Map<String, ApiMemberKeyData> _memberKeys;
  @override
  @JsonKey()
  Map<String, ApiMemberKeyData> get memberKeys {
    if (_memberKeys is EqualUnmodifiableMapView) return _memberKeys;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_memberKeys);
  }

  @override
  String toString() {
    return 'ApiGroupKey(docUpdatedAt: $docUpdatedAt, memberKeys: $memberKeys)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApiGroupKeyImpl &&
            (identical(other.docUpdatedAt, docUpdatedAt) ||
                other.docUpdatedAt == docUpdatedAt) &&
            const DeepCollectionEquality()
                .equals(other._memberKeys, _memberKeys));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, docUpdatedAt,
      const DeepCollectionEquality().hash(_memberKeys));

  /// Create a copy of ApiGroupKey
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApiGroupKeyImplCopyWith<_$ApiGroupKeyImpl> get copyWith =>
      __$$ApiGroupKeyImplCopyWithImpl<_$ApiGroupKeyImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApiGroupKeyImplToJson(
      this,
    );
  }
}

abstract class _ApiGroupKey extends ApiGroupKey {
  const factory _ApiGroupKey(
      {required final int docUpdatedAt,
      final Map<String, ApiMemberKeyData> memberKeys}) = _$ApiGroupKeyImpl;
  const _ApiGroupKey._() : super._();

  factory _ApiGroupKey.fromJson(Map<String, dynamic> json) =
      _$ApiGroupKeyImpl.fromJson;

  @override
  int get docUpdatedAt;
  @override
  Map<String, ApiMemberKeyData> get memberKeys;

  /// Create a copy of ApiGroupKey
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApiGroupKeyImplCopyWith<_$ApiGroupKeyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ApiMemberKeyData _$ApiMemberKeyDataFromJson(Map<String, dynamic> json) {
  return _ApiMemberKeyData.fromJson(json);
}

/// @nodoc
mixin _$ApiMemberKeyData {
  int get member_device_id => throw _privateConstructorUsedError;
  int get data_updated_at => throw _privateConstructorUsedError;
  List<EncryptedDistribution> get distributions =>
      throw _privateConstructorUsedError;

  /// Serializes this ApiMemberKeyData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ApiMemberKeyData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApiMemberKeyDataCopyWith<ApiMemberKeyData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiMemberKeyDataCopyWith<$Res> {
  factory $ApiMemberKeyDataCopyWith(
          ApiMemberKeyData value, $Res Function(ApiMemberKeyData) then) =
      _$ApiMemberKeyDataCopyWithImpl<$Res, ApiMemberKeyData>;
  @useResult
  $Res call(
      {int member_device_id,
      int data_updated_at,
      List<EncryptedDistribution> distributions});
}

/// @nodoc
class _$ApiMemberKeyDataCopyWithImpl<$Res, $Val extends ApiMemberKeyData>
    implements $ApiMemberKeyDataCopyWith<$Res> {
  _$ApiMemberKeyDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApiMemberKeyData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? member_device_id = null,
    Object? data_updated_at = null,
    Object? distributions = null,
  }) {
    return _then(_value.copyWith(
      member_device_id: null == member_device_id
          ? _value.member_device_id
          : member_device_id // ignore: cast_nullable_to_non_nullable
              as int,
      data_updated_at: null == data_updated_at
          ? _value.data_updated_at
          : data_updated_at // ignore: cast_nullable_to_non_nullable
              as int,
      distributions: null == distributions
          ? _value.distributions
          : distributions // ignore: cast_nullable_to_non_nullable
              as List<EncryptedDistribution>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ApiMemberKeyDataImplCopyWith<$Res>
    implements $ApiMemberKeyDataCopyWith<$Res> {
  factory _$$ApiMemberKeyDataImplCopyWith(_$ApiMemberKeyDataImpl value,
          $Res Function(_$ApiMemberKeyDataImpl) then) =
      __$$ApiMemberKeyDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int member_device_id,
      int data_updated_at,
      List<EncryptedDistribution> distributions});
}

/// @nodoc
class __$$ApiMemberKeyDataImplCopyWithImpl<$Res>
    extends _$ApiMemberKeyDataCopyWithImpl<$Res, _$ApiMemberKeyDataImpl>
    implements _$$ApiMemberKeyDataImplCopyWith<$Res> {
  __$$ApiMemberKeyDataImplCopyWithImpl(_$ApiMemberKeyDataImpl _value,
      $Res Function(_$ApiMemberKeyDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of ApiMemberKeyData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? member_device_id = null,
    Object? data_updated_at = null,
    Object? distributions = null,
  }) {
    return _then(_$ApiMemberKeyDataImpl(
      member_device_id: null == member_device_id
          ? _value.member_device_id
          : member_device_id // ignore: cast_nullable_to_non_nullable
              as int,
      data_updated_at: null == data_updated_at
          ? _value.data_updated_at
          : data_updated_at // ignore: cast_nullable_to_non_nullable
              as int,
      distributions: null == distributions
          ? _value._distributions
          : distributions // ignore: cast_nullable_to_non_nullable
              as List<EncryptedDistribution>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ApiMemberKeyDataImpl implements _ApiMemberKeyData {
  const _$ApiMemberKeyDataImpl(
      {this.member_device_id = 0,
      this.data_updated_at = 0,
      final List<EncryptedDistribution> distributions = const []})
      : _distributions = distributions;

  factory _$ApiMemberKeyDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApiMemberKeyDataImplFromJson(json);

  @override
  @JsonKey()
  final int member_device_id;
  @override
  @JsonKey()
  final int data_updated_at;
  final List<EncryptedDistribution> _distributions;
  @override
  @JsonKey()
  List<EncryptedDistribution> get distributions {
    if (_distributions is EqualUnmodifiableListView) return _distributions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_distributions);
  }

  @override
  String toString() {
    return 'ApiMemberKeyData(member_device_id: $member_device_id, data_updated_at: $data_updated_at, distributions: $distributions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApiMemberKeyDataImpl &&
            (identical(other.member_device_id, member_device_id) ||
                other.member_device_id == member_device_id) &&
            (identical(other.data_updated_at, data_updated_at) ||
                other.data_updated_at == data_updated_at) &&
            const DeepCollectionEquality()
                .equals(other._distributions, _distributions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, member_device_id,
      data_updated_at, const DeepCollectionEquality().hash(_distributions));

  /// Create a copy of ApiMemberKeyData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApiMemberKeyDataImplCopyWith<_$ApiMemberKeyDataImpl> get copyWith =>
      __$$ApiMemberKeyDataImplCopyWithImpl<_$ApiMemberKeyDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApiMemberKeyDataImplToJson(
      this,
    );
  }
}

abstract class _ApiMemberKeyData implements ApiMemberKeyData {
  const factory _ApiMemberKeyData(
          {final int member_device_id,
          final int data_updated_at,
          final List<EncryptedDistribution> distributions}) =
      _$ApiMemberKeyDataImpl;

  factory _ApiMemberKeyData.fromJson(Map<String, dynamic> json) =
      _$ApiMemberKeyDataImpl.fromJson;

  @override
  int get member_device_id;
  @override
  int get data_updated_at;
  @override
  List<EncryptedDistribution> get distributions;

  /// Create a copy of ApiMemberKeyData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApiMemberKeyDataImplCopyWith<_$ApiMemberKeyDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EncryptedDistribution _$EncryptedDistributionFromJson(
    Map<String, dynamic> json) {
  return _EncryptedDistribution.fromJson(json);
}

/// @nodoc
mixin _$EncryptedDistribution {
  String get recipientId => throw _privateConstructorUsedError;
  @BlobConverter()
  Blob get ephemeralPub => throw _privateConstructorUsedError;
  @BlobConverter()
  Blob get iv => throw _privateConstructorUsedError;
  @BlobConverter()
  Blob get ciphertext => throw _privateConstructorUsedError;

  /// Serializes this EncryptedDistribution to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EncryptedDistribution
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EncryptedDistributionCopyWith<EncryptedDistribution> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EncryptedDistributionCopyWith<$Res> {
  factory $EncryptedDistributionCopyWith(EncryptedDistribution value,
          $Res Function(EncryptedDistribution) then) =
      _$EncryptedDistributionCopyWithImpl<$Res, EncryptedDistribution>;
  @useResult
  $Res call(
      {String recipientId,
      @BlobConverter() Blob ephemeralPub,
      @BlobConverter() Blob iv,
      @BlobConverter() Blob ciphertext});
}

/// @nodoc
class _$EncryptedDistributionCopyWithImpl<$Res,
        $Val extends EncryptedDistribution>
    implements $EncryptedDistributionCopyWith<$Res> {
  _$EncryptedDistributionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EncryptedDistribution
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? recipientId = null,
    Object? ephemeralPub = null,
    Object? iv = null,
    Object? ciphertext = null,
  }) {
    return _then(_value.copyWith(
      recipientId: null == recipientId
          ? _value.recipientId
          : recipientId // ignore: cast_nullable_to_non_nullable
              as String,
      ephemeralPub: null == ephemeralPub
          ? _value.ephemeralPub
          : ephemeralPub // ignore: cast_nullable_to_non_nullable
              as Blob,
      iv: null == iv
          ? _value.iv
          : iv // ignore: cast_nullable_to_non_nullable
              as Blob,
      ciphertext: null == ciphertext
          ? _value.ciphertext
          : ciphertext // ignore: cast_nullable_to_non_nullable
              as Blob,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EncryptedDistributionImplCopyWith<$Res>
    implements $EncryptedDistributionCopyWith<$Res> {
  factory _$$EncryptedDistributionImplCopyWith(
          _$EncryptedDistributionImpl value,
          $Res Function(_$EncryptedDistributionImpl) then) =
      __$$EncryptedDistributionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String recipientId,
      @BlobConverter() Blob ephemeralPub,
      @BlobConverter() Blob iv,
      @BlobConverter() Blob ciphertext});
}

/// @nodoc
class __$$EncryptedDistributionImplCopyWithImpl<$Res>
    extends _$EncryptedDistributionCopyWithImpl<$Res,
        _$EncryptedDistributionImpl>
    implements _$$EncryptedDistributionImplCopyWith<$Res> {
  __$$EncryptedDistributionImplCopyWithImpl(_$EncryptedDistributionImpl _value,
      $Res Function(_$EncryptedDistributionImpl) _then)
      : super(_value, _then);

  /// Create a copy of EncryptedDistribution
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? recipientId = null,
    Object? ephemeralPub = null,
    Object? iv = null,
    Object? ciphertext = null,
  }) {
    return _then(_$EncryptedDistributionImpl(
      recipientId: null == recipientId
          ? _value.recipientId
          : recipientId // ignore: cast_nullable_to_non_nullable
              as String,
      ephemeralPub: null == ephemeralPub
          ? _value.ephemeralPub
          : ephemeralPub // ignore: cast_nullable_to_non_nullable
              as Blob,
      iv: null == iv
          ? _value.iv
          : iv // ignore: cast_nullable_to_non_nullable
              as Blob,
      ciphertext: null == ciphertext
          ? _value.ciphertext
          : ciphertext // ignore: cast_nullable_to_non_nullable
              as Blob,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EncryptedDistributionImpl extends _EncryptedDistribution {
  const _$EncryptedDistributionImpl(
      {this.recipientId = "",
      @BlobConverter() required this.ephemeralPub,
      @BlobConverter() required this.iv,
      @BlobConverter() required this.ciphertext})
      : super._();

  factory _$EncryptedDistributionImpl.fromJson(Map<String, dynamic> json) =>
      _$$EncryptedDistributionImplFromJson(json);

  @override
  @JsonKey()
  final String recipientId;
  @override
  @BlobConverter()
  final Blob ephemeralPub;
  @override
  @BlobConverter()
  final Blob iv;
  @override
  @BlobConverter()
  final Blob ciphertext;

  @override
  String toString() {
    return 'EncryptedDistribution(recipientId: $recipientId, ephemeralPub: $ephemeralPub, iv: $iv, ciphertext: $ciphertext)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EncryptedDistributionImpl &&
            (identical(other.recipientId, recipientId) ||
                other.recipientId == recipientId) &&
            (identical(other.ephemeralPub, ephemeralPub) ||
                other.ephemeralPub == ephemeralPub) &&
            (identical(other.iv, iv) || other.iv == iv) &&
            (identical(other.ciphertext, ciphertext) ||
                other.ciphertext == ciphertext));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, recipientId, ephemeralPub, iv, ciphertext);

  /// Create a copy of EncryptedDistribution
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EncryptedDistributionImplCopyWith<_$EncryptedDistributionImpl>
      get copyWith => __$$EncryptedDistributionImplCopyWithImpl<
          _$EncryptedDistributionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EncryptedDistributionImplToJson(
      this,
    );
  }
}

abstract class _EncryptedDistribution extends EncryptedDistribution {
  const factory _EncryptedDistribution(
          {final String recipientId,
          @BlobConverter() required final Blob ephemeralPub,
          @BlobConverter() required final Blob iv,
          @BlobConverter() required final Blob ciphertext}) =
      _$EncryptedDistributionImpl;
  const _EncryptedDistribution._() : super._();

  factory _EncryptedDistribution.fromJson(Map<String, dynamic> json) =
      _$EncryptedDistributionImpl.fromJson;

  @override
  String get recipientId;
  @override
  @BlobConverter()
  Blob get ephemeralPub;
  @override
  @BlobConverter()
  Blob get iv;
  @override
  @BlobConverter()
  Blob get ciphertext;

  /// Create a copy of EncryptedDistribution
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EncryptedDistributionImplCopyWith<_$EncryptedDistributionImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ApiSenderKeyRecord _$ApiSenderKeyRecordFromJson(Map<String, dynamic> json) {
  return _ApiSenderKeyRecord.fromJson(json);
}

/// @nodoc
mixin _$ApiSenderKeyRecord {
  String get id => throw _privateConstructorUsedError;
  int get device_id => throw _privateConstructorUsedError;
  String get distribution_id => throw _privateConstructorUsedError;
  @BlobConverter()
  Blob get record => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  int get created_at => throw _privateConstructorUsedError;

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
      int device_id,
      String distribution_id,
      @BlobConverter() Blob record,
      String address,
      int created_at});
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
    Object? device_id = null,
    Object? distribution_id = null,
    Object? record = null,
    Object? address = null,
    Object? created_at = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      device_id: null == device_id
          ? _value.device_id
          : device_id // ignore: cast_nullable_to_non_nullable
              as int,
      distribution_id: null == distribution_id
          ? _value.distribution_id
          : distribution_id // ignore: cast_nullable_to_non_nullable
              as String,
      record: null == record
          ? _value.record
          : record // ignore: cast_nullable_to_non_nullable
              as Blob,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      created_at: null == created_at
          ? _value.created_at
          : created_at // ignore: cast_nullable_to_non_nullable
              as int,
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
      int device_id,
      String distribution_id,
      @BlobConverter() Blob record,
      String address,
      int created_at});
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
    Object? device_id = null,
    Object? distribution_id = null,
    Object? record = null,
    Object? address = null,
    Object? created_at = null,
  }) {
    return _then(_$ApiSenderKeyRecordImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      device_id: null == device_id
          ? _value.device_id
          : device_id // ignore: cast_nullable_to_non_nullable
              as int,
      distribution_id: null == distribution_id
          ? _value.distribution_id
          : distribution_id // ignore: cast_nullable_to_non_nullable
              as String,
      record: null == record
          ? _value.record
          : record // ignore: cast_nullable_to_non_nullable
              as Blob,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      created_at: null == created_at
          ? _value.created_at
          : created_at // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ApiSenderKeyRecordImpl extends _ApiSenderKeyRecord {
  const _$ApiSenderKeyRecordImpl(
      {required this.id,
      required this.device_id,
      required this.distribution_id,
      @BlobConverter() required this.record,
      this.address = '',
      required this.created_at})
      : super._();

  factory _$ApiSenderKeyRecordImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApiSenderKeyRecordImplFromJson(json);

  @override
  final String id;
  @override
  final int device_id;
  @override
  final String distribution_id;
  @override
  @BlobConverter()
  final Blob record;
  @override
  @JsonKey()
  final String address;
  @override
  final int created_at;

  @override
  String toString() {
    return 'ApiSenderKeyRecord(id: $id, device_id: $device_id, distribution_id: $distribution_id, record: $record, address: $address, created_at: $created_at)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApiSenderKeyRecordImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.device_id, device_id) ||
                other.device_id == device_id) &&
            (identical(other.distribution_id, distribution_id) ||
                other.distribution_id == distribution_id) &&
            (identical(other.record, record) || other.record == record) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.created_at, created_at) ||
                other.created_at == created_at));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, device_id, distribution_id, record, address, created_at);

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
      required final int device_id,
      required final String distribution_id,
      @BlobConverter() required final Blob record,
      final String address,
      required final int created_at}) = _$ApiSenderKeyRecordImpl;
  const _ApiSenderKeyRecord._() : super._();

  factory _ApiSenderKeyRecord.fromJson(Map<String, dynamic> json) =
      _$ApiSenderKeyRecordImpl.fromJson;

  @override
  String get id;
  @override
  int get device_id;
  @override
  String get distribution_id;
  @override
  @BlobConverter()
  Blob get record;
  @override
  String get address;
  @override
  int get created_at;

  /// Create a copy of ApiSenderKeyRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApiSenderKeyRecordImplCopyWith<_$ApiSenderKeyRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
