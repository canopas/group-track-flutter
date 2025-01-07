import 'package:data/api/place/api_place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:style/animation/on_tap_scale.dart';
import 'package:style/button/primary_button.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:style/indicator/progress_indicator.dart';
import 'package:style/text/app_text_dart.dart';
import 'package:yourspace_flutter/domain/extenstions/api_error_extension.dart';
import 'package:yourspace_flutter/domain/extenstions/context_extenstions.dart';
import 'package:yourspace_flutter/ui/app_route.dart';
import 'package:yourspace_flutter/ui/components/app_page.dart';
import 'package:yourspace_flutter/ui/flow/geofence/places/places_list_view_model.dart';
import 'package:yourspace_flutter/ui/flow/navigation/routes.dart';

import '../../../../domain/extenstions/widget_extensions.dart';
import '../../../../gen/assets.gen.dart';
import '../../../components/alert.dart';
import '../../../components/error_snakebar.dart';
import '../../../components/no_internet_screen.dart';

class PlacesListScreen extends ConsumerStatefulWidget {
  final String spaceId;

  const PlacesListScreen({super.key, required this.spaceId});

  @override
  ConsumerState<PlacesListScreen> createState() => _PlacesViewState();
}

class _PlacesViewState extends ConsumerState<PlacesListScreen> {
  late PlacesListViewNotifier notifier;

  @override
  void initState() {
    super.initState();
    runPostFrame(() {
      notifier = ref.watch(placesListViewStateProvider.notifier);
      notifier.loadPlaces(widget.spaceId);
      notifier.getSpaceMember(widget.spaceId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(placesListViewStateProvider);

    _observeError();
    _observeShowDeletePlaceDialog();
    _observeInviteScreenNavigation();

    return AppPage(title: context.l10n.places_list_title, body: _body(state));
  }

  Widget _body(PlacesListState state) {
    if (state.loading) {
      return const Center(
        child: AppProgressIndicator(),
      );
    }

    if (state.spaceMember.length <= 1) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: _emptyViewWith0Member(context, state),
      );
    }

    return _listView(state);
  }

  Widget _listView(PlacesListState state) {
    final placeLength = (state.places.isEmpty) ? 0 : state.places.length + 1;
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: placeLength + state.suggestions.length,
              itemBuilder: (_, index) {
                if (index < state.places.length) {
                  return _memberPlaceItem(state, state.places[index]);
                }

                if (index == state.places.length && state.places.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child:
                        Divider(color: context.colorScheme.outline, height: 1),
                  );
                }

                final placeIndex = (state.places.isEmpty)
                    ? index
                    : index - state.places.length - 1;

                final item = state.suggestions[placeIndex];
                return _placeItemView(
                  placeName: item,
                  icon: _getPlacesIcon(item),
                  isSuggestion: true,
                  onTap: () => onSuggestionItemTap(item),
                  onDeletePlace: () {},
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Align(alignment: Alignment.bottomRight, child: _addPlaceButton())
        ],
      ),
    );
  }

  Widget _memberPlaceItem(PlacesListState state, ApiPlace item) {
    final icon = _getPlacesIcon(item.name);
    final isDeleting =
        state.deletingPlaces && state.placesToDelete?.id == item.id;
    final allowDelete = state.currentUser?.id == item.created_by;
    return _placeItemView(
      placeName: item.name,
      icon: icon,
      allowDelete: allowDelete,
      isDeleting: isDeleting,
      onTap: () {
        AppRoute.editPlaceScreen(item).push(context);
      },
      onDeletePlace: () {
        notifier.onClickDeletePlace(item);
      },
    );
  }

  Widget _placeItemView({
    required String placeName,
    required String icon,
    bool isSuggestion = false,
    bool allowDelete = false,
    bool isDeleting = false,
    required VoidCallback onTap,
    required VoidCallback onDeletePlace,
  }) {
    final enabled = !isSuggestion && allowDelete;

    return OnTapScale(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                color: context.colorScheme.containerLowOnSurface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: SvgPicture.asset(
                  icon,
                  colorFilter: ColorFilter.mode(
                    context.colorScheme.textPrimary,
                    BlendMode.srcATop,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                placeName,
                style: AppTextStyle.subtitle3
                    .copyWith(color: context.colorScheme.textPrimary),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            (isDeleting)
                ? const AppProgressIndicator(
                    size: AppProgressIndicatorSize.small)
                : Visibility(
                    visible: enabled,
                    child: OnTapScale(
                      onTap: onDeletePlace,
                      child: SvgPicture.asset(
                        Assets.images.icCloseIcon,
                        colorFilter: ColorFilter.mode(
                          context.colorScheme.textPrimary,
                          BlendMode.srcATop,
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _addPlaceButton() {
    return OnTapScale(
      onTap: () {
        AppRoute.addNewPlace(widget.spaceId).push(context);
      },
      child: Container(
        margin: const EdgeInsets.only(right: 16, bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: context.colorScheme.primary,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              Assets.images.icPlusIcon,
              colorFilter: ColorFilter.mode(
                context.colorScheme.textInversePrimary,
                BlendMode.srcATop,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              context.l10n.places_list_add_place_btn_text,
              style: AppTextStyle.button.copyWith(
                color: context.colorScheme.textInversePrimary,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _emptyViewWith0Member(BuildContext context, PlacesListState state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            Assets.images.icGeofenceIcon,
            colorFilter: ColorFilter.mode(
              context.colorScheme.textPrimary,
              BlendMode.srcATop,
            ),
            width: 80,
          ),
          const SizedBox(height: 16),
          Text(
            context.l10n.place_list_add_member_to_add_places_title,
            style: AppTextStyle.header3.copyWith(
              color: context.colorScheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            context.l10n.place_list_add_member_to_add_places_subtitle,
            style: AppTextStyle.subtitle1.copyWith(
              color: context.colorScheme.textDisabled,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          PrimaryButton(context.l10n.message_add_new_member_title,
              progress: state.fetchingInviteCode, onPressed: () {
            notifier.onAddNewMemberTap(widget.spaceId);
          }),
        ],
      ),
    );
  }

  String _getPlacesIcon(String name) {
    if (name == 'Home') {
      return Assets.images.icPlacesHomeIcon;
    } else if (name == 'Work') {
      return Assets.images.icPlacesWorkIcon;
    } else if (name == 'School') {
      return Assets.images.icPlacesSchoolIcon;
    } else if (name == 'Gym') {
      return Assets.images.icPlacesGymIcon;
    } else if (name == 'Library') {
      return Assets.images.icPlacesLibraryIcon;
    } else if (name == 'Local park') {
      return Assets.images.icPlacesParkIcon;
    } else {
      return Assets.images.icLocation;
    }
  }

  void onSuggestionItemTap(String placeName) {
    AppRoute.locateOnMapScreen(spaceId: widget.spaceId, placesName: placeName)
        .push(context);
  }

  void _observeError() {
    ref.listen(placesListViewStateProvider.select((state) => state.error),
        (previous, next) {
      if (next != null) {
        showErrorSnackBar(context, next.l10nMessage(context));
      }
    });
  }

  void _observeShowDeletePlaceDialog() {
    ref.listen(
        placesListViewStateProvider
            .select((state) => state.showDeletePlaceDialog), (_, next) {
      if (next != null) {
        showConfirmation(context,
            message: context.l10n.places_list_delete_dialog_content_text,
            confirmBtnText: context.l10n.common_delete,
            cancelButtonText: context.l10n.common_cancel,
            onCancel: () => notifier.dismissDeletePlaceDialog(),
            onConfirm: () async {
              final isNetworkOff = await checkInternetConnectivity();
              isNetworkOff ? _showSnackBar() : notifier.deletePlace();
            });
      }
    });
  }

  void _observeInviteScreenNavigation() {
    ref.listen(
        placesListViewStateProvider
            .select((state) => state.spaceInvitationCode), (previous, next) {
      if (next.isNotEmpty) {
        InviteCodeRoute(InviteCodeRouteData(
                inviteCode: next, spaceName: '', fromOnboard: false))
            .push(context);
      }
    });
  }

  void _showSnackBar() {
    showErrorSnackBar(context, context.l10n.on_internet_error_sub_title);
  }
}
