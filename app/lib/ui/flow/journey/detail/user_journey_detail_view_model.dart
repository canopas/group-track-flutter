import 'package:data/api/location/journey/api_journey_service.dart';
import 'package:data/api/location/journey/journey.dart';
import 'package:data/log/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'user_journey_detail_view_model.freezed.dart';

final userJourneyDetailStateProvider = StateNotifierProvider.autoDispose<
        UserJourneyDetailViewModel, UserJourneyDetailState>(
    (ref) => UserJourneyDetailViewModel(
          ref.read(journeyServiceProvider),
        ));

class UserJourneyDetailViewModel extends StateNotifier<UserJourneyDetailState> {
  final ApiJourneyService journeyService;

  UserJourneyDetailViewModel(this.journeyService)
      : super(const UserJourneyDetailState());

  void loadData(ApiLocationJourney journey) async {
    if (state.loading) return;
    state = state.copyWith(loading: true, error: null);

    await _getJourneyAddress(journey);

    state = state.copyWith(journey: journey, loading: false);
  }

  Future<void> _getJourneyAddress(ApiLocationJourney journey) async {
    try {
      final fromLatLng = LatLng(journey.from_latitude, journey.from_longitude);
      final toLatLng =
          LatLng(journey.to_latitude ?? 0.0, journey.to_longitude ?? 0.0);

      final fromPlaceMarks = await placemarkFromCoordinates(
          fromLatLng.latitude, fromLatLng.longitude);
      final toPlaceMarks =
          await placemarkFromCoordinates(toLatLng.latitude, toLatLng.longitude);

      state = state.copyWith(
        addressFrom: fromPlaceMarks,
        addressTo: toPlaceMarks,
      );
    } catch (error, stack) {
      logger.e(
        'UserJourneyDetailViewModel: error while getting address',
        error: error,
        stackTrace: stack,
      );
    }
  }
}

@freezed
class UserJourneyDetailState with _$UserJourneyDetailState {
  const factory UserJourneyDetailState({
    @Default(false) bool loading,
    ApiLocationJourney? journey,
    String? journeyId,
    @Default([]) List<Placemark> addressFrom,
    @Default([]) List<Placemark> addressTo,
    Object? error,
  }) = _UserJourneyDetailState;
}
