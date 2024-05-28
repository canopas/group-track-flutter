import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:data/service/space_service.dart';

part 'home_screen_viewmodel.freezed.dart';

final createSpaceViewStateProvider = StateNotifierProvider.autoDispose<
    HomeViewNotifier, HomeViewState>((ref) {
  return HomeViewNotifier(
    ref.read(spaceServiceProvider),
  );
});

class HomeViewNotifier extends StateNotifier<HomeViewState> {
  final SpaceService spaceService;

  HomeViewNotifier(this.spaceService)
      : super(
    const HomeViewState(),
  );

}

@freezed
class HomeViewState with _$HomeViewState {
  const factory HomeViewState({
    @Default(false) bool allowSave,
    @Default(false) bool isCreating,
    @Default('') String selectedSpaceName,
    @Default('') String invitationCode,
  }) = _HomeViewState;
}
