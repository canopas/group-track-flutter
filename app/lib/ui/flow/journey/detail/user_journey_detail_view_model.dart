import 'dart:ui' as ui;

import 'package:data/api/location/journey/journey.dart';
import 'package:data/log/logger.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../components/no_internet_screen.dart';

part 'user_journey_detail_view_model.freezed.dart';

final userJourneyDetailStateProvider = StateNotifierProvider.autoDispose<
    UserJourneyDetailViewModel, UserJourneyDetailState>(
  (ref) => UserJourneyDetailViewModel(),
);

class UserJourneyDetailViewModel extends StateNotifier<UserJourneyDetailState> {
  UserJourneyDetailViewModel() : super(const UserJourneyDetailState());

  void loadData(ApiLocationJourney journey) async {
    final isNetworkOff = await _checkUserInternet();
    if (isNetworkOff) return;

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
        error: null,
      );
    } catch (error, stack) {
      state = state.copyWith(error: error);
      logger.e(
        'UserJourneyDetailViewModel: error while getting address',
        error: error,
        stackTrace: stack,
      );
    }
  }

  Future<bool> _checkUserInternet() async {
    final isNetworkOff = await checkInternetConnectivity();
    state = state.copyWith(isNetworkOff: isNetworkOff);
    return isNetworkOff;
  }

  String getDistanceString(double routeDistance) {
    if (routeDistance < 1000) {
      return '${routeDistance.round()} m';
    } else {
      final distanceInKm = routeDistance / 1000;
      return '${distanceInKm.round()} km';
    }
  }

  String getRouteDurationString(int routeDuration) {
    final duration = Duration(milliseconds: routeDuration);

    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    if (hours > 0) {
      return "$hours hr $minutes mins";
    } else if (minutes > 0) {
      return "$minutes mins";
    } else {
      return "$seconds sec";
    }
  }

  Future<BitmapDescriptor> createCustomIcon(String assetPath) async {
    final data = await rootBundle.load(assetPath);
    final codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: 200,
      targetHeight: 200,
    );
    final frameInfo = await codec.getNextFrame();

    final byteData =
        await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);
    final resizedBytes = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(resizedBytes);
  }
}

@freezed
class UserJourneyDetailState with _$UserJourneyDetailState {
  const factory UserJourneyDetailState({
    @Default(false) bool loading,
    @Default(false) bool isNetworkOff,
    ApiLocationJourney? journey,
    String? journeyId,
    @Default([]) List<Placemark> addressFrom,
    @Default([]) List<Placemark> addressTo,
    Object? error,
  }) = _UserJourneyDetailState;
}
