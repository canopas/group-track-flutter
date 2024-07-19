import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:style/animation/on_tap_scale.dart';
import 'package:style/button/icon_primary_button.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:style/text/app_text_dart.dart';
import 'package:yourspace_flutter/domain/extenstions/context_extenstions.dart';
import 'package:yourspace_flutter/ui/app_route.dart';
import 'package:yourspace_flutter/ui/components/app_page.dart';
import 'package:yourspace_flutter/ui/flow/geofence/add/locate/locate_on_map_view_model.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../home/map/map_screen.dart';

class LocateOnMapScreen extends ConsumerStatefulWidget {
  final String spaceId;

  const LocateOnMapScreen({super.key, required this.spaceId});

  @override
  ConsumerState<LocateOnMapScreen> createState() => _LocateOnMapViewState();
}

class _LocateOnMapViewState extends ConsumerState<LocateOnMapScreen> {
  late LocateOnMapVieNotifier notifier;
  GoogleMapController? _controller;
  final CameraPosition _cameraPosition =
      const CameraPosition(target: LatLng(0.0, 0.0), zoom: defaultCameraZoom);

  @override
  Widget build(BuildContext context) {
    _observeMapCameraPosition();

    notifier = ref.watch(locateOnMapViewStateProvider.notifier);
    final state = ref.watch(locateOnMapViewStateProvider);
    final centerPosition = state.centerPosition;
    final enable = centerPosition != null
        ? centerPosition.target != _cameraPosition.target
        : false;

    return AppPage(
      title: context.l10n.locate_on_map_title,
      actions: [
        OnTapScale(
          enabled: enable,
          onTap: () {
            if (centerPosition != null) {
              AppRoute.choosePlaceName(centerPosition.target, widget.spaceId)
                  .push(context);
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              context.l10n.common_next,
              style: AppTextStyle.button.copyWith(
                color: enable
                    ? context.colorScheme.primary
                    : context.colorScheme.textDisabled,
              ),
            ),
          ),
        )
      ],
      body: _body(state),
    );
  }

  Widget _body(LocateOnMapState state) {
    return Padding(
      padding:
          EdgeInsets.only(top: 16, bottom: context.mediaQueryPadding.bottom),
      child: Stack(children: [
        Center(
          child: GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: _cameraPosition,
            compassEnabled: false,
            zoomControlsEnabled: false,
            tiltGesturesEnabled: false,
            myLocationButtonEnabled: false,
            mapToolbarEnabled: false,
            buildingsEnabled: false,
          ),
        ),
        Center(child: _locateMarkerView()),
        Align(
          alignment: Alignment.bottomRight,
          child: _currentLocationIconView(state),
        )
      ]),
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

  Widget _currentLocationIconView(LocateOnMapState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: IconPrimaryButton(
        bgColor: context.colorScheme.onPrimary,
        onTap: () async {
          await _controller
              ?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: state.currentLatLng ?? const LatLng(0.0, 0.0),
            zoom: defaultCameraZoom,
          )));
        },
        icon: SvgPicture.asset(
          Assets.images.icRelocateIcon,
          colorFilter: ColorFilter.mode(
            context.colorScheme.primary,
            BlendMode.srcATop,
          ),
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    _controller = controller;
  }

  void _observeMapCameraPosition() {
    ref.listen(
        locateOnMapViewStateProvider.select((state) => state.centerPosition),
        (_, next) async {
      if (next != null) {
        await _controller?.animateCamera(CameraUpdate.newCameraPosition(next));
      }
    });
  }
}
