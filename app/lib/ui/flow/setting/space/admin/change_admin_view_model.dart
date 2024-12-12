import 'package:data/api/auth/auth_models.dart';
import 'package:data/api/space/space_models.dart';
import 'package:data/log/logger.dart';
import 'package:data/service/space_service.dart';
import 'package:data/storage/app_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'change_admin_view_model.freezed.dart';

final changeAdminViewStateProvider = StateNotifierProvider.autoDispose<
    ChangAdminViewNotifier, ChangeAdminViewState>(
      (ref) => ChangAdminViewNotifier(
    ref.read(spaceServiceProvider),
    ref.read(currentUserPod),
  ),
);

class ChangAdminViewNotifier extends StateNotifier<ChangeAdminViewState> {
  final SpaceService spaceService;
  final ApiUser? user;

  ChangAdminViewNotifier(this.spaceService, this.user)
      : super(const ChangeAdminViewState()) {
    state = state.copyWith(currentUserId: user?.id ?? '');
  }

  void updateSpaceAdmin(ApiSpace space) async {
    try {
      state = state.copyWith(adminIdChanged: false, saving: true);
      await spaceService.updateSpace(space.copyWith(admin_id: state.newAdminId));
      state = state.copyWith(adminIdChanged: true, error: null, saving: false);
    } catch (error, stack) {
      state = state.copyWith(error: error);
      logger.e('ChangeAdminViewNotifier: error while update space admin id',
          error: error, stackTrace: stack);
    }
  }

  void updateNewAdminId(String id) {
    state = state.copyWith(newAdminId: id, allowSave: true);
  }
}

@freezed
class ChangeAdminViewState with _$ChangeAdminViewState {
  const factory ChangeAdminViewState({
    @Default(false) bool allowSave,
    @Default(false) bool saving,
    @Default(false) bool adminIdChanged,
    @Default('') String newAdminId,
    @Default('') String currentUserId,
    Object? error,
  }) = _ChangeAdminViewState;
}
