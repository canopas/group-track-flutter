import 'package:flutter/material.dart';
import 'package:style/text/app_text_dart.dart';


const primaryColor = Color(0xFFFF9800);

const secondaryLightColor = Color(0xFF34495E);
const secondaryVariantLightColor = Color(0x5234495E);

const secondaryDarkColor = Color(0xFFCEE5FF);
const secondaryVariantDarkColor = Color(0x66CEE5FF);

const tertiaryDarkColor = Color(0xFF58633A);
const tertiaryLightColor = Color(0xFFDCE8B4);

const containerHighLightColor = Color(0x2934495E);
const containerNormalLightColor = Color(0x1434495E);
const containerLowLightColor = Color(0x0A34495E);

const containerHighDarkColor = Color(0x3DCEE5FF);
const containerNormalDarkColor = Color(0x29CEE5FF);
const containerLowDarkColor = Color(0x14CEE5FF);

const textPrimaryLightColor = Color(0xDE000000);
const textSecondaryLightColor = Color(0x99000000);
const textDisabledLightColor = Color(0x66000000);

const textPrimaryDarkColor = Color(0xF7FFFFFF);
const textSecondaryDarkColor = Color(0xB3FFFFFF);
const textDisabledDarkColor = Color(0x80FFFFFF);

const outlineLightColor = Color(0x14000000);
const outlineDarkColor = Color(0x14FFFFFF);

const surfaceLightColor = Color(0xFFFFFFFF);
const surfaceDarkColor = Color(0xFF121212);

const awarenessAlertColor = Color(0xFFCA2F27);
const awarenessPositiveColor = Color(0xFF47A96E);
const awarenessWarningColor = Color(0xFFD39800);

final ThemeData _materialLightTheme = ThemeData.light(useMaterial3: true);
final ThemeData _materialDarkTheme = ThemeData.dark(useMaterial3: true);

final ThemeData materialThemeDataLight = _materialLightTheme.copyWith(
  primaryColor: primaryColor,
  dividerColor: outlineLightColor,
  colorScheme: _materialLightTheme.colorScheme.copyWith(
    primary: primaryColor,
    secondary: secondaryLightColor,
    tertiary: tertiaryLightColor,
    surface: surfaceLightColor,
    onPrimary: textPrimaryDarkColor,
    onSecondary: textSecondaryDarkColor,
    onSurface: textPrimaryLightColor,
  ),
  scaffoldBackgroundColor: surfaceLightColor,
  appBarTheme: _materialLightTheme.appBarTheme.copyWith(
    backgroundColor: surfaceLightColor,
    surfaceTintColor: containerLowLightColor,
    titleTextStyle: _materialLightTheme.appBarTheme.titleTextStyle?.copyWith(
      fontFamily: AppTextStyle.interFontFamily,
      package: 'style',
    ),
  ),
);

final ThemeData materialThemeDataDark = _materialDarkTheme.copyWith(
  primaryColor: primaryColor,
  dividerColor: outlineDarkColor,
  colorScheme: _materialDarkTheme.colorScheme.copyWith(
    primary: primaryColor,
    secondary: secondaryDarkColor,
    tertiary: tertiaryDarkColor,
    surface: surfaceDarkColor,
    onPrimary: textPrimaryDarkColor,
    onSecondary: textSecondaryLightColor,
    onSurface: textPrimaryDarkColor,
  ),
  scaffoldBackgroundColor: surfaceDarkColor,
  appBarTheme: _materialDarkTheme.appBarTheme.copyWith(
    backgroundColor: surfaceDarkColor,
    surfaceTintColor: containerLowDarkColor,
    titleTextStyle: _materialDarkTheme.appBarTheme.titleTextStyle?.copyWith(
      fontFamily: AppTextStyle.interFontFamily,
      package: 'style',
    ),
  ),
);

class AppColorScheme {
  final Color primary;
  final Color secondary;
  final Color secondaryVariant;
  final Color tertiary;
  final Color tertiaryVariant;
  final Color surface;
  final Color outline;
  final Color textPrimary;
  final Color textSecondary;
  final Color textDisabled;
  final Color outlineInverse;
  final Color textInversePrimary;
  final Color textInverseSecondary;
  final Color textInverseDisabled;
  final Color containerInverseHigh;
  final Color containerNormalInverse;
  final Color secondaryInverseVariant;
  final Color containerHigh;
  final Color containerNormal;
  final Color containerLow;
  final Color positive;
  final Color alert;
  final Color warning;
  final Color onPrimary;
  final Color onPrimaryVariant;
  final Color onSecondary;
  final Color onDisabled;
  final Color botSecondary;
  final ThemeMode themeMode;

  AppColorScheme({
    required this.primary,
    required this.secondary,
    required this.secondaryVariant,
    required this.tertiary,
    required this.tertiaryVariant,
    required this.surface,
    required this.outline,
    required this.textPrimary,
    required this.textSecondary,
    required this.textDisabled,
    required this.outlineInverse,
    required this.textInversePrimary,
    required this.textInverseSecondary,
    required this.textInverseDisabled,
    required this.containerInverseHigh,
    required this.containerNormalInverse,
    required this.secondaryInverseVariant,
    required this.containerHigh,
    required this.containerNormal,
    required this.containerLow,
    required this.positive,
    required this.alert,
    required this.warning,
    required this.onPrimary,
    required this.onPrimaryVariant,
    required this.onSecondary,
    required this.onDisabled,
    required this.botSecondary,
    required this.themeMode,
  });

  Color get containerNormalOnSurface =>
      Color.alphaBlend(containerNormal, surface);

  Color get containerHighOnSurface => Color.alphaBlend(containerHigh, surface);

  Color get containerLowOnSurface => Color.alphaBlend(containerLow, surface);
}

final appColorSchemeLight = AppColorScheme(
  primary: primaryColor,
  secondary: secondaryLightColor,
  secondaryVariant: secondaryVariantLightColor,
  tertiary: tertiaryDarkColor,
  tertiaryVariant: tertiaryLightColor,
  surface: surfaceLightColor,
  outline: outlineLightColor,
  textPrimary: textPrimaryLightColor,
  textSecondary: textSecondaryLightColor,
  textDisabled: textDisabledLightColor,
  outlineInverse: outlineDarkColor,
  textInversePrimary: textPrimaryDarkColor,
  textInverseSecondary: textSecondaryDarkColor,
  textInverseDisabled: textDisabledDarkColor,
  containerInverseHigh: containerHighDarkColor,
  containerNormalInverse: containerNormalDarkColor,
  secondaryInverseVariant: secondaryVariantDarkColor,
  containerHigh: containerHighLightColor,
  containerNormal: containerNormalLightColor,
  containerLow: containerLowLightColor,
  positive: awarenessPositiveColor,
  alert: awarenessAlertColor,
  warning: awarenessWarningColor,
  onPrimary: textPrimaryDarkColor,
  onPrimaryVariant: textPrimaryLightColor,
  onSecondary: textSecondaryDarkColor,
  onDisabled: textDisabledLightColor,
  botSecondary: secondaryLightColor,
  themeMode: ThemeMode.light,
);

final appColorSchemeDark = AppColorScheme(
  primary: primaryColor,
  secondary: secondaryDarkColor,
  secondaryVariant: secondaryVariantDarkColor,
  tertiary: tertiaryLightColor,
  tertiaryVariant: tertiaryDarkColor,
  surface: surfaceDarkColor,
  outline: outlineDarkColor,
  textPrimary: textPrimaryDarkColor,
  textSecondary: textSecondaryDarkColor,
  textDisabled: textDisabledDarkColor,
  outlineInverse: outlineLightColor,
  textInversePrimary: textPrimaryLightColor,
  textInverseSecondary: textSecondaryLightColor,
  textInverseDisabled: textDisabledLightColor,
  containerInverseHigh: containerHighLightColor,
  containerNormalInverse: containerNormalLightColor,
  secondaryInverseVariant: secondaryVariantLightColor,
  containerHigh: containerHighDarkColor,
  containerNormal: containerNormalDarkColor,
  containerLow: containerLowDarkColor,
  positive: awarenessPositiveColor,
  alert: awarenessAlertColor,
  warning: awarenessWarningColor,
  onPrimary: textPrimaryDarkColor,
  onPrimaryVariant: textPrimaryLightColor,
  onSecondary: textSecondaryDarkColor,
  onDisabled: textDisabledLightColor,
  botSecondary: secondaryVariantLightColor,
  themeMode: ThemeMode.dark,
);
