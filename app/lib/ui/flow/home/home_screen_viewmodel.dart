import 'package:data/api/space/space_models.dart';
import 'package:data/log/logger.dart';
import 'package:data/storage/app_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:data/service/space_service.dart';

part 'home_screen_viewmodel.freezed.dart';

final homeViewStateProvider = StateNotifierProvider.autoDispose<
    HomeViewNotifier, HomeViewState>(
      (ref) => HomeViewNotifier(
        ref.read(spaceServiceProvider),
        ref.read(currentUserSessionJsonPod.notifier),
  ),
);

class HomeViewNotifier extends StateNotifier<HomeViewState> {
  final SpaceService spaceService;
  final StateController<String?> _currentSpaceIdController;

  HomeViewNotifier(this.spaceService, this._currentSpaceIdController) : super(const HomeViewState());

  String? get currentSpaceId => _currentSpaceIdController.state;

  set currentSpaceId(String? value) {
    _currentSpaceIdController.state = value;
  }

  void getAllSpace() async {
    try {
      state = state.copyWith(loading: state.spaceList.isEmpty);
      final spaces = await spaceService.getAllSpaceInfo();
      state = state.copyWith(loading: false, spaceList: spaces);

      final selectedSpace = spaces.firstWhere(
            (space) => space.space.id == currentSpaceId,
      );

      updateSelectedSpaceName(selectedSpace);
    } catch (error, stack) {
      logger.e(
        'HomeViewNotifier: error while getting all spaces',
        error: error,
        stackTrace: stack,
      );
    }
  }

  void onAddMemberTap() async {
    try {
      state = state.copyWith(isCodeGetting: true);
      final code = await spaceService.getInviteCode(state.selectedSpace?.space.id ?? '');
      state = state.copyWith(spaceInvitationCode: code ?? '', isCodeGetting: false);
    } catch (error, stack) {
      logger.e(
        'HomeViewNotifier: Error while getting invitation code',
        error: error,
        stackTrace: stack,
      );
    }
  }

  void updateSelectedSpaceName(SpaceInfo space) {
    if (space != state.selectedSpace) {
      state = state.copyWith(selectedSpace: space);
      currentSpaceId = space.space.id;
    }
  }
}

@freezed
class HomeViewState with _$HomeViewState {
  const factory HomeViewState({
    @Default(false) bool allowSave,
    @Default(false) bool isCreating,
    @Default(false) bool loading,
    @Default(false) bool isCodeGetting,
    SpaceInfo? selectedSpace,
    @Default('') String spaceInvitationCode,
    @Default([]) List<SpaceInfo> spaceList,
  }) = _HomeViewState;
}
