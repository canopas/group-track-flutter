import 'dart:ui' as ui;

import 'package:data/api/auth/auth_models.dart';
import 'package:data/api/location/journey/api_journey_service.dart';
import 'package:data/api/location/journey/journey.dart';
import 'package:data/log/logger.dart';
import 'package:data/storage/app_preferences.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:style/extenstions/date_extenstions.dart';
import 'package:yourspace_flutter/domain/extenstions/lat_lng_extenstion.dart';

import '../../../components/no_internet_screen.dart';

part 'journey_timeline_view_model.freezed.dart';

final journeyTimelineStateProvider = StateNotifierProvider.autoDispose<
        JourneyTimelineViewModel, JourneyTimelineState>(
    (ref) => JourneyTimelineViewModel(
          ref.read(currentUserPod),
          ref.read(journeyServiceProvider),
          ref.read(currentSpaceId.notifier),
          ref.read(googleMapType.notifier),
        ));

class JourneyTimelineViewModel extends StateNotifier<JourneyTimelineState> {
  final ApiUser? currentUser;
  final ApiJourneyService journeyService;
  final StateController<String?> _currentSpaceId;
  final StateController<String> mapTypeController;

  JourneyTimelineViewModel(
    this.currentUser,
    this.journeyService,
    this._currentSpaceId,
    this.mapTypeController,
  ) : super(JourneyTimelineState(mapType: mapTypeController.state));

  void loadData(ApiUser selectedUser) async {
    final isNetworkOff = await _checkUserInternet();
    if (isNetworkOff) return;

    final isCurrentUser = selectedUser.id == currentUser?.id;
    state = state.copyWith(
      isCurrentUser: isCurrentUser,
      selectedUser: selectedUser,
      spaceId: _currentSpaceId.state,
    );
    setSelectedTimeRange();
    _loadJourney();
  }

  void setSelectedTimeRange() {
    state = state.copyWith(
        selectedTimeFrom: DateTime.now().startOfDay.millisecondsSinceEpoch,
        selectedTimeTo: DateTime.now().endOfDay.millisecondsSinceEpoch);
  }

  void _loadJourney({bool loadMore = false}) async {
    if (loadMore && !state.hasMore) return;
    try {
      state = state.copyWith(
          isLoading: state.sortedJourney.isEmpty, appending: loadMore);
      final userId = state.selectedUser!.id;
      final from = state.selectedTimeFrom ??
          DateTime.now().startOfDay.millisecondsSinceEpoch;
      final to = state.selectedTimeTo ??
          DateTime.now().endOfDay.millisecondsSinceEpoch;
      final lastJourneyTime = _getEarliestJourneyTime(state.sortedJourney);

      // Fetch journey history based on loadMore status
      final journeys = (loadMore)
          ? await journeyService.getMoreJourneyHistory(userId, lastJourneyTime)
          : await journeyService.getJourneyHistory(userId, from, to);

      // Filter by date range
      final filteredJourneys = journeys.where((journey) {
        return journey.created_at! >= from && journey.created_at! <= to;
      }).toList();

      // Combine all journeys and sort
      final allJourney = [...state.sortedJourney, ...filteredJourneys];
      final sortedJourney = _sortJourneysByUpdateAt(allJourney);

      // Update state with final data
      state = state.copyWith(
        isLoading: false,
        appending: false,
        hasMore: filteredJourneys.isNotEmpty,
        sortedJourney: sortedJourney,
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

  void onFilterBySelectedDate(DateTime pickedDate) async {
    final isNetworkOff = await _checkUserInternet();
    if (isNetworkOff) return;

    final fromTimeStamp = pickedDate.millisecondsSinceEpoch;
    final toTimeStamp = pickedDate.endOfDay.millisecondsSinceEpoch;
    state = state.copyWith(
      selectedTimeFrom: fromTimeStamp,
      selectedTimeTo: toTimeStamp,
      sortedJourney: [],
    );
    _loadJourney();
  }

  Future<bool> _checkUserInternet() async {
    final isNetworkOff = await checkInternetConnectivity();
    state = state.copyWith(isNetworkOff: isNetworkOff);
    return isNetworkOff;
  }

  String getSteadyDuration(int createdAt, int updatedAt) {
    Duration duration = DateTime.fromMillisecondsSinceEpoch(updatedAt)
        .difference(DateTime.fromMillisecondsSinceEpoch(createdAt));

    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes.remainder(60) > 0 ? '${duration.inMinutes.remainder(60)}min' : ''}';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes} min';
    } else {
      return '';
    }
  }

  String getDistanceString(double routeDistance) {
    if (routeDistance < 1000) {
      return '${routeDistance.round()} m';
    } else {
      final distanceInKm = routeDistance / 1000;
      return '${distanceInKm.round()} km';
    }
  }

  Future<String> getAddress(LatLng latLng) async {
    await Future.delayed(const Duration(seconds: 2));
    final address = await latLng.getAddressFromLocation();
    return address;
  }

  String formattedAddress(Placemark fromPlace, Placemark? toPlace) {
    final fromCity = fromPlace.locality ?? '';
    final toCity = toPlace?.locality ?? '';

    final fromArea = fromPlace.subLocality ?? '';
    final toArea = toPlace?.subLocality ?? '';

    final fromState = fromPlace.administrativeArea ?? '';
    final toState = toPlace?.administrativeArea ?? '';

    if (toPlace == null) {
      return formatAddress([fromArea, fromCity]);
    } else if (fromArea == toArea) {
      return formatAddress([fromArea, fromCity]);
    } else if (fromCity == toCity) {
      return formatTwoPlaceAddress([fromArea], [toArea, fromCity]);
    } else if (fromState == toState) {
      return formatTwoPlaceAddress([fromArea, fromCity], [toArea, toCity]);
    } else {
      return formatTwoPlaceAddress([fromCity, fromState], [toCity, toState]);
    }
  }

  String formatTwoPlaceAddress(List<String> fromPlace, List<String> toPlace) {
    bool isFromPlaceEmpty = fromPlace.every((part) => part.isEmpty);
    bool isToPlaceEmpty = toPlace.every((part) => part.isEmpty);

    if (!isFromPlaceEmpty && !isToPlaceEmpty) {
      return "${formatAddress(fromPlace)} -> ${formatAddress(toPlace)}";
    } else if (!isFromPlaceEmpty && isToPlaceEmpty) {
      return formatAddress(fromPlace);
    } else {
      return formatAddress(toPlace);
    }
  }

  String formatAddress(List<String> parts) {
    return parts.map((part) => part.isNotEmpty ? part : "Unknown").join(', ');
  }

  Future<BitmapDescriptor> createCustomIcon(String assetPath) async {
    final data = await rootBundle.load(assetPath);
    final codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetHeight: 24,
    );
    final frameInfo = await codec.getNextFrame();

    final byteData =
        await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);
    final resizedBytes = byteData!.buffer.asUint8List();

    return BitmapDescriptor.bytes(resizedBytes,
        bitmapScaling: MapBitmapScaling.none);
  }

  bool selectedDateIsTodayDate() {
    return state.selectedTimeFrom ==
        DateTime.now().startOfDay.millisecondsSinceEpoch;
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
    @Default(false) bool isNetworkOff,
    ApiUser? selectedUser,
    @Default([]) List<ApiLocationJourney> sortedJourney,
    int? selectedTimeFrom,
    int? selectedTimeTo,
    String? spaceId,
    @Default("Normal") String mapType,
    Object? error,
  }) = _JourneyTimelineState;
}
