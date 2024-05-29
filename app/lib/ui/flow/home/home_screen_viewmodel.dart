import 'package:data/api/space/space_models.dart';
import 'package:data/log/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:data/service/space_service.dart';

part 'home_screen_viewmodel.freezed.dart';

final homeViewStateProvider = StateNotifierProvider.autoDispose<
    HomeViewNotifier, HomeViewState>(
      (ref) => HomeViewNotifier(
        ref.read(spaceServiceProvider),
  ),
);

class HomeViewNotifier extends StateNotifier<HomeViewState> {
  final SpaceService spaceService;

  HomeViewNotifier(this.spaceService) : super(const HomeViewState());

  void getAllSpace() async {
    try {
      state = state.copyWith(loading: state.spaceList.isEmpty);
      final spaces = await spaceService.getAllSpaceInfo();
      state = state.copyWith(loading: false, spaceList: spaces);
      if (state.selectedSpaceName.isEmpty) {
        updateSelectedSpaceName(state.spaceList.first.space.name);
      }
    } catch (error, stack) {
      logger.e(
        'HomeViewNotifier: error while get all place',
        error: error,
        stackTrace: stack,
      );
    }
  }

  void updateSelectedSpaceName(String name) {
    if (name != state.selectedSpaceName) {
      state = state.copyWith(
        selectedSpaceName: name,
      );
    } else {
      state = state.copyWith(
        selectedSpaceName: state.spaceList.first.space.name,
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
    @Default('') String selectedSpaceName,
    @Default('') String invitationCode,
    @Default([]) List<SpaceInfo> spaceList,
  }) = _HomeViewState;
}
