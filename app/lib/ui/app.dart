library ui;

import 'dart:io';

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
import 'flow/navigation/routes.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  GoRouter? _router;

  @override
  void initState() {
    super.initState();
    ref.read(goRouterProvider.future).then((router) {
      _router = router;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_router == null) {
      return Container();
    }

    final isDarkMode = context.brightness == Brightness.dark;
    final colorScheme = isDarkMode ? appColorSchemeDark : appColorSchemeLight;

    return AppTheme(
      colorScheme: colorScheme,
      child: MediaQuery.withClampedTextScaling(
        maxScaleFactor: 1.16,
        minScaleFactor: 0.92,
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
