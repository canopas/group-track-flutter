import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:style/button/primary_button.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:style/text/app_text_dart.dart';
import 'package:yourspace_flutter/domain/extenstions/context_extenstions.dart';

import '../../../../../../gen/assets.gen.dart';
import '../../../home/map/map_screen.dart';

void showPlaceAddedDialog(
    BuildContext context,
    double lat,
    double lng,
    String placeName,
    ) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return PlaceAddedDialog(
        lat: lat,
        lng: lng,
        placeName: placeName,
      );
    },
  );
}

class PlaceAddedDialog extends StatefulWidget {
  final double lat;
  final double lng;
  final String placeName;

  const PlaceAddedDialog({
    super.key,
    required this.lat,
    required this.lng,
    required this.placeName,
  });

  @override
  State<PlaceAddedDialog> createState() => _PlaceAddedDialogState();
}

class _PlaceAddedDialogState extends State<PlaceAddedDialog> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 1.77,
              child: _googleMapView(widget.lat, widget.lng),
            ),
            const SizedBox(height: 24),
            Text(
              context.l10n.choose_place_prompt_added_title_text(widget.placeName),
              style: AppTextStyle.header1.copyWith(
                color: context.colorScheme.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 14),
            Text(
              context.l10n.choose_place_prompt_sub_title_text,
              style: AppTextStyle.body1.copyWith(
                color: context.colorScheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              context.l10n.choose_place_prompt_got_it_btn_text,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _googleMapView(double lat, double lng) {
    final cameraPosition =
        CameraPosition(target: LatLng(lat, lng), zoom: defaultCameraZoom);
    return Stack(
      alignment: Alignment.center,
      children: [
        GoogleMap(
          initialCameraPosition: cameraPosition,
          scrollGesturesEnabled: false,
          rotateGesturesEnabled: false,
          compassEnabled: false,
          zoomControlsEnabled: false,
          tiltGesturesEnabled: false,
          myLocationButtonEnabled: false,
          mapToolbarEnabled: false,
        ),
        _locateMarkerView(),
      ],
    );
  }

  Widget _locateMarkerView() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: context.colorScheme.onPrimary,
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: SvgPicture.asset(
          Assets.images.icLocationFeedIcon,
          colorFilter: ColorFilter.mode(
            context.colorScheme.primary,
            BlendMode.srcATop,
          ),
        ),
      ),
    );
  }
}
