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
  bool get messageSending => throw _privateConstructorUsedError;
  bool get allowSend => throw _privateConstructorUsedError;
  List<ApiUserInfo> get users => throw _privateConstructorUsedError;
  TextEditingController get message => throw _privateConstructorUsedError;
  List<ApiThreadMessage> get messages => throw _privateConstructorUsedError;
  List<ApiUserInfo> get sender => throw _privateConstructorUsedError;
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
      bool messageSending,
      bool allowSend,
      List<ApiUserInfo> users,
      TextEditingController message,
      List<ApiThreadMessage> messages,
      List<ApiUserInfo> sender,
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
    Object? messageSending = null,
    Object? allowSend = null,
    Object? users = null,
    Object? message = null,
    Object? messages = null,
    Object? sender = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      messageSending: null == messageSending
          ? _value.messageSending
          : messageSending // ignore: cast_nullable_to_non_nullable
              as bool,
      allowSend: null == allowSend
          ? _value.allowSend
          : allowSend // ignore: cast_nullable_to_non_nullable
              as bool,
      users: null == users
          ? _value.users
          : users // ignore: cast_nullable_to_non_nullable
              as List<ApiUserInfo>,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as TextEditingController,
      messages: null == messages
          ? _value.messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<ApiThreadMessage>,
      sender: null == sender
          ? _value.sender
          : sender // ignore: cast_nullable_to_non_nullable
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
      bool messageSending,
      bool allowSend,
      List<ApiUserInfo> users,
      TextEditingController message,
      List<ApiThreadMessage> messages,
      List<ApiUserInfo> sender,
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
    Object? messageSending = null,
    Object? allowSend = null,
    Object? users = null,
    Object? message = null,
    Object? messages = null,
    Object? sender = null,
    Object? error = freezed,
  }) {
    return _then(_$ChatViewStateImpl(
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      messageSending: null == messageSending
          ? _value.messageSending
          : messageSending // ignore: cast_nullable_to_non_nullable
              as bool,
      allowSend: null == allowSend
          ? _value.allowSend
          : allowSend // ignore: cast_nullable_to_non_nullable
              as bool,
      users: null == users
          ? _value._users
          : users // ignore: cast_nullable_to_non_nullable
              as List<ApiUserInfo>,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as TextEditingController,
      messages: null == messages
          ? _value._messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<ApiThreadMessage>,
      sender: null == sender
          ? _value._sender
          : sender // ignore: cast_nullable_to_non_nullable
              as List<ApiUserInfo>,
      error: freezed == error ? _value.error : error,
    ));
  }
}

/// @nodoc

class _$ChatViewStateImpl implements _ChatViewState {
  const _$ChatViewStateImpl(
      {this.loading = false,
      this.messageSending = false,
      this.allowSend = false,
      final List<ApiUserInfo> users = const [],
      required this.message,
      final List<ApiThreadMessage> messages = const [],
      final List<ApiUserInfo> sender = const [],
      this.error})
      : _users = users,
        _messages = messages,
        _sender = sender;

  @override
  @JsonKey()
  final bool loading;
  @override
  @JsonKey()
  final bool messageSending;
  @override
  @JsonKey()
  final bool allowSend;
  final List<ApiUserInfo> _users;
  @override
  @JsonKey()
  List<ApiUserInfo> get users {
    if (_users is EqualUnmodifiableListView) return _users;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_users);
  }

  @override
  final TextEditingController message;
  final List<ApiThreadMessage> _messages;
  @override
  @JsonKey()
  List<ApiThreadMessage> get messages {
    if (_messages is EqualUnmodifiableListView) return _messages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_messages);
  }

  final List<ApiUserInfo> _sender;
  @override
  @JsonKey()
  List<ApiUserInfo> get sender {
    if (_sender is EqualUnmodifiableListView) return _sender;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sender);
  }

  @override
  final Object? error;

  @override
  String toString() {
    return 'ChatViewState(loading: $loading, messageSending: $messageSending, allowSend: $allowSend, users: $users, message: $message, messages: $messages, sender: $sender, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatViewStateImpl &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.messageSending, messageSending) ||
                other.messageSending == messageSending) &&
            (identical(other.allowSend, allowSend) ||
                other.allowSend == allowSend) &&
            const DeepCollectionEquality().equals(other._users, _users) &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other._messages, _messages) &&
            const DeepCollectionEquality().equals(other._sender, _sender) &&
            const DeepCollectionEquality().equals(other.error, error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      loading,
      messageSending,
      allowSend,
      const DeepCollectionEquality().hash(_users),
      message,
      const DeepCollectionEquality().hash(_messages),
      const DeepCollectionEquality().hash(_sender),
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
      final bool messageSending,
      final bool allowSend,
      final List<ApiUserInfo> users,
      required final TextEditingController message,
      final List<ApiThreadMessage> messages,
      final List<ApiUserInfo> sender,
      final Object? error}) = _$ChatViewStateImpl;

  @override
  bool get loading;
  @override
  bool get messageSending;
  @override
  bool get allowSend;
  @override
  List<ApiUserInfo> get users;
  @override
  TextEditingController get message;
  @override
  List<ApiThreadMessage> get messages;
  @override
  List<ApiUserInfo> get sender;
  @override
  Object? get error;
  @override
  @JsonKey(ignore: true)
  _$$ChatViewStateImplCopyWith<_$ChatViewStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
