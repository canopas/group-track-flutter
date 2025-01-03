import 'dart:async';

import 'package:data/api/auth/auth_models.dart';
import 'package:data/api/location/journey/journey.dart';
import 'package:data/api/message/message_models.dart';
import 'package:data/api/place/api_place.dart';
import 'package:data/api/space/space_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yourspace_flutter/ui/flow/geofence/add/locate/locate_on_map_screen.dart';
import 'package:yourspace_flutter/ui/flow/geofence/add/placename/choose_place_name_screen.dart';
import 'package:yourspace_flutter/ui/flow/geofence/edit/edit_place_screen.dart';
import 'package:yourspace_flutter/ui/flow/geofence/places/places_list_screen.dart';
import 'package:yourspace_flutter/ui/flow/journey/detail/user_journey_detail_screen.dart';
import 'package:yourspace_flutter/ui/flow/journey/timeline/journey_timeline_screen.dart';
import 'package:yourspace_flutter/ui/flow/message/chat/chat_screen.dart';
import 'package:yourspace_flutter/ui/flow/message/thread_list_screen.dart';
import 'package:yourspace_flutter/ui/flow/onboard/connection_screen.dart';
import 'package:yourspace_flutter/ui/flow/onboard/pick_name_screen.dart';
import 'package:yourspace_flutter/ui/flow/permission/enable_permission_view.dart';
import 'package:yourspace_flutter/ui/flow/setting/contact_support/contact_support_screen.dart';
import 'package:yourspace_flutter/ui/flow/setting/profile/profile_screen.dart';
import 'package:yourspace_flutter/ui/flow/setting/setting_screen.dart';
import 'package:yourspace_flutter/ui/flow/setting/space/admin/change_admin_screen.dart';
import 'package:yourspace_flutter/ui/flow/setting/space/edit_space_screen.dart';
import 'package:yourspace_flutter/ui/flow/space/create/create_space_screen.dart';
import 'package:yourspace_flutter/ui/flow/space/invite/invite_code_screen.dart';
import 'package:yourspace_flutter/ui/flow/space/join/join_space_screen.dart';

import 'flow/auth/sign_in_method_screen.dart';
import 'flow/geofence/add/addnew/add_new_place_screen.dart';
import 'flow/home/home_screen.dart';
import 'flow/intro/intro_screen.dart';
import 'flow/setting/subscription/subscription_screen.dart';

class AppRoute {
  static const pathPhoneNumberVerification = '/phone-number-verification';
  static const pathCreateSpace = '/create';
  static const pathJoinSpace = '/join';
  static const pathInviteCode = '/invite';
  static const pathSetting = '/setting';
  static const pathProfile = '/profile';
  static const pathEditSpace = '/space';
  static const pathChangeAdmin = '/admin';
  static const pathContactSupport = '/contact-support';
  static const pathMessage = '/message';
  static const pathChat = '/chat';
  static const pathConnection = '/connection';
  static const pathPickName = '/pick-name';
  static const pathEnablePermission = '/enable-permission';
  static const pathPlacesList = '/places-list';
  static const pathAddNewPlace = '/add-new-place';
  static const pathLocateOnMap = "/locate_on_map";
  static const pathChoosePlace = "/choose_place";
  static const pathEditPlace = "/edit_place";
  static const pathJourneyTimeline = '/journey-timeline';
  static const pathJourneyDetail = '/journey-detail';
  static const pathSubscriptions = '/subscriptions';

  final String path;
  final String? name;
  final WidgetBuilder builder;

  const AppRoute(
    this.path, {
    this.name,
    required this.builder,
  });

  void go(BuildContext context) {
    if (name != null) {
      GoRouter.of(context).goNamed(name!, extra: builder);
    } else {
      GoRouter.of(context).go(path, extra: builder);
    }
  }

  static void popTo(
    BuildContext context,
    String path, {
    bool inclusive = false,
  }) {
    while (GoRouter.of(context)
            .routerDelegate
            .currentConfiguration
            .matches
            .last
            .matchedLocation !=
        path) {
      if (!GoRouter.of(context).canPop()) {
        return;
      }
      GoRouter.of(context).pop();
    }

    if (inclusive && GoRouter.of(context).canPop()) {
      GoRouter.of(context).pop();
    }
  }

  static void popBack(BuildContext context) {
    if (GoRouter.of(context).canPop()) {
      GoRouter.of(context).pop();
    }
  }

  Future<T?> push<T extends Object?>(BuildContext context) {
    if (name != null) {
      return GoRouter.of(context).pushNamed(name!, extra: builder);
    } else {
      return GoRouter.of(context).push(path, extra: builder);
    }
  }

  Future<T?> pushReplacement<T extends Object?>(BuildContext context) {
    if (name != null) {
      return GoRouter.of(context).pushReplacementNamed(name!, extra: builder);
    } else {
      return GoRouter.of(context).pushReplacement(path, extra: builder);
    }
  }

  Future<T?> pushNamed<T extends Object?>(BuildContext context) {
    if (name == null) {
      throw UnsupportedError('Name has to be set to use this feature!');
    }
    return GoRouter.of(context).pushNamed(name!, extra: builder);
  }

  GoRoute goRoute() => GoRoute(
        path: path,
        name: path,
        builder: (context, state) => state.widget(context),
      );

  static AppRoute get intro =>
      AppRoute("/intro", builder: (_) => const IntroScreen());

  static AppRoute get home =>
      AppRoute("/home", builder: (_) => const HomeScreen());

  static AppRoute get signInMethod =>
      AppRoute("/sign-in", builder: (_) => const SignInMethodScreen());

  static AppRoute pickName({ApiUser? user}) => AppRoute(
        pathPickName,
        builder: (_) => PickNameScreen(user: user),
      );

  static AppRoute get connection =>
      AppRoute(pathConnection, builder: (_) => const ConnectionScreen());

  static AppRoute createSpace({bool fromOnboard = false}) =>
      AppRoute(pathCreateSpace,
          builder: (_) => CreateSpace(fromOnboard: fromOnboard));

  static AppRoute joinSpace({bool fromOnboard = false}) =>
      AppRoute(pathJoinSpace,
          builder: (_) => JoinSpace(fromOnboard: fromOnboard));

  static AppRoute inviteCode({
    required String code,
    required String spaceName,
    bool fromOnboard = false,
  }) {
    return AppRoute(
      pathInviteCode,
      builder: (_) => InviteCode(
          spaceName: spaceName, inviteCode: code, fromOnboard: fromOnboard),
    );
  }

  static AppRoute get enablePermission => AppRoute(pathEnablePermission,
      builder: (_) => const EnablePermissionView());

  static AppRoute get setting =>
      AppRoute(pathCreateSpace, builder: (_) => const SettingScreen());

  static AppRoute get profile =>
      AppRoute(pathProfile, builder: (_) => const ProfileScreen());

  static AppRoute editSpace(String spaceId) {
    return AppRoute(
      pathEditSpace,
      builder: (_) => EditSpaceScreen(spaceId: spaceId),
    );
  }

  static AppRoute changeAdmin(SpaceInfo space) {
    return AppRoute(
      pathChangeAdmin,
      builder: (_) => ChangeAdminScreen(spaceInfo: space),
    );
  }

  static AppRoute get contactSupport => AppRoute(pathContactSupport,
      builder: (_) => const ContactSupportScreen());

  static AppRoute get subscription =>
      AppRoute(pathSubscriptions, builder: (_) => const SubscriptionScreen());

  static AppRoute placesList(String spaceId) {
    return AppRoute(pathPlacesList,
        builder: (_) => PlacesListScreen(spaceId: spaceId));
  }

  static AppRoute addNewPlace(String spaceId) {
    return AppRoute(
      pathAddNewPlace,
      builder: (_) => AddNewPlaceScreen(spaceId: spaceId),
    );
  }

  static AppRoute locateOnMapScreen({
    required String spaceId,
    String? placesName,
  }) {
    return AppRoute(pathLocateOnMap,
        builder: (_) => LocateOnMapScreen(spaceId: spaceId));
  }

  static AppRoute choosePlaceName({
    required LatLng location,
    required String spaceId,
    String? placeName,
  }) {
    return AppRoute(
      pathChoosePlace,
      builder: (_) => ChoosePlaceNameScreen(
        location: location,
        spaceId: spaceId,
        placesName: placeName ?? '',
      ),
    );
  }

  static AppRoute editPlaceScreen(ApiPlace place) {
    return AppRoute(
      pathEditPlace,
      builder: (_) => EditPlaceScreen(place: place),
    );
  }

  static AppRoute journeyTimeline(ApiUser user, int groupCreatedDate) {
    return AppRoute(pathJourneyTimeline,
        builder: (_) => JourneyTimelineScreen(selectedUser: user, groupCreatedDate: groupCreatedDate));
  }

  static AppRoute journeyDetail(ApiLocationJourney journey) {
    return AppRoute(
      pathJourneyDetail,
      builder: (_) => UserJourneyDetailScreen(journey: journey),
    );
  }

  static AppRoute message(SpaceInfo space) {
    return AppRoute(
      pathMessage,
      builder: (_) => ThreadListScreen(spaceInfo: space),
    );
  }

  static AppRoute chat({
    ApiSpace? space,
    String? threadId,
    List<ApiThread>? threads,
  }) {
    return AppRoute(
      pathMessage,
      builder: (_) => ChatScreen(
        space: space,
        threadId: threadId,
        threadInfoList: threads,
      ),
    );
  }

  static final routes = [
    GoRoute(
        path: intro.path,
        builder: (context, state) {
          return state.extra == null
              ? const IntroScreen()
              : state.widget(context);
        }),
    GoRoute(
      path: pathPickName,
      builder: (context, state) {
        return state.extra == null
            ? const PickNameScreen()
            : state.widget(context);
      },
    ),
    GoRoute(
      path: home.path,
      builder: (context, state) {
        return state.extra == null ? const HomeScreen() : state.widget(context);
      },
    ),
    GoRoute(
      path: signInMethod.path,
      builder: (context, state) {
        return state.extra == null
            ? const SignInMethodScreen()
            : state.widget(context);
      },
    ),
    GoRoute(
      path: pathCreateSpace,
      builder: (context, state) => state.widget(context),
    ),
    GoRoute(
      path: pathJoinSpace,
      builder: (context, state) => state.widget(context),
    ),
    GoRoute(
      path: pathInviteCode,
      builder: (context, state) => state.widget(context),
    ),
    GoRoute(
      path: pathSetting,
      builder: (context, state) => state.widget(context),
    ),
    GoRoute(
      path: pathProfile,
      builder: (context, state) => state.widget(context),
    ),
    GoRoute(
      path: pathEditSpace,
      builder: (context, state) => state.widget(context),
    ),
    GoRoute(
      path: pathChangeAdmin,
      builder: (context, state) => state.widget(context),
    ),
    GoRoute(
      path: pathContactSupport,
      builder: (context, state) => state.widget(context),
    ),
    GoRoute(
      path: pathMessage,
      builder: (context, state) => state.widget(context),
    ),
    GoRoute(
      path: pathChat,
      builder: (context, state) => state.widget(context),
    ),
    GoRoute(
      path: pathConnection,
      builder: (context, state) => state.widget(context),
    ),
    GoRoute(
      path: pathEnablePermission,
      builder: (context, state) => state.widget(context),
    ),
    GoRoute(
      path: pathPlacesList,
      builder: (context, state) => state.widget(context),
    ),
    GoRoute(
      path: pathAddNewPlace,
      builder: (context, state) => state.widget(context),
    ),
    GoRoute(
      path: pathLocateOnMap,
      builder: (context, state) => state.widget(context),
    ),
    GoRoute(
      path: pathChoosePlace,
      builder: (context, state) => state.widget(context),
    ),
    GoRoute(
      path: pathEditPlace,
      builder: (context, state) => state.widget(context),
    ),
    GoRoute(
      path: pathJourneyTimeline,
      builder: (context, state) => state.widget(context),
    ),
    GoRoute(
      path: pathJourneyDetail,
      builder: (context, state) => state.widget(context),
    ),
    GoRoute(
        path: pathSubscriptions,
        builder: (context, state) => state.widget(context)),
  ];
}

extension GoRouterStateExtensions on GoRouterState {
  Widget widget(BuildContext context) => (extra as WidgetBuilder)(context);
}
