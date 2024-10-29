import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../api/location/journey/journey.dart';

extension JourneyRouteLatLngExtension on JourneyRoute {
  LatLng toLatLng() {
    return LatLng(latitude, longitude);
  }
}