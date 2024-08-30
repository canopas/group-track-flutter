import 'package:data/api/auth/auth_models.dart';
import 'package:data/api/location/journey/api_journey_service.dart';
import 'package:data/api/location/journey/journey.dart';
import 'package:data/log/logger.dart';
import 'package:data/storage/app_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geocoding/geocoding.dart';

part 'journey_timeline_view_model.freezed.dart';

final journeyTimelineStateProvider = StateNotifierProvider.autoDispose<
        JourneyTimelineViewModel, JourneyTimelineState>(
    (ref) => JourneyTimelineViewModel(
          ref.read(currentUserPod),
          ref.read(journeyServiceProvider),
          ref.read(currentSpaceId.notifier),
        ));

class JourneyTimelineViewModel extends StateNotifier<JourneyTimelineState> {
  final ApiUser? currentUser;
  final ApiJourneyService journeyService;
  final StateController<String?> _currentSpaceId;

  JourneyTimelineViewModel(
    this.currentUser,
    this.journeyService,
    this._currentSpaceId,
  ) : super(const JourneyTimelineState());

  void loadData(ApiUser selectedUser) {
    final isCurrentUser = selectedUser.id == currentUser?.id;
    state = state.copyWith(
      isCurrentUser: isCurrentUser,
      selectedUser: selectedUser,
      spaceId: _currentSpaceId.state,
    );
    _loadJourney();
  }

  void _loadJourney({bool loadMore = false}) async {
    if (loadMore && !state.hasMore) return;
    try {
      state = state.copyWith(
          isLoading: state.sortedJourney.isEmpty, appending: loadMore);
      final userId = state.selectedUser!.id;
      final from = state.selectedTimeFrom;
      final to = state.selectedTimeTo;
      final lastJourneyTime = _getEarliestJourneyTime(state.sortedJourney);
      final journeys = (loadMore)
          ? await journeyService.getMoreJourneyHistory(userId, lastJourneyTime)
          : await journeyService.getJourneyHistory(userId, from, to);

      final allJourney = [...state.sortedJourney, ...journeys];

      final sortJourney = _sortJourneysByUpdateAt(allJourney);

      state = state.copyWith(
        isLoading: false,
        appending: false,
        hasMore: journeys.isNotEmpty && from == null && to == null,
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

  int? _getEarliestJourneyTime(List<ApiLocationJourney> allJourneys) {
    if (allJourneys.isEmpty) return null;
    int earliestTimestamp = allJourneys
        .map((journey) => journey.created_at)
        .fold<int>(allJourneys.first.created_at!, (a, b) => a < b! ? a : b);
    return earliestTimestamp;
  }

  List<ApiLocationJourney> _sortJourneysByUpdateAt(
      List<ApiLocationJourney> journeys) {
    journeys.sort((a, b) => (b.update_at ?? 0).compareTo(a.update_at ?? 0));
    return journeys;
  }

  void loadMoreJourney() async {
    if (state.hasMore && !state.appending) {
      await Future.delayed(const Duration(milliseconds: 200));
      _loadJourney(loadMore: true);
    }
  }

  void showDatePicker(bool showPicker) {
    state = state.copyWith(showDatePicker: showPicker);
  }

  void onFilterBySelectedDate(DateTime pickedDate) {
    final fromTimeStamp = pickedDate.millisecondsSinceEpoch;
    final toTimeStamp = pickedDate.copyWith(hour: 23).millisecondsSinceEpoch;
    state = state.copyWith(
      selectedTimeFrom: fromTimeStamp,
      selectedTimeTo: toTimeStamp,
      sortedJourney: [],
    );
    _loadJourney();
  }

  Future<String> getAddress(double lat, double long) async {
    try {
      List<Placemark> placeMark = await placemarkFromCoordinates(lat, long);

      var address = '';

      if (placeMark.isNotEmpty) {
        var streets = placeMark.reversed
            .map((placeMark) => placeMark.street)
            .where((street) => street != null);

        streets = streets.where((street) =>
        street!.toLowerCase() != placeMark.reversed.last.locality!.toLowerCase());
        streets = streets.where((street) => !street!.contains('+'));

        address += streets.join(', ');

        address += ', ${placeMark.reversed.last.subLocality ?? ''}';
        address += ', ${placeMark.reversed.last.locality ?? ''}';
        address += ', ${placeMark.reversed.last.subAdministrativeArea ?? ''}';
        address += ', ${placeMark.reversed.last.administrativeArea ?? ''}';
        address += ', ${placeMark.reversed.last.postalCode ?? ''}';
        address += ', ${placeMark.reversed.last.country ?? ''}';
      }
      return address;
    } catch (e) {
      return "Getting address";
    }
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
    String? spaceId,
    Object? error,
  }) = _JourneyTimelineState;
}
