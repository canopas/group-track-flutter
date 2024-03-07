import 'package:data/storage/app_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:style/theme/colors.dart';
import 'package:style/theme/theme.dart';
import 'package:yourspace_flutter/domain/extenstions/context_extenstions.dart';

import 'app_route.dart';

class App extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  late GoRouter _router;

  @override
  void initState() {
    super.initState();
    final AppRoute initialRoute;
    if (!ref.read(isIntroScreenShownPod)) {
      initialRoute = AppRoute.intro;
    } else if (ref.read(currentUserPod) == null) {
      initialRoute = AppRoute.signInMethod;
    } else if (ref.read(currentUserPod)?.first_name?.isEmpty ?? true) {
      initialRoute = AppRoute.pickName;
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
      child: MaterialApp.router(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        onGenerateTitle: (context) => context.l10n.app_title,
        routerConfig: _router,
        theme: materialThemeDataLight,
        darkTheme: materialThemeDataDark,
      ),
    );
  }
}
