import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../api/location/journey/journey.dart';
import '../api/location/location.dart';

class LocationConverters {
  // Convert JSON string to List<ApiLocation>
  static List<ApiLocation>? locationListFromString(String value) {
    try {
      final parsed = jsonDecode(value).cast<Map<String, dynamic>>();
      return parsed
          .map<ApiLocation>((json) => ApiLocation.fromJson(json))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print("Error converting location list from string: $e");
      }
      return null;
    }
  }

  // Convert List<ApiLocation> to JSON string
  static String locationListToString(List<ApiLocation?> list) {
    try {
      return jsonEncode(list.map((location) => location?.toJson()).toList());
    } catch (e) {
      if (kDebugMode) {
        print("Error converting location list to string: $e");
      }
      return '';
    }
  }

  // Convert JSON string to LocationJourney
  static ApiLocationJourney? journeyFromString(String value) {
    try {
      final parsed = jsonDecode(value);
      return ApiLocationJourney.fromJson(parsed);
    } catch (e) {
      if (kDebugMode) {
        print("Error converting journey from string: $e");
      }
      return null;
    }
  }

  // Convert LocationJourney to JSON string
  static String journeyToString(ApiLocationJourney? journey) {
    try {
      return jsonEncode(journey?.toJson());
    } catch (e) {
      if (kDebugMode) {
        print("Error converting journey to string: $e");
      }
      return '';
    }
  }
}
