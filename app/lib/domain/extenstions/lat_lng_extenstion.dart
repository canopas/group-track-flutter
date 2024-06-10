import 'package:data/log/logger.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

extension LatLngExtensions on LatLng {
  Future<String> getAddressFromLocation() async {
    String? address = '';
    try {
      final placeMarks = await placemarkFromCoordinates(latitude, longitude);
      if (placeMarks.isNotEmpty) {
        var streets = placeMarks
            .map((placeMark) => placeMark.street)
            .where((street) => street != null);

        streets = streets.where((street) =>
            street!.toLowerCase() != placeMarks.last.locality!.toLowerCase());

        streets = streets.where((street) => !street!.contains('+'));
        address += streets.join(', ');

        address += ', ${placeMarks.reversed.last.subLocality ?? ''}';
        address += ', ${placeMarks.reversed.last.locality ?? ''}';
        address += ', ${placeMarks.reversed.last.subAdministrativeArea ?? ''}';
        address += ', ${placeMarks.reversed.last.administrativeArea ?? ''}';
        address += ', ${placeMarks.reversed.last.postalCode ?? ''}';
        address += ', ${placeMarks.reversed.last.country ?? ''}';
      }
      return address;
    } catch (e) {
      logger.e('GetAddress: Error while getting address', error: e);
    }
    return '';
  }
}
