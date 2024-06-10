import 'package:data/api/auth/auth_models.dart';
import 'package:data/api/space/space_models.dart';
import 'package:data/log/logger.dart';
import 'package:data/service/space_service.dart';
import 'package:data/storage/app_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_screen_viewmodel.freezed.dart';

final homeViewStateProvider =
    StateNotifierProvider.autoDispose<HomeViewNotifier, HomeViewState>(
  (ref) => HomeViewNotifier(
    ref.read(spaceServiceProvider),
    ref.read(currentUserSessionJsonPod.notifier),
  ),
);

class HomeViewNotifier extends StateNotifier<HomeViewState> {
  final SpaceService spaceService;
  final StateController<String?> _currentSpaceIdController;

  HomeViewNotifier(this.spaceService, this._currentSpaceIdController)
      : super(const HomeViewState());

  String? get currentSpaceId => _currentSpaceIdController.state;

  set currentSpaceId(String? value) {
    _currentSpaceIdController.state = value;
  }

  void getAllSpace() async {
    try {
      state = state.copyWith(loading: state.spaceList.isEmpty);
      final spaces = await spaceService.getAllSpaceInfo();

      final sortedSpaces = spaces.toList();

      if (currentSpaceId != null) {
        final selectedSpaceIndex = sortedSpaces
            .indexWhere((space) => space.space.id == currentSpaceId);
        if (selectedSpaceIndex > -1) {
          final selectedSpace = sortedSpaces.removeAt(selectedSpaceIndex);
          sortedSpaces.insert(0, selectedSpace);
        }
      }

      state = state.copyWith(loading: false, spaceList: sortedSpaces);

      if (currentSpaceId != null && sortedSpaces.isNotEmpty) {
        final selectedSpace = sortedSpaces.first;
        updateSelectedSpace(selectedSpace);
      }
    } catch (error, stack) {
      state = state.copyWith(error: error);
      logger.e(
        'HomeViewNotifier: error while getting all spaces',
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
      state = state.copyWith(selectedSpace: space);
      currentSpaceId = space.space.id;
    }
  }

  void onDismissMemberDetail() {
    state = state.copyWith(selectedMember: null);
  }

  void onSelectMember(ApiUserInfo member) {
    final selectedMember =
        (state.selectedMember?.user.id == member.user.id) ? null : member;
    state = state.copyWith(selectedMember: selectedMember);
  }
}

@freezed
class HomeViewState with _$HomeViewState {
  const factory HomeViewState({
    @Default(false) bool allowSave,
    @Default(false) bool isCreating,
    @Default(false) bool loading,
    @Default(false) bool fetchingInviteCode,
    SpaceInfo? selectedSpace,
    ApiUserInfo? selectedMember,
    @Default('') String spaceInvitationCode,
    @Default([]) List<SpaceInfo> spaceList,
    Object? error,
  }) = _HomeViewState;
}
