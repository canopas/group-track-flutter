import 'package:flutter/material.dart';
import 'package:style/text/app_text_dart.dart';


const primaryColor = Color(0xFF1679AB);

const secondaryLightColor = Color(0xFF34495E);
const secondaryVariantLightColor = Color(0x5234495E);

const secondaryDarkColor = Color(0xFFCEE5FF);
const secondaryVariantDarkColor = Color(0x66CEE5FF);

const containerHighLightColor = Color(0x1E2884B2);
const containerNormalLightColor = Color(0x0F2884B2);
const containerLowLightColor = Color(0x0A2884B2);
const containerLightColor = Color(0x0A61A4C6);

const containerHighDarkColor = Color(0x3DABCFE1);
const containerNormalDarkColor = Color(0x1EABCFE1);
const containerLowDarkColor = Color(0x14ABCFE1);
const containerDarkColor = Color(0x0AABCFE1);

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
  final Color container;
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
    required this.container,
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
  container: containerLightColor,
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
  container: containerDarkColor,
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
