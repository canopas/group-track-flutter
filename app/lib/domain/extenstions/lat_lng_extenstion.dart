import 'package:data/log/logger.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

extension LatLngExtensions on LatLng {
  static String? _cachedAddress;
  static LatLng? _cachedLatLng;

  Future<String> getAddressFromLocation() async {
    if (_cachedLatLng != null &&
        _cachedLatLng!.latitude == latitude &&
        _cachedLatLng!.longitude == longitude &&
        _cachedAddress != null) {
      return _cachedAddress!;
    }

    try {
      if (latitude < 1.0 && longitude < 1.0) return '';
      final placeMarks = await placemarkFromCoordinates(latitude, longitude)
          .timeout(const Duration(seconds: 5), onTimeout: () {
        logger.e('GetAddress: Geocoding request timed out');
        return [];
      });
      if (placeMarks.isNotEmpty) {
        var address = placeMarks.getFormattedAddress();

        _cachedLatLng = LatLng(latitude, longitude);
        _cachedAddress = address;

        return address;
      }
    } catch (error, stack) {
      logger.e(
        'GetAddress: Error while getting address',
        error: error,
        stackTrace: stack,
      );
    }
    return '';
  }
}

extension PlacemarkExtensions on List<Placemark> {
  String getFormattedAddress() {

    var streets = map((placeMark) => placeMark.street)
        .where((street) => street != null)
        .where(
            (street) => street!.toLowerCase() != last.locality?.toLowerCase())
        .where((street) => !street!.contains('+'))
        .map((street) => street!)
        .join(',');

    final lastPlaceMark = last;

    List<String> addressParts = [
      streets,
      lastPlaceMark.subLocality ?? '',
      lastPlaceMark.locality ?? '',
      lastPlaceMark.subAdministrativeArea != null &&
          lastPlaceMark.subAdministrativeArea!.toLowerCase() !=
              lastPlaceMark.locality?.toLowerCase()
          ? lastPlaceMark.subAdministrativeArea!
          : '',
      lastPlaceMark.administrativeArea ?? '',
      lastPlaceMark.postalCode ?? '',
      lastPlaceMark.country ?? '',
    ];

    return formatAddress(addressParts);
  }
}

String formatAddress(List<String> parts) {
  return parts.where((part) => part.isNotEmpty).join(', ');
}
