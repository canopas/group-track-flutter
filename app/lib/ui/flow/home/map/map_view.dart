import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const defaultCameraZoom = 15;
const defaultCameraZoomForSelectedUser = 17;

class MapView extends ConsumerStatefulWidget {

  const MapView({super.key});

  @override
  ConsumerState<MapView> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapView> {
  final Completer<GoogleMapController> _controller = Completer();
  final _center = const LatLng(0.0, 0.0);

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(target: _center, zoom: 5.0),
            zoomControlsEnabled: false,
            tiltGesturesEnabled: false,
            myLocationButtonEnabled: false,
            compassEnabled: false,
            mapToolbarEnabled: false,
          ),
        ),
      ],
    );
  }
}
