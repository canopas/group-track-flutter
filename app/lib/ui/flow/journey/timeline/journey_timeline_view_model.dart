import 'package:data/api/auth/auth_models.dart';
import 'package:data/api/location/journey/api_journey_service.dart';
import 'package:data/api/location/journey/journey.dart';
import 'package:data/log/logger.dart';
import 'package:data/storage/app_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'journey_timeline_view_model.freezed.dart';

final journeyTimelineStateProvider = StateNotifierProvider.autoDispose<
        JourneyTimelineViewModel, JourneyTimelineState>(
    (ref) => JourneyTimelineViewModel(
          ref.read(currentUserPod),
          ref.read(journeyServiceProvider),
        ));

class JourneyTimelineViewModel extends StateNotifier<JourneyTimelineState> {
  final ApiUser? currentUser;
  final ApiJourneyService journeyService;

  JourneyTimelineViewModel(this.currentUser, this.journeyService)
      : super(const JourneyTimelineState());

  void loadData(ApiUser selectedUser) {
    final isCurrentUser = selectedUser.id == currentUser?.id;
    state = state.copyWith(
      isCurrentUser: isCurrentUser,
      selectedUser: selectedUser,
    );
    loadJourney();
  }

  void loadJourney({bool loadMore = false}) async {
    if (loadMore && !state.hasMore) return;
    try {
      state = state.copyWith(
          isLoading: state.sortedJourney.isEmpty, appending: loadMore);
      final userId = state.selectedUser!.id;
      final from = state.selectedTimeFrom;
      final to = state.selectedTimeTo;
      final lastJourneyTime = getEarliestJourneyTime(state.sortedJourney);
      final journeys = (loadMore)
          ? await journeyService.getMoreJourneyHistory(userId, lastJourneyTime)
          : await journeyService.getJourneyHistory(userId, from, to);

      final allJourney = [...state.sortedJourney, ...journeys];

      final sortJourney = sortJourneysByUpdateAt(allJourney);

      state = state.copyWith(
        isLoading: false,
        appending: false,
        hasMore: journeys.isNotEmpty,
        sortedJourney: sortJourney,
      );
    } catch (error, stack) {
      state = state.copyWith(error: error, isLoading: false, appending: false);
      logger.e(
        'JourneyTimelineViewModel: error while getting user journeys',
        error: error,
        stackTrace: stack,
      );
    }
  }

  int? getEarliestJourneyTime(List<ApiLocationJourney> allJourneys) {
    if (allJourneys.isEmpty) return null;
    int earliestTimestamp = allJourneys
        .map((journey) => journey.created_at)
        .fold<int>(allJourneys.first.created_at!, (a, b) => a < b! ? a : b);
    return earliestTimestamp;
  }

  List<ApiLocationJourney> sortJourneysByUpdateAt(
      List<ApiLocationJourney> journeys) {
    journeys.sort((a, b) => (b.update_at ?? 0).compareTo(a.update_at ?? 0));
    return journeys;
  }

  void loadMoreJourney() async {
    if (state.hasMore && !state.appending) {
      await Future.delayed(const Duration(milliseconds: 200));
      loadJourney(loadMore: true);
    }
  }

  void showDatePicker() {
    state = state.copyWith(showDatePicker: true);
  }

  void dismissDatePicker() {
    state = state.copyWith(showDatePicker: false);
  }

  void onFilterBySelectedDate(DateTime pickedDate) {
    final fromTimeStamp = pickedDate.millisecondsSinceEpoch;
    final toTimeStamp = pickedDate.copyWith(hour: 23).millisecondsSinceEpoch;
    state = state.copyWith(
      selectedTimeFrom: fromTimeStamp,
      selectedTimeTo: toTimeStamp,
      sortedJourney: [],
    );
    loadJourney();
  }
}

@freezed
class JourneyTimelineState with _$JourneyTimelineState {
  const factory JourneyTimelineState({
    @Default(false) bool isLoading,
    @Default(false) bool appending,
    @Default(true) bool hasMore,
    @Default(false) bool isCurrentUser,
    @Default(false) bool showDatePicker,
    ApiUser? selectedUser,
    @Default([]) List<ApiLocationJourney> sortedJourney,
    int? selectedTimeFrom,
    int? selectedTimeTo,
    Object? error,
  }) = _JourneyTimelineState;
}
