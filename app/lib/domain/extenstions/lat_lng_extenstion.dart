import 'package:data/log/logger.dart';
import 'package:data/storage/location_caches.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CachedLocation {
  final LatLng location;
  final String address;

  CachedLocation(this.location, this.address);
}

extension LatLngExtensions on LatLng {
  static const int _maxCacheSize = 100;
  static final Cache<LatLng, String> _cachedLocations =
      Cache<LatLng, String>(_maxCacheSize);
  static const double _locationTolerance = 0.001;

  Future<String> getAddressFromLocation() async {
    final cachedAddress = _getCachedAddress();
    if (cachedAddress != null) return cachedAddress;

    try {
      if (latitude < 1.0 && longitude < 1.0) return '';
      final placeMarks = await placemarkFromCoordinates(latitude, longitude)
          .timeout(const Duration(seconds: 5), onTimeout: () {
        logger.e('GetAddress: Geocoding request timed out');
        return [];
      });
      if (placeMarks.isNotEmpty) {
        var address = placeMarks.getFormattedAddress();
        _cachedLocations.put(LatLng(latitude, longitude), address);
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

  String? _getCachedAddress() {
    for (var entry in _cachedLocations.entries) {
      if (_isLocationClose(entry.key)) {
        return entry.value;
      }
    }
    return null;
  }

  bool _isLocationClose(LatLng cachedLocation) {
    return (latitude - cachedLocation.latitude).abs() < _locationTolerance &&
        (longitude - cachedLocation.longitude).abs() < _locationTolerance;
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
