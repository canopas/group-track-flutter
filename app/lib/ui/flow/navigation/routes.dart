import 'package:data/api/auth/auth_models.dart';
import 'package:data/api/location/journey/journey.dart';
import 'package:data/api/message/message_models.dart';
import 'package:data/api/place/api_place.dart';
import 'package:data/api/space/space_models.dart';
import 'package:data/log/logger.dart';
import 'package:data/storage/app_preferences.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../auth/sign_in_method_screen.dart';
import '../geofence/add/addnew/add_new_place_screen.dart';
import '../geofence/add/locate/locate_on_map_screen.dart';
import '../geofence/add/placename/choose_place_name_screen.dart';
import '../geofence/edit/edit_place_screen.dart';
import '../geofence/places/places_list_screen.dart';
import '../home/home_screen.dart';
import '../intro/intro_screen.dart';
import '../journey/detail/user_journey_detail_screen.dart';
import '../journey/timeline/journey_timeline_screen.dart';
import '../message/chat/chat_screen.dart';
import '../message/thread_list_screen.dart';
import '../onboard/connection_screen.dart';
import '../onboard/pick_name_screen.dart';
import '../permission/enable_permission_view.dart';
import '../setting/contact_support/contact_support_screen.dart';
import '../setting/profile/profile_screen.dart';
import '../setting/setting_screen.dart';
import '../setting/space/admin/change_admin_screen.dart';
import '../setting/space/edit_space_screen.dart';
import '../setting/subscription/subscription_screen.dart';
import '../space/create/create_space_screen.dart';
import '../space/invite/invite_code_screen.dart';
import '../space/join/join_space_screen.dart';

part 'routes.g.dart';

final goRouterProvider = FutureProvider<GoRouter>((ref) async {
  Future<String> getInitialLocation() async {
    final isIntroScreenShown = ref.read(isIntroScreenShownPod);
    final user = ref.read(currentUserPod);

    if (!isIntroScreenShown) return IntroRoute().location;
    if (user == null) return SignInMethodRoute().location;
    if (user.first_name?.isEmpty ?? true) return PickNameRoute(user).location;
    return HomeRoute().location;
  }

  final initialLocation = await getInitialLocation();
  return GoRouter(
    initialLocation: initialLocation,
    routes: $appRoutes,
    debugLogDiagnostics: true,
    onException: (context, state, error) {
      logger.d('GoRouter onException', error: error);
    },
    redirect: (context, state) {
      return null;
    },
  );
});

@TypedGoRoute<IntroRoute>(
  path: '/intro',
)
class IntroRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const IntroScreen();
  }
}

@TypedGoRoute<SignInMethodRoute>(
  path: '/sign-in',
)
class SignInMethodRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SignInMethodScreen();
  }
}

@TypedGoRoute<PickNameRoute>(
  path: '/pick-name',
)
class PickNameRoute extends GoRouteData {
  final ApiUser $extra;

  const PickNameRoute(this.$extra);

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return PickNameScreen(
      user: $extra,
    );
  }
}

@TypedGoRoute<ConnectionRoute>(
  path: '/connection',
)
class ConnectionRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ConnectionScreen();
  }
}

@TypedGoRoute<CreateSpaceRoute>(
  path: '/create',
)
class CreateSpaceRoute extends GoRouteData {
  final bool fromOnboard;

  const CreateSpaceRoute({this.fromOnboard = false});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return CreateSpace(
      fromOnboard: fromOnboard,
    );
  }
}

@TypedGoRoute<JoinSpaceRoute>(
  path: '/join-space',
)
class JoinSpaceRoute extends GoRouteData {
  final bool fromOnboard;

  const JoinSpaceRoute({this.fromOnboard = false});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return JoinSpace(
      fromOnboard: fromOnboard,
    );
  }
}

class InviteCodeRouteData {
  final String spaceName;
  final String inviteCode;
  final bool fromOnboard;

  const InviteCodeRouteData({
    required this.spaceName,
    required this.inviteCode,
    this.fromOnboard = false,
  });
}

@TypedGoRoute<InviteCodeRoute>(
  path: '/invite-code',
)
class InviteCodeRoute extends GoRouteData {
  final InviteCodeRouteData $extra;

  const InviteCodeRoute(this.$extra);

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return InviteCode(
        spaceName: $extra.spaceName,
        inviteCode: $extra.inviteCode,
        fromOnboard: $extra.fromOnboard);
  }
}

class EnablePermissionRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const EnablePermissionView();
  }
}

class SettingsRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SettingScreen();
  }
}

class ProfileRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ProfileScreen();
  }
}

class ContactSupportRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ContactSupportScreen();
  }
}

class SubscriptionRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SubscriptionScreen();
  }
}

class EditSpaceRoute extends GoRouteData {
  final String spaceId;

  const EditSpaceRoute({required this.spaceId});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return EditSpaceScreen(
      spaceId: spaceId,
    );
  }
}

@TypedGoRoute<ChangeAdminRoute>(
  path: '/change-admin',
)
class ChangeAdminRoute extends GoRouteData {
  final SpaceInfo $extra;

  const ChangeAdminRoute({required this.$extra});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ChangeAdminScreen(
      spaceInfo: $extra,
    );
  }
}

class PlacesListRoute extends GoRouteData {
  final String spaceId;

  const PlacesListRoute({required this.spaceId});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return PlacesListScreen(spaceId: spaceId);
  }
}

class AddPlaceRoute extends GoRouteData {
  final String spaceId;

  const AddPlaceRoute({required this.spaceId});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return AddNewPlaceScreen(
      spaceId: spaceId,
    );
  }
}

class LocateOnMapRoute extends GoRouteData {
  final String spaceId;
  final String? placeName;

  const LocateOnMapRoute({required this.spaceId, this.placeName});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return LocateOnMapScreen(
      spaceId: spaceId,
      placesName: placeName,
    );
  }
}

class ChoosePlaceNameRoute extends GoRouteData {
  final String spaceId;
  final String? placeName;
  final LatLng $extra;

  const ChoosePlaceNameRoute(
      {required this.spaceId, required this.$extra, this.placeName});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ChoosePlaceNameScreen(
      spaceId: spaceId,
      location: $extra,
      placesName: placeName ?? '',
    );
  }
}

class EditPlaceRoute extends GoRouteData {
  final ApiPlace $extra;
  final String spaceId;

  const EditPlaceRoute({required this.spaceId, required this.$extra});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return EditPlaceScreen(place: $extra);
  }
}

class JourneyTimelineRouteData {
  final ApiUser user;
  final ApiSpace? space;

  const JourneyTimelineRouteData({
    required this.user,
    this.space,
  });
}

class JourneyTimelineRoute extends GoRouteData {
  final JourneyTimelineRouteData $extra;

  const JourneyTimelineRoute(this.$extra);

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return JourneyTimelineScreen(
      selectedUser: $extra.user,
      group: $extra.space,
    );
  }
}

class JourneyDetailsRoute extends GoRouteData {
  final ApiLocationJourney $extra;

  const JourneyDetailsRoute(this.$extra);

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return UserJourneyDetailScreen(
      journey: $extra,
    );
  }
}

@TypedGoRoute<ThreadsRoute>(path: '/thread')
class ThreadsRoute extends GoRouteData {
  final SpaceInfo $extra;

  const ThreadsRoute(this.$extra);

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ThreadListScreen(
      spaceInfo: $extra,
    );
  }
}

class ChatRouteData {
  final ApiSpace? space;
  final List<ApiThread>? threads;
  final String? threadId;

  const ChatRouteData({
    this.space,
    this.threadId,
    this.threads = const [],
  });
}

@TypedGoRoute<ChatRoute>(
  path: '/chat',
)
class ChatRoute extends GoRouteData {
  final ChatRouteData $extra;

  const ChatRoute(this.$extra);

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ChatScreen(
      space: $extra.space,
      threadId: $extra.threadId,
      threadInfoList: $extra.threads,
    );
  }
}

@TypedGoRoute<HomeRoute>(path: '/', routes: [
  TypedGoRoute<JourneyTimelineRoute>(path: 'journey-timeline'),
  TypedGoRoute<JourneyDetailsRoute>(path: 'journey-details'),
  TypedGoRoute<EnablePermissionRoute>(
    path: 'enable-permission',
  ),
  TypedGoRoute<SettingsRoute>(path: 'settings', routes: [
    TypedGoRoute<ProfileRoute>(
      path: 'profile',
    ),
    TypedGoRoute<ContactSupportRoute>(
      path: 'contact-support',
    ),
    TypedGoRoute<SubscriptionRoute>(
      path: 'subscription',
    ),
    TypedGoRoute<EditSpaceRoute>(path: 'edit-space/:spaceId')
  ]),
  TypedGoRoute<PlacesListRoute>(
    path: 'places/:spaceId',
    routes: [
      TypedGoRoute<EditPlaceRoute>(path: 'edit-place'),
      TypedGoRoute<LocateOnMapRoute>(
        path: 'locate-on-map',
      ),
      TypedGoRoute<AddPlaceRoute>(path: 'add-place'),
      TypedGoRoute<ChoosePlaceNameRoute>(
        path: 'choose-place-name',
      )
    ],
  )
])
class HomeRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HomeScreen();
  }
}
