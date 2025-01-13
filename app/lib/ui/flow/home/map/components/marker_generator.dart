import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:style/text/app_text_dart.dart';
import 'package:yourspace_flutter/ui/flow/home/map/map_view_model.dart';

double markerSize = Platform.isAndroid ? 124.0 : 70.0;
double markerRadius = Platform.isAndroid ? 60.0 : 30.0;

Future<List<Marker>> createMarkerFromAsset(
  BuildContext context,
  List<MapUserInfo> users,
  Color markerColor, {
  required Function(String)? onTap,
}) async {
  if (!context.mounted) return [];
  final markers = await Future.wait(users.map((item) async {
    final marker = await _mapMarker(
      context,
      item.user.fullName,
      item.imageUrl,
      item.isSelected ? context.colorScheme.primary : markerColor,
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
  BuildContext context,
  String userName,
  String? imageUrl,
  Color markerBgColor,
  Color iconBgColor,
  TextStyle textStyle,
) async {
  if (imageUrl != null && imageUrl.isNotEmpty) {
    return await _userImageMarker(
        context, imageUrl, markerBgColor, iconBgColor);
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
  return BitmapDescriptor.bytes(byteData!.buffer.asUint8List(),
      bitmapScaling: MapBitmapScaling.none);
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
  BuildContext context,
  String path,
  Color markerBgColor,
  Color iconBgColor,
) async {
  final imageInfo = await getImageInfoFromUrl(context, path);
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);

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
  //
  final center = Offset(markerSize / 2, markerSize / 2);
  final double imageOffset =
      (markerSize - imageInfo.image.width.toDouble()) / 2;
  final Offset offset = Offset(imageOffset, imageOffset);

  final Path circlePath = Path()
    ..addOval(Rect.fromCircle(center: center, radius: 48));
  canvas.clipPath(circlePath);
  canvas.drawImage(imageInfo.image, offset, Paint()..color = iconBgColor);

  final picture = recorder.endRecording();
  final img = await picture.toImage(markerSize.toInt(), markerSize.toInt());
  final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
  return BitmapDescriptor.bytes(byteData!.buffer.asUint8List(),
      bitmapScaling: MapBitmapScaling.none);
}

Future<ImageInfo> getImageInfoFromUrl(
    BuildContext context, String imageUrl) async {
  NetworkImage networkImage = NetworkImage(imageUrl);
  ImageStream stream =
      networkImage.resolve(createLocalImageConfiguration(context));
  Completer<ImageInfo> completer = Completer();
  stream.addListener(ImageStreamListener((ImageInfo imageInfo, _) {
    return completer.complete(imageInfo);
  }));
  return completer.future;
}
