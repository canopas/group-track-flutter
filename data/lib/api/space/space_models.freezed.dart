// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'space_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ApiSpace _$ApiSpaceFromJson(Map<String, dynamic> json) {
  return _ApiSpace.fromJson(json);
}

/// @nodoc
mixin _$ApiSpace {
  String get id => throw _privateConstructorUsedError;
  String get admin_id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int? get created_at => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ApiSpaceCopyWith<ApiSpace> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiSpaceCopyWith<$Res> {
  factory $ApiSpaceCopyWith(ApiSpace value, $Res Function(ApiSpace) then) =
      _$ApiSpaceCopyWithImpl<$Res, ApiSpace>;
  @useResult
  $Res call({String id, String admin_id, String name, int? created_at});
}

/// @nodoc
class _$ApiSpaceCopyWithImpl<$Res, $Val extends ApiSpace>
    implements $ApiSpaceCopyWith<$Res> {
  _$ApiSpaceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? admin_id = null,
    Object? name = null,
    Object? created_at = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      admin_id: null == admin_id
          ? _value.admin_id
          : admin_id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      created_at: freezed == created_at
          ? _value.created_at
          : created_at // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ApiSpaceImplCopyWith<$Res>
    implements $ApiSpaceCopyWith<$Res> {
  factory _$$ApiSpaceImplCopyWith(
          _$ApiSpaceImpl value, $Res Function(_$ApiSpaceImpl) then) =
      __$$ApiSpaceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String admin_id, String name, int? created_at});
}

/// @nodoc
class __$$ApiSpaceImplCopyWithImpl<$Res>
    extends _$ApiSpaceCopyWithImpl<$Res, _$ApiSpaceImpl>
    implements _$$ApiSpaceImplCopyWith<$Res> {
  __$$ApiSpaceImplCopyWithImpl(
      _$ApiSpaceImpl _value, $Res Function(_$ApiSpaceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? admin_id = null,
    Object? name = null,
    Object? created_at = freezed,
  }) {
    return _then(_$ApiSpaceImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      admin_id: null == admin_id
          ? _value.admin_id
          : admin_id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      created_at: freezed == created_at
          ? _value.created_at
          : created_at // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ApiSpaceImpl extends _ApiSpace {
  const _$ApiSpaceImpl(
      {required this.id,
      required this.admin_id,
      required this.name,
      this.created_at})
      : super._();

  factory _$ApiSpaceImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApiSpaceImplFromJson(json);

  @override
  final String id;
  @override
  final String admin_id;
  @override
  final String name;
  @override
  final int? created_at;

  @override
  String toString() {
    return 'ApiSpace(id: $id, admin_id: $admin_id, name: $name, created_at: $created_at)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApiSpaceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.admin_id, admin_id) ||
                other.admin_id == admin_id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.created_at, created_at) ||
                other.created_at == created_at));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, admin_id, name, created_at);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ApiSpaceImplCopyWith<_$ApiSpaceImpl> get copyWith =>
      __$$ApiSpaceImplCopyWithImpl<_$ApiSpaceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApiSpaceImplToJson(
      this,
    );
  }
}

abstract class _ApiSpace extends ApiSpace {
  const factory _ApiSpace(
      {required final String id,
      required final String admin_id,
      required final String name,
      final int? created_at}) = _$ApiSpaceImpl;
  const _ApiSpace._() : super._();

  factory _ApiSpace.fromJson(Map<String, dynamic> json) =
      _$ApiSpaceImpl.fromJson;

  @override
  String get id;
  @override
  String get admin_id;
  @override
  String get name;
  @override
  int? get created_at;
  @override
  @JsonKey(ignore: true)
  _$$ApiSpaceImplCopyWith<_$ApiSpaceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ApiSpaceMember _$ApiSpaceMemberFromJson(Map<String, dynamic> json) {
  return _ApiSpaceMember.fromJson(json);
}

/// @nodoc
mixin _$ApiSpaceMember {
  String get id => throw _privateConstructorUsedError;
  String get space_id => throw _privateConstructorUsedError;
  String get user_id => throw _privateConstructorUsedError;
  int get role => throw _privateConstructorUsedError;
  bool get location_enabled => throw _privateConstructorUsedError;
  int? get created_at => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ApiSpaceMemberCopyWith<ApiSpaceMember> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiSpaceMemberCopyWith<$Res> {
  factory $ApiSpaceMemberCopyWith(
          ApiSpaceMember value, $Res Function(ApiSpaceMember) then) =
      _$ApiSpaceMemberCopyWithImpl<$Res, ApiSpaceMember>;
  @useResult
  $Res call(
      {String id,
      String space_id,
      String user_id,
      int role,
      bool location_enabled,
      int? created_at});
}

/// @nodoc
class _$ApiSpaceMemberCopyWithImpl<$Res, $Val extends ApiSpaceMember>
    implements $ApiSpaceMemberCopyWith<$Res> {
  _$ApiSpaceMemberCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? space_id = null,
    Object? user_id = null,
    Object? role = null,
    Object? location_enabled = null,
    Object? created_at = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      space_id: null == space_id
          ? _value.space_id
          : space_id // ignore: cast_nullable_to_non_nullable
              as String,
      user_id: null == user_id
          ? _value.user_id
          : user_id // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as int,
      location_enabled: null == location_enabled
          ? _value.location_enabled
          : location_enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      created_at: freezed == created_at
          ? _value.created_at
          : created_at // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ApiSpaceMemberImplCopyWith<$Res>
    implements $ApiSpaceMemberCopyWith<$Res> {
  factory _$$ApiSpaceMemberImplCopyWith(_$ApiSpaceMemberImpl value,
          $Res Function(_$ApiSpaceMemberImpl) then) =
      __$$ApiSpaceMemberImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String space_id,
      String user_id,
      int role,
      bool location_enabled,
      int? created_at});
}

/// @nodoc
class __$$ApiSpaceMemberImplCopyWithImpl<$Res>
    extends _$ApiSpaceMemberCopyWithImpl<$Res, _$ApiSpaceMemberImpl>
    implements _$$ApiSpaceMemberImplCopyWith<$Res> {
  __$$ApiSpaceMemberImplCopyWithImpl(
      _$ApiSpaceMemberImpl _value, $Res Function(_$ApiSpaceMemberImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? space_id = null,
    Object? user_id = null,
    Object? role = null,
    Object? location_enabled = null,
    Object? created_at = freezed,
  }) {
    return _then(_$ApiSpaceMemberImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      space_id: null == space_id
          ? _value.space_id
          : space_id // ignore: cast_nullable_to_non_nullable
              as String,
      user_id: null == user_id
          ? _value.user_id
          : user_id // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as int,
      location_enabled: null == location_enabled
          ? _value.location_enabled
          : location_enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      created_at: freezed == created_at
          ? _value.created_at
          : created_at // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ApiSpaceMemberImpl extends _ApiSpaceMember {
  const _$ApiSpaceMemberImpl(
      {required this.id,
      required this.space_id,
      required this.user_id,
      required this.role,
      required this.location_enabled,
      this.created_at})
      : super._();

  factory _$ApiSpaceMemberImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApiSpaceMemberImplFromJson(json);

  @override
  final String id;
  @override
  final String space_id;
  @override
  final String user_id;
  @override
  final int role;
  @override
  final bool location_enabled;
  @override
  final int? created_at;

  @override
  String toString() {
    return 'ApiSpaceMember(id: $id, space_id: $space_id, user_id: $user_id, role: $role, location_enabled: $location_enabled, created_at: $created_at)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApiSpaceMemberImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.space_id, space_id) ||
                other.space_id == space_id) &&
            (identical(other.user_id, user_id) || other.user_id == user_id) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.location_enabled, location_enabled) ||
                other.location_enabled == location_enabled) &&
            (identical(other.created_at, created_at) ||
                other.created_at == created_at));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, space_id, user_id, role, location_enabled, created_at);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ApiSpaceMemberImplCopyWith<_$ApiSpaceMemberImpl> get copyWith =>
      __$$ApiSpaceMemberImplCopyWithImpl<_$ApiSpaceMemberImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApiSpaceMemberImplToJson(
      this,
    );
  }
}

abstract class _ApiSpaceMember extends ApiSpaceMember {
  const factory _ApiSpaceMember(
      {required final String id,
      required final String space_id,
      required final String user_id,
      required final int role,
      required final bool location_enabled,
      final int? created_at}) = _$ApiSpaceMemberImpl;
  const _ApiSpaceMember._() : super._();

  factory _ApiSpaceMember.fromJson(Map<String, dynamic> json) =
      _$ApiSpaceMemberImpl.fromJson;

  @override
  String get id;
  @override
  String get space_id;
  @override
  String get user_id;
  @override
  int get role;
  @override
  bool get location_enabled;
  @override
  int? get created_at;
  @override
  @JsonKey(ignore: true)
  _$$ApiSpaceMemberImplCopyWith<_$ApiSpaceMemberImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ApiSpaceInvitation _$ApiSpaceInvitationFromJson(Map<String, dynamic> json) {
  return _ApiSpaceInvitation.fromJson(json);
}

/// @nodoc
mixin _$ApiSpaceInvitation {
  String get id => throw _privateConstructorUsedError;
  String get space_id => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  int? get created_at => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ApiSpaceInvitationCopyWith<ApiSpaceInvitation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiSpaceInvitationCopyWith<$Res> {
  factory $ApiSpaceInvitationCopyWith(
          ApiSpaceInvitation value, $Res Function(ApiSpaceInvitation) then) =
      _$ApiSpaceInvitationCopyWithImpl<$Res, ApiSpaceInvitation>;
  @useResult
  $Res call({String id, String space_id, String code, int? created_at});
}

/// @nodoc
class _$ApiSpaceInvitationCopyWithImpl<$Res, $Val extends ApiSpaceInvitation>
    implements $ApiSpaceInvitationCopyWith<$Res> {
  _$ApiSpaceInvitationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? space_id = null,
    Object? code = null,
    Object? created_at = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      space_id: null == space_id
          ? _value.space_id
          : space_id // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      created_at: freezed == created_at
          ? _value.created_at
          : created_at // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ApiSpaceInvitationImplCopyWith<$Res>
    implements $ApiSpaceInvitationCopyWith<$Res> {
  factory _$$ApiSpaceInvitationImplCopyWith(_$ApiSpaceInvitationImpl value,
          $Res Function(_$ApiSpaceInvitationImpl) then) =
      __$$ApiSpaceInvitationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String space_id, String code, int? created_at});
}

/// @nodoc
class __$$ApiSpaceInvitationImplCopyWithImpl<$Res>
    extends _$ApiSpaceInvitationCopyWithImpl<$Res, _$ApiSpaceInvitationImpl>
    implements _$$ApiSpaceInvitationImplCopyWith<$Res> {
  __$$ApiSpaceInvitationImplCopyWithImpl(_$ApiSpaceInvitationImpl _value,
      $Res Function(_$ApiSpaceInvitationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? space_id = null,
    Object? code = null,
    Object? created_at = freezed,
  }) {
    return _then(_$ApiSpaceInvitationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      space_id: null == space_id
          ? _value.space_id
          : space_id // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      created_at: freezed == created_at
          ? _value.created_at
          : created_at // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ApiSpaceInvitationImpl extends _ApiSpaceInvitation {
  const _$ApiSpaceInvitationImpl(
      {required this.id,
      required this.space_id,
      required this.code,
      this.created_at})
      : super._();

  factory _$ApiSpaceInvitationImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApiSpaceInvitationImplFromJson(json);

  @override
  final String id;
  @override
  final String space_id;
  @override
  final String code;
  @override
  final int? created_at;

  @override
  String toString() {
    return 'ApiSpaceInvitation(id: $id, space_id: $space_id, code: $code, created_at: $created_at)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApiSpaceInvitationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.space_id, space_id) ||
                other.space_id == space_id) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.created_at, created_at) ||
                other.created_at == created_at));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, space_id, code, created_at);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ApiSpaceInvitationImplCopyWith<_$ApiSpaceInvitationImpl> get copyWith =>
      __$$ApiSpaceInvitationImplCopyWithImpl<_$ApiSpaceInvitationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApiSpaceInvitationImplToJson(
      this,
    );
  }
}

abstract class _ApiSpaceInvitation extends ApiSpaceInvitation {
  const factory _ApiSpaceInvitation(
      {required final String id,
      required final String space_id,
      required final String code,
      final int? created_at}) = _$ApiSpaceInvitationImpl;
  const _ApiSpaceInvitation._() : super._();

  factory _ApiSpaceInvitation.fromJson(Map<String, dynamic> json) =
      _$ApiSpaceInvitationImpl.fromJson;

  @override
  String get id;
  @override
  String get space_id;
  @override
  String get code;
  @override
  int? get created_at;
  @override
  @JsonKey(ignore: true)
  _$$ApiSpaceInvitationImplCopyWith<_$ApiSpaceInvitationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SpaceInfo _$SpaceInfoFromJson(Map<String, dynamic> json) {
  return _SpaceInfo.fromJson(json);
}

/// @nodoc
mixin _$SpaceInfo {
  ApiSpace get space => throw _privateConstructorUsedError;
  List<ApiUserInfo> get members => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SpaceInfoCopyWith<SpaceInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpaceInfoCopyWith<$Res> {
  factory $SpaceInfoCopyWith(SpaceInfo value, $Res Function(SpaceInfo) then) =
      _$SpaceInfoCopyWithImpl<$Res, SpaceInfo>;
  @useResult
  $Res call({ApiSpace space, List<ApiUserInfo> members});

  $ApiSpaceCopyWith<$Res> get space;
}

/// @nodoc
class _$SpaceInfoCopyWithImpl<$Res, $Val extends SpaceInfo>
    implements $SpaceInfoCopyWith<$Res> {
  _$SpaceInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? space = null,
    Object? members = null,
  }) {
    return _then(_value.copyWith(
      space: null == space
          ? _value.space
          : space // ignore: cast_nullable_to_non_nullable
              as ApiSpace,
      members: null == members
          ? _value.members
          : members // ignore: cast_nullable_to_non_nullable
              as List<ApiUserInfo>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ApiSpaceCopyWith<$Res> get space {
    return $ApiSpaceCopyWith<$Res>(_value.space, (value) {
      return _then(_value.copyWith(space: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SpaceInfoImplCopyWith<$Res>
    implements $SpaceInfoCopyWith<$Res> {
  factory _$$SpaceInfoImplCopyWith(
          _$SpaceInfoImpl value, $Res Function(_$SpaceInfoImpl) then) =
      __$$SpaceInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({ApiSpace space, List<ApiUserInfo> members});

  @override
  $ApiSpaceCopyWith<$Res> get space;
}

/// @nodoc
class __$$SpaceInfoImplCopyWithImpl<$Res>
    extends _$SpaceInfoCopyWithImpl<$Res, _$SpaceInfoImpl>
    implements _$$SpaceInfoImplCopyWith<$Res> {
  __$$SpaceInfoImplCopyWithImpl(
      _$SpaceInfoImpl _value, $Res Function(_$SpaceInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? space = null,
    Object? members = null,
  }) {
    return _then(_$SpaceInfoImpl(
      space: null == space
          ? _value.space
          : space // ignore: cast_nullable_to_non_nullable
              as ApiSpace,
      members: null == members
          ? _value._members
          : members // ignore: cast_nullable_to_non_nullable
              as List<ApiUserInfo>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpaceInfoImpl extends _SpaceInfo {
  const _$SpaceInfoImpl(
      {required this.space, required final List<ApiUserInfo> members})
      : _members = members,
        super._();

  factory _$SpaceInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpaceInfoImplFromJson(json);

  @override
  final ApiSpace space;
  final List<ApiUserInfo> _members;
  @override
  List<ApiUserInfo> get members {
    if (_members is EqualUnmodifiableListView) return _members;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_members);
  }

  @override
  String toString() {
    return 'SpaceInfo(space: $space, members: $members)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpaceInfoImpl &&
            (identical(other.space, space) || other.space == space) &&
            const DeepCollectionEquality().equals(other._members, _members));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, space, const DeepCollectionEquality().hash(_members));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SpaceInfoImplCopyWith<_$SpaceInfoImpl> get copyWith =>
      __$$SpaceInfoImplCopyWithImpl<_$SpaceInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SpaceInfoImplToJson(
      this,
    );
  }
}

abstract class _SpaceInfo extends SpaceInfo {
  const factory _SpaceInfo(
      {required final ApiSpace space,
      required final List<ApiUserInfo> members}) = _$SpaceInfoImpl;
  const _SpaceInfo._() : super._();

  factory _SpaceInfo.fromJson(Map<String, dynamic> json) =
      _$SpaceInfoImpl.fromJson;

  @override
  ApiSpace get space;
  @override
  List<ApiUserInfo> get members;
  @override
  @JsonKey(ignore: true)
  _$$SpaceInfoImplCopyWith<_$SpaceInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
