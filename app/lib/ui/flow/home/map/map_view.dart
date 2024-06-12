import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:data/api/space/space_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:style/extenstions/context_extenstions.dart';

import 'components/space_user_footer.dart';
import 'map_view_model.dart';

const defaultCameraZoom = 15;
const defaultCameraZoomForSelectedUser = 17;
const markerSize = 100.0;

class MapView extends ConsumerStatefulWidget {
  final SpaceInfo? space;

  const MapView({super.key, this.space});

  @override
  ConsumerState<MapView> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapView> {
  late MapViewNotifier notifier;
  final Completer<GoogleMapController> _controller = Completer();
  final _center = const LatLng(21.2300467, 72.8359667);
  List<Marker> _markers = [];

  @override
  Widget build(BuildContext context) {
    _observeMarkerChange();

    notifier = ref.watch(mapViewStateProvider.notifier);
    final state = ref.watch(mapViewStateProvider);

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
            markers: _markers.toSet(),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: SpaceUserFooter(
            members: state.userInfo,
            selectedUser: state.selectedUser,
            isEnabled: !state.loading,
            onAddMemberTap: () =>
                notifier.onAddMemberTap(widget.space!.space.id),
            onMemberTap: (member) {
              notifier.showMemberDetail(member);
            },
            onRelocateTap: () {},
            onPlacesTap: () {},
            onDismiss: () => notifier.onDismissMemberDetail(),
            onTapTimeline: () {},
          ),
        ),
      ],
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    _controller.complete(controller);
  }

  void _observeMarkerChange() {
    ref.listen(mapViewStateProvider.select((state) => state.markers),
        (_, next) {
      if (next.isNotEmpty) {
        for (final item in next) {
          _buildMarkerIcon(item);
        }
      } else {
        setState(() {
          _markers = [];
        });
      }
    });
  }

  void _buildMarkerIcon(UserMarker item) async {
    final marker = await _customMarker(
      item.isSelected,
      item.userName,
      item.imageUrl,
      item.isSelected
          ? context.colorScheme.secondary
          : context.colorScheme.surface,
      context.colorScheme.primary,
    );

    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(item.userId),
          position: LatLng(item.latitude, item.longitude),
          anchor: const Offset(0.0, 1.0),
          icon: marker,
        ),
      );
    });
  }

  Future<BitmapDescriptor> _customMarker(
    bool isSelected,
    String userName,
    String? imageUrl,
    Color markerBgColor,
    Color iconBgColor,
  ) async {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return await _userImageMarker(
          userName, imageUrl, isSelected, markerBgColor, iconBgColor);
    } else {
      return await _userCharMarker(
          isSelected, userName, imageUrl, markerBgColor, iconBgColor);
    }
  }

  Future<BitmapDescriptor> _userCharMarker(
    bool isSelected,
    String userName,
    String? imageUrl,
    Color markerBgColor,
    Color iconBgColor,
  ) async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);

    // Draw background rectangle
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        const Rect.fromLTWH(0.0, 0.0, markerSize, markerSize),
        topLeft: const Radius.circular(40),
        topRight: const Radius.circular(40),
        bottomLeft: const Radius.circular(0),
        bottomRight: const Radius.circular(40),
      ),
      Paint()..color = markerBgColor,
    );

    _drawUserName(canvas, userName, markerSize, iconBgColor);

    final picture = pictureRecorder.endRecording();
    final img = await picture.toImage(markerSize.toInt(), markerSize.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    final bitmapDescriptor =
        BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());

    return bitmapDescriptor;
  }

  void _drawUserName(
      Canvas canvas, String userName, double size, Color bgColor) {
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    canvas.drawCircle(
      Offset(size / 2, size / 2),
      40,
      Paint()..color = bgColor,
    );

    textPainter.text = TextSpan(
      text: userName.isNotEmpty ? userName[0] : '',
      style: const TextStyle(fontSize: 50, color: Colors.white),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (size - textPainter.width) / 2,
        (size - textPainter.height) / 2,
      ),
    );
  }

  Future<BitmapDescriptor> _userImageMarker(
    String userName,
    String imageUrl,
    bool isSelected,
    Color markerBgColor,
    Color iconBgColor,
  ) async {
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      final image = img.decodeImage(bytes)!;
      final resizedImage = img.copyResize(image, width: 80, height: 80);

      // Create a circular image
      final circularImage = img.copyCropCircle(resizedImage);

      final byteData = ByteData.view(
        Uint8List.fromList(img.encodePng(circularImage)).buffer,
      );

      // Create an Image from the ByteData
      final codec =
          await ui.instantiateImageCodec(byteData.buffer.asUint8List());
      final frame = await codec.getNextFrame();
      final uiImage = frame.image;

      // Prepare the canvas to draw the rounded rectangle and the image
      final recorder = ui.PictureRecorder();
      final canvas = ui.Canvas(
          recorder,
          Rect.fromPoints(
              const Offset(0, 0), const Offset(markerSize, markerSize)));

      // Draw the rounded rectangle
      canvas.drawRRect(
        RRect.fromRectAndCorners(
          const Rect.fromLTWH(0.0, 0.0, markerSize, markerSize),
          topLeft: const Radius.circular(40),
          topRight: const Radius.circular(40),
          bottomLeft: const Radius.circular(0),
          bottomRight: const Radius.circular(40),
        ),
        Paint()..color = markerBgColor,
      );

      // Calculate the position to center the image
      final double imageOffset = (markerSize - uiImage.width.toDouble()) / 2;
      final Offset offset = Offset(imageOffset, imageOffset);

      // Draw the image on the canvas centered
      canvas.drawImage(uiImage, offset, Paint()..color = iconBgColor);

      // End recording and create an image from the canvas
      final picture = recorder.endRecording();
      final imgData =
          await picture.toImage(markerSize.toInt(), markerSize.toInt());
      final data = await imgData.toByteData(format: ui.ImageByteFormat.png);

      final bitmapDescriptor =
          BitmapDescriptor.fromBytes(data!.buffer.asUint8List());

      return bitmapDescriptor;
    } else {
      return _userCharMarker(
          isSelected, userName, imageUrl, markerBgColor, iconBgColor);
    }
  }
}
