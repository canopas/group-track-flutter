import '../api/location/journey/journey.dart';
import '../api/location/location.dart';

extension LocationDataExtension on LocationData {
  JourneyRoute toJourneyRoute() {
    return JourneyRoute(latitude: latitude, longitude: longitude);
  }

  ApiLocationJourney toLocationJourney(String userId, String journeyId) {
    return ApiLocationJourney(
      id: journeyId,
      user_id: userId,
      from_latitude: latitude,
      from_longitude: longitude,
    );
  }
}