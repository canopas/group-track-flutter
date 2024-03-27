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
