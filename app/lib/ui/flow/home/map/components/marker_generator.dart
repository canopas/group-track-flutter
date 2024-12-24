import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:style/text/app_text_dart.dart';
import 'package:yourspace_flutter/ui/flow/home/map/map_view_model.dart';

double markerSize = Platform.isAndroid ? 124.0 : 70.0;
double markerRadius = Platform.isAndroid ? 60.0 : 30.0;

Future<List<Marker>> createMarkerFromAsset(
  BuildContext context,
  List<MapUserInfo> users, {
  required Function(String)? onTap,
}) async {
  if (!context.mounted) return [];
  final markers = await Future.wait(users.map((item) async {
    final marker = await _mapMarker(
      item.user.fullName,
      item.imageUrl,
      item.isSelected
          ? context.colorScheme.secondary
          : context.colorScheme.surface,
      context.colorScheme.primary,
      AppTextStyle.subtitle2.copyWith(
          fontSize: Platform.isAndroid ? 70 : 40,
          color: context.colorScheme.textInversePrimary),
    );

    return Marker(
      markerId: MarkerId(item.userId),
      position: LatLng(item.latitude, item.longitude),
      anchor: const Offset(0.0, 1.0),
      icon: marker,
      onTap: () {
        onTap?.call(item.userId);
      },
    );
  }).toList());
  return markers;
}

Future<BitmapDescriptor> _mapMarker(
  String userName,
  ui.Image? imageUrl,
  Color markerBgColor,
  Color iconBgColor,
  TextStyle textStyle,
) async {
  if (imageUrl != null) {
    return await _userImageMarker(imageUrl, markerBgColor, iconBgColor);
  } else {
    return await _userCharMarker(
        userName, markerBgColor, iconBgColor, textStyle);
  }
}

Future<BitmapDescriptor> _userCharMarker(
  String userName,
  Color markerBgColor,
  Color iconBgColor,
  TextStyle textStyle,
) async {
  final pictureRecorder = ui.PictureRecorder();
  final canvas = Canvas(pictureRecorder);

  // Draw background rectangle
  canvas.drawRRect(
    RRect.fromRectAndCorners(
      Rect.fromLTWH(0.0, 0.0, markerSize, markerSize),
      topLeft: Radius.circular(markerRadius),
      topRight: Radius.circular(markerRadius),
      bottomLeft: const Radius.circular(0),
      bottomRight: Radius.circular(markerRadius),
    ),
    Paint()..color = markerBgColor,
  );

  _drawUserName(canvas, userName, iconBgColor, textStyle);

  final picture = pictureRecorder.endRecording();
  final img = await picture.toImage(markerSize.toInt(), markerSize.toInt());
  final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
  final bitmapDescriptor = BitmapDescriptor.bytes(
      byteData!.buffer.asUint8List(),
      bitmapScaling: MapBitmapScaling.none);

  return bitmapDescriptor;
}

void _drawUserName(
  Canvas canvas,
  String userName,
  Color bgColor,
  TextStyle textStyle,
) {
  final textPainter = TextPainter(textDirection: TextDirection.ltr);

  canvas.drawCircle(Offset(markerSize / 2, markerSize / 2),
      Platform.isAndroid ? 50 : 30, Paint()..color = bgColor);

  textPainter.text = TextSpan(
    text: userName.isNotEmpty ? userName[0] : '',
    style: textStyle,
  );
  textPainter.layout();
  textPainter.paint(
    canvas,
    Offset(
      (markerSize - textPainter.width) / 2,
      (markerSize - textPainter.height) / 2,
    ),
  );
}

Future<BitmapDescriptor> _userImageMarker(
  ui.Image uiImage,
  Color markerBgColor,
  Color iconBgColor,
) async {
  // Prepare the canvas to draw the rounded rectangle and the image
  final recorder = ui.PictureRecorder();
  final canvas = ui.Canvas(recorder,
      Rect.fromPoints(const Offset(0, 0), Offset(markerSize, markerSize)));

  // Draw the rounded rectangle
  canvas.drawRRect(
    RRect.fromRectAndCorners(
      Rect.fromLTWH(0.0, 0.0, markerSize, markerSize),
      topLeft: Radius.circular(markerRadius),
      topRight: Radius.circular(markerRadius),
      bottomLeft: const Radius.circular(0),
      bottomRight: Radius.circular(markerRadius),
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
  final imgData = await picture.toImage(markerSize.toInt(), markerSize.toInt());
  final data = await imgData.toByteData(format: ui.ImageByteFormat.png);

  final bitmapDescriptor = BitmapDescriptor.bytes(data!.buffer.asUint8List(),
      bitmapScaling: MapBitmapScaling.none);

  return bitmapDescriptor;
}
