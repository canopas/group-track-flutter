import '../api/location/journey/journey.dart';
import '../api/location/location.dart';

extension LocationDataExtension on LocationData {
  JourneyRoute toRoute() {
    return JourneyRoute(latitude: latitude, longitude: longitude);
  }
}