// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ApiUser _$ApiUserFromJson(Map<String, dynamic> json) {
  return _ApiUser.fromJson(json);
}

/// @nodoc
mixin _$ApiUser {
  String get id => throw _privateConstructorUsedError;
  String? get first_name => throw _privateConstructorUsedError;
  String? get last_name => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get provider_firebase_id_token => throw _privateConstructorUsedError;
  int get auth_type => throw _privateConstructorUsedError;
  String? get profile_image => throw _privateConstructorUsedError;
  bool? get location_enabled => throw _privateConstructorUsedError;
  List<String>? get space_ids => throw _privateConstructorUsedError;
  int? get battery_pct => throw _privateConstructorUsedError;
  String? get fcm_token => throw _privateConstructorUsedError;
  String? get public_key => throw _privateConstructorUsedError;
  String? get private_key_encrypted => throw _privateConstructorUsedError;
  ApiUserPreKeyBundle? get pre_key_bundle => throw _privateConstructorUsedError;
  int? get state => throw _privateConstructorUsedError;
  int? get created_at => throw _privateConstructorUsedError;
  int? get updated_at => throw _privateConstructorUsedError;

  /// Serializes this ApiUser to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ApiUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApiUserCopyWith<ApiUser> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiUserCopyWith<$Res> {
  factory $ApiUserCopyWith(ApiUser value, $Res Function(ApiUser) then) =
      _$ApiUserCopyWithImpl<$Res, ApiUser>;
  @useResult
  $Res call(
      {String id,
      String? first_name,
      String? last_name,
      String? email,
      String? provider_firebase_id_token,
      int auth_type,
      String? profile_image,
      bool? location_enabled,
      List<String>? space_ids,
      int? battery_pct,
      String? fcm_token,
      String? public_key,
      String? private_key_encrypted,
      ApiUserPreKeyBundle? pre_key_bundle,
      int? state,
      int? created_at,
      int? updated_at});

  $ApiUserPreKeyBundleCopyWith<$Res>? get pre_key_bundle;
}

/// @nodoc
class _$ApiUserCopyWithImpl<$Res, $Val extends ApiUser>
    implements $ApiUserCopyWith<$Res> {
  _$ApiUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApiUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? first_name = freezed,
    Object? last_name = freezed,
    Object? email = freezed,
    Object? provider_firebase_id_token = freezed,
    Object? auth_type = null,
    Object? profile_image = freezed,
    Object? location_enabled = freezed,
    Object? space_ids = freezed,
    Object? battery_pct = freezed,
    Object? fcm_token = freezed,
    Object? public_key = freezed,
    Object? private_key_encrypted = freezed,
    Object? pre_key_bundle = freezed,
    Object? state = freezed,
    Object? created_at = freezed,
    Object? updated_at = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      first_name: freezed == first_name
          ? _value.first_name
          : first_name // ignore: cast_nullable_to_non_nullable
              as String?,
      last_name: freezed == last_name
          ? _value.last_name
          : last_name // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      provider_firebase_id_token: freezed == provider_firebase_id_token
          ? _value.provider_firebase_id_token
          : provider_firebase_id_token // ignore: cast_nullable_to_non_nullable
              as String?,
      auth_type: null == auth_type
          ? _value.auth_type
          : auth_type // ignore: cast_nullable_to_non_nullable
              as int,
      profile_image: freezed == profile_image
          ? _value.profile_image
          : profile_image // ignore: cast_nullable_to_non_nullable
              as String?,
      location_enabled: freezed == location_enabled
          ? _value.location_enabled
          : location_enabled // ignore: cast_nullable_to_non_nullable
              as bool?,
      space_ids: freezed == space_ids
          ? _value.space_ids
          : space_ids // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      battery_pct: freezed == battery_pct
          ? _value.battery_pct
          : battery_pct // ignore: cast_nullable_to_non_nullable
              as int?,
      fcm_token: freezed == fcm_token
          ? _value.fcm_token
          : fcm_token // ignore: cast_nullable_to_non_nullable
              as String?,
      public_key: freezed == public_key
          ? _value.public_key
          : public_key // ignore: cast_nullable_to_non_nullable
              as String?,
      private_key_encrypted: freezed == private_key_encrypted
          ? _value.private_key_encrypted
          : private_key_encrypted // ignore: cast_nullable_to_non_nullable
              as String?,
      pre_key_bundle: freezed == pre_key_bundle
          ? _value.pre_key_bundle
          : pre_key_bundle // ignore: cast_nullable_to_non_nullable
              as ApiUserPreKeyBundle?,
      state: freezed == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as int?,
      created_at: freezed == created_at
          ? _value.created_at
          : created_at // ignore: cast_nullable_to_non_nullable
              as int?,
      updated_at: freezed == updated_at
          ? _value.updated_at
          : updated_at // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }

  /// Create a copy of ApiUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ApiUserPreKeyBundleCopyWith<$Res>? get pre_key_bundle {
    if (_value.pre_key_bundle == null) {
      return null;
    }

    return $ApiUserPreKeyBundleCopyWith<$Res>(_value.pre_key_bundle!, (value) {
      return _then(_value.copyWith(pre_key_bundle: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ApiUserImplCopyWith<$Res> implements $ApiUserCopyWith<$Res> {
  factory _$$ApiUserImplCopyWith(
          _$ApiUserImpl value, $Res Function(_$ApiUserImpl) then) =
      __$$ApiUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String? first_name,
      String? last_name,
      String? email,
      String? provider_firebase_id_token,
      int auth_type,
      String? profile_image,
      bool? location_enabled,
      List<String>? space_ids,
      int? battery_pct,
      String? fcm_token,
      String? public_key,
      String? private_key_encrypted,
      ApiUserPreKeyBundle? pre_key_bundle,
      int? state,
      int? created_at,
      int? updated_at});

  @override
  $ApiUserPreKeyBundleCopyWith<$Res>? get pre_key_bundle;
}

/// @nodoc
class __$$ApiUserImplCopyWithImpl<$Res>
    extends _$ApiUserCopyWithImpl<$Res, _$ApiUserImpl>
    implements _$$ApiUserImplCopyWith<$Res> {
  __$$ApiUserImplCopyWithImpl(
      _$ApiUserImpl _value, $Res Function(_$ApiUserImpl) _then)
      : super(_value, _then);

  /// Create a copy of ApiUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? first_name = freezed,
    Object? last_name = freezed,
    Object? email = freezed,
    Object? provider_firebase_id_token = freezed,
    Object? auth_type = null,
    Object? profile_image = freezed,
    Object? location_enabled = freezed,
    Object? space_ids = freezed,
    Object? battery_pct = freezed,
    Object? fcm_token = freezed,
    Object? public_key = freezed,
    Object? private_key_encrypted = freezed,
    Object? pre_key_bundle = freezed,
    Object? state = freezed,
    Object? created_at = freezed,
    Object? updated_at = freezed,
  }) {
    return _then(_$ApiUserImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      first_name: freezed == first_name
          ? _value.first_name
          : first_name // ignore: cast_nullable_to_non_nullable
              as String?,
      last_name: freezed == last_name
          ? _value.last_name
          : last_name // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      provider_firebase_id_token: freezed == provider_firebase_id_token
          ? _value.provider_firebase_id_token
          : provider_firebase_id_token // ignore: cast_nullable_to_non_nullable
              as String?,
      auth_type: null == auth_type
          ? _value.auth_type
          : auth_type // ignore: cast_nullable_to_non_nullable
              as int,
      profile_image: freezed == profile_image
          ? _value.profile_image
          : profile_image // ignore: cast_nullable_to_non_nullable
              as String?,
      location_enabled: freezed == location_enabled
          ? _value.location_enabled
          : location_enabled // ignore: cast_nullable_to_non_nullable
              as bool?,
      space_ids: freezed == space_ids
          ? _value._space_ids
          : space_ids // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      battery_pct: freezed == battery_pct
          ? _value.battery_pct
          : battery_pct // ignore: cast_nullable_to_non_nullable
              as int?,
      fcm_token: freezed == fcm_token
          ? _value.fcm_token
          : fcm_token // ignore: cast_nullable_to_non_nullable
              as String?,
      public_key: freezed == public_key
          ? _value.public_key
          : public_key // ignore: cast_nullable_to_non_nullable
              as String?,
      private_key_encrypted: freezed == private_key_encrypted
          ? _value.private_key_encrypted
          : private_key_encrypted // ignore: cast_nullable_to_non_nullable
              as String?,
      pre_key_bundle: freezed == pre_key_bundle
          ? _value.pre_key_bundle
          : pre_key_bundle // ignore: cast_nullable_to_non_nullable
              as ApiUserPreKeyBundle?,
      state: freezed == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as int?,
      created_at: freezed == created_at
          ? _value.created_at
          : created_at // ignore: cast_nullable_to_non_nullable
              as int?,
      updated_at: freezed == updated_at
          ? _value.updated_at
          : updated_at // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ApiUserImpl extends _ApiUser {
  const _$ApiUserImpl(
      {required this.id,
      this.first_name,
      this.last_name,
      this.email,
      this.provider_firebase_id_token,
      required this.auth_type,
      this.profile_image,
      this.location_enabled = true,
      final List<String>? space_ids = const [],
      this.battery_pct,
      this.fcm_token = "",
      this.public_key,
      this.private_key_encrypted,
      this.pre_key_bundle,
      this.state,
      this.created_at,
      this.updated_at})
      : _space_ids = space_ids,
        super._();

  factory _$ApiUserImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApiUserImplFromJson(json);

  @override
  final String id;
  @override
  final String? first_name;
  @override
  final String? last_name;
  @override
  final String? email;
  @override
  final String? provider_firebase_id_token;
  @override
  final int auth_type;
  @override
  final String? profile_image;
  @override
  @JsonKey()
  final bool? location_enabled;
  final List<String>? _space_ids;
  @override
  @JsonKey()
  List<String>? get space_ids {
    final value = _space_ids;
    if (value == null) return null;
    if (_space_ids is EqualUnmodifiableListView) return _space_ids;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final int? battery_pct;
  @override
  @JsonKey()
  final String? fcm_token;
  @override
  final String? public_key;
  @override
  final String? private_key_encrypted;
  @override
  final ApiUserPreKeyBundle? pre_key_bundle;
  @override
  final int? state;
  @override
  final int? created_at;
  @override
  final int? updated_at;

  @override
  String toString() {
    return 'ApiUser(id: $id, first_name: $first_name, last_name: $last_name, email: $email, provider_firebase_id_token: $provider_firebase_id_token, auth_type: $auth_type, profile_image: $profile_image, location_enabled: $location_enabled, space_ids: $space_ids, battery_pct: $battery_pct, fcm_token: $fcm_token, public_key: $public_key, private_key_encrypted: $private_key_encrypted, pre_key_bundle: $pre_key_bundle, state: $state, created_at: $created_at, updated_at: $updated_at)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApiUserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.first_name, first_name) ||
                other.first_name == first_name) &&
            (identical(other.last_name, last_name) ||
                other.last_name == last_name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.provider_firebase_id_token,
                    provider_firebase_id_token) ||
                other.provider_firebase_id_token ==
                    provider_firebase_id_token) &&
            (identical(other.auth_type, auth_type) ||
                other.auth_type == auth_type) &&
            (identical(other.profile_image, profile_image) ||
                other.profile_image == profile_image) &&
            (identical(other.location_enabled, location_enabled) ||
                other.location_enabled == location_enabled) &&
            const DeepCollectionEquality()
                .equals(other._space_ids, _space_ids) &&
            (identical(other.battery_pct, battery_pct) ||
                other.battery_pct == battery_pct) &&
            (identical(other.fcm_token, fcm_token) ||
                other.fcm_token == fcm_token) &&
            (identical(other.public_key, public_key) ||
                other.public_key == public_key) &&
            (identical(other.private_key_encrypted, private_key_encrypted) ||
                other.private_key_encrypted == private_key_encrypted) &&
            (identical(other.pre_key_bundle, pre_key_bundle) ||
                other.pre_key_bundle == pre_key_bundle) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.created_at, created_at) ||
                other.created_at == created_at) &&
            (identical(other.updated_at, updated_at) ||
                other.updated_at == updated_at));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      first_name,
      last_name,
      email,
      provider_firebase_id_token,
      auth_type,
      profile_image,
      location_enabled,
      const DeepCollectionEquality().hash(_space_ids),
      battery_pct,
      fcm_token,
      public_key,
      private_key_encrypted,
      pre_key_bundle,
      state,
      created_at,
      updated_at);

  /// Create a copy of ApiUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApiUserImplCopyWith<_$ApiUserImpl> get copyWith =>
      __$$ApiUserImplCopyWithImpl<_$ApiUserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApiUserImplToJson(
      this,
    );
  }
}

abstract class _ApiUser extends ApiUser {
  const factory _ApiUser(
      {required final String id,
      final String? first_name,
      final String? last_name,
      final String? email,
      final String? provider_firebase_id_token,
      required final int auth_type,
      final String? profile_image,
      final bool? location_enabled,
      final List<String>? space_ids,
      final int? battery_pct,
      final String? fcm_token,
      final String? public_key,
      final String? private_key_encrypted,
      final ApiUserPreKeyBundle? pre_key_bundle,
      final int? state,
      final int? created_at,
      final int? updated_at}) = _$ApiUserImpl;
  const _ApiUser._() : super._();

  factory _ApiUser.fromJson(Map<String, dynamic> json) = _$ApiUserImpl.fromJson;

  @override
  String get id;
  @override
  String? get first_name;
  @override
  String? get last_name;
  @override
  String? get email;
  @override
  String? get provider_firebase_id_token;
  @override
  int get auth_type;
  @override
  String? get profile_image;
  @override
  bool? get location_enabled;
  @override
  List<String>? get space_ids;
  @override
  int? get battery_pct;
  @override
  String? get fcm_token;
  @override
  String? get public_key;
  @override
  String? get private_key_encrypted;
  @override
  ApiUserPreKeyBundle? get pre_key_bundle;
  @override
  int? get state;
  @override
  int? get created_at;
  @override
  int? get updated_at;

  /// Create a copy of ApiUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApiUserImplCopyWith<_$ApiUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ApiUserPreKeyBundle _$ApiUserPreKeyBundleFromJson(Map<String, dynamic> json) {
  return _ApiUserPreKeyBundle.fromJson(json);
}

/// @nodoc
mixin _$ApiUserPreKeyBundle {
  String get identity_key => throw _privateConstructorUsedError;
  List<String> get signed_prekeys => throw _privateConstructorUsedError;
  List<String> get one_time_prekeys => throw _privateConstructorUsedError;

  /// Serializes this ApiUserPreKeyBundle to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ApiUserPreKeyBundle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApiUserPreKeyBundleCopyWith<ApiUserPreKeyBundle> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiUserPreKeyBundleCopyWith<$Res> {
  factory $ApiUserPreKeyBundleCopyWith(
          ApiUserPreKeyBundle value, $Res Function(ApiUserPreKeyBundle) then) =
      _$ApiUserPreKeyBundleCopyWithImpl<$Res, ApiUserPreKeyBundle>;
  @useResult
  $Res call(
      {String identity_key,
      List<String> signed_prekeys,
      List<String> one_time_prekeys});
}

/// @nodoc
class _$ApiUserPreKeyBundleCopyWithImpl<$Res, $Val extends ApiUserPreKeyBundle>
    implements $ApiUserPreKeyBundleCopyWith<$Res> {
  _$ApiUserPreKeyBundleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApiUserPreKeyBundle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? identity_key = null,
    Object? signed_prekeys = null,
    Object? one_time_prekeys = null,
  }) {
    return _then(_value.copyWith(
      identity_key: null == identity_key
          ? _value.identity_key
          : identity_key // ignore: cast_nullable_to_non_nullable
              as String,
      signed_prekeys: null == signed_prekeys
          ? _value.signed_prekeys
          : signed_prekeys // ignore: cast_nullable_to_non_nullable
              as List<String>,
      one_time_prekeys: null == one_time_prekeys
          ? _value.one_time_prekeys
          : one_time_prekeys // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ApiUserPreKeyBundleImplCopyWith<$Res>
    implements $ApiUserPreKeyBundleCopyWith<$Res> {
  factory _$$ApiUserPreKeyBundleImplCopyWith(_$ApiUserPreKeyBundleImpl value,
          $Res Function(_$ApiUserPreKeyBundleImpl) then) =
      __$$ApiUserPreKeyBundleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String identity_key,
      List<String> signed_prekeys,
      List<String> one_time_prekeys});
}

/// @nodoc
class __$$ApiUserPreKeyBundleImplCopyWithImpl<$Res>
    extends _$ApiUserPreKeyBundleCopyWithImpl<$Res, _$ApiUserPreKeyBundleImpl>
    implements _$$ApiUserPreKeyBundleImplCopyWith<$Res> {
  __$$ApiUserPreKeyBundleImplCopyWithImpl(_$ApiUserPreKeyBundleImpl _value,
      $Res Function(_$ApiUserPreKeyBundleImpl) _then)
      : super(_value, _then);

  /// Create a copy of ApiUserPreKeyBundle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? identity_key = null,
    Object? signed_prekeys = null,
    Object? one_time_prekeys = null,
  }) {
    return _then(_$ApiUserPreKeyBundleImpl(
      identity_key: null == identity_key
          ? _value.identity_key
          : identity_key // ignore: cast_nullable_to_non_nullable
              as String,
      signed_prekeys: null == signed_prekeys
          ? _value._signed_prekeys
          : signed_prekeys // ignore: cast_nullable_to_non_nullable
              as List<String>,
      one_time_prekeys: null == one_time_prekeys
          ? _value._one_time_prekeys
          : one_time_prekeys // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ApiUserPreKeyBundleImpl extends _ApiUserPreKeyBundle {
  const _$ApiUserPreKeyBundleImpl(
      {required this.identity_key,
      required final List<String> signed_prekeys,
      required final List<String> one_time_prekeys})
      : _signed_prekeys = signed_prekeys,
        _one_time_prekeys = one_time_prekeys,
        super._();

  factory _$ApiUserPreKeyBundleImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApiUserPreKeyBundleImplFromJson(json);

  @override
  final String identity_key;
  final List<String> _signed_prekeys;
  @override
  List<String> get signed_prekeys {
    if (_signed_prekeys is EqualUnmodifiableListView) return _signed_prekeys;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_signed_prekeys);
  }

  final List<String> _one_time_prekeys;
  @override
  List<String> get one_time_prekeys {
    if (_one_time_prekeys is EqualUnmodifiableListView)
      return _one_time_prekeys;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_one_time_prekeys);
  }

  @override
  String toString() {
    return 'ApiUserPreKeyBundle(identity_key: $identity_key, signed_prekeys: $signed_prekeys, one_time_prekeys: $one_time_prekeys)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApiUserPreKeyBundleImpl &&
            (identical(other.identity_key, identity_key) ||
                other.identity_key == identity_key) &&
            const DeepCollectionEquality()
                .equals(other._signed_prekeys, _signed_prekeys) &&
            const DeepCollectionEquality()
                .equals(other._one_time_prekeys, _one_time_prekeys));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      identity_key,
      const DeepCollectionEquality().hash(_signed_prekeys),
      const DeepCollectionEquality().hash(_one_time_prekeys));

  /// Create a copy of ApiUserPreKeyBundle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApiUserPreKeyBundleImplCopyWith<_$ApiUserPreKeyBundleImpl> get copyWith =>
      __$$ApiUserPreKeyBundleImplCopyWithImpl<_$ApiUserPreKeyBundleImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApiUserPreKeyBundleImplToJson(
      this,
    );
  }
}

abstract class _ApiUserPreKeyBundle extends ApiUserPreKeyBundle {
  const factory _ApiUserPreKeyBundle(
          {required final String identity_key,
          required final List<String> signed_prekeys,
          required final List<String> one_time_prekeys}) =
      _$ApiUserPreKeyBundleImpl;
  const _ApiUserPreKeyBundle._() : super._();

  factory _ApiUserPreKeyBundle.fromJson(Map<String, dynamic> json) =
      _$ApiUserPreKeyBundleImpl.fromJson;

  @override
  String get identity_key;
  @override
  List<String> get signed_prekeys;
  @override
  List<String> get one_time_prekeys;

  /// Create a copy of ApiUserPreKeyBundle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApiUserPreKeyBundleImplCopyWith<_$ApiUserPreKeyBundleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ApiSession _$ApiSessionFromJson(Map<String, dynamic> json) {
  return _ApiSession.fromJson(json);
}

/// @nodoc
mixin _$ApiSession {
  String get id => throw _privateConstructorUsedError;
  String get user_id => throw _privateConstructorUsedError;
  int? get platform => throw _privateConstructorUsedError;
  bool get session_active => throw _privateConstructorUsedError;
  String? get device_name => throw _privateConstructorUsedError;
  String? get device_id => throw _privateConstructorUsedError;
  int? get created_at => throw _privateConstructorUsedError;
  int? get app_version => throw _privateConstructorUsedError;

  /// Serializes this ApiSession to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ApiSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApiSessionCopyWith<ApiSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiSessionCopyWith<$Res> {
  factory $ApiSessionCopyWith(
          ApiSession value, $Res Function(ApiSession) then) =
      _$ApiSessionCopyWithImpl<$Res, ApiSession>;
  @useResult
  $Res call(
      {String id,
      String user_id,
      int? platform,
      bool session_active,
      String? device_name,
      String? device_id,
      int? created_at,
      int? app_version});
}

/// @nodoc
class _$ApiSessionCopyWithImpl<$Res, $Val extends ApiSession>
    implements $ApiSessionCopyWith<$Res> {
  _$ApiSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApiSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? user_id = null,
    Object? platform = freezed,
    Object? session_active = null,
    Object? device_name = freezed,
    Object? device_id = freezed,
    Object? created_at = freezed,
    Object? app_version = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      user_id: null == user_id
          ? _value.user_id
          : user_id // ignore: cast_nullable_to_non_nullable
              as String,
      platform: freezed == platform
          ? _value.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as int?,
      session_active: null == session_active
          ? _value.session_active
          : session_active // ignore: cast_nullable_to_non_nullable
              as bool,
      device_name: freezed == device_name
          ? _value.device_name
          : device_name // ignore: cast_nullable_to_non_nullable
              as String?,
      device_id: freezed == device_id
          ? _value.device_id
          : device_id // ignore: cast_nullable_to_non_nullable
              as String?,
      created_at: freezed == created_at
          ? _value.created_at
          : created_at // ignore: cast_nullable_to_non_nullable
              as int?,
      app_version: freezed == app_version
          ? _value.app_version
          : app_version // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ApiSessionImplCopyWith<$Res>
    implements $ApiSessionCopyWith<$Res> {
  factory _$$ApiSessionImplCopyWith(
          _$ApiSessionImpl value, $Res Function(_$ApiSessionImpl) then) =
      __$$ApiSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String user_id,
      int? platform,
      bool session_active,
      String? device_name,
      String? device_id,
      int? created_at,
      int? app_version});
}

/// @nodoc
class __$$ApiSessionImplCopyWithImpl<$Res>
    extends _$ApiSessionCopyWithImpl<$Res, _$ApiSessionImpl>
    implements _$$ApiSessionImplCopyWith<$Res> {
  __$$ApiSessionImplCopyWithImpl(
      _$ApiSessionImpl _value, $Res Function(_$ApiSessionImpl) _then)
      : super(_value, _then);

  /// Create a copy of ApiSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? user_id = null,
    Object? platform = freezed,
    Object? session_active = null,
    Object? device_name = freezed,
    Object? device_id = freezed,
    Object? created_at = freezed,
    Object? app_version = freezed,
  }) {
    return _then(_$ApiSessionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      user_id: null == user_id
          ? _value.user_id
          : user_id // ignore: cast_nullable_to_non_nullable
              as String,
      platform: freezed == platform
          ? _value.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as int?,
      session_active: null == session_active
          ? _value.session_active
          : session_active // ignore: cast_nullable_to_non_nullable
              as bool,
      device_name: freezed == device_name
          ? _value.device_name
          : device_name // ignore: cast_nullable_to_non_nullable
              as String?,
      device_id: freezed == device_id
          ? _value.device_id
          : device_id // ignore: cast_nullable_to_non_nullable
              as String?,
      created_at: freezed == created_at
          ? _value.created_at
          : created_at // ignore: cast_nullable_to_non_nullable
              as int?,
      app_version: freezed == app_version
          ? _value.app_version
          : app_version // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ApiSessionImpl extends _ApiSession {
  const _$ApiSessionImpl(
      {required this.id,
      required this.user_id,
      this.platform = 1,
      required this.session_active,
      this.device_name,
      this.device_id,
      this.created_at,
      this.app_version})
      : super._();

  factory _$ApiSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApiSessionImplFromJson(json);

  @override
  final String id;
  @override
  final String user_id;
  @override
  @JsonKey()
  final int? platform;
  @override
  final bool session_active;
  @override
  final String? device_name;
  @override
  final String? device_id;
  @override
  final int? created_at;
  @override
  final int? app_version;

  @override
  String toString() {
    return 'ApiSession(id: $id, user_id: $user_id, platform: $platform, session_active: $session_active, device_name: $device_name, device_id: $device_id, created_at: $created_at, app_version: $app_version)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApiSessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.user_id, user_id) || other.user_id == user_id) &&
            (identical(other.platform, platform) ||
                other.platform == platform) &&
            (identical(other.session_active, session_active) ||
                other.session_active == session_active) &&
            (identical(other.device_name, device_name) ||
                other.device_name == device_name) &&
            (identical(other.device_id, device_id) ||
                other.device_id == device_id) &&
            (identical(other.created_at, created_at) ||
                other.created_at == created_at) &&
            (identical(other.app_version, app_version) ||
                other.app_version == app_version));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, user_id, platform,
      session_active, device_name, device_id, created_at, app_version);

  /// Create a copy of ApiSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApiSessionImplCopyWith<_$ApiSessionImpl> get copyWith =>
      __$$ApiSessionImplCopyWithImpl<_$ApiSessionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApiSessionImplToJson(
      this,
    );
  }
}

abstract class _ApiSession extends ApiSession {
  const factory _ApiSession(
      {required final String id,
      required final String user_id,
      final int? platform,
      required final bool session_active,
      final String? device_name,
      final String? device_id,
      final int? created_at,
      final int? app_version}) = _$ApiSessionImpl;
  const _ApiSession._() : super._();

  factory _ApiSession.fromJson(Map<String, dynamic> json) =
      _$ApiSessionImpl.fromJson;

  @override
  String get id;
  @override
  String get user_id;
  @override
  int? get platform;
  @override
  bool get session_active;
  @override
  String? get device_name;
  @override
  String? get device_id;
  @override
  int? get created_at;
  @override
  int? get app_version;

  /// Create a copy of ApiSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApiSessionImplCopyWith<_$ApiSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
