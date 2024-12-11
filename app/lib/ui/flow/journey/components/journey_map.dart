import 'dart:math' as math;

import 'package:data/api/location/journey/journey.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:yourspace_flutter/ui/app_route.dart';

const INITIAL_ZOOM_LEVEL = 6;

class JourneyMap extends StatefulWidget {
  final ApiLocationJourney journey;
  final List<Marker> markers;
  final bool isTimeLine;
  final bool gestureEnable;

  const JourneyMap({
    super.key,
    required this.journey,
    required this.markers,
    required this.isTimeLine,
    required this.gestureEnable,
  });

  @override
  State<JourneyMap> createState() => _JourneyMapState();
}

class _JourneyMapState extends State<JourneyMap> {
  GoogleMapController? _controller;
  String? _mapStyle;
  bool _isDarkMode = false;
  final LatLng _fromLatLng = const LatLng(0.0, 0.0);

  @override
  Widget build(BuildContext context) {
    final (ployLines, center, zoom) = _setMapData(widget.journey);
    final cameraPosition = CameraPosition(target: center, zoom: zoom);

    _updateMapStyle(context.brightness == Brightness.dark);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (widget.isTimeLine) {
          AppRoute.journeyDetail(widget.journey).push(context);
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: IgnorePointer(
          ignoring: widget.isTimeLine,
          child: GoogleMap(
            onMapCreated: (controller) {
              _onMapCreate(controller, widget.journey);
            },
            initialCameraPosition: cameraPosition,
            style: _mapStyle,
            compassEnabled: false,
            zoomControlsEnabled: false,
            tiltGesturesEnabled: false,
            myLocationButtonEnabled: false,
            mapToolbarEnabled: false,
            zoomGesturesEnabled: widget.gestureEnable,
            scrollGesturesEnabled: widget.gestureEnable,
            rotateGesturesEnabled: widget.gestureEnable,
            markers: widget.markers.toSet(),
            polylines:ployLines.toSet(),
          ),
        ),
      ),
    );
  }

  void _onMapCreate(
    GoogleMapController controller,
    ApiLocationJourney journey,
  ) async {
    _controller = controller;
    LatLngBounds bounds = _createLatLngBounds(journey.toRoute());
    await _controller?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 20));
  }

  LatLngBounds _createLatLngBounds(List<LatLng> points) {
    double minLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLat = points.first.latitude;
    double maxLng = points.first.longitude;

    for (LatLng point in points) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  (List<Polyline>, LatLng, double) _setMapData(
    ApiLocationJourney journey,
  ) {
    List<Polyline> polyline = [];

    polyline.add(Polyline(
      polylineId: PolylineId(journey.id!),
      color: context.colorScheme.primary,
      points: journey.toRoute(),
      patterns: [PatternItem.dash(20.0), PatternItem.gap(8)],
      width: 3,
    ));

    final longDistanceLatLng = _getLongDistanceCoordinate();
    final centerLatLng = _getCenterCoordinate(_fromLatLng, longDistanceLatLng);
    final zoom = _calculateZoomLevel(_getDistanceString(journey));
    return (polyline, centerLatLng, zoom);
  }

  double _calculateZoomLevel(double distanceInMeters) {
    final mapWidth = context.mediaQuerySize.width;
    const double earthCircumferenceInMeters = 40075016;
    double zoomLevel = math
        .log(earthCircumferenceInMeters * mapWidth / (distanceInMeters * 250));
    return zoomLevel > 10 ? 15 : zoomLevel + INITIAL_ZOOM_LEVEL;
  }

  LatLng _getCenterCoordinate(LatLng startLatLng, LatLng endLatLng) {
    double centerLat = (startLatLng.latitude + endLatLng.latitude) / 2;
    double centerLng = (startLatLng.longitude + endLatLng.longitude) / 2;
    return LatLng(centerLat, centerLng);
  }

  LatLng _getLongDistanceCoordinate() {
    LatLng longCoordinate = _fromLatLng;
    double distance = 0.0;
    for (final route in widget.journey.toRoute()) {
      final routeDistance = _distanceBetween(_fromLatLng, route);
      if (routeDistance > distance) {
        distance = routeDistance;
        longCoordinate = route;
      }
    }
    return longCoordinate;
  }

  double _distanceBetween(LatLng startLocation, LatLng endLocation) {
    return Geolocator.distanceBetween(
      startLocation.latitude,
      startLocation.longitude,
      endLocation.latitude,
      endLocation.longitude,
    );
  }

  void _updateMapStyle(bool isDarkMode) async {
    if (_isDarkMode == isDarkMode) return;
    final style =
        await rootBundle.loadString('assets/map/map_theme_night.json');
    setState(() {
      _isDarkMode = isDarkMode;
      if (isDarkMode) {
        _mapStyle = style;
      } else {
        _mapStyle = null;
      }
    });
  }

  double _getDistanceString(ApiLocationJourney location) {
    final steadyLocation = location.toLocationFromSteadyJourney();
    final movingLocation = location.toLocationFromMovingJourney();

    final routeDistance = steadyLocation.distanceTo(movingLocation);

    if (routeDistance < 1000) {
      return routeDistance.round().ceilToDouble();
    } else {
      final distanceInKm = routeDistance / 1000;
      return distanceInKm.round().ceilToDouble();
    }
  }
}
