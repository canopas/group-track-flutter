import 'package:data/api/place/api_place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:style/animation/on_tap_scale.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:style/indicator/progress_indicator.dart';
import 'package:style/text/app_text_dart.dart';
import 'package:style/text/app_text_field.dart';
import 'package:yourspace_flutter/domain/extenstions/context_extenstions.dart';
import 'package:yourspace_flutter/ui/app_route.dart';
import 'package:yourspace_flutter/ui/components/app_page.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../components/error_snakebar.dart';
import 'add_new_place_view_model.dart';

class AddNewPlaceScreen extends ConsumerStatefulWidget {
  final String spaceId;

  const AddNewPlaceScreen({super.key, required this.spaceId});

  @override
  ConsumerState<AddNewPlaceScreen> createState() => _AddNewPlaceViewState();
}

class _AddNewPlaceViewState extends ConsumerState<AddNewPlaceScreen> {
  late AddNewPlaceViewNotifier notifier;

  @override
  Widget build(BuildContext context) {
    notifier = ref.watch(addNewPlaceStateProvider.notifier);

    _observeError();

    return AppPage(
      title: context.l10n.add_new_place_title,
      body: _body(),
    );
  }

  Widget _body() {
    final state = ref.watch(addNewPlaceStateProvider);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
          bottom: context.mediaQueryPadding.bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _searchTextField(),
              const SizedBox(height: 56),
              _locateOnMapView(),
              const SizedBox(height: 40),
              if (state.places.isNotEmpty || state.loading) ...[
                Text(
                  context.l10n.add_new_place_suggestion_text,
                  style: AppTextStyle.caption.copyWith(
                    color: context.colorScheme.textDisabled,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              if (state.isNetworkOff)
                _showNoInternetView()
              else
                ...state.places.map((place) {
                  final isLast =
                      state.places.indexOf(place) == state.places.length - 1;
                  return _suggestedPlaceItemView(place, isLast);
                }),
              const SizedBox(height: 24),
              state.loading
                  ? const Center(child: AppProgressIndicator())
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchTextField() {
    return Column(
      children: [
        AppTextField(
          style: AppTextStyle.subtitle3.copyWith(
            color: context.colorScheme.textPrimary,
          ),
          onChanged: (value) {
            notifier.onPlaceNameChanged(value.trim());
          },
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
          hintText: context.l10n.add_new_place_search_hint_text,
          hintStyle: AppTextStyle.subtitle3.copyWith(
            color: context.colorScheme.textDisabled,
          ),
          isDense: true,
          contentPadding: const EdgeInsets.all(0),
        ),
      ],
    );
  }

  Widget _locateOnMapView() {
    return OnTapScale(
      onTap: () {
        AppRoute.locateOnMapScreen(spaceId: widget.spaceId).push(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: context.colorScheme.containerNormal,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: context.colorScheme.containerLow),
              child: SvgPicture.asset(
                Assets.images.icLocation,
                colorFilter: ColorFilter.mode(
                  context.colorScheme.textPrimary,
                  BlendMode.srcATop,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              context.l10n.add_new_place_location_on_map_text,
              style: AppTextStyle.subtitle3.copyWith(
                color: context.colorScheme.textPrimary,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _suggestedPlaceItemView(ApiNearbyPlace place, bool isLast) {
    final latLng = LatLng(place.lat, place.lng);
    return Column(
      children: [
        OnTapScale(
          onTap: () {
            AppRoute.choosePlaceName(
              location: latLng,
              spaceId: widget.spaceId,
              placeName: place.name,
            ).push(context);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: SvgPicture.asset(
                  Assets.images.icLocation,
                  colorFilter: ColorFilter.mode(
                    context.colorScheme.textPrimary,
                    BlendMode.srcATop,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place.name,
                      maxLines: 1,
                      style: AppTextStyle.subtitle2.copyWith(
                        color: context.colorScheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      place.formatted_address,
                      style: AppTextStyle.caption
                          .copyWith(color: context.colorScheme.textSecondary),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              )
            ]),
          ),
        ),
        Visibility(
          visible: !isLast,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Divider(
              thickness: 1,
              height: 1,
              color: context.colorScheme.outline,
            ),
          ),
        )
      ],
    );
  }

  Widget _showNoInternetView() {
    return Column(
      children: [
        Text(
          context.l10n.on_internet_error_sub_title,
          style: AppTextStyle.body2
              .copyWith(color: context.colorScheme.textDisabled),
          textAlign: TextAlign.center,
        )
      ],
    );
  }

  void _observeError() {
    ref.listen(addNewPlaceStateProvider.select((state) => state.error),
        (previous, next) {
      if (next != null) {
        showErrorSnackBar(context, next.toString());
      }
    });
  }
}
