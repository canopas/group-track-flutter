import 'dart:io';

import 'package:data/api/auth/auth_models.dart';
import 'package:data/api/location/location.dart';
import 'package:data/log/logger.dart';
import 'package:data/repository/journey_repository.dart';
import 'package:data/service/location_service.dart';
import 'package:data/service/space_service.dart';
import 'package:data/storage/app_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';

part 'create_space_view_model.freezed.dart';

final createSpaceViewStateProvider = StateNotifierProvider.autoDispose<
    CreateSpaceViewNotifier, CreateSpaceViewState>((ref) {
  return CreateSpaceViewNotifier(
    ref.read(spaceServiceProvider),
    ref.read(locationServiceProvider),
    ref.read(currentUserPod),
  );
});

class CreateSpaceViewNotifier extends StateNotifier<CreateSpaceViewState> {
  final SpaceService spaceService;
  final LocationService locationService;
  final JourneyRepository journeyRepository = JourneyRepository.instance;
  final ApiUser? _currentUser;

  CreateSpaceViewNotifier(this.spaceService, this.locationService, this._currentUser)
      : super(
          CreateSpaceViewState(spaceName: TextEditingController()),
        );

  Future<void> createSpace() async {
    try {
      state = state.copyWith(isCreating: true, invitationCode: '');
      final result = await spaceService.createSpaceAndGetInviteCode(state.spaceName.text);

      final spaceId = result['spaceId']!;
      final invitationCode = result['generatedCode']!;

      state = state.copyWith(isCreating: false, invitationCode: invitationCode, error: null);
      _saveCurrentUserLocation(spaceId);
    } catch (error, stack) {
      state = state.copyWith(error: error, isCreating: false);
      logger.e(
        'CreateSpaceViewNotifier: $error - error while creating new space',
        error: error,
        stackTrace: stack,
      );
    }
  }

  void updateSelectedSpaceName(String message) {
    if (message != state.selectedSpaceName) {
      state = state.copyWith(
        selectedSpaceName: message,
        spaceName: TextEditingController(text: message),
      );
    } else {
      state = state.copyWith(
        selectedSpaceName: '',
        spaceName: TextEditingController(text: ''),
      );
    }
  }

  void onChange(String spaceName) {
    state = state.copyWith(selectedSpaceName: spaceName, allowSave: spaceName.isNotEmpty);
  }

  Future<void> _saveCurrentUserLocation(String spaceId) async {
    try {
      if (Platform.isIOS) {
        const platform = MethodChannel('com.grouptrack/current_location');
        final locationFromIOS =
        await platform.invokeMethod('getCurrentLocation');
        final locationData = LocationData(
            latitude: locationFromIOS['latitude'],
            longitude: locationFromIOS['longitude'],
            timestamp: DateTime.now());
        await locationService.saveCurrentLocationWithSpaceId(
            spaceId: spaceId,
            userId: _currentUser ?.id ?? '',
            locationData: locationData);
        await journeyRepository.saveLocationJourney(extractedLocation: locationData, userId: _currentUser ?.id ?? '');
      } else {
        var location = await Geolocator.getCurrentPosition();
        final locationData = LocationData(
            latitude: location.latitude,
            longitude: location.longitude,
            timestamp: DateTime.now());
        await locationService.saveCurrentLocationWithSpaceId(
            spaceId: spaceId,
            userId: _currentUser?.id ?? '',
            locationData: locationData);
        await journeyRepository.saveLocationJourney(extractedLocation: locationData, userId: _currentUser ?.id ?? '');
      }
    } catch (error, stack) {
      logger.e(
          'JoinSpaceViewNotifier: error while save current location in space',
          error: error,
          stackTrace: stack);
    }
  }
}

@freezed
class CreateSpaceViewState with _$CreateSpaceViewState {
  const factory CreateSpaceViewState({
    @Default(false) bool allowSave,
    @Default(false) bool isCreating,
    @Default('') String selectedSpaceName,
    @Default('') String invitationCode,
    required TextEditingController spaceName,
    Object? error,
  }) = _CreateSpaceViewState;
}
