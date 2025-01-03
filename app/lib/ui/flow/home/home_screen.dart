import 'dart:io';

import 'package:data/api/auth/api_user_service.dart';
import 'package:data/repository/geofence_repository.dart';
import 'package:data/service/geofence_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:yourspace_flutter/domain/extenstions/api_error_extension.dart';
import 'package:yourspace_flutter/domain/extenstions/context_extenstions.dart';
import 'package:yourspace_flutter/domain/extenstions/widget_extensions.dart';
import 'package:yourspace_flutter/ui/app_route.dart';
import 'package:yourspace_flutter/ui/components/app_page.dart';
import 'package:yourspace_flutter/ui/components/error_snakebar.dart';
import 'package:yourspace_flutter/ui/components/resume_detector.dart';
import 'package:yourspace_flutter/ui/flow/home/home_screen_viewmodel.dart';

import '../../../domain/fcm/notification_handler.dart';
import '../../components/alert.dart';
import '../../components/no_internet_screen.dart';
import '../../components/permission_dialog.dart';
import 'components/home_top_bar.dart';
import 'map/map_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late HomeViewNotifier notifier;
  late NotificationHandler notificationHandler;
  late GeofenceRepository geofenceRepository;

  @override
  void initState() {
    super.initState();
    runPostFrame(() {
      notificationHandler = ref.read(notificationHandlerProvider);
      notificationHandler.init(context);

      notifier = ref.watch(homeViewStateProvider.notifier);

      GeofenceService.setGeofenceCallback(
        onEnter: (id) => geofenceRepository.makeHttpCall(id, GEOFENCE_ENTER),
        onExit: (id) => geofenceRepository.makeHttpCall(id, GEOFENCE_EXIT),
      );
    });

    onResume();
  }

  void onResume() {
    // Delay request to reduce too many API calls when the app is opened
    Future.delayed(const Duration(seconds: 1)).then((_) {
      if (mounted) {
        final service = ref.read(apiUserServiceProvider);
        service.registerDevice();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeViewStateProvider);
    _observeNavigation(state);
    _observeError();
    if (Platform.isAndroid) _observeShowBatteryDialog(context);
    _observeSessionExpiredAlertPopup(context);
    _observeSignInState();

    return AppPage(
      body: ResumeDetector(
        onResume: () {
          notifier.showBatteryOptimizationDialog();
          notifier.updateCurrentUserNetworkState();
        },
        child: _body(context, state),
      ),
    );
  }

  Widget _body(BuildContext context, HomeViewState state) {
    if (state.isNetworkOff) {
      return NoInternetScreen(onPressed: () {
        notifier.fetchData();
      });
    }

    return Padding(
      padding: context.mediaQueryPadding,
      child: Stack(
        children: [
          MapScreen(space: state.selectedSpace),
          HomeTopBar(
            spaces: state.spaceList,
            onSpaceItemTap: (name) => notifier.updateSelectedSpace(name),
            onAddMemberTap: () {
              _checkUserInternet(() => notifier.onAddMemberTap());
            },
            onToggleLocation: () {
              _checkUserInternet(() => notifier.toggleLocation());
            },
            selectedSpace: state.selectedSpace,
            loading: state.loading,
            fetchingInviteCode: state.fetchingInviteCode,
            locationEnabled: state.locationEnabled,
            enablingLocation: state.enablingLocation,
          ),
        ],
      ),
    );
  }

  void _observeNavigation(HomeViewState state) {
    ref.listen(
        homeViewStateProvider.select((state) => state.spaceInvitationCode),
        (_, next) {
      if (next.isNotEmpty) {
        AppRoute.inviteCode(
                code: next, spaceName: state.selectedSpace?.space.name ?? '')
            .push(context);
      }
    });
  }

  void _observeError() {
    ref.listen(homeViewStateProvider.select((state) => state.error),
        (previous, next) {
      if (next != null) {
        showErrorSnackBar(context, next.l10nMessage(context));
      }
    });
  }

  void _observeShowBatteryDialog(BuildContext context) {
    ref.listen(homeViewStateProvider.select((state) => state.showBatteryDialog),
        (_, next) {
      if (next != null) {
        showDialog(
            context: context,
            builder: (context) {
              return PermissionDialog(
                title: context.l10n.battery_optimization_dialog_title,
                subTitle1: context.l10n.battery_optimization_dialog_message,
                confirmBtn:
                    context.l10n.battery_optimization_dialog_btn_change_now,
                dismissBtn: context.l10n.common_cancel,
                onDismiss: () {
                  Navigator.of(context).pop();
                },
                goToSettings: () {
                  if (Platform.isAndroid) openAppSettings();
                  notifier.requestIgnoreBatteryOptimizations();
                  Navigator.of(context).pop();
                },
              );
            });
      }
    });
  }

  void _observeSessionExpiredAlertPopup(BuildContext context) {
    ref.listen(homeViewStateProvider.select((state) => state.isSessionExpired),
        (_, next) {
      if (next) {
        showOkayConfirmation(
          context,
          title: context.l10n.home_session_expired_title,
          message: context.l10n.home_session_expired_message,
          barrierDismissible: false,
          onOkay: () => notifier.signOut(),
        );
      }
    });
  }

  void _observeSignInState() {
    ref.listen(homeViewStateProvider.select((state) => state.popToSignIn),
        (_, next) {
      if (next != null) {
        AppRoute.signInMethod.go(context);
      }
    });
  }

  void _checkUserInternet(VoidCallback onCallback) async {
    final isNetworkOff = await checkInternetConnectivity();
    isNetworkOff ? _showSnackBar() : onCallback();
  }

  void _showSnackBar() {
    showErrorSnackBar(context, context.l10n.on_internet_error_sub_title);
  }
}
