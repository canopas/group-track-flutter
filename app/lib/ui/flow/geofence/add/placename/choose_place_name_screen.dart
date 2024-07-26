import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:style/animation/on_tap_scale.dart';
import 'package:style/button/primary_button.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:style/text/app_text_dart.dart';
import 'package:style/text/app_text_field.dart';
import 'package:yourspace_flutter/domain/extenstions/context_extenstions.dart';
import 'package:yourspace_flutter/ui/app_route.dart';
import 'package:yourspace_flutter/ui/components/app_page.dart';
import 'package:yourspace_flutter/ui/flow/geofence/add/placename/choose_place_name_view_model.dart';

import '../../../../../domain/extenstions/widget_extensions.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../components/error_snakebar.dart';
import '../../../home/map/map_screen.dart';

class ChoosePlaceNameScreen extends ConsumerStatefulWidget {
  final LatLng location;
  final String spaceId;
  final String placesName;

  const ChoosePlaceNameScreen({
    super.key,
    required this.location,
    required this.spaceId,
    required this.placesName,
  });

  @override
  ConsumerState<ChoosePlaceNameScreen> createState() =>
      _ChoosePlaceNameViewState();
}

class _ChoosePlaceNameViewState extends ConsumerState<ChoosePlaceNameScreen> {
  late ChoosePlaceNameViewNotifier notifier;

  @override
  void initState() {
    super.initState();
    runPostFrame(() {
      notifier = ref.watch(choosePlaceViewStateProvider.notifier);
      notifier.setData(widget.location, widget.spaceId, widget.placesName);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(choosePlaceViewStateProvider);

    _observeError();
    _observePopToPlacesListScreen(state.title.text);

    return AppPage(
      title: context.l10n.choose_place_screen_title,
      body: _body(state),
    );
  }

  Widget _body(ChoosePlaceViewState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _searchTextField(state),
          const SizedBox(height: 40),
          Text(
            context.l10n.choose_place_suggestion_text,
            style: AppTextStyle.caption
                .copyWith(color: context.colorScheme.textDisabled),
          ),
          const SizedBox(height: 16),
          _suggestionsPlaceView(state.suggestions, state),
          const Spacer(),
          Align(
            alignment: Alignment.center,
            child: _addPlaceButtonView(state),
          )
        ],
      ),
    );
  }

  Widget _searchTextField(ChoosePlaceViewState state) {
    return Column(
      children: [
        AppTextField(
          controller: state.title,
          onChanged: (value) => notifier.onSearchTitleChange(value),
          style: AppTextStyle.subtitle3.copyWith(
            color: context.colorScheme.textPrimary,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(right: 8, bottom: 8),
            child: SvgPicture.asset(
              Assets.images.icSearchIcon,
              colorFilter: ColorFilter.mode(
                context.colorScheme.textDisabled,
                BlendMode.srcATop,
              ),
            ),
          ),
          hintText: context.l10n.choose_place_search_hint_text,
          hintStyle: AppTextStyle.subtitle3.copyWith(
            color: context.colorScheme.textDisabled,
          ),
          isDense: true,
          contentPadding: const EdgeInsets.all(0),
        ),
      ],
    );
  }

  Widget _suggestionsPlaceView(
    List<String>? suggestions,
    ChoosePlaceViewState state,
  ) {
    if (suggestions == null) return Container();
    return Wrap(
      alignment: WrapAlignment.start,
      spacing: 8,
      children: suggestions.map((element) {
        return OnTapScale(
          onTap: () {
            notifier.onTapSuggestedPlace(element);
          },
          child: Chip(
            label: Text(
              element,
              style: AppTextStyle.body2
                  .copyWith(color: context.colorScheme.textSecondary),
            ),
            labelPadding: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            backgroundColor: context.colorScheme.containerLowOnSurface,
            side: const BorderSide(color: Colors.transparent),
          ),
        );
      }).toList(),
    );
  }

  Widget _addPlaceButtonView(ChoosePlaceViewState state) {
    final enable = state.enableAddBtn && !state.addingPlace;

    return Padding(
      padding: EdgeInsets.only(bottom: context.mediaQueryPadding.bottom + 24),
      child: PrimaryButton(
        enabled: enable,
        progress: state.addingPlace,
        onPressed: () {
          notifier.onTapAddPlaceBtn();
        },
        edgeInsets: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
        context.l10n.choose_place_add_place_btn_text,
        expanded: false,
      ),
    );
  }

  void _observeError() {
    ref.listen(choosePlaceViewStateProvider.select((state) => state.error),
        (previous, next) {
      if (next != null) {
        showErrorSnackBar(context, next.toString());
      }
    });
  }

  void _observePopToPlacesListScreen(String title) {
    ref.listen(
        choosePlaceViewStateProvider.select((state) => state.popToPlaceList),
        (_, next) {
      AppRoute.popTo(context, AppRoute.pathPlacesList);
      _showPlaceAddedDialog(
        context,
        widget.location.latitude,
        widget.location.longitude,
        title,
      );
    });
  }

  void _showPlaceAddedDialog(
    BuildContext context,
    double lat,
    double lng,
    String placeName,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AspectRatio(
                aspectRatio: 1.77,
                child: _googleMapView(lat, lng),
              ),
              const SizedBox(height: 24),
              Text(
                context.l10n.choose_place_prompt_added_title_text(placeName),
                style: AppTextStyle.header1
                    .copyWith(color: context.colorScheme.textPrimary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 14),
              Text(
                context.l10n.choose_place_prompt_sub_title_text,
                style: AppTextStyle.body1
                    .copyWith(color: context.colorScheme.textSecondary),
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
        );
      },
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
        _locateMarkerView()
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
