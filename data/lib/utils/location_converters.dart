import 'dart:convert';

import 'package:data/log/logger.dart';

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
    } catch (error) {
      logger.e('Error converting location list from string', error: error);
      return null;
    }
  }

  // Convert List<ApiLocation> to JSON string
  static String locationListToString(List<ApiLocation?> list) {
    try {
      return jsonEncode(list.map((location) => location?.toJson()).toList());
    } catch (error) {
      logger.e('Error converting location list to string', error: error);
      return '';
    }
  }

  // Convert JSON string to LocationJourney
  static ApiLocationJourney? journeyFromString(String value) {
    try {
      final parsed = jsonDecode(value);
      return ApiLocationJourney.fromJson(parsed);
    } catch (error) {
      logger.e('Error converting journey from string', error: error);
      return null;
    }
  }

  // Convert LocationJourney to JSON string
  static String journeyToString(ApiLocationJourney? journey) {
    try {
      return jsonEncode(journey?.toJson());
    } catch (error) {
      logger.e('Error converting journey to string', error: error);
      return '';
    }
  }
}
