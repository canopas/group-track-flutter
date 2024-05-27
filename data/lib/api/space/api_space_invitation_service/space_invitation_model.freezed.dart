// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'space_invitation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

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
