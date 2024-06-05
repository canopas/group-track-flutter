// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contact_support_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ContactSupportViewState {
  bool get submitting => throw _privateConstructorUsedError;
  bool get requestSent => throw _privateConstructorUsedError;
  bool get attachmentSizeLimitExceed => throw _privateConstructorUsedError;
  Object? get error => throw _privateConstructorUsedError;
  TextEditingController get title => throw _privateConstructorUsedError;
  TextEditingController get description => throw _privateConstructorUsedError;
  List<File> get attachments => throw _privateConstructorUsedError;
  List<File> get attachmentUploading => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ContactSupportViewStateCopyWith<ContactSupportViewState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContactSupportViewStateCopyWith<$Res> {
  factory $ContactSupportViewStateCopyWith(ContactSupportViewState value,
          $Res Function(ContactSupportViewState) then) =
      _$ContactSupportViewStateCopyWithImpl<$Res, ContactSupportViewState>;
  @useResult
  $Res call(
      {bool submitting,
      bool requestSent,
      bool attachmentSizeLimitExceed,
      Object? error,
      TextEditingController title,
      TextEditingController description,
      List<File> attachments,
      List<File> attachmentUploading});
}

/// @nodoc
class _$ContactSupportViewStateCopyWithImpl<$Res,
        $Val extends ContactSupportViewState>
    implements $ContactSupportViewStateCopyWith<$Res> {
  _$ContactSupportViewStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? submitting = null,
    Object? requestSent = null,
    Object? attachmentSizeLimitExceed = null,
    Object? error = freezed,
    Object? title = null,
    Object? description = null,
    Object? attachments = null,
    Object? attachmentUploading = null,
  }) {
    return _then(_value.copyWith(
      submitting: null == submitting
          ? _value.submitting
          : submitting // ignore: cast_nullable_to_non_nullable
              as bool,
      requestSent: null == requestSent
          ? _value.requestSent
          : requestSent // ignore: cast_nullable_to_non_nullable
              as bool,
      attachmentSizeLimitExceed: null == attachmentSizeLimitExceed
          ? _value.attachmentSizeLimitExceed
          : attachmentSizeLimitExceed // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error ? _value.error : error,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as TextEditingController,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as TextEditingController,
      attachments: null == attachments
          ? _value.attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<File>,
      attachmentUploading: null == attachmentUploading
          ? _value.attachmentUploading
          : attachmentUploading // ignore: cast_nullable_to_non_nullable
              as List<File>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ContactSupportViewStateImplCopyWith<$Res>
    implements $ContactSupportViewStateCopyWith<$Res> {
  factory _$$ContactSupportViewStateImplCopyWith(
          _$ContactSupportViewStateImpl value,
          $Res Function(_$ContactSupportViewStateImpl) then) =
      __$$ContactSupportViewStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool submitting,
      bool requestSent,
      bool attachmentSizeLimitExceed,
      Object? error,
      TextEditingController title,
      TextEditingController description,
      List<File> attachments,
      List<File> attachmentUploading});
}

/// @nodoc
class __$$ContactSupportViewStateImplCopyWithImpl<$Res>
    extends _$ContactSupportViewStateCopyWithImpl<$Res,
        _$ContactSupportViewStateImpl>
    implements _$$ContactSupportViewStateImplCopyWith<$Res> {
  __$$ContactSupportViewStateImplCopyWithImpl(
      _$ContactSupportViewStateImpl _value,
      $Res Function(_$ContactSupportViewStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? submitting = null,
    Object? requestSent = null,
    Object? attachmentSizeLimitExceed = null,
    Object? error = freezed,
    Object? title = null,
    Object? description = null,
    Object? attachments = null,
    Object? attachmentUploading = null,
  }) {
    return _then(_$ContactSupportViewStateImpl(
      submitting: null == submitting
          ? _value.submitting
          : submitting // ignore: cast_nullable_to_non_nullable
              as bool,
      requestSent: null == requestSent
          ? _value.requestSent
          : requestSent // ignore: cast_nullable_to_non_nullable
              as bool,
      attachmentSizeLimitExceed: null == attachmentSizeLimitExceed
          ? _value.attachmentSizeLimitExceed
          : attachmentSizeLimitExceed // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error ? _value.error : error,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as TextEditingController,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as TextEditingController,
      attachments: null == attachments
          ? _value._attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<File>,
      attachmentUploading: null == attachmentUploading
          ? _value._attachmentUploading
          : attachmentUploading // ignore: cast_nullable_to_non_nullable
              as List<File>,
    ));
  }
}

/// @nodoc

class _$ContactSupportViewStateImpl implements _ContactSupportViewState {
  const _$ContactSupportViewStateImpl(
      {this.submitting = false,
      this.requestSent = false,
      this.attachmentSizeLimitExceed = false,
      this.error,
      required this.title,
      required this.description,
      final List<File> attachments = const [],
      final List<File> attachmentUploading = const []})
      : _attachments = attachments,
        _attachmentUploading = attachmentUploading;

  @override
  @JsonKey()
  final bool submitting;
  @override
  @JsonKey()
  final bool requestSent;
  @override
  @JsonKey()
  final bool attachmentSizeLimitExceed;
  @override
  final Object? error;
  @override
  final TextEditingController title;
  @override
  final TextEditingController description;
  final List<File> _attachments;
  @override
  @JsonKey()
  List<File> get attachments {
    if (_attachments is EqualUnmodifiableListView) return _attachments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_attachments);
  }

  final List<File> _attachmentUploading;
  @override
  @JsonKey()
  List<File> get attachmentUploading {
    if (_attachmentUploading is EqualUnmodifiableListView)
      return _attachmentUploading;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_attachmentUploading);
  }

  @override
  String toString() {
    return 'ContactSupportViewState(submitting: $submitting, requestSent: $requestSent, attachmentSizeLimitExceed: $attachmentSizeLimitExceed, error: $error, title: $title, description: $description, attachments: $attachments, attachmentUploading: $attachmentUploading)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContactSupportViewStateImpl &&
            (identical(other.submitting, submitting) ||
                other.submitting == submitting) &&
            (identical(other.requestSent, requestSent) ||
                other.requestSent == requestSent) &&
            (identical(other.attachmentSizeLimitExceed,
                    attachmentSizeLimitExceed) ||
                other.attachmentSizeLimitExceed == attachmentSizeLimitExceed) &&
            const DeepCollectionEquality().equals(other.error, error) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._attachments, _attachments) &&
            const DeepCollectionEquality()
                .equals(other._attachmentUploading, _attachmentUploading));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      submitting,
      requestSent,
      attachmentSizeLimitExceed,
      const DeepCollectionEquality().hash(error),
      title,
      description,
      const DeepCollectionEquality().hash(_attachments),
      const DeepCollectionEquality().hash(_attachmentUploading));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ContactSupportViewStateImplCopyWith<_$ContactSupportViewStateImpl>
      get copyWith => __$$ContactSupportViewStateImplCopyWithImpl<
          _$ContactSupportViewStateImpl>(this, _$identity);
}

abstract class _ContactSupportViewState implements ContactSupportViewState {
  const factory _ContactSupportViewState(
      {final bool submitting,
      final bool requestSent,
      final bool attachmentSizeLimitExceed,
      final Object? error,
      required final TextEditingController title,
      required final TextEditingController description,
      final List<File> attachments,
      final List<File> attachmentUploading}) = _$ContactSupportViewStateImpl;

  @override
  bool get submitting;
  @override
  bool get requestSent;
  @override
  bool get attachmentSizeLimitExceed;
  @override
  Object? get error;
  @override
  TextEditingController get title;
  @override
  TextEditingController get description;
  @override
  List<File> get attachments;
  @override
  List<File> get attachmentUploading;
  @override
  @JsonKey(ignore: true)
  _$$ContactSupportViewStateImplCopyWith<_$ContactSupportViewStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
