library ui;

import 'dart:io';

import 'package:data/storage/app_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:style/theme/colors.dart';
import 'package:style/theme/theme.dart';
import 'package:yourspace_flutter/domain/extenstions/context_extenstions.dart';

import '../domain/extenstions/widget_extensions.dart';
import '../domain/fcm/notification_handler.dart';
import 'app_route.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  late GoRouter _router;
  late NotificationHandler notificationHandler;

  @override
  void initState() {
    super.initState();

    notificationHandler = ref.read(notificationHandlerProvider);
    notificationHandler.init(context);

    final AppRoute initialRoute;
    if (!ref.read(isIntroScreenShownPod)) {
      initialRoute = AppRoute.intro;
    } else if (ref.read(currentUserPod) == null) {
      initialRoute = AppRoute.signInMethod;
    } else if (ref.read(currentUserPod)?.first_name?.isEmpty ?? true) {
      initialRoute = AppRoute.pickName();
    } else {
      initialRoute = AppRoute.home;
    }

    _router =
        GoRouter(routes: AppRoute.routes, initialLocation: initialRoute.path);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.brightness == Brightness.dark;
    final colorScheme = isDarkMode ? appColorSchemeDark : appColorSchemeLight;

    return AppTheme(
      colorScheme: colorScheme,
      child: Builder(
        builder: (context) {
          if (Platform.isAndroid) {
            runPostFrame(() => configureAndroidSystemUi(context));
          }

          return Platform.isIOS
              ? CupertinoApp.router(
                  debugShowCheckedModeBanner: false,
                  localizationsDelegates:
                      AppLocalizations.localizationsDelegates,
                  supportedLocales: AppLocalizations.supportedLocales,
                  onGenerateTitle: (context) => context.l10n.app_title,
                  routerConfig: _router,
                  theme: CupertinoThemeData(
                    brightness: context.brightness,
                    primaryColor: colorScheme.primary,
                    primaryContrastingColor: colorScheme.onPrimary,
                    barBackgroundColor: colorScheme.surface,
                    scaffoldBackgroundColor: colorScheme.surface,
                    applyThemeToAll: true,
                  ),
                )
              : MaterialApp.router(
                  debugShowCheckedModeBanner: false,
                  localizationsDelegates:
                      AppLocalizations.localizationsDelegates,
                  supportedLocales: AppLocalizations.supportedLocales,
                  onGenerateTitle: (context) => context.l10n.app_title,
                  routerConfig: _router,
                  theme: materialThemeDataLight,
                  darkTheme: materialThemeDataDark,
                );
        },
      ),
    );
  }

  void configureAndroidSystemUi(BuildContext context) {
    final overlayStyle = (context.brightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark)
        .copyWith(
      statusBarColor: context.colorScheme.surface,
      systemNavigationBarColor: Colors.transparent,
    );

    SystemChrome.setSystemUIOverlayStyle(overlayStyle);

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: [SystemUiOverlay.top],
    );
  }
}
