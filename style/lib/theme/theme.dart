import 'package:flutter/cupertino.dart';
import 'package:style/theme/colors.dart';

class AppTheme extends InheritedWidget {
  final AppColorScheme colorScheme;

  const AppTheme({
    super.key,
    required this.colorScheme,
    required super.child,
  });

  @override
  bool updateShouldNotify(AppTheme oldWidget) {
    return colorScheme != oldWidget.colorScheme;
  }
}

AppColorScheme appColorSchemeOf(BuildContext context) {
  return context.dependOnInheritedWidgetOfExactType<AppTheme>()!.colorScheme;
}