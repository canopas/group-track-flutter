import 'package:data/api/location/journey/journey.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:style/indicator/progress_indicator.dart';
import 'package:style/text/app_text_dart.dart';
import 'package:yourspace_flutter/domain/extenstions/context_extenstions.dart';
import 'package:yourspace_flutter/domain/extenstions/date_formatter.dart';
import 'package:yourspace_flutter/domain/extenstions/lat_lng_extenstion.dart';
import 'package:yourspace_flutter/ui/components/app_page.dart';
import 'package:yourspace_flutter/ui/flow/journey/components/journey_map.dart';
import 'package:yourspace_flutter/ui/flow/journey/detail/user_journey_detail_view_model.dart';

import '../../../../domain/extenstions/widget_extensions.dart';
import '../../../components/error_snakebar.dart';
import '../../../components/no_internet_screen.dart';
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
  late UserJourneyDetailViewModel notifier;

  @override
  void initState() {
    super.initState();
    runPostFrame(() {
      notifier = ref.read(userJourneyDetailStateProvider.notifier);
      notifier.loadData(widget.journey);
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
    if (state.isNetworkOff) {
      return NoInternetScreen(onPressed: () {
        notifier.loadData(widget.journey);
      });
    }

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
    final distance =
        notifier.getDistanceString(state.journey!.route_distance ?? 0);
    final duration =
        notifier.getRouteDurationString(state.journey!.route_duration ?? 0);

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
    bool isSteadyLocation,
  ) {
    return SizedBox(
      height: 86,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DetailJourneyDottedLineView(isSteadyLocation: isSteadyLocation),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _placeInfo(placeMark, createdAt),
                  const SizedBox(height: 8),
                  Visibility(
                      visible: !isSteadyLocation,
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
    final address = placeMark.isNotEmpty
        ? placeMark.getFormattedAddress()
        : context.l10n.journey_detail_getting_address_text;

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

  String _getDateAndTime(int createdAt) {
    DateTime createdAtDate = DateTime.fromMillisecondsSinceEpoch(createdAt);
    final startTime = createdAtDate.format(context, DateFormatType.time);
    final date = createdAtDate.isToday
        ? context.l10n.common_today
        : createdAtDate.format(context, DateFormatType.dayMonthFull);
    return '$date $startTime';
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

  Future<List<Marker>> _buildMarkers(LatLng fromLatLng, LatLng toLatLng) async {
    final fromIcon = await notifier.createCustomIcon(
        'assets/images/ic_timeline_start_location_icon.png');
    final toIcon = await notifier.createCustomIcon(
        'assets/images/ic_timeline_end_location_flag_icon.png');

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
}
