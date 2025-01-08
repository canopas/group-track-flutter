// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $introRoute,
      $signInMethodRoute,
      $pickNameRoute,
      $connectionRoute,
      $createSpaceRoute,
      $joinSpaceRoute,
      $inviteCodeRoute,
      $changeAdminRoute,
      $threadsRoute,
      $chatRoute,
      $homeRoute,
    ];

RouteBase get $introRoute => GoRouteData.$route(
      path: '/intro',
      factory: $IntroRouteExtension._fromState,
    );

extension $IntroRouteExtension on IntroRoute {
  static IntroRoute _fromState(GoRouterState state) => IntroRoute();

  String get location => GoRouteData.$location(
        '/intro',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $signInMethodRoute => GoRouteData.$route(
      path: '/sign-in',
      factory: $SignInMethodRouteExtension._fromState,
    );

extension $SignInMethodRouteExtension on SignInMethodRoute {
  static SignInMethodRoute _fromState(GoRouterState state) =>
      SignInMethodRoute();

  String get location => GoRouteData.$location(
        '/sign-in',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $pickNameRoute => GoRouteData.$route(
      path: '/pick-name',
      factory: $PickNameRouteExtension._fromState,
    );

extension $PickNameRouteExtension on PickNameRoute {
  static PickNameRoute _fromState(GoRouterState state) => PickNameRoute(
        state.extra as ApiUser,
      );

  String get location => GoRouteData.$location(
        '/pick-name',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

RouteBase get $connectionRoute => GoRouteData.$route(
      path: '/connection',
      factory: $ConnectionRouteExtension._fromState,
    );

extension $ConnectionRouteExtension on ConnectionRoute {
  static ConnectionRoute _fromState(GoRouterState state) => ConnectionRoute();

  String get location => GoRouteData.$location(
        '/connection',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $createSpaceRoute => GoRouteData.$route(
      path: '/create',
      factory: $CreateSpaceRouteExtension._fromState,
    );

extension $CreateSpaceRouteExtension on CreateSpaceRoute {
  static CreateSpaceRoute _fromState(GoRouterState state) => CreateSpaceRoute(
        fromOnboard: _$convertMapValue(
                'from-onboard', state.uri.queryParameters, _$boolConverter) ??
            false,
      );

  String get location => GoRouteData.$location(
        '/create',
        queryParams: {
          if (fromOnboard != false) 'from-onboard': fromOnboard.toString(),
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

T? _$convertMapValue<T>(
  String key,
  Map<String, String> map,
  T Function(String) converter,
) {
  final value = map[key];
  return value == null ? null : converter(value);
}

bool _$boolConverter(String value) {
  switch (value) {
    case 'true':
      return true;
    case 'false':
      return false;
    default:
      throw UnsupportedError('Cannot convert "$value" into a bool.');
  }
}

RouteBase get $joinSpaceRoute => GoRouteData.$route(
      path: '/join-space',
      factory: $JoinSpaceRouteExtension._fromState,
    );

extension $JoinSpaceRouteExtension on JoinSpaceRoute {
  static JoinSpaceRoute _fromState(GoRouterState state) => JoinSpaceRoute(
        fromOnboard: _$convertMapValue(
                'from-onboard', state.uri.queryParameters, _$boolConverter) ??
            false,
      );

  String get location => GoRouteData.$location(
        '/join-space',
        queryParams: {
          if (fromOnboard != false) 'from-onboard': fromOnboard.toString(),
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $inviteCodeRoute => GoRouteData.$route(
      path: '/invite-code',
      factory: $InviteCodeRouteExtension._fromState,
    );

extension $InviteCodeRouteExtension on InviteCodeRoute {
  static InviteCodeRoute _fromState(GoRouterState state) => InviteCodeRoute(
        state.extra as InviteCodeRouteData,
      );

  String get location => GoRouteData.$location(
        '/invite-code',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

RouteBase get $changeAdminRoute => GoRouteData.$route(
      path: '/change-admin',
      factory: $ChangeAdminRouteExtension._fromState,
    );

extension $ChangeAdminRouteExtension on ChangeAdminRoute {
  static ChangeAdminRoute _fromState(GoRouterState state) => ChangeAdminRoute(
        $extra: state.extra as SpaceInfo,
      );

  String get location => GoRouteData.$location(
        '/change-admin',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

RouteBase get $threadsRoute => GoRouteData.$route(
      path: '/thread',
      factory: $ThreadsRouteExtension._fromState,
    );

extension $ThreadsRouteExtension on ThreadsRoute {
  static ThreadsRoute _fromState(GoRouterState state) => ThreadsRoute(
        state.extra as SpaceInfo,
      );

  String get location => GoRouteData.$location(
        '/thread',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

RouteBase get $chatRoute => GoRouteData.$route(
      path: '/chat',
      factory: $ChatRouteExtension._fromState,
    );

extension $ChatRouteExtension on ChatRoute {
  static ChatRoute _fromState(GoRouterState state) => ChatRoute(
        state.extra as ChatRouteData,
      );

  String get location => GoRouteData.$location(
        '/chat',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

RouteBase get $homeRoute => GoRouteData.$route(
      path: '/',
      factory: $HomeRouteExtension._fromState,
      routes: [
        GoRouteData.$route(
          path: 'journey-timeline',
          factory: $JourneyTimelineRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'journey-details',
          factory: $JourneyDetailsRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'enable-permission',
          factory: $EnablePermissionRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'settings',
          factory: $SettingsRouteExtension._fromState,
          routes: [
            GoRouteData.$route(
              path: 'profile',
              factory: $ProfileRouteExtension._fromState,
            ),
            GoRouteData.$route(
              path: 'contact-support',
              factory: $ContactSupportRouteExtension._fromState,
            ),
            GoRouteData.$route(
              path: 'subscription',
              factory: $SubscriptionRouteExtension._fromState,
            ),
            GoRouteData.$route(
              path: 'edit-space/:spaceId',
              factory: $EditSpaceRouteExtension._fromState,
            ),
          ],
        ),
        GoRouteData.$route(
          path: 'places/:spaceId',
          factory: $PlacesListRouteExtension._fromState,
          routes: [
            GoRouteData.$route(
              path: 'edit-place',
              factory: $EditPlaceRouteExtension._fromState,
            ),
            GoRouteData.$route(
              path: 'locate-on-map',
              factory: $LocateOnMapRouteExtension._fromState,
            ),
            GoRouteData.$route(
              path: 'add-place',
              factory: $AddPlaceRouteExtension._fromState,
            ),
            GoRouteData.$route(
              path: 'choose-place-name',
              factory: $ChoosePlaceNameRouteExtension._fromState,
            ),
          ],
        ),
      ],
    );

extension $HomeRouteExtension on HomeRoute {
  static HomeRoute _fromState(GoRouterState state) => HomeRoute();

  String get location => GoRouteData.$location(
        '/',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $JourneyTimelineRouteExtension on JourneyTimelineRoute {
  static JourneyTimelineRoute _fromState(GoRouterState state) =>
      JourneyTimelineRoute(
        state.extra as JourneyTimelineRouteData,
      );

  String get location => GoRouteData.$location(
        '/journey-timeline',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

extension $JourneyDetailsRouteExtension on JourneyDetailsRoute {
  static JourneyDetailsRoute _fromState(GoRouterState state) =>
      JourneyDetailsRoute(
        state.extra as ApiLocationJourney,
      );

  String get location => GoRouteData.$location(
        '/journey-details',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

extension $EnablePermissionRouteExtension on EnablePermissionRoute {
  static EnablePermissionRoute _fromState(GoRouterState state) =>
      EnablePermissionRoute();

  String get location => GoRouteData.$location(
        '/enable-permission',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $SettingsRouteExtension on SettingsRoute {
  static SettingsRoute _fromState(GoRouterState state) => SettingsRoute();

  String get location => GoRouteData.$location(
        '/settings',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ProfileRouteExtension on ProfileRoute {
  static ProfileRoute _fromState(GoRouterState state) => ProfileRoute();

  String get location => GoRouteData.$location(
        '/settings/profile',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ContactSupportRouteExtension on ContactSupportRoute {
  static ContactSupportRoute _fromState(GoRouterState state) =>
      ContactSupportRoute();

  String get location => GoRouteData.$location(
        '/settings/contact-support',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $SubscriptionRouteExtension on SubscriptionRoute {
  static SubscriptionRoute _fromState(GoRouterState state) =>
      SubscriptionRoute();

  String get location => GoRouteData.$location(
        '/settings/subscription',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $EditSpaceRouteExtension on EditSpaceRoute {
  static EditSpaceRoute _fromState(GoRouterState state) => EditSpaceRoute(
        spaceId: state.pathParameters['spaceId']!,
      );

  String get location => GoRouteData.$location(
        '/settings/edit-space/${Uri.encodeComponent(spaceId)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $PlacesListRouteExtension on PlacesListRoute {
  static PlacesListRoute _fromState(GoRouterState state) => PlacesListRoute(
        spaceId: state.pathParameters['spaceId']!,
      );

  String get location => GoRouteData.$location(
        '/places/${Uri.encodeComponent(spaceId)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $EditPlaceRouteExtension on EditPlaceRoute {
  static EditPlaceRoute _fromState(GoRouterState state) => EditPlaceRoute(
        spaceId: state.pathParameters['spaceId']!,
        $extra: state.extra as ApiPlace,
      );

  String get location => GoRouteData.$location(
        '/places/${Uri.encodeComponent(spaceId)}/edit-place',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

extension $LocateOnMapRouteExtension on LocateOnMapRoute {
  static LocateOnMapRoute _fromState(GoRouterState state) => LocateOnMapRoute(
        spaceId: state.pathParameters['spaceId']!,
        placeName: state.uri.queryParameters['place-name'],
      );

  String get location => GoRouteData.$location(
        '/places/${Uri.encodeComponent(spaceId)}/locate-on-map',
        queryParams: {
          if (placeName != null) 'place-name': placeName,
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $AddPlaceRouteExtension on AddPlaceRoute {
  static AddPlaceRoute _fromState(GoRouterState state) => AddPlaceRoute(
        spaceId: state.pathParameters['spaceId']!,
      );

  String get location => GoRouteData.$location(
        '/places/${Uri.encodeComponent(spaceId)}/add-place',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ChoosePlaceNameRouteExtension on ChoosePlaceNameRoute {
  static ChoosePlaceNameRoute _fromState(GoRouterState state) =>
      ChoosePlaceNameRoute(
        spaceId: state.pathParameters['spaceId']!,
        placeName: state.uri.queryParameters['place-name'],
        $extra: state.extra as LatLng,
      );

  String get location => GoRouteData.$location(
        '/places/${Uri.encodeComponent(spaceId)}/choose-place-name',
        queryParams: {
          if (placeName != null) 'place-name': placeName,
        },
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}
