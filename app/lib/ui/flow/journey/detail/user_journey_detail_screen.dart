import 'dart:ui' as ui;

import 'package:data/api/location/journey/journey.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:style/indicator/progress_indicator.dart';
import 'package:style/text/app_text_dart.dart';
import 'package:yourspace_flutter/domain/extenstions/date_formatter.dart';
import 'package:yourspace_flutter/domain/extenstions/lat_lng_extenstion.dart';
import 'package:yourspace_flutter/ui/components/app_page.dart';
import 'package:yourspace_flutter/ui/flow/journey/components/journey_map.dart';
import 'package:yourspace_flutter/ui/flow/journey/detail/user_journey_detail_view_model.dart';

import '../../../../domain/extenstions/widget_extensions.dart';
import '../../../components/error_snakebar.dart';
import '../components/dotted_line_view.dart';

class UserJourneyDetailScreen extends ConsumerStatefulWidget {
  final ApiLocationJourney journey;

  const UserJourneyDetailScreen({super.key, required this.journey});

  @override
  ConsumerState<UserJourneyDetailScreen> createState() =>
      _UserJourneyDetailScreenState();
}

class _UserJourneyDetailScreenState
    extends ConsumerState<UserJourneyDetailScreen> {
  final List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    runPostFrame(() {
      ref
          .read(userJourneyDetailStateProvider.notifier)
          .loadData(widget.journey);
    });
  }

  @override
  Widget build(BuildContext context) {
    _observeError();
    _observeMapMarker();

    final state = ref.watch(userJourneyDetailStateProvider);
    final title = _formattedAddress(state.addressFrom, state.addressTo);
    return AppPage(title: title, body: _body(state));
  }

  Widget _body(UserJourneyDetailState state) {
    if (state.loading) {
      return const Center(
        child: AppProgressIndicator(),
      );
    }
    return state.journey != null
        ? Column(
            children: [
              Expanded(
                child: JourneyMap(
                  journey: state.journey!,
                  markers: _markers,
                  isTimeLine: false,
                  gestureEnable: true,
                ),
              ),
              _journeyInfo(state)
            ],
          )
        : Container();
  }

  Widget _journeyInfo(UserJourneyDetailState state) {
    final distance = _getDistanceString(state.journey!.route_distance ?? 0.0);
    final duration =
        _getRouteDurationString(state.journey!.route_duration ?? 0);

    return Padding(
      padding: EdgeInsets.only(
        top: 16,
        left: 16,
        right: 16,
        bottom: context.mediaQueryPadding.bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$distance - $duration',
            style: AppTextStyle.subtitle1
                .copyWith(color: context.colorScheme.textDisabled),
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 16),
          _journeyPlacesInfo(
            state.addressFrom,
            state.journey!.created_at,
            false,
          ),
          _journeyPlacesInfo(state.addressTo, state.journey!.update_at, true),
        ],
      ),
    );
  }

  Widget _journeyPlacesInfo(
    List<Placemark> placeMark,
    int? createdAt,
    bool isLastItem,
  ) {
    return SizedBox(
      height: 86,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DottedLineView(isSteadyLocation: !isLastItem, isLastItem: isLastItem),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _placeInfo(placeMark, createdAt),
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
    );
  }

  Widget _placeInfo(List<Placemark> placeMark, int? createdAt) {
    final formattedTime = _getDateAndTime(createdAt ?? 0);
    final address = placeMark.getFormattedAddress();

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

  String _formattedAddress(
    List<Placemark>? fromPlaces,
    List<Placemark>? toPlaces,
  ) {
    if (fromPlaces == null || fromPlaces.isEmpty) return '';
    final fromPlace = fromPlaces.first;
    final toPlace = toPlaces?.first;

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

  String _getDistanceString(double distance) {
    if (distance < 1000) {
      return '${distance.round()} m';
    } else {
      final distanceInKm = distance / 1000;
      return '${distanceInKm.round()} km';
    }
  }

  String _getRouteDurationString(int durationInMilliseconds) {
    final duration = Duration(milliseconds: durationInMilliseconds);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;
    if (hours > 0) {
      return '$hours hr $minutes mins';
    } else if (minutes > 0) {
      return '$minutes mins';
    } else {
      return '$seconds sec';
    }
  }

  String _getDateAndTime(int createdAt) {
    DateTime createdAtDate = DateTime.fromMillisecondsSinceEpoch(createdAt);
    return createdAtDate.format(context, DateFormatType.dayTime);
  }

  void _observeError() {
    ref.listen(userJourneyDetailStateProvider.select((state) => state.error),
        (_, next) {
      if (next != null) {
        showErrorSnackBar(context, next.toString());
      }
    });
  }

  void _observeMapMarker() {
    ref.listen(userJourneyDetailStateProvider.select((state) => state.journey),
        (_, next) async {
      if (next != null) {
        final fromLatLng = LatLng(next.from_latitude, next.from_longitude);
        final toLatLng =
            LatLng(next.to_latitude ?? 0.0, next.to_longitude ?? 0.0);
        final markers = await _buildMarkers(fromLatLng, toLatLng);
        setState(() {
          _markers.addAll(markers);
        });
      }
    });
  }

  Future<List<Marker>> _buildMarkers(LatLng fromLatLng, LatLng toLatLng) async {
    final fromIcon = await _createCustomIcon(
        'assets/images/ic_location_detail_start_icon.png');
    final toIcon = await _createCustomIcon(
        'assets/images/ic_location_detail_end_icon.png');

    final List<Marker> markers = [
      Marker(
        markerId: const MarkerId('fromLocation'),
        position: fromLatLng,
        anchor: const Offset(0.5, 0.5),
        consumeTapEvents: true,
        icon: fromIcon,
      ),
      Marker(
        markerId: const MarkerId('toLocation'),
        anchor: const Offset(0.5, 0.5),
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
      targetWidth: 200,
      targetHeight: 200,
    );
    final frameInfo = await codec.getNextFrame();

    final byteData =
        await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);
    final resizedBytes = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(resizedBytes);
  }
}
