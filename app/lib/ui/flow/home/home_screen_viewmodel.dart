import 'package:data/api/auth/auth_models.dart';
import 'package:data/api/space/space_models.dart';
import 'package:data/log/logger.dart';
import 'package:data/service/permission_service.dart';
import 'package:data/service/space_service.dart';
import 'package:data/storage/app_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_screen_viewmodel.freezed.dart';

final homeViewStateProvider =
    StateNotifierProvider.autoDispose<HomeViewNotifier, HomeViewState>(
  (ref) => HomeViewNotifier(
    ref.read(spaceServiceProvider),
    ref.read(currentSpaceId.notifier),
    ref.read(permissionServiceProvider),
    ref.read(lastBatteryDialogPod.notifier),
    ref.read(currentUserPod),
  ),
);

class HomeViewNotifier extends StateNotifier<HomeViewState> {
  final SpaceService spaceService;
  final PermissionService permissionService;
  final StateController<String?> _currentSpaceIdController;
  final StateController<String?> _lastBatteryDialogDate;
  final ApiUser? _currentUser;

  HomeViewNotifier(
    this.spaceService,
    this._currentSpaceIdController,
    this.permissionService,
    this._lastBatteryDialogDate,
    this._currentUser,
  ) : super(const HomeViewState()) {
    getAllSpaces();
  }

  String? get currentSpaceId => _currentSpaceIdController.state;

  void listenSpaceMember() async {
    if (state.loading) return;
    try {
      state = state.copyWith(loading: state.spaceList.isEmpty);
      spaceService.streamSpaceMember().listen((spaces) {
        final sortedSpaces = spaces.toList();
        if ((currentSpaceId?.isNotEmpty ?? false) && spaces.isNotEmpty) {
          final selectedSpaceIndex = sortedSpaces
              .indexWhere((space) => space.space.id == currentSpaceId);
          if (selectedSpaceIndex > -1) {
            final selectedSpace = sortedSpaces.removeAt(selectedSpaceIndex);
            sortedSpaces.insert(0, selectedSpace);
            updateSelectedSpace(selectedSpace);
          }
        }
        if (spaces.isEmpty) {
          state = state.copyWith(loading: false, spaceList: []);
        }
        state = state.copyWith(loading: false, spaceList: sortedSpaces);

        if ((currentSpaceId?.isEmpty ?? false) && sortedSpaces.isNotEmpty) {
          final selectedSpace = sortedSpaces.first;
          _currentSpaceIdController.state = selectedSpace.space.id;
          updateSelectedSpace(selectedSpace);
        }
      });
    } catch (error, stack) {
      state = state.copyWith(error: error, loading: false);
      logger.e(
        'HomeViewNotifier: error while getting all spaces',
        error: error,
        stackTrace: stack,
      );
    }
  }

  void getAllSpaces() async {
    try {
      state = state.copyWith(loading: state.spaceList.isEmpty);
      final spaces = await spaceService.getAllSpaceInfo();
      state = state.copyWith(spaceList: spaces, loading: false);
      listenSpaceMember();
    } catch (error, stack) {
      logger.e(
        'HomeViewNotifier: error while load user spaces',
        error: error,
        stackTrace: stack,
      );
    }
  }

  void onAddMemberTap() async {
    try {
      state = state.copyWith(fetchingInviteCode: true, spaceInvitationCode: '');
      final code =
          await spaceService.getInviteCode(state.selectedSpace?.space.id ?? '');
      state = state.copyWith(
          spaceInvitationCode: code ?? '', fetchingInviteCode: false);
    } catch (error, stack) {
      state = state.copyWith(error: error, fetchingInviteCode: false);
      logger.e(
        'HomeViewNotifier: Error while getting invitation code',
        error: error,
        stackTrace: stack,
      );
    }
  }

  void updateSelectedSpace(SpaceInfo space) {
    if (space != state.selectedSpace) {
      final member = space.members
          .firstWhere((member) => member.user.id == _currentUser!.id);
      state = state.copyWith(
        selectedSpace: space,
        locationEnabled: member.isLocationEnabled,
      );
      _currentSpaceIdController.state = space.space.id;
    }
  }

  void showBatteryOptimizationDialog() async {
    // We don't want to show prompt immediately after user opens the app
    await Future.delayed(const Duration(seconds: 1));
    final date = _lastBatteryDialogDate.state;

    if (date == null) {
      _checkBatteryPermission();
    } else {
      final storedDate = DateTime.parse(date);
      final currentDate = DateTime.now();
      final daysPassed = currentDate.difference(storedDate).inDays;

      if (daysPassed >= 1) {
        _checkBatteryPermission();
      }
    }
  }

  void _checkBatteryPermission() async {
    final isBatteryOptimization =
        await permissionService.isBatteryOptimizationEnabled();
    final isBackgroundEnabled =
        await permissionService.isBackgroundLocationPermissionGranted();

    if (!isBatteryOptimization && isBackgroundEnabled) {
      _lastBatteryDialogDate.state = DateTime.now().toString();
      state = state.copyWith(showBatteryDialog: DateTime.now());
    }
  }

  void requestIgnoreBatteryOptimizations() async {
    await permissionService.requestIgnoreBatteryOptimizations();
  }

  void toggleLocation() async {
    if (currentSpaceId == null && _currentUser == null) return;
    try {
      final isEnabled = !state.locationEnabled;
      state = state.copyWith(enablingLocation: true);
      await spaceService.enableLocation(
        currentSpaceId!,
        _currentUser!.id,
        isEnabled,
      );
      state =
          state.copyWith(enablingLocation: false, locationEnabled: isEnabled);
    } catch (error, stack) {
      state = state.copyWith(enablingLocation: false, error: error);
      logger.e(
        'HomeViewNotifier: Error while location enabled or disabled',
        error: error,
        stackTrace: stack,
      );
    }
  }
}

@freezed
class HomeViewState with _$HomeViewState {
  const factory HomeViewState({
    @Default(false) bool allowSave,
    @Default(false) bool isCreating,
    @Default(false) bool loading,
    @Default(false) bool fetchingInviteCode,
    @Default(false) bool enablingLocation,
    @Default(true) bool locationEnabled,
    SpaceInfo? selectedSpace,
    @Default('') String spaceInvitationCode,
    @Default([]) List<SpaceInfo> spaceList,
    Object? error,
    DateTime? showBatteryDialog,
  }) = _HomeViewState;
}
