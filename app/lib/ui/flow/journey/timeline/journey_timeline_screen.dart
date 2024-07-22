import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:data/api/auth/auth_models.dart';
import 'package:data/api/location/journey/journey.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:style/animation/on_tap_scale.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:style/indicator/progress_indicator.dart';
import 'package:style/text/app_text_dart.dart';
import 'package:yourspace_flutter/domain/extenstions/context_extenstions.dart';
import 'package:yourspace_flutter/domain/extenstions/date_formatter.dart';
import 'package:yourspace_flutter/domain/extenstions/lat_lng_extenstion.dart';
import 'package:yourspace_flutter/ui/components/app_page.dart';
import 'package:yourspace_flutter/ui/flow/journey/timeline/journey_timeline_view_model.dart';

import '../../../../domain/extenstions/widget_extensions.dart';
import '../../../../gen/assets.gen.dart';
import '../../../components/dashed_divider.dart';

const INITIAL_ZOOM_LEVEL = 6;

class JourneyTimelineScreen extends ConsumerStatefulWidget {
  final ApiUser selectedUser;

  const JourneyTimelineScreen({super.key, required this.selectedUser});

  @override
  ConsumerState<JourneyTimelineScreen> createState() =>
      _JourneyTimelineScreenState();
}

class _JourneyTimelineScreenState extends ConsumerState<JourneyTimelineScreen> {
  late JourneyTimelineViewModel notifier;
  String? _mapStyle;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    runPostFrame(() {
      notifier = ref.read(journeyTimelineStateProvider.notifier);
      notifier.loadData(widget.selectedUser);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(journeyTimelineStateProvider);
    final title = (state.selectedUser == null)
        ? context.l10n.journey_timeline_title
        : (state.isCurrentUser)
            ? context.l10n.journey_timeline_title_your_timeline
            : context.l10n.journey_timeline_title_other_user(
                state.selectedUser?.first_name ?? '');

    final selectedDate = _onSelectDatePickerDate(state.selectedTimeFrom);

    _observeShowDatePicker(state);

    return AppPage(
      title: title,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: OnTapScale(
            onTap: () {
              notifier.showDatePicker(true);
            },
            child: Row(
              children: [
                Text(
                  selectedDate,
                  style: AppTextStyle.body1
                      .copyWith(color: context.colorScheme.textPrimary),
                ),
                const SizedBox(width: 8),
                SvgPicture.asset(
                  Assets.images.icTimelineFilterIcon,
                  colorFilter: ColorFilter.mode(
                    context.colorScheme.textPrimary,
                    BlendMode.srcATop,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
      body: _body(state),
    );
  }

  Widget _body(JourneyTimelineState state) {
    if (state.isLoading) {
      return const Center(child: AppProgressIndicator());
    }
    if (state.sortedJourney.isEmpty) {
      return _emptyHistoryView();
    }

    return ListView.builder(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: context.mediaQueryPadding.bottom,
        ),
        itemCount: state.sortedJourney.length + 1,
        itemBuilder: (_, index) {
          if (index < state.sortedJourney.length) {
            final journey = state.sortedJourney[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                journey.isSteadyLocation()
                    ? _steadyLocationItem(
                        journey,
                        state.sortedJourney.first.id == journey.id,
                        state.sortedJourney.last.id == journey.id,
                      )
                    : _journeyLocationItem(
                        journey,
                        state.sortedJourney.first.id == journey.id,
                        state.sortedJourney.last.id == journey.id,
                      ),
              ],
            );
          } else {
            if (state.hasMore) {
              notifier.loadMoreJourney();
              return const AppProgressIndicator();
            }
          }
          return const SizedBox();
        });
  }

  Widget _emptyHistoryView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(Assets.images.icJourneyEmptyTimelineImage),
          const SizedBox(height: 16),
          Text(
            context.l10n.journey_timeline_empty_screen_text,
            style: AppTextStyle.subtitle3.copyWith(
              color: context.colorScheme.textDisabled,
            ),
          )
        ],
      ),
    );
  }

  Widget _steadyLocationItem(
    ApiLocationJourney journey,
    bool isFirstItem,
    bool isLastItem,
  ) {
    final location = LatLng(journey.from_latitude, journey.from_longitude);
    final formattedTime = (isFirstItem)
        ? _getFormattedLocationTimeForFirstItem(journey.created_at!)
        : _getFormattedLocationTime(journey.created_at!);

    return Padding(
      padding: EdgeInsets.only(top: isFirstItem ? 16 : 0),
      child: SizedBox(
        height: 130,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _dottedTimeline(true, isLastItem),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPlaceInfo(location, formattedTime),
                    const SizedBox(height: 8),
                    _appPlaceButton(),
                    const SizedBox(height: 8),
                    Visibility(
                        visible: !isLastItem,
                        child: Divider(
                          thickness: 1,
                          color: context.colorScheme.outline,
                        )),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _journeyLocationItem(
    ApiLocationJourney journey,
    bool isFirstItem,
    bool isLastItem,
  ) {
    final time = _getFormattedJourneyTime(
        journey.created_at ?? 0, journey.update_at ?? 0);
    final distance = _getDistanceString(journey.route_distance ?? 0.0);
    final fromLatLng = LatLng(journey.from_latitude, journey.from_longitude);
    final toLatLng =
        LatLng(journey.to_latitude ?? 0.0, journey.to_longitude ?? 0.0);

    return SizedBox(
      height: 210,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _dottedTimeline(false, isLastItem),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMovingPlaceInfo(
                    fromLatLng,
                    toLatLng,
                    '$time - $distance',
                  ),
                  const SizedBox(height: 16),
                  FutureBuilder(
                      future: _buildMarkers(fromLatLng, toLatLng),
                      builder: (_, snapshot) {
                        if (snapshot.hasData) {
                          final markers = snapshot.data ?? [];
                          return _googleMap(journey, markers);
                        } else {
                          return _googleMap(journey, []);
                        }
                      })
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _googleMap(ApiLocationJourney journey, List<Marker> markers) {
    final (ployLines, center, zoom) = _onCreateMap(journey);
    final cameraPosition = CameraPosition(target: center, zoom: zoom);

    _updateMapStyle(context.brightness == Brightness.dark);
    return SizedBox(
      height: 125,
      child: OnTapScale(
        onTap: () {},
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: GoogleMap(
            initialCameraPosition: cameraPosition,
            style: _mapStyle,
            compassEnabled: false,
            scrollGesturesEnabled: false,
            zoomControlsEnabled: false,
            zoomGesturesEnabled: false,
            tiltGesturesEnabled: false,
            myLocationButtonEnabled: false,
            mapToolbarEnabled: false,
            markers: markers.toSet(),
            polylines: ployLines.toSet(),
          ),
        ),
      ),
    );
  }

  Widget _dottedTimeline(bool isSteadyLocation, bool isLastItem) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isSteadyLocation
                ? context.colorScheme.containerLowOnSurface
                : context.colorScheme.surface,
            shape: BoxShape.circle,
            border: Border.all(
              color: isSteadyLocation
                  ? Colors.transparent
                  : context.colorScheme.outline,
              width: 1,
            ),
          ),
          child: Center(
            child: isSteadyLocation
                ? SvgPicture.asset(
                    Assets.images.icFeedLocationPin,
                    colorFilter: ColorFilter.mode(
                      context.colorScheme.primary,
                      BlendMode.srcATop,
                    ),
                  )
                : Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: context.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
          ),
        ),
        if (!isLastItem)
          Expanded(
            child: CustomPaint(
              size: const Size(1, double.infinity),
              painter: DashedLineVerticalPainter(
                color: context.colorScheme.textPrimary,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPlaceInfo(LatLng latLng, String formattedTime) {
    return FutureBuilder(
        future: _getAddress(latLng),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            final address = snapshot.data ??
                context.l10n.journey_timeline_unknown_address_text;
            return _placeInfo(address, formattedTime);
          } else {
            return _placeInfo(
              context.l10n.journey_timeline_getting_address_text,
              formattedTime,
            );
          }
        });
  }

  Widget _buildMovingPlaceInfo(
      LatLng fromLatLng, LatLng toLatLng, String formattedTime) {
    return FutureBuilder(
        future: _getMovingJourneyAddress(fromLatLng, toLatLng),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            final address = snapshot.data ??
                context.l10n.journey_timeline_unknown_address_text;
            return _placeInfo(address, formattedTime);
          } else {
            return _placeInfo(
              context.l10n.journey_timeline_getting_address_text,
              formattedTime,
            );
          }
        });
  }

  Widget _placeInfo(String address, String formattedTime) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          address,
          style: AppTextStyle.body2
              .copyWith(color: context.colorScheme.textPrimary),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Text(
          formattedTime,
          style: AppTextStyle.caption
              .copyWith(color: context.colorScheme.textDisabled),
        ),
      ],
    );
  }

  Widget _appPlaceButton() {
    return Container(
      width: 136,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: context.colorScheme.containerLow),
      child: Row(
        children: [
          SvgPicture.asset(
            Assets.images.icGeofenceIcon,
            colorFilter: ColorFilter.mode(
                context.colorScheme.primary, BlendMode.srcATop),
          ),
          const SizedBox(width: 8),
          Text(
            context.l10n.journey_timeline_add_place_btn_text,
            style: AppTextStyle.button.copyWith(
              color: context.colorScheme.primary,
            ),
          )
        ],
      ),
    );
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

  String _getFormattedLocationTimeForFirstItem(int createdAt) {
    DateTime createdAtDate = DateTime.fromMillisecondsSinceEpoch(createdAt);

    if (createdAtDate.isToday) {
      final dataFormat = DateFormat('hh:mm a');
      return context.l10n
          .journey_timeline_Since_text(dataFormat.format(createdAtDate));
    } else {
      final dataFormat = DateFormat('dd MMMM hh:mm a');
      return context.l10n
          .journey_timeline_Since_text(dataFormat.format(createdAtDate));
    }
  }

  Future<String> _getAddress(LatLng latLng) async {
    final address = await latLng.getAddressFromLocation();
    return address;
  }

  String _getFormattedJourneyTime(int startAt, int endAt) {
    DateTime startAtDate = DateTime.fromMillisecondsSinceEpoch(startAt);
    DateTime endAtDate = DateTime.fromMillisecondsSinceEpoch(endAt);

    final inputFormat = DateFormat('hh:mm a');
    final dateFormat = DateFormat('d MMMM');

    final formattedStartDate = dateFormat.format(startAtDate);
    final formattedEndDate = dateFormat.format(endAtDate);

    if (formattedStartDate == formattedEndDate) {
      return '${_getFormattedLocationTime(startAt)} - ${inputFormat.format(endAtDate)}';
    } else {
      return '${_getFormattedLocationTime(startAt)} - ${_getFormattedLocationTime(endAt)}';
    }
  }

  String _getFormattedLocationTime(int createdAt) {
    DateTime createdAtDate = DateTime.fromMillisecondsSinceEpoch(createdAt);

    if (createdAtDate.isToday) {
      final dataFormat = DateFormat('hh:mm a');
      return context.l10n
          .journey_timeline_today_text(dataFormat.format(createdAtDate));
    } else {
      final dataFormat = DateFormat('dd MMMM hh:mm a');
      return dataFormat.format(createdAtDate);
    }
  }

  String _getDistanceString(double distance) {
    if (distance < 1000) {
      return '${distance.round()} m';
    } else {
      final distanceInKm = distance / 1000;
      return '${distanceInKm.round()} km';
    }
  }

  Future<String> _getMovingJourneyAddress(
      LatLng fromLatLng, LatLng toLatLng) async {
    final fromPlaceMarks = await placemarkFromCoordinates(
        fromLatLng.latitude, fromLatLng.longitude);
    final toPlaceMarks =
        await placemarkFromCoordinates(toLatLng.latitude, toLatLng.longitude);

    return _formattedAddress(fromPlaceMarks.first, toPlaceMarks.first);
  }

  String _formattedAddress(Placemark fromPlace, Placemark? toPlace) {
    final fromCity = fromPlace.locality ?? '';
    final toCity = toPlace?.locality ?? '';

    final fromArea = fromPlace.subLocality ?? '';
    final toArea = toPlace?.subLocality ?? '';

    final fromState = fromPlace.administrativeArea ?? '';
    final toState = toPlace?.administrativeArea ?? '';

    if (toPlace == null) {
      return "$fromArea, $fromCity";
    } else if (fromArea == toArea) {
      return "$fromArea, $fromCity";
    } else if (fromCity == toCity) {
      return "$fromArea to $toArea, $fromCity";
    } else if (fromState == toState) {
      return "$fromArea, $fromCity to $toArea, $toCity";
    } else {
      return "$fromCity, $fromState to $toCity, $toState";
    }
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

    polyline.add(Polyline(
      polylineId: PolylineId(journey.id!),
      color: context.colorScheme.primary,
      points: latLngList,
      patterns: [PatternItem.dash(20.0), PatternItem.gap(8)],
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

  Future<List<Marker>> _buildMarkers(LatLng fromLatLng, LatLng toLatLng) async {
    final fromIcon =
        await _createCustomIcon('assets/images/ic_feed_location_icon.png');
    final toIcon =
        await _createCustomIcon('assets/images/ic_distance_icon.png');

    final List<Marker> markers = [
      Marker(
        markerId: const MarkerId('fromLocation'),
        position: fromLatLng,
        consumeTapEvents: true,
        icon: fromIcon,
      ),
      Marker(
        markerId: const MarkerId('toLocation'),
        anchor: const Offset(0.0, 1.0),
        position: toLatLng,
        consumeTapEvents: true,
        icon: toIcon,
      ),
    ];

    return markers;
  }

  Future<BitmapDescriptor> _createCustomIcon(String assetPath) async {
    final data = await rootBundle.load(assetPath);
    final codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: 38,
      targetHeight: 54,
    );
    final frameInfo = await codec.getNextFrame();

    final byteData =
        await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);
    final resizedBytes = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(resizedBytes);
  }

  String _onSelectDatePickerDate(int? timestamp) {
    if (timestamp == null) return '';
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final date = DateFormat('dd MMMM').format(dateTime);
    return date.toString();
  }

  void _observeShowDatePicker(JourneyTimelineState state) {
    ref.listen(
        journeyTimelineStateProvider.select((state) => state.showDatePicker),
        (_, next) async {
      if (next) {
        final selectedDate =
            state.selectedTimeTo ?? DateTime.now().millisecondsSinceEpoch;
        final dateTime = DateTime.fromMillisecondsSinceEpoch(selectedDate);
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: dateTime,
          firstDate: DateTime(2023),
          lastDate: DateTime.now(),
          confirmText: context.l10n.journey_timeline_date_picker_select_text,
        );
        notifier.showDatePicker(false);
        if (pickedDate != null) {
          notifier.onFilterBySelectedDate(pickedDate);
        }
      }
    });
  }
}
