import 'dart:async';

import 'package:data/api/place/api_place.dart';
import 'package:data/log/logger.dart';
import 'package:data/service/location_manager.dart';
import 'package:data/service/place_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';

part 'add_new_place_view_model.freezed.dart';

final addNewPlaceStateProvider = StateNotifierProvider.autoDispose<
    AddNewPlaceViewNotifier, AddNewPlaceState>((ref) {
  return AddNewPlaceViewNotifier(
    ref.read(placeServiceProvider),
    ref.read(locationManagerProvider),
  );
});

class AddNewPlaceViewNotifier extends StateNotifier<AddNewPlaceState> {
  final PlaceService placeService;
  final LocationManager locationManager;

  AddNewPlaceViewNotifier(
    this.placeService,
    this.locationManager,
  ) : super(const AddNewPlaceState());

  Timer? _debounce;
  Position? _position;

  void onPlaceNameChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      fidePlace(value);
    });
  }

  void fidePlace(String value) async {
    if (value.isEmpty) {
      state = state.copyWith(places: []);
      return;
    }
    try {
      state = state.copyWith(loading: true);
      final position = await locationManager.getLastLocation();

      if (position != null &&
          position.latitude != _position?.latitude &&
          position.longitude != _position?.longitude) {
        _position = position;
      }
      final places = await placeService.searchNearbyPlaces(
        value,
        _position?.latitude,
        _position?.longitude,
      );
      state = state.copyWith(places: places, loading: false);
    } catch (error, stack) {
      state = state.copyWith(error: error, loading: false);
      logger.e(
        'AddNewPlaceViewNotifier: Error while finding place',
        error: error,
        stackTrace: stack,
      );
    }
  }
}

@freezed
class AddNewPlaceState with _$AddNewPlaceState {
  const factory AddNewPlaceState({
    @Default(false) loading,
    @Default([]) List<ApiNearbyPlace> places,
    Object? error,
  }) = _AddNewPlaceState;
}
