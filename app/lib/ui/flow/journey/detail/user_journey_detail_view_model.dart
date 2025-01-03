import 'dart:io';
import 'dart:ui' as ui;

import 'package:data/api/location/journey/api_journey_service.dart';
import 'package:data/api/location/journey/journey.dart';
import 'package:data/log/logger.dart';
import 'package:data/storage/app_preferences.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../components/no_internet_screen.dart';

part 'user_journey_detail_view_model.freezed.dart';

final userJourneyDetailStateProvider = StateNotifierProvider.autoDispose<
        UserJourneyDetailViewModel, UserJourneyDetailState>(
    (ref) => UserJourneyDetailViewModel(
          ref.read(journeyServiceProvider),
          ref.read(googleMapType.notifier),
        ));

class UserJourneyDetailViewModel extends StateNotifier<UserJourneyDetailState> {
  final ApiJourneyService journeyService;
  final StateController<String> mapTypeController;

  UserJourneyDetailViewModel(this.journeyService, this.mapTypeController)
      : super(UserJourneyDetailState(mapType: mapTypeController.state));

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

      final fromPlaceMarks = await getPlaceMarkFromLatLng(fromLatLng);
      final toPlaceMarks = await getPlaceMarkFromLatLng(toLatLng);

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

  Future<List<Placemark>> getPlaceMarkFromLatLng(LatLng latLng) async {
    if (latLng.latitude == 0.0 && latLng.longitude == 0.0) return [];
    return await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
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
      targetWidth: Platform.isAndroid ? 200 : 100,
      targetHeight: Platform.isAndroid ? 200 : 100,
    );
    final frameInfo = await codec.getNextFrame();

    final byteData =
        await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);
    final resizedBytes = byteData!.buffer.asUint8List();

    return BitmapDescriptor.bytes(resizedBytes,
        bitmapScaling: MapBitmapScaling.none);
  }
}

@freezed
class UserJourneyDetailState with _$UserJourneyDetailState {
  const factory UserJourneyDetailState({
    @Default(false) bool loading,
    @Default(false) bool isNetworkOff,
    ApiLocationJourney? journey,
    String? journeyId,
    @Default("Normal") String mapType,
    @Default([]) List<Placemark> addressFrom,
    @Default([]) List<Placemark> addressTo,
    Object? error,
  }) = _UserJourneyDetailState;
}
