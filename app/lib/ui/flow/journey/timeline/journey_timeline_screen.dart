import 'package:data/api/auth/auth_models.dart';
import 'package:data/api/location/journey/journey.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:style/animation/on_tap_scale.dart';
import 'package:style/button/action_button.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:style/indicator/progress_indicator.dart';
import 'package:style/text/app_text_dart.dart';
import 'package:yourspace_flutter/domain/extenstions/context_extenstions.dart';
import 'package:yourspace_flutter/domain/extenstions/date_formatter.dart';
import 'package:yourspace_flutter/ui/components/app_page.dart';
import 'package:yourspace_flutter/ui/flow/journey/timeline/journey_timeline_view_model.dart';

import '../../../../domain/extenstions/widget_extensions.dart';
import '../../../../gen/assets.gen.dart';
import '../../../app_route.dart';
import '../../../components/error_snakebar.dart';
import '../../../components/no_internet_screen.dart';
import '../components/dotted_line_view.dart';
import '../components/journey_map.dart';

class JourneyTimelineScreen extends ConsumerStatefulWidget {
  final ApiUser selectedUser;
  final int groupCreatedDate;

  const JourneyTimelineScreen(
      {super.key, required this.selectedUser, required this.groupCreatedDate});

  @override
  ConsumerState<JourneyTimelineScreen> createState() =>
      _JourneyTimelineScreenState();
}

class _JourneyTimelineScreenState extends ConsumerState<JourneyTimelineScreen> {
  late JourneyTimelineViewModel notifier;
  final Map<LatLng, String> _addressCache = {};

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

    _observeShowDatePicker(state);

    return AppPage(
      title: title,
      actions: [
        OnTapScale(
          onTap: () => notifier.showDatePicker(true),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              actionButton(
                context: context,
                onPressed: () => notifier.showDatePicker(true),
                icon: Icon(
                  Icons.calendar_month_outlined,
                  color: context.colorScheme.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
      body: SafeArea(child: _body(state)),
    );
  }

  Widget _body(JourneyTimelineState state) {
    final selectedDate = _onSelectDatePickerDate(state.selectedTimeFrom);

    if (state.isNetworkOff) {
      return NoInternetScreen(onPressed: () {
        notifier.loadData(widget.selectedUser);
      });
    }

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
        itemCount: state.sortedJourney.length + 2,
        itemBuilder: (_, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(children: [
                Text(selectedDate,
                    style: AppTextStyle.subtitle1.copyWith(
                      color: context.colorScheme.textDisabled,
                    ))
              ]),
            );
          }

          final itemIndex = index - 1;
          if (itemIndex < state.sortedJourney.length) {
            final journey = state.sortedJourney[itemIndex];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                journey.isSteadyLocation()
                    ? _steadyLocationItem(
                        journey,
                        state.sortedJourney.first.id == journey.id,
                        state.sortedJourney.last.id == journey.id,
                        state.spaceId,
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
              _checkUserInternet(() => notifier.loadMoreJourney());
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
    String? spaceId,
  ) {
    final location = LatLng(journey.from_latitude, journey.from_longitude);
    final steadyDuration =
        notifier.getSteadyDuration(journey.created_at!, journey.update_at!);
    final formattedTime = (isFirstItem)
        ? _getFormattedLocationTimeForFirstItem(journey.created_at!)
        : _getFormattedTimeForSteadyLocation(journey.created_at!);

    return Padding(
      padding: EdgeInsets.only(top: isFirstItem ? 16 : 0),
      child: SizedBox(
        height: 142,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DottedLineView(isSteadyLocation: true, isLastItem: isLastItem),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPlaceInfo(
                        location,
                        formattedTime,
                        journey.isSteadyLocation(),
                        steadyDuration,
                        isFirstItem),
                    const SizedBox(height: 16),
                    _appPlaceButton(location, spaceId),
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
    final distance = notifier.getDistanceString(journey.route_distance ?? 0);
    final fromLatLng = LatLng(journey.from_latitude, journey.from_longitude);
    final toLatLng =
        LatLng(journey.to_latitude ?? 0.0, journey.to_longitude ?? 0.0);

    return SizedBox(
      height: 210,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DottedLineView(isSteadyLocation: false, isLastItem: isLastItem),
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
                  SizedBox(
                    height: 125,
                    child: FutureBuilder(
                      future: _buildMarkers(fromLatLng, toLatLng),
                      builder: (_, snapshot) {
                        if (snapshot.hasData) {
                          final markers = snapshot.data ?? [];
                          return JourneyMap(
                            journey: journey,
                            markers: markers,
                            isTimeLine: true,
                            gestureEnable: false,
                          );
                        } else {
                          return JourneyMap(
                            journey: journey,
                            markers: const [],
                            isTimeLine: true,
                            gestureEnable: false,
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceInfo(LatLng latLng, String formattedTime,
      bool isSteadyLocation, String steadyDuration, bool firstItem) {
    if (_addressCache.containsKey(latLng)) {
      return _placeInfo(
          address: _addressCache[latLng]!,
          formattedTime: formattedTime,
          isSteadyLocation: isSteadyLocation,
          steadyDuration: steadyDuration,
          firstItem: firstItem);
    }

    return FutureBuilder(
      future: notifier.getAddress(latLng),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _placeInfo(
            address: context.l10n.journey_timeline_getting_address_text,
            formattedTime: formattedTime,
          );
        }

        if (snapshot.hasData) {
          final address = snapshot.data ?? '';
          _addressCache[latLng] = address;
          return _placeInfo(
              address: address,
              formattedTime: formattedTime,
              isSteadyLocation: isSteadyLocation,
              steadyDuration: steadyDuration,
              firstItem: firstItem);
        } else if (snapshot.hasError) {
          return _placeInfo(address: "", formattedTime: formattedTime);
        } else {
          return _placeInfo(
            address: context.l10n.journey_timeline_unknown_address_text,
            formattedTime: formattedTime,
          );
        }
      },
    );
  }

  Widget _buildMovingPlaceInfo(
    LatLng fromLatLng,
    LatLng toLatLng,
    String formattedTime,
  ) {
    return FutureBuilder(
        future: _getMovingJourneyAddress(fromLatLng, toLatLng),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _placeInfo(
              address: context.l10n.journey_timeline_getting_address_text,
              formattedTime: formattedTime,
            );
          } else if (snapshot.hasData) {
            final address = snapshot.data ??
                context.l10n.journey_timeline_unknown_address_text;
            return _placeInfo(address: address, formattedTime: formattedTime);
          } else {
            return _placeInfo(
              address: context.l10n.journey_timeline_getting_address_text,
              formattedTime: formattedTime,
            );
          }
        });
  }

  Widget _placeInfo({
    required String address,
    required String formattedTime,
    bool? isSteadyLocation,
    String? steadyDuration,
    bool? firstItem,
  }) {
    final steadyText = (isSteadyLocation ?? false)
        ? ((firstItem ?? false) && notifier.selectedDateIsTodayDate())
            ? ''
            : context.l10n
                .journey_timeline_steady_duration_text(steadyDuration!)
        : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          address.isEmpty ? context.l10n.journey_timeline_unknown_address_text : address,
          style: AppTextStyle.body2
              .copyWith(color: context.colorScheme.textPrimary),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Text.rich(
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          TextSpan(
            children: [
              TextSpan(
                text: formattedTime,
                style: AppTextStyle.caption
                    .copyWith(color: context.colorScheme.textDisabled),
              ),
              TextSpan(
                text: steadyText,
                style: AppTextStyle.caption
                    .copyWith(color: context.colorScheme.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _appPlaceButton(LatLng location, String? spaceId) {
    return Row(
      children: [
        OnTapScale(
          onTap: () {
            if (spaceId != null) {
              AppRoute.choosePlaceName(location: location, spaceId: spaceId)
                  .push(context);
            }
          },
          child: Container(
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
          ),
        ),
      ],
    );
  }

  String _getFormattedLocationTimeForFirstItem(int createdAt) {
    DateTime createdAtDate = DateTime.fromMillisecondsSinceEpoch(createdAt);

    if (createdAtDate.isToday) {
      final time = createdAtDate.format(context, DateFormatType.time);
      return context.l10n.journey_timeline_Since_text(time);
    } else {
      final dayTime =
          createdAtDate.format(context, DateFormatType.dayMonthYear);
      return context.l10n.journey_timeline_Since_text(dayTime);
    }
  }

  String _getFormattedJourneyTime(int startAt, int endAt) {
    DateTime startAtDate = DateTime.fromMillisecondsSinceEpoch(startAt);
    DateTime endAtDate = DateTime.fromMillisecondsSinceEpoch(endAt);

    final endTime = endAtDate.format(context, DateFormatType.time);

    final startDate = startAtDate.format(context, DateFormatType.shortDayMonth);
    final endDate = endAtDate.format(context, DateFormatType.shortDayMonth);

    if (startDate == endDate) {
      return '${_getFormattedLocationTime(startAt)} - $endTime';
    } else {
      return '${_getFormattedLocationTime(startAt)} - ${_getFormattedLocationTime(endAt)}';
    }
  }

  String _getFormattedLocationTime(int createdAt) {
    DateTime createdAtDate = DateTime.fromMillisecondsSinceEpoch(createdAt);
    final startTime = createdAtDate.format(context, DateFormatType.time);

    if (createdAtDate.isToday) {
      final time = createdAtDate.format(context, DateFormatType.time);
      return context.l10n.journey_timeline_today_text(time);
    } else {
      return '${createdAtDate.format(context, DateFormatType.dayMonthFull)} $startTime';
    }
  }

  String _getFormattedTimeForSteadyLocation(int createdAt) {
    DateTime createdAtDate = DateTime.fromMillisecondsSinceEpoch(createdAt);
    final startTime = createdAtDate.format(context, DateFormatType.time);

    if (createdAtDate.isToday) {
      final time = createdAtDate.format(context, DateFormatType.time);
      return context.l10n.journey_timeline_today_text(time);
    } else {
      return '${createdAtDate.format(context, DateFormatType.dayMonthFull)} $startTime';
    }
  }

  Future<String> _getMovingJourneyAddress(
      LatLng fromLatLng, LatLng toLatLng) async {
    final fromPlaceMarks = await placemarkFromCoordinates(
        fromLatLng.latitude, fromLatLng.longitude);
    final toPlaceMarks =
        await placemarkFromCoordinates(toLatLng.latitude, toLatLng.longitude);

    return notifier.formattedAddress(fromPlaceMarks.first, toPlaceMarks.first);
  }

  Future<List<Marker>> _buildMarkers(LatLng fromLatLng, LatLng toLatLng) async {
    final fromIcon = await notifier
        .createCustomIcon('assets/images/ic_feed_location_icon.png');
    final toIcon =
        await notifier.createCustomIcon('assets/images/ic_distance_icon.png');

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
          firstDate:
              DateTime.fromMillisecondsSinceEpoch(widget.groupCreatedDate),
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

  void _checkUserInternet(VoidCallback onCallback) async {
    final isNetworkOff = await checkInternetConnectivity();
    isNetworkOff ? _showSnackBar() : onCallback();
  }

  void _showSnackBar() {
    showErrorSnackBar(context, context.l10n.on_internet_error_sub_title);
  }

  String _onSelectDatePickerDate(int? timestamp) {
    if (timestamp == null) return context.l10n.common_today;
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);

    if (dateTime.isToday) {
      return context.l10n.common_today;
    } else {
      final date = DateFormat('dd MMM').format(dateTime);
      return date.toString();
    }
  }
}
