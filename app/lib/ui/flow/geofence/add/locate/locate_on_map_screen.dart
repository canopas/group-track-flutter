import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:style/button/action_button.dart';
import 'package:style/button/icon_primary_button.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:style/text/app_text_dart.dart';
import 'package:style/text/app_text_field.dart';
import 'package:yourspace_flutter/domain/extenstions/api_error_extension.dart';
import 'package:yourspace_flutter/domain/extenstions/context_extenstions.dart';
import 'package:yourspace_flutter/ui/components/app_page.dart';
import 'package:yourspace_flutter/ui/flow/geofence/add/locate/locate_on_map_view_model.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../components/error_snakebar.dart';
import '../../../../components/no_internet_screen.dart';
import '../../../home/map/map_screen.dart';
import '../../../navigation/routes.dart';
import '../components/place_added_dialog.dart';

class LocateOnMapScreen extends ConsumerStatefulWidget {
  final String spaceId;
  final String? placesName;

  const LocateOnMapScreen({super.key, required this.spaceId, this.placesName});

  @override
  ConsumerState<LocateOnMapScreen> createState() => _LocateOnMapViewState();
}

class _LocateOnMapViewState extends ConsumerState<LocateOnMapScreen> {
  late LocateOnMapVieNotifier notifier;
  Timer? _debounceTimer;

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final CameraPosition _cameraPosition =
      const CameraPosition(target: LatLng(0.0, 0.0), zoom: defaultCameraZoom);

  @override
  Widget build(BuildContext context) {
    notifier = ref.watch(locateOnMapViewStateProvider.notifier);
    final state = ref.watch(locateOnMapViewStateProvider);

    _observeError();
    _observeMapCameraPosition();
    _observePopToPlacesListScreen(state.cameraLatLng);

    final enable = state.cameraLatLng != null
        ? state.cameraLatLng != _cameraPosition.target
        : false;

    return AppPage(
      title: context.l10n.locate_on_map_title,
      actions: [
        actionButton(
          context: context,
          padding: const EdgeInsets.only(right: 16),
          progress: state.addingPlace,
          enabled: !state.addingPlace && enable,
          onPressed: () {
            _checkUserInternet(() {
              if (widget.placesName == null) {
                if (state.cameraLatLng != null) {
                  ChoosePlaceNameRoute(
                    spaceId: widget.spaceId,
                    $extra: state.cameraLatLng!,
                  ).push(context);
                }
              } else {
                notifier.onTapAddPlaceBtn(
                  widget.spaceId,
                  widget.placesName ?? '',
                );
              }
            });
          },
          icon: Text(
            widget.placesName != null
                ? context.l10n.common_add
                : context.l10n.common_next,
            style: AppTextStyle.button.copyWith(
              color: enable
                  ? context.colorScheme.primary
                  : context.colorScheme.textDisabled,
            ),
          ),
        )
      ],
      body: _body(state),
    );
  }

  Widget _body(LocateOnMapState state) {
    return Column(
      children: [
        if (widget.placesName != null) _placeDetailView(state),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
                top: 16, bottom: context.mediaQueryPadding.bottom),
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
                  onCameraMove: _onCameraMove,
                ),
              ),
              Center(child: _locateMarkerView()),
              Align(
                alignment: Alignment.bottomRight,
                child: _currentLocationIconView(state),
              )
            ]),
          ),
        ),
      ],
    );
  }

  Widget _placeDetailView(LocateOnMapState state) {
    final address = state.gettingAddress
        ? context.l10n.edit_place_getting_address_text
        : state.address ?? '';
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _placeTextField(),
          const SizedBox(height: 24),
          _placeAddressView(address),
          const SizedBox(height: 8),
          Divider(thickness: 1, height: 1, color: context.colorScheme.outline)
        ],
      ),
    );
  }

  Widget _placeTextField() {
    return Column(
      children: [
        AppTextField(
          controller: TextEditingController(text: widget.placesName),
          enabled: false,
          style: AppTextStyle.subtitle2
              .copyWith(color: context.colorScheme.textPrimary),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(right: 8, bottom: 8),
            child: Icon(
              Icons.bookmark,
              size: 24,
              color: context.colorScheme.textPrimary,
            ),
          ),
          isDense: true,
          contentPadding: const EdgeInsets.all(0),
        ),
      ],
    );
  }

  Widget _placeAddressView(String address) {
    return Row(
      children: [
        Icon(
          Icons.location_on_outlined,
          color: context.colorScheme.textPrimary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            address,
            style: AppTextStyle.subtitle2
                .copyWith(color: context.colorScheme.textPrimary),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        )
      ],
    );
  }

  Widget _currentLocationIconView(LocateOnMapState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: IconPrimaryButton(
        bgColor: context.colorScheme.onPrimary,
        onTap: () async {
          await _controller.future.then((controller) {
            controller
                .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
              target: state.currentLatLng ?? const LatLng(0.0, 0.0),
              zoom: defaultCameraZoom,
            )));
          });
        },
        progress: state.loading,
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

  void _observePopToPlacesListScreen(LatLng? latLng) {
    ref.listen(
        locateOnMapViewStateProvider.select((state) => state.popToPlaceList),
        (_, next) {
      showPlaceAddedDialog(
        context,
        widget.spaceId,
        latLng!.latitude,
        latLng.longitude,
        widget.placesName ?? '',
      );
    });
  }

  void _onMapCreated(GoogleMapController controller) async {
    _controller.complete(controller);
  }

  void _onCameraMove(CameraPosition position) {
    _debounceTimer?.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      notifier.onMapCameraMove(position);
    });
  }

  void _observeError() {
    ref.listen(locateOnMapViewStateProvider.select((state) => state.error),
        (previous, next) {
      if (next != null) {
        showErrorSnackBar(context, next.l10nMessage(context));
      }
    });
  }

  void _observeMapCameraPosition() {
    ref.listen(
        locateOnMapViewStateProvider.select((state) => state.centerPosition),
        (_, next) async {
      if (next != null) {
        await _controller.future.then((controller) {
          controller.animateCamera(CameraUpdate.newCameraPosition(next));
        });
      }
    });
  }

  void _checkUserInternet(VoidCallback onCallback) async {
    final isNetworkOff = await checkInternetConnectivity();
    isNetworkOff ? _showSnackBar() : onCallback();
  }

  void _showSnackBar() {
    showErrorSnackBar(context, context.l10n.on_internet_error_sub_title);
  }
}
