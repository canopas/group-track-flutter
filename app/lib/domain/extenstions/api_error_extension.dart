import 'package:data/network/error.dart';
import 'package:flutter/cupertino.dart';
import 'package:yourspace_flutter/domain/extenstions/context_extenstions.dart';


extension AppErrorExtensions on Object {
  String l10nMessage(BuildContext context) {
    switch (runtimeType) {
      case const (NoInternetConnectionError):
        return context.l10n.errorNoConnection;
      case const (GenericError):
        return context.l10n.errorGeneric;
      case const (String):
        return this as String;
      case const (StringError):
        return (this as StringError).error;
      case const (ApiError):
        return (this as ApiError).message ?? context.l10n.errorGeneric;
      default:
        return context.l10n.errorGeneric;
    }
  }
}
