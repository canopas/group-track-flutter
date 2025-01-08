import 'dart:ui' as ui;

import 'package:data/api/space/space_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:style/animation/on_tap_scale.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:style/text/app_text_dart.dart';
import 'package:yourspace_flutter/domain/extenstions/api_error_extension.dart';
import 'package:yourspace_flutter/domain/extenstions/context_extenstions.dart';
import 'package:yourspace_flutter/ui/components/error_snakebar.dart';
import 'package:yourspace_flutter/ui/flow/navigation/routes.dart';

import '../../../../gen/assets.gen.dart';
import '../../../components/action_bottom_sheet.dart';
import '../../../components/permission_dialog.dart';
import '../../../components/resume_detector.dart';
import '../../permission/enable_permission_view_model.dart';
import 'components/marker_generator.dart';
import 'components/space_user_footer.dart';
import 'map_view_model.dart';

const defaultCameraZoom = 15.0;
const defaultCameraZoomForSelectedUser = 17.0;

const placeSize = 80.0;

class MapScreen extends ConsumerStatefulWidget {
  final SpaceInfo? space;

  const MapScreen({super.key, this.space});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  late MapViewNotifier notifier;

  String? _mapStyle;
  bool _isDarkMode = false;

  final List<Marker> _markers = [];
  List<Circle> _places = [];

  @override
  Widget build(BuildContext context) {
    _observeNavigation();
    _observeMarkerChange();
    _observeShowEnableLocationPrompt(context);
    _observeMemberPlace(context);
    _observePermissionChange();
    _observeError();

    notifier = ref.watch(mapViewStateProvider.notifier);
    final state = ref.watch(mapViewStateProvider);

    _updateMapStyle(context.brightness == Brightness.dark);
    return ResumeDetector(
      onResume: () {
        notifier.checkUserPermission();
      },
      child: Stack(
        children: [
          Center(
            child: GoogleMap(
              onMapCreated: (controller) {
                notifier.onMapCreated(controller);
              },
              initialCameraPosition: state.defaultPosition,
              style: _mapStyle,
              compassEnabled: false,
              zoomControlsEnabled: false,
              tiltGesturesEnabled: false,
              myLocationButtonEnabled: false,
              mapToolbarEnabled: false,
              buildingsEnabled: false,
              circles: _places.toSet(),
              markers: _markers.toSet(),
              mapType: notifier.getMapTypeInfo().mapType,
            ),
          ),
          Positioned(
              bottom: 0, left: 0, right: 0, child: _bottomFooters(state)),
        ],
      ),
    );
  }

  Widget _bottomFooters(MapViewState state) {
    final enabled = !state.hasLocationEnabled ||
        !state.hasLocationServiceEnabled ||
        !state.hasNotificationEnabled;

    return Column(
      children: [
        SpaceUserFooter(
          selectedSpace: widget.space,
          members: state.userInfos.values.toList(),
          selectedUser: state.userInfos[state.selectedUser?.id],
          isEnabled: !state.loading,
          fetchingInviteCode: state.fetchingInviteCode,
          isCurrentUser: notifier.isCurrentUser(),
          onAddMemberTap: () {
            if (widget.space != null) {
              notifier.onAddMemberTap(widget.space!.space.id);
            }
          },
          onMemberTap: (member) {
            notifier.showMemberDetail(member);
          },
          onRelocateTap: () => notifier.relocateCameraPosition(),
          onMapTypeTap: () => _openMapTypeSheet(context),
          onPlacesTap: () {
            final space = widget.space;
            if (space != null) {
              PlacesListRoute(spaceId: space.space.id).push(context);
            }
          },
          onDismiss: () => notifier.onDismissMemberDetail(),
          currentUserLocation:
              state.currentUserLocation ?? const LatLng(0.0, 0.0),
        ),
        Visibility(visible: enabled, child: _permissionFooter(state))
      ],
    );
  }

  Widget _permissionFooter(MapViewState state) {
    final locationEnabled =
        state.hasLocationEnabled ? state.hasLocationServiceEnabled : true;
    final (title, subTitle) = _permissionFooterContent(state);

    return OnTapScale(
      onTap: () {
        (!locationEnabled)
            ? notifier.showEnableLocationDialog()
            : EnablePermissionRoute().push(context);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        color: !locationEnabled
            ? context.colorScheme.alert
            : context.colorScheme.secondary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyle.body2.copyWith(
                      color: context.colorScheme.textInversePrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subTitle,
                    style: AppTextStyle.caption.copyWith(
                      color: context.colorScheme.textInverseDisabled,
                    ),
                  )
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: context.colorScheme.textInversePrimary,
            )
          ],
        ),
      ),
    );
  }

  (String, String) _permissionFooterContent(MapViewState state) {
    final locationEnabled =
        state.hasLocationEnabled ? state.hasLocationServiceEnabled : true;

    String title = '';
    String subTitle = '';

    if (!state.hasLocationEnabled) {
      title = context.l10n.permission_footer_missing_location_permission_title;
    } else if (!state.hasNotificationEnabled) {
      title = context.l10n.permission_footer_title;
    } else {
      title = context.l10n.permission_footer_missing_location_permission_title;
    }

    if (!locationEnabled) {
      subTitle = context.l10n.permission_footer_location_off_subtitle;
    } else if (!state.hasFineLocationEnabled) {
      subTitle = context.l10n.permission_footer_subtitle;
    } else {
      subTitle =
          context.l10n.permission_footer_missing_location_permission_subtitle;
    }

    return (title, subTitle);
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

  void _openMapTypeSheet(BuildContext context) {
    showActionBottomSheet(
      context: context,
      showHorizontal: true,
      selectedIndex: notifier.getMapTypeInfo().index,
      items: [
        BottomSheetAction(
          title: context.l10n.home_map_style_type_app_theme_text,
          icon: Image.asset(Assets.images.icNormalMap.path),
          onTap: () {
            notifier
                .setMapType(context.l10n.home_map_selected_type_normal_text);
          },
        ),
        BottomSheetAction(
          title: context.l10n.home_map_selected_type_terrain_text,
          icon: Image.asset(Assets.images.icTerrainMap.path),
          onTap: () {
            notifier
                .setMapType(context.l10n.home_map_selected_type_terrain_text);
          },
        ),
        BottomSheetAction(
          title: context.l10n.home_map_selected_type_satellite_text,
          icon: Image.asset(Assets.images.icSatelliteMap.path),
          onTap: () {
            notifier
                .setMapType(context.l10n.home_map_selected_type_satellite_text);
          },
        ),
      ],
    );
  }

  void _observeNavigation() {
    ref.listen(
        mapViewStateProvider.select((state) => state.spaceInvitationCode),
        (_, next) {
      if (next.isNotEmpty) {
        InviteCodeRoute(InviteCodeRouteData(inviteCode: next, spaceName: ''))
            .push(context);
      }
    });
  }

  void _observeShowEnableLocationPrompt(BuildContext context) {
    ref.listen(mapViewStateProvider.select((state) => state.showLocationDialog),
        (_, next) {
      if (next != null) {
        showDialog(
          context: context,
          builder: (context) {
            return PermissionDialog(
              title: context.l10n.enable_location_service_title,
              subTitle1: context.l10n.enable_location_service_message,
              onDismiss: () {},
              goToSettings: () {
                openAppSettings();
                context.pop();
              },
            );
          },
        );
      }
    });
  }

  void _observePermissionChange() {
    ref.listen(
        permissionStateProvider.select((state) => state.isLocationGranted),
        (previous, next) {
      if (previous != next && next) {
        notifier.fetchCurrentUserLocation();
      }
    });
  }

  void _observeMarkerChange() {
    ref.listen(mapViewStateProvider.select((state) => state.userInfos),
        (previous, next) async {
      if (previous?.length != next.length) {
        _clearNonPlaceMarkers();
      }
      if (next.isNotEmpty) {
        final markersToAdd = await createMarkerFromAsset(
            context, next.values.toList(), onTap: (userId) {
          notifier.onTapUserMarker(userId);
        });
        _markers.addAll(markersToAdd);
        setState(() {});
      }
    });
  }

  void _observeMemberPlace(BuildContext context) {
    ref.listen(mapViewStateProvider.select((state) => state.places),
        (previous, next) {
      if (previous?.length != next.length) {
        _clearPlacesAndPlaceMarkers();
      }

      if (next.isNotEmpty) {
        for (final place in next) {
          final latLng = LatLng(place.latitude, place.longitude);

          _generatePlaceMarker(place.id, latLng);

          _places.add(Circle(
            circleId: CircleId(place.id),
            fillColor:
                context.colorScheme.primary.withAlpha((0.4 * 255).toInt()),
            strokeColor:
                context.colorScheme.primary.withAlpha((0.6 * 255).toInt()),
            strokeWidth: 1,
            center: latLng,
            radius: place.radius,
          ));
        }
        setState(() {});
      }
    });
  }

  void _generatePlaceMarker(String id, LatLng latLng) async {
    final icon = await BitmapDescriptor.asset(
        const ImageConfiguration(size: ui.Size(placeSize, placeSize)),
        'assets/images/ic_place_marker_icon.png');

    _markers.add(
      Marker(
        markerId: MarkerId("place_$id"),
        position: latLng,
        anchor: const Offset(0.5, 0.5),
        zIndex: 1,
        icon: icon,
      ),
    );
  }

  void _clearPlacesAndPlaceMarkers() {
    setState(() {
      _places = [];
      _markers
          .removeWhere((marker) => marker.markerId.value.startsWith('place'));
    });
  }

  void _clearNonPlaceMarkers() {
    setState(() {
      _markers
          .removeWhere((marker) => !marker.markerId.value.startsWith('place'));
    });
  }

  void _observeError() {
    ref.listen(mapViewStateProvider.select((state) => state.error),
        (previous, next) {
      if (next != null) {
        showErrorSnackBar(context, next.l10nMessage(context));
      }
    });
  }
}
