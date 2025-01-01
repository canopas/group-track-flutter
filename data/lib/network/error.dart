import 'dart:async';



class ApiError implements Exception {
  final String? message;

  const ApiError({this.message});

  @override
  String toString() {
    return '$runtimeType(message: $message)';
  }

  factory ApiError.fromError(Object error) {
    if (error is ApiError) {
      return error;
    } else if (error is TimeoutException) {
      return const NoInternetConnectionError();
    } else if (error is MediaFormatNotSupportedError) {
      return const MediaFormatNotSupportedError();
    } else if (error is FileTooLargeError) {
      return const FileTooLargeError();
    } else if (error is VideoDurationTooLongError) {
      return const VideoDurationTooLongError();
    } else if (error is String) {
      return StringError(error: error);
    } else {
      return GenericError(error: error);
    }
  }
}

class NoInternetConnectionError extends ApiError {
  const NoInternetConnectionError()
      : super(
    message:
    "No internet connection. Please check your network and try again.",
  );
}

class MediaFormatNotSupportedError extends ApiError {
  const MediaFormatNotSupportedError()
      : super(
    message:
    "Media format not supported. Please try again with a different format.",
  );
}

class FileTooLargeError extends ApiError {
  const FileTooLargeError()
      : super(
    message: "File is too large. Please try again with a smaller file.",
  );
}

class VideoDurationTooLongError extends ApiError {
  const VideoDurationTooLongError()
      : super(
    message: "Please upload videos up to 60 seconds in length.",
  );
}

class GenericError extends ApiError {
  final Object error;
  final int? code;

  GenericError({required this.error, this.code});

  @override
  String get message => 'Status code: $code, Error: $error';
}

class StringError extends ApiError {
  final String error;

  StringError({required this.error});

  @override
  String get message => 'Error: $error';
}
