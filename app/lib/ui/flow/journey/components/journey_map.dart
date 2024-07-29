import 'dart:math' as math;

import 'package:data/api/location/journey/journey.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:yourspace_flutter/ui/app_route.dart';

import '../timeline/journey_timeline_screen.dart';

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
  String? _mapStyle;
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    final (ployLines, center, zoom) = _onCreateMap(widget.journey);
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
            polylines: ployLines.toSet(),
          ),
        ),
      ),
    );
  }

  (List<Polyline>, LatLng, double) _onCreateMap(
    ApiLocationJourney journey,
  ) {
    List<LatLng> latLngList = [];
    List<Polyline> polyline = [];
    final fromLatLng = LatLng(journey.from_latitude, journey.from_longitude);
    final toLatLng = journey.to_latitude != null && journey.to_longitude != null
        ? LatLng(journey.to_latitude!, journey.to_longitude!)
        : null;

    latLngList.add(fromLatLng);
    for (var route in journey.routes) {
      latLngList.add(LatLng(route.latitude, route.longitude));
    }
    if (toLatLng != null) {
      latLngList.add(toLatLng);
    }

    polyline.add(Polyline(
      polylineId: PolylineId(journey.id!),
      color: context.colorScheme.primary,
      points: latLngList,
      patterns: [PatternItem.dash(20.0), PatternItem.gap(2)],
      width: 2,
    ));

    final centerLatLng =
        _getCenterCoordinate(fromLatLng, toLatLng ?? const LatLng(0.0, 0.0));
    final zoom = _calculateZoomLevel(
        journey.route_distance ?? 0, context.mediaQuerySize.width);
    return (polyline, centerLatLng, zoom);
  }

  double _calculateZoomLevel(double distanceInMeters, double mapWidth) {
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
}
