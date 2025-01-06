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
