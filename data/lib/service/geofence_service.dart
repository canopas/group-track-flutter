import 'dart:io';

import 'package:data/log/logger.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/place/api_place.dart';

final geofenceServiceProvider = Provider((ref) => GeofenceService());

class GeofenceService {
  static const MethodChannel _channel = MethodChannel('geofence_plugin');

  static Future<void> startMonitoring(List<ApiPlace> places) async {
    print('XXX get start monitoring:$places');
    try {
      if (Platform.isAndroid) {
        startAndroidMonitoring(places);
      } else {
        for (final place in places) {
          await _channel.invokeMethod('startMonitoring', {
            'latitude': place.latitude,
            'longitude': place.longitude,
            'radius': place.radius,
            'identifier': place.id,
          });
        }
      }
    } catch (error, stack) {
      logger.e(
        'GeofenceService: error while start monitoring geofence places',
        error: error,
        stackTrace: stack,
      );
    }
  }

  static Future<void> startAndroidMonitoring(List<ApiPlace> places) async {
    final locations = places
        .map((place) => {
              'latitude': place.latitude,
              'longitude': place.longitude,
              'radius': place.radius,
              'identifier': place.id,
            })
        .toList();

    await _channel.invokeMethod('startMonitoring', {'locations': locations});
  }

  static Future<void> stopMonitoring(String id) async {
    try {
      await _channel.invokeMethod('stopMonitoring', {'identifier': id});
    } catch (error, stack) {
      logger.e(
        'GeofenceService: error while stop monitoring geofence place',
        error: error,
        stackTrace: stack,
      );
    }
  }

  static void setGeofenceCallback({
    required Function(String) onEnter,
    required Function(String) onExit,
  }) {
    _channel.setMethodCallHandler((call) async {
      logger
          .d('Geofence place event: ${call.method}');
      switch (call.method) {
        case 'onEnterGeofence':
          logger
              .d('Entered in geofence place: ${call.arguments['identifier']}');
          onEnter(call.arguments['identifier']);
          logger
              .d('Entered in geofence place: ${call.arguments['identifier']}');
          break;
        case 'onExitGeofence':
          logger.d('Exited in geofence place: ${call.arguments['identifier']}');
          onExit(call.arguments['identifier']);
          stopMonitoring(call.arguments['identifier']);
          logger.d('Exited in geofence place: ${call.arguments['identifier']}');
          break;
      }
    });
  }
}
