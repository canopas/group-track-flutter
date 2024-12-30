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
  bool get creating => throw _privateConstructorUsedError;
  bool get loadingMoreMessages => throw _privateConstructorUsedError;
  bool get messageSending => throw _privateConstructorUsedError;
  bool get allowSend => throw _privateConstructorUsedError;
  bool get showMemberSelectionView => throw _privateConstructorUsedError;
  bool get isNewThread => throw _privateConstructorUsedError;
  bool get isNetworkOff => throw _privateConstructorUsedError;
  String? get threadId => throw _privateConstructorUsedError;
  TextEditingController get message => throw _privateConstructorUsedError;
  List<ApiThreadMessage> get messages => throw _privateConstructorUsedError;
  List<String> get selectedMember => throw _privateConstructorUsedError;
  Object? get error => throw _privateConstructorUsedError;
  Object? get actionError => throw _privateConstructorUsedError;
  ApiSpace? get space => throw _privateConstructorUsedError;
  ApiThread? get thread => throw _privateConstructorUsedError;
  Map<String, ApiUser> get members => throw _privateConstructorUsedError;
  ApiUser? get currentUser => throw _privateConstructorUsedError;
  List<ApiThread> get threads => throw _privateConstructorUsedError;

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
      bool creating,
      bool loadingMoreMessages,
      bool messageSending,
      bool allowSend,
      bool showMemberSelectionView,
      bool isNewThread,
      bool isNetworkOff,
      String? threadId,
      TextEditingController message,
      List<ApiThreadMessage> messages,
      List<String> selectedMember,
      Object? error,
      Object? actionError,
      ApiSpace? space,
      ApiThread? thread,
      Map<String, ApiUser> members,
      ApiUser? currentUser,
      List<ApiThread> threads});

  $ApiSpaceCopyWith<$Res>? get space;
  $ApiThreadCopyWith<$Res>? get thread;
  $ApiUserCopyWith<$Res>? get currentUser;
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
    Object? creating = null,
    Object? loadingMoreMessages = null,
    Object? messageSending = null,
    Object? allowSend = null,
    Object? showMemberSelectionView = null,
    Object? isNewThread = null,
    Object? isNetworkOff = null,
    Object? threadId = freezed,
    Object? message = null,
    Object? messages = null,
    Object? selectedMember = null,
    Object? error = freezed,
    Object? actionError = freezed,
    Object? space = freezed,
    Object? thread = freezed,
    Object? members = null,
    Object? currentUser = freezed,
    Object? threads = null,
  }) {
    return _then(_value.copyWith(
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      creating: null == creating
          ? _value.creating
          : creating // ignore: cast_nullable_to_non_nullable
              as bool,
      loadingMoreMessages: null == loadingMoreMessages
          ? _value.loadingMoreMessages
          : loadingMoreMessages // ignore: cast_nullable_to_non_nullable
              as bool,
      messageSending: null == messageSending
          ? _value.messageSending
          : messageSending // ignore: cast_nullable_to_non_nullable
              as bool,
      allowSend: null == allowSend
          ? _value.allowSend
          : allowSend // ignore: cast_nullable_to_non_nullable
              as bool,
      showMemberSelectionView: null == showMemberSelectionView
          ? _value.showMemberSelectionView
          : showMemberSelectionView // ignore: cast_nullable_to_non_nullable
              as bool,
      isNewThread: null == isNewThread
          ? _value.isNewThread
          : isNewThread // ignore: cast_nullable_to_non_nullable
              as bool,
      isNetworkOff: null == isNetworkOff
          ? _value.isNetworkOff
          : isNetworkOff // ignore: cast_nullable_to_non_nullable
              as bool,
      threadId: freezed == threadId
          ? _value.threadId
          : threadId // ignore: cast_nullable_to_non_nullable
              as String?,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as TextEditingController,
      messages: null == messages
          ? _value.messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<ApiThreadMessage>,
      selectedMember: null == selectedMember
          ? _value.selectedMember
          : selectedMember // ignore: cast_nullable_to_non_nullable
              as List<String>,
      error: freezed == error ? _value.error : error,
      actionError: freezed == actionError ? _value.actionError : actionError,
      space: freezed == space
          ? _value.space
          : space // ignore: cast_nullable_to_non_nullable
              as ApiSpace?,
      thread: freezed == thread
          ? _value.thread
          : thread // ignore: cast_nullable_to_non_nullable
              as ApiThread?,
      members: null == members
          ? _value.members
          : members // ignore: cast_nullable_to_non_nullable
              as Map<String, ApiUser>,
      currentUser: freezed == currentUser
          ? _value.currentUser
          : currentUser // ignore: cast_nullable_to_non_nullable
              as ApiUser?,
      threads: null == threads
          ? _value.threads
          : threads // ignore: cast_nullable_to_non_nullable
              as List<ApiThread>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ApiSpaceCopyWith<$Res>? get space {
    if (_value.space == null) {
      return null;
    }

    return $ApiSpaceCopyWith<$Res>(_value.space!, (value) {
      return _then(_value.copyWith(space: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ApiThreadCopyWith<$Res>? get thread {
    if (_value.thread == null) {
      return null;
    }

    return $ApiThreadCopyWith<$Res>(_value.thread!, (value) {
      return _then(_value.copyWith(thread: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ApiUserCopyWith<$Res>? get currentUser {
    if (_value.currentUser == null) {
      return null;
    }

    return $ApiUserCopyWith<$Res>(_value.currentUser!, (value) {
      return _then(_value.copyWith(currentUser: value) as $Val);
    });
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
      bool creating,
      bool loadingMoreMessages,
      bool messageSending,
      bool allowSend,
      bool showMemberSelectionView,
      bool isNewThread,
      bool isNetworkOff,
      String? threadId,
      TextEditingController message,
      List<ApiThreadMessage> messages,
      List<String> selectedMember,
      Object? error,
      Object? actionError,
      ApiSpace? space,
      ApiThread? thread,
      Map<String, ApiUser> members,
      ApiUser? currentUser,
      List<ApiThread> threads});

  @override
  $ApiSpaceCopyWith<$Res>? get space;
  @override
  $ApiThreadCopyWith<$Res>? get thread;
  @override
  $ApiUserCopyWith<$Res>? get currentUser;
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
    Object? creating = null,
    Object? loadingMoreMessages = null,
    Object? messageSending = null,
    Object? allowSend = null,
    Object? showMemberSelectionView = null,
    Object? isNewThread = null,
    Object? isNetworkOff = null,
    Object? threadId = freezed,
    Object? message = null,
    Object? messages = null,
    Object? selectedMember = null,
    Object? error = freezed,
    Object? actionError = freezed,
    Object? space = freezed,
    Object? thread = freezed,
    Object? members = null,
    Object? currentUser = freezed,
    Object? threads = null,
  }) {
    return _then(_$ChatViewStateImpl(
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      creating: null == creating
          ? _value.creating
          : creating // ignore: cast_nullable_to_non_nullable
              as bool,
      loadingMoreMessages: null == loadingMoreMessages
          ? _value.loadingMoreMessages
          : loadingMoreMessages // ignore: cast_nullable_to_non_nullable
              as bool,
      messageSending: null == messageSending
          ? _value.messageSending
          : messageSending // ignore: cast_nullable_to_non_nullable
              as bool,
      allowSend: null == allowSend
          ? _value.allowSend
          : allowSend // ignore: cast_nullable_to_non_nullable
              as bool,
      showMemberSelectionView: null == showMemberSelectionView
          ? _value.showMemberSelectionView
          : showMemberSelectionView // ignore: cast_nullable_to_non_nullable
              as bool,
      isNewThread: null == isNewThread
          ? _value.isNewThread
          : isNewThread // ignore: cast_nullable_to_non_nullable
              as bool,
      isNetworkOff: null == isNetworkOff
          ? _value.isNetworkOff
          : isNetworkOff // ignore: cast_nullable_to_non_nullable
              as bool,
      threadId: freezed == threadId
          ? _value.threadId
          : threadId // ignore: cast_nullable_to_non_nullable
              as String?,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as TextEditingController,
      messages: null == messages
          ? _value._messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<ApiThreadMessage>,
      selectedMember: null == selectedMember
          ? _value._selectedMember
          : selectedMember // ignore: cast_nullable_to_non_nullable
              as List<String>,
      error: freezed == error ? _value.error : error,
      actionError: freezed == actionError ? _value.actionError : actionError,
      space: freezed == space
          ? _value.space
          : space // ignore: cast_nullable_to_non_nullable
              as ApiSpace?,
      thread: freezed == thread
          ? _value.thread
          : thread // ignore: cast_nullable_to_non_nullable
              as ApiThread?,
      members: null == members
          ? _value._members
          : members // ignore: cast_nullable_to_non_nullable
              as Map<String, ApiUser>,
      currentUser: freezed == currentUser
          ? _value.currentUser
          : currentUser // ignore: cast_nullable_to_non_nullable
              as ApiUser?,
      threads: null == threads
          ? _value._threads
          : threads // ignore: cast_nullable_to_non_nullable
              as List<ApiThread>,
    ));
  }
}

/// @nodoc

class _$ChatViewStateImpl implements _ChatViewState {
  const _$ChatViewStateImpl(
      {this.loading = false,
      this.creating = false,
      this.loadingMoreMessages = false,
      this.messageSending = false,
      this.allowSend = false,
      this.showMemberSelectionView = false,
      this.isNewThread = false,
      this.isNetworkOff = false,
      this.threadId,
      required this.message,
      final List<ApiThreadMessage> messages = const [],
      final List<String> selectedMember = const [],
      this.error,
      this.actionError,
      this.space,
      this.thread,
      final Map<String, ApiUser> members = const {},
      this.currentUser,
      final List<ApiThread> threads = const []})
      : _messages = messages,
        _selectedMember = selectedMember,
        _members = members,
        _threads = threads;

  @override
  @JsonKey()
  final bool loading;
  @override
  @JsonKey()
  final bool creating;
  @override
  @JsonKey()
  final bool loadingMoreMessages;
  @override
  @JsonKey()
  final bool messageSending;
  @override
  @JsonKey()
  final bool allowSend;
  @override
  @JsonKey()
  final bool showMemberSelectionView;
  @override
  @JsonKey()
  final bool isNewThread;
  @override
  @JsonKey()
  final bool isNetworkOff;
  @override
  final String? threadId;
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

  final List<String> _selectedMember;
  @override
  @JsonKey()
  List<String> get selectedMember {
    if (_selectedMember is EqualUnmodifiableListView) return _selectedMember;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedMember);
  }

  @override
  final Object? error;
  @override
  final Object? actionError;
  @override
  final ApiSpace? space;
  @override
  final ApiThread? thread;
  final Map<String, ApiUser> _members;
  @override
  @JsonKey()
  Map<String, ApiUser> get members {
    if (_members is EqualUnmodifiableMapView) return _members;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_members);
  }

  @override
  final ApiUser? currentUser;
  final List<ApiThread> _threads;
  @override
  @JsonKey()
  List<ApiThread> get threads {
    if (_threads is EqualUnmodifiableListView) return _threads;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_threads);
  }

  @override
  String toString() {
    return 'ChatViewState(loading: $loading, creating: $creating, loadingMoreMessages: $loadingMoreMessages, messageSending: $messageSending, allowSend: $allowSend, showMemberSelectionView: $showMemberSelectionView, isNewThread: $isNewThread, isNetworkOff: $isNetworkOff, threadId: $threadId, message: $message, messages: $messages, selectedMember: $selectedMember, error: $error, actionError: $actionError, space: $space, thread: $thread, members: $members, currentUser: $currentUser, threads: $threads)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatViewStateImpl &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.creating, creating) ||
                other.creating == creating) &&
            (identical(other.loadingMoreMessages, loadingMoreMessages) ||
                other.loadingMoreMessages == loadingMoreMessages) &&
            (identical(other.messageSending, messageSending) ||
                other.messageSending == messageSending) &&
            (identical(other.allowSend, allowSend) ||
                other.allowSend == allowSend) &&
            (identical(
                    other.showMemberSelectionView, showMemberSelectionView) ||
                other.showMemberSelectionView == showMemberSelectionView) &&
            (identical(other.isNewThread, isNewThread) ||
                other.isNewThread == isNewThread) &&
            (identical(other.isNetworkOff, isNetworkOff) ||
                other.isNetworkOff == isNetworkOff) &&
            (identical(other.threadId, threadId) ||
                other.threadId == threadId) &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other._messages, _messages) &&
            const DeepCollectionEquality()
                .equals(other._selectedMember, _selectedMember) &&
            const DeepCollectionEquality().equals(other.error, error) &&
            const DeepCollectionEquality()
                .equals(other.actionError, actionError) &&
            (identical(other.space, space) || other.space == space) &&
            (identical(other.thread, thread) || other.thread == thread) &&
            const DeepCollectionEquality().equals(other._members, _members) &&
            (identical(other.currentUser, currentUser) ||
                other.currentUser == currentUser) &&
            const DeepCollectionEquality().equals(other._threads, _threads));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        loading,
        creating,
        loadingMoreMessages,
        messageSending,
        allowSend,
        showMemberSelectionView,
        isNewThread,
        isNetworkOff,
        threadId,
        message,
        const DeepCollectionEquality().hash(_messages),
        const DeepCollectionEquality().hash(_selectedMember),
        const DeepCollectionEquality().hash(error),
        const DeepCollectionEquality().hash(actionError),
        space,
        thread,
        const DeepCollectionEquality().hash(_members),
        currentUser,
        const DeepCollectionEquality().hash(_threads)
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatViewStateImplCopyWith<_$ChatViewStateImpl> get copyWith =>
      __$$ChatViewStateImplCopyWithImpl<_$ChatViewStateImpl>(this, _$identity);
}

abstract class _ChatViewState implements ChatViewState {
  const factory _ChatViewState(
      {final bool loading,
      final bool creating,
      final bool loadingMoreMessages,
      final bool messageSending,
      final bool allowSend,
      final bool showMemberSelectionView,
      final bool isNewThread,
      final bool isNetworkOff,
      final String? threadId,
      required final TextEditingController message,
      final List<ApiThreadMessage> messages,
      final List<String> selectedMember,
      final Object? error,
      final Object? actionError,
      final ApiSpace? space,
      final ApiThread? thread,
      final Map<String, ApiUser> members,
      final ApiUser? currentUser,
      final List<ApiThread> threads}) = _$ChatViewStateImpl;

  @override
  bool get loading;
  @override
  bool get creating;
  @override
  bool get loadingMoreMessages;
  @override
  bool get messageSending;
  @override
  bool get allowSend;
  @override
  bool get showMemberSelectionView;
  @override
  bool get isNewThread;
  @override
  bool get isNetworkOff;
  @override
  String? get threadId;
  @override
  TextEditingController get message;
  @override
  List<ApiThreadMessage> get messages;
  @override
  List<String> get selectedMember;
  @override
  Object? get error;
  @override
  Object? get actionError;
  @override
  ApiSpace? get space;
  @override
  ApiThread? get thread;
  @override
  Map<String, ApiUser> get members;
  @override
  ApiUser? get currentUser;
  @override
  List<ApiThread> get threads;
  @override
  @JsonKey(ignore: true)
  _$$ChatViewStateImplCopyWith<_$ChatViewStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
