// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ChatViewState {
  bool get loading => throw _privateConstructorUsedError;
  bool get isCurrentUser => throw _privateConstructorUsedError;
  List<ApiUserInfo> get users => throw _privateConstructorUsedError;
  Object? get error => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ChatViewStateCopyWith<ChatViewState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatViewStateCopyWith<$Res> {
  factory $ChatViewStateCopyWith(
          ChatViewState value, $Res Function(ChatViewState) then) =
      _$ChatViewStateCopyWithImpl<$Res, ChatViewState>;
  @useResult
  $Res call(
      {bool loading,
      bool isCurrentUser,
      List<ApiUserInfo> users,
      Object? error});
}

/// @nodoc
class _$ChatViewStateCopyWithImpl<$Res, $Val extends ChatViewState>
    implements $ChatViewStateCopyWith<$Res> {
  _$ChatViewStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = null,
    Object? isCurrentUser = null,
    Object? users = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      isCurrentUser: null == isCurrentUser
          ? _value.isCurrentUser
          : isCurrentUser // ignore: cast_nullable_to_non_nullable
              as bool,
      users: null == users
          ? _value.users
          : users // ignore: cast_nullable_to_non_nullable
              as List<ApiUserInfo>,
      error: freezed == error ? _value.error : error,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChatViewStateImplCopyWith<$Res>
    implements $ChatViewStateCopyWith<$Res> {
  factory _$$ChatViewStateImplCopyWith(
          _$ChatViewStateImpl value, $Res Function(_$ChatViewStateImpl) then) =
      __$$ChatViewStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool loading,
      bool isCurrentUser,
      List<ApiUserInfo> users,
      Object? error});
}

/// @nodoc
class __$$ChatViewStateImplCopyWithImpl<$Res>
    extends _$ChatViewStateCopyWithImpl<$Res, _$ChatViewStateImpl>
    implements _$$ChatViewStateImplCopyWith<$Res> {
  __$$ChatViewStateImplCopyWithImpl(
      _$ChatViewStateImpl _value, $Res Function(_$ChatViewStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = null,
    Object? isCurrentUser = null,
    Object? users = null,
    Object? error = freezed,
  }) {
    return _then(_$ChatViewStateImpl(
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      isCurrentUser: null == isCurrentUser
          ? _value.isCurrentUser
          : isCurrentUser // ignore: cast_nullable_to_non_nullable
              as bool,
      users: null == users
          ? _value._users
          : users // ignore: cast_nullable_to_non_nullable
              as List<ApiUserInfo>,
      error: freezed == error ? _value.error : error,
    ));
  }
}

/// @nodoc

class _$ChatViewStateImpl implements _ChatViewState {
  const _$ChatViewStateImpl(
      {this.loading = false,
      this.isCurrentUser = false,
      final List<ApiUserInfo> users = const [],
      this.error})
      : _users = users;

  @override
  @JsonKey()
  final bool loading;
  @override
  @JsonKey()
  final bool isCurrentUser;
  final List<ApiUserInfo> _users;
  @override
  @JsonKey()
  List<ApiUserInfo> get users {
    if (_users is EqualUnmodifiableListView) return _users;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_users);
  }

  @override
  final Object? error;

  @override
  String toString() {
    return 'ChatViewState(loading: $loading, isCurrentUser: $isCurrentUser, users: $users, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatViewStateImpl &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.isCurrentUser, isCurrentUser) ||
                other.isCurrentUser == isCurrentUser) &&
            const DeepCollectionEquality().equals(other._users, _users) &&
            const DeepCollectionEquality().equals(other.error, error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      loading,
      isCurrentUser,
      const DeepCollectionEquality().hash(_users),
      const DeepCollectionEquality().hash(error));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatViewStateImplCopyWith<_$ChatViewStateImpl> get copyWith =>
      __$$ChatViewStateImplCopyWithImpl<_$ChatViewStateImpl>(this, _$identity);
}

abstract class _ChatViewState implements ChatViewState {
  const factory _ChatViewState(
      {final bool loading,
      final bool isCurrentUser,
      final List<ApiUserInfo> users,
      final Object? error}) = _$ChatViewStateImpl;

  @override
  bool get loading;
  @override
  bool get isCurrentUser;
  @override
  List<ApiUserInfo> get users;
  @override
  Object? get error;
  @override
  @JsonKey(ignore: true)
  _$$ChatViewStateImplCopyWith<_$ChatViewStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
