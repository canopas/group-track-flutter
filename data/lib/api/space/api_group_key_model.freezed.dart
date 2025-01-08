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
  int get memberDeviceId => throw _privateConstructorUsedError;
  int get dataUpdatedAt => throw _privateConstructorUsedError;
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
      {int memberDeviceId,
      int dataUpdatedAt,
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
    Object? memberDeviceId = null,
    Object? dataUpdatedAt = null,
    Object? distributions = null,
  }) {
    return _then(_value.copyWith(
      memberDeviceId: null == memberDeviceId
          ? _value.memberDeviceId
          : memberDeviceId // ignore: cast_nullable_to_non_nullable
              as int,
      dataUpdatedAt: null == dataUpdatedAt
          ? _value.dataUpdatedAt
          : dataUpdatedAt // ignore: cast_nullable_to_non_nullable
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
      {int memberDeviceId,
      int dataUpdatedAt,
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
    Object? memberDeviceId = null,
    Object? dataUpdatedAt = null,
    Object? distributions = null,
  }) {
    return _then(_$ApiMemberKeyDataImpl(
      memberDeviceId: null == memberDeviceId
          ? _value.memberDeviceId
          : memberDeviceId // ignore: cast_nullable_to_non_nullable
              as int,
      dataUpdatedAt: null == dataUpdatedAt
          ? _value.dataUpdatedAt
          : dataUpdatedAt // ignore: cast_nullable_to_non_nullable
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
      {this.memberDeviceId = 0,
      this.dataUpdatedAt = 0,
      final List<EncryptedDistribution> distributions = const []})
      : _distributions = distributions;

  factory _$ApiMemberKeyDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApiMemberKeyDataImplFromJson(json);

  @override
  @JsonKey()
  final int memberDeviceId;
  @override
  @JsonKey()
  final int dataUpdatedAt;
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
    return 'ApiMemberKeyData(memberDeviceId: $memberDeviceId, dataUpdatedAt: $dataUpdatedAt, distributions: $distributions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApiMemberKeyDataImpl &&
            (identical(other.memberDeviceId, memberDeviceId) ||
                other.memberDeviceId == memberDeviceId) &&
            (identical(other.dataUpdatedAt, dataUpdatedAt) ||
                other.dataUpdatedAt == dataUpdatedAt) &&
            const DeepCollectionEquality()
                .equals(other._distributions, _distributions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, memberDeviceId, dataUpdatedAt,
      const DeepCollectionEquality().hash(_distributions));

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
          {final int memberDeviceId,
          final int dataUpdatedAt,
          final List<EncryptedDistribution> distributions}) =
      _$ApiMemberKeyDataImpl;

  factory _ApiMemberKeyData.fromJson(Map<String, dynamic> json) =
      _$ApiMemberKeyDataImpl.fromJson;

  @override
  int get memberDeviceId;
  @override
  int get dataUpdatedAt;
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
