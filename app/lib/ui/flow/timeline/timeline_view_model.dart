import 'package:data/api/auth/auth_models.dart';
import 'package:data/api/location/location.dart';
import 'package:data/log/logger.dart';
import 'package:data/service/auth_service.dart';
import 'package:data/service/timeline_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:data/service/space_service.dart';

part 'timeline_view_model.freezed.dart';

final timelineViewStateProvider = StateNotifierProvider.autoDispose<
    TimelineViewNotifier, TimelineViewState>((ref) {
  return TimelineViewNotifier(
    ref.read(spaceServiceProvider),
    ref.read(timelineServiceProvider),
    ref.read(authServiceProvider),
  );
});

class TimelineViewNotifier extends StateNotifier<TimelineViewState> {
  final SpaceService spaceService;
  final TimelineService timelineService;
  final AuthService authService;

  final String _userId = '';

  TimelineViewNotifier(
      this.spaceService,
      this.timelineService,
      this.authService,
      ) : super(const TimelineViewState()) {
    fetchUser();
    loadLocation();
  }

  void fetchUser() {
    try {
      final ApiUser? currentUser = authService.currentUser;
      final ApiUser user = (currentUser != null && currentUser.id == _userId)
          ? currentUser
          : authService.getUser(userId: _userId) as ApiUser;

      state = state.copyWith(
        selectedUser: user,
        isCurrentUserTimeline: currentUser?.id == _userId,
      );
    } catch (error, stack) {
      logger.e(
        'TimelineViewNotifier: error while fetching user',
        error: error,
        stackTrace: stack,
      );
    }
  }

  void loadLocation({bool loadMore = false}) async {
    try {
      if (loadMore && !state.hasMoreLocations) return;
      state = state.copyWith(loading: state.locations.isEmpty, appending: loadMore);
      final from = state.selectedTimeForm;
      final to = state.selectedTimeTo;
      final lastJourneyTime = state.locations.isNotEmpty
          ? state.locations.map((loc) => loc.created_at).reduce((a, b) => a!.isBefore(b!) ? a : b)
          : null;

      List<ApiLocation> locations;
      if (loadMore) {
        locations = await timelineService.getMoreTimelineHistory(_userId, lastJourneyTime);
      } else {
        locations = await timelineService.getTimelineHistory(_userId, from: from, to: to);
      }

      final hasMoreItems = locations.isNotEmpty;
      state = state.copyWith(
          locations: [...state.locations, ...locations],
          hasMoreLocations: hasMoreItems);

    } catch (error, stack) {
      logger.e(
        'TimelineViewNotifier: error while load locations',
        error: error,
        stackTrace: stack,
      );
    }
  }
}

@freezed
class TimelineViewState with _$TimelineViewState {
  const factory TimelineViewState({
    @Default(false) bool isCurrentUserTimeline,
    ApiUser? selectedUser,
    int? selectedTimeForm,
    int? selectedTimeTo,
    @Default(false) bool loading,
    @Default(false) bool appending,
    @Default(false) bool hasMoreLocations,
    @Default([]) List<ApiLocation> locations,
    Object? error,
  }) = _TimelineViewState;
}
