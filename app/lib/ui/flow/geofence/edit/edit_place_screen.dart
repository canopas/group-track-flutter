import 'dart:math' as math;
import 'dart:math';

import 'package:data/api/auth/auth_models.dart';
import 'package:data/api/place/api_place.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:style/animation/on_tap_scale.dart';
import 'package:style/button/primary_button.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:style/indicator/progress_indicator.dart';
import 'package:style/text/app_text_dart.dart';
import 'package:style/text/app_text_field.dart';
import 'package:yourspace_flutter/domain/extenstions/context_extenstions.dart';
import 'package:yourspace_flutter/ui/components/app_page.dart';
import 'package:yourspace_flutter/ui/components/profile_picture.dart';
import 'package:yourspace_flutter/ui/flow/geofence/edit/edit_place_view_model.dart';
import 'package:yourspace_flutter/ui/flow/setting/profile/profile_view_model.dart';

import '../../../../domain/extenstions/widget_extensions.dart';
import '../../../components/alert.dart';
import '../../../components/error_snakebar.dart';
import '../../../components/no_internet_screen.dart';
import '../add/components/place_marker.dart';

const defaultCameraZoom = 15.5;

class EditPlaceScreen extends ConsumerStatefulWidget {
  final ApiPlace place;

  const EditPlaceScreen({super.key, required this.place});

  @override
  ConsumerState<EditPlaceScreen> createState() => _EditPlaceViewState();
}

class _EditPlaceViewState extends ConsumerState<EditPlaceScreen> {
  late EditPlaceViewNotifier notifier;
  late CameraPosition _cameraPosition;
  GoogleMapController? _controller;
  TextEditingController _textController = TextEditingController();
  double _radiusToPixel = 0.0;
  double _previousZoom = 0.0;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.place.name);
    _cameraPosition = CameraPosition(
        target: LatLng(widget.place.latitude, widget.place.longitude),
        zoom: defaultCameraZoom);

    runPostFrame(() {
      notifier = ref.watch(editPlaceViewStateProvider.notifier);
      notifier.loadData(widget.place);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editPlaceViewStateProvider);
    final latLng = LatLng(state.updatedPlace?.latitude ?? 0.0,
        state.updatedPlace?.longitude ?? 0.0);

    _observeError();
    _observeMapCameraPosition(latLng);
    _observePopBack();
    _observeDeleteDialog();

    return AppPage(
      title: context.l10n.edit_place_title_text,
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: state.saving
              ? const AppProgressIndicator(size: AppProgressIndicatorSize.small)
              : OnTapScale(
                  enabled: state.enableSave,
                  onTap: () {
                    _checkUserInternet(() => notifier.onSavePlace());
                  },
                  child: Text(
                    context.l10n.common_save,
                    style: AppTextStyle.button.copyWith(
                      color: state.enableSave
                          ? context.colorScheme.primary
                          : context.colorScheme.textDisabled,
                    ),
                  ),
                ),
        )
      ],
      body: SafeArea(child: _body(state)),
    );
  }

  Widget _body(EditPlaceState state) {
    if (state.isNetworkOff) {
      return NoInternetScreen(onPressed: () {
        notifier.loadData(widget.place);
      });
    }

    if (state.loading) {
      return const Center(
        child: AppProgressIndicator(
          size: AppProgressIndicatorSize.normal,
        ),
      );
    }

    final place = state.updatedPlace;
    if (place == null) return Container();

    return OrientationBuilder(
      builder: (context, orientation) {
        return Stack(children: [
          ListView(
            children: [
              if (orientation == Orientation.portrait) ...[
                AspectRatio(
                  aspectRatio: 1.85,
                  child: _googleMapView(
                    place.latitude,
                    place.longitude,
                    state.isAdmin,
                    place.radius,
                  ),
                ),
              ] else ...[
                SizedBox(
                  height: 200,
                  child: _googleMapView(
                    place.latitude,
                    place.longitude,
                    state.isAdmin,
                    place.radius,
                  ),
                ),
              ],
              Visibility(
                visible: state.isAdmin,
                child: _radiusSliderView(place.radius),
              ),
              _placeDetailView(place, state),
              const SizedBox(height: 40),
              _placeSettingView(state),
              const SizedBox(height: 100),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _deletePlaceButton(state.isAdmin, state.deleting),
          ),
        ]);
      },
    );
  }

  Widget _googleMapView(double lat, double lng, bool isAdmin, double radius) {
    _convertZoneRadiusToPixels(LatLng(lat, lng), radius * 1.07);
    return Stack(
      alignment: Alignment.center,
      children: [
        GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: _cameraPosition,
          gestureRecognizers: {
            Factory<OneSequenceGestureRecognizer>(
                () => EagerGestureRecognizer())
          },
          scrollGesturesEnabled: isAdmin,
          rotateGesturesEnabled: isAdmin,
          compassEnabled: false,
          zoomControlsEnabled: false,
          tiltGesturesEnabled: false,
          myLocationButtonEnabled: false,
          mapToolbarEnabled: false,
          onCameraMove: (position) {
            notifier.onMapCameraMove(position);
          },
        ),
        IgnorePointer(child: PlaceMarker(radius: _radiusToPixel))
      ],
    );
  }

  Widget _radiusSliderView(double radius) {
    String radiusText;
    if (radius < 1609.34) {
      radiusText = '${radius.round()} m';
    } else {
      final miles = (radius / 1609.34);
      radiusText = miles % 1 == 0.0
          ? '${miles.toInt()} mi'
          : '${miles.toStringAsFixed(1)} mi';
    }

    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Slider(
              value: radius,
              onChanged: notifier.onPlaceRadiusChanged,
              activeColor: context.colorScheme.primary,
              inactiveColor: context.colorScheme.containerLow,
              min: 100,
              max: 3219,
              divisions: 100,
            ),
          ),
          Text(
            radiusText.trim(),
            style: AppTextStyle.caption
                .copyWith(color: context.colorScheme.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _placeDetailView(ApiPlace place, EditPlaceState state) {
    final address = state.gettingAddress
        ? context.l10n.edit_place_getting_address_text
        : state.address ?? '';
    return Padding(
      padding: const EdgeInsets.only(top: 24, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.edit_place_detail_title_text,
            style: AppTextStyle.subtitle1
                .copyWith(color: context.colorScheme.textDisabled),
          ),
          const SizedBox(height: 16),
          _placeTextField(place.name, state.isAdmin),
          const SizedBox(height: 24),
          _placeAddressView(address),
          const SizedBox(height: 8),
          Divider(thickness: 1, height: 1, color: context.colorScheme.outline)
        ],
      ),
    );
  }

  Widget _placeTextField(String placeName, bool isAdmin) {
    return Column(
      children: [
        AppTextField(
          controller: _textController,
          enabled: isAdmin,
          style: AppTextStyle.subtitle2
              .copyWith(color: context.colorScheme.textPrimary),
          onChanged: (value) {
            notifier.onPlaceNameChanged(value.trim());
          },
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
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

  Widget _placeSettingView(EditPlaceState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            widget.place.space_member_ids.length == 1 ? '' : context.l10n.edit_place_get_notified_title_text,
            style: AppTextStyle.subtitle1
                .copyWith(color: context.colorScheme.textDisabled),
          ),
        ),
        const SizedBox(height: 16),
        ...state.membersInfo.map((member) {
          final isLast =
              state.membersInfo.indexOf(member) == state.membersInfo.length - 1;
          return _memberItemView(member, state.updatedSetting, isLast);
        }),
      ],
    );
  }

  Widget _memberItemView(
    ApiUser member,
    ApiPlaceMemberSetting? setting,
    bool isLast,
  ) {
    final user = member;
    final enableArrives = setting?.arrival_alert_for.contains(user.id) ?? false;
    final enableLeaves = setting?.leave_alert_for.contains(user.id) ?? false;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _memberProfileView(user),
              const Spacer(),
              Column(
                children: [
                  _toggleSwitch(
                    title: context.l10n.edit_place_arrives_text,
                    enable: enableArrives,
                    onChanged: (value) {
                      notifier.onToggleArrives(user.id, value);
                    },
                  ),
                  const SizedBox(height: 8),
                  _toggleSwitch(
                    title: context.l10n.edit_place_leaves_text,
                    enable: enableLeaves,
                    onChanged: (value) {
                      notifier.onToggleLeaves(user.id, value);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        Visibility(
          visible: !isLast,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Divider(
                thickness: 1, height: 1, color: context.colorScheme.outline),
          ),
        )
      ],
    );
  }

  Widget _memberProfileView(ApiUser user) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ProfileImage(
            profileImageUrl: user.profile_image!,
            firstLetter: user.firstChar,
            size: 40,
            backgroundColor: context.colorScheme.primary,
          ),
          const SizedBox(width: 16),
          Text(
            user.fullName,
            style: AppTextStyle.subtitle2
                .copyWith(color: context.colorScheme.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _toggleSwitch({
    required String title,
    required bool enable,
    required Function(bool) onChanged,
  }) {
    return Row(
      children: [
        Text(
          title,
          style: AppTextStyle.body2
              .copyWith(color: context.colorScheme.textDisabled),
        ),
        const SizedBox(width: 16),
        Switch(
          value: enable,
          onChanged: onChanged,
          activeTrackColor: context.colorScheme.primary,
          inactiveTrackColor: context.colorScheme.outline,
          inactiveThumbColor: context.colorScheme.textPrimaryDark,
          trackOutlineColor:
              WidgetStatePropertyAll(context.colorScheme.outline),
          trackOutlineWidth: const WidgetStatePropertyAll(0.5),
        )
      ],
    );
  }

  Widget _deletePlaceButton(bool isAdmin, bool isDeleting) {
    return Container(
      color: context.colorScheme.surface,
      padding: const EdgeInsets.only(right: 16, left: 16, top: 16),
      child: Column(
        children: [
          isAdmin
              ? PrimaryButton(
                  progress: isDeleting,
                  context.l10n.edit_place_delete_place_btn_text,
                  background: context.colorScheme.containerLow,
                  foreground: context.colorScheme.alert,
                  onPressed: notifier.onTapDeletePlaceBtn,
                )
              : Text(
                  context.l10n.edit_place_only_admin_edit_text,
                  style: AppTextStyle.body2
                      .copyWith(color: context.colorScheme.textSecondary),
                  textAlign: TextAlign.center,
                )
        ],
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  void _observeError() {
    ref.listen(editProfileViewStateProvider.select((state) => state.error),
        (previous, next) {
      if (next != null) {
        showErrorSnackBar(context, next.toString());
      }
    });
  }

  void _observeMapCameraPosition(LatLng latLng) {
    ref.listen(editPlaceViewStateProvider.select((state) => state.radius),
        (previous, next) async {
      if (next != null) {
        final zoom = _getZoomLevel(next);
        await _controller
            ?.animateCamera(CameraUpdate.newLatLngZoom(latLng, zoom));
      }
    });
  }

  void _observePopBack() {
    ref.listen(editPlaceViewStateProvider.select((state) => state.popToBack),
        (_, next) {
      if (next != null) {
        context.pop();
      }
    });
  }

  double _getZoomLevel(double radius) {
    double scale = radius / 200;
    double zoomLevel = defaultCameraZoom - math.log(scale) / math.log(2);
    return zoomLevel;
  }

  void _convertZoneRadiusToPixels(
    LatLng latLang,
    double radius,
  ) async {
    if (_controller == null) return;
    final zoom = await _controller?.getZoomLevel();
    if (zoom == _previousZoom) return;
    const double earthRadius = 6378100.0;
    double lat1 = radius / earthRadius;
    double lng1 = radius / (earthRadius * cos(pi * latLang.latitude / 180));

    double lat2 = latLang.latitude + lat1 * 180 / pi;
    double lng2 = latLang.longitude + lng1 * 180 / pi;

    final p1 = await _controller
        ?.getScreenCoordinate(LatLng(latLang.latitude, latLang.longitude));
    final p2 = await _controller?.getScreenCoordinate(LatLng(lat2, lng2));

    setState(() {
      _previousZoom = zoom!;
      _radiusToPixel = (p1!.x - p2!.x).abs().toDouble();
    });
  }

  void _observeDeleteDialog() {
    ref.listen(
        editPlaceViewStateProvider.select((state) => state.showDeleteDialog),
        (_, next) {
      if (next != null) {
        showConfirmation(
          context,
          message: context.l10n.edit_place_delete_dialog_sub_title_text,
          confirmBtnText: context.l10n.common_delete,
          cancelButtonText: context.l10n.common_cancel,
          onConfirm: () {
            _checkUserInternet(() => notifier.onPlaceDelete());
          },
        );
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
