import 'dart:async';

import 'package:data/api/auth/auth_models.dart';
import 'package:data/api/space/space_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:style/animation/on_tap_scale.dart';
import 'package:style/button/icon_primary_button.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:style/text/app_text_dart.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yourspace_flutter/domain/extenstions/context_extenstions.dart';
import 'package:yourspace_flutter/domain/extenstions/lat_lng_extenstion.dart';
import 'package:yourspace_flutter/domain/extenstions/time_ago_extenstions.dart';
import 'package:yourspace_flutter/ui/components/profile_picture.dart';
import 'package:yourspace_flutter/ui/flow/home/map/map_view_model.dart';
import 'package:yourspace_flutter/ui/flow/navigation/routes.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../components/user_battery_status.dart';

class SelectedMemberDetailView extends StatefulWidget {
  final ApiSpace group;
  final MapUserInfo? userInfo;
  final void Function() onDismiss;
  final bool isCurrentUser;
  final LatLng currentUserLocation;

  const SelectedMemberDetailView({
    super.key,
    required this.group,
    required this.userInfo,
    required this.onDismiss,
    required this.isCurrentUser,
    required this.currentUserLocation,
  });

  @override
  State<SelectedMemberDetailView> createState() =>
      _SelectedMemberDetailViewState();
}

class _SelectedMemberDetailViewState extends State<SelectedMemberDetailView> {
  String? address = '';
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    getAddressDebounced(widget.userInfo?.latLng);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SelectedMemberDetailView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.userInfo?.user.id != widget.userInfo?.user.id) {
      _debounce?.cancel();

      setState(() {
        address = '';
      });

      getAddressDebounced(widget.userInfo?.latLng);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = widget.userInfo;
    return userInfo != null ? _userDetailCardView(userInfo.user) : Container();
  }

  Widget _userDetailCardView(ApiUser user) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: context.colorScheme.surface),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _userProfileView(user),
                const SizedBox(width: 16),
                Expanded(child: _userDetailView(user)),
              ],
            ),
          ),
        ),
        Container(
          width: context.mediaQuerySize.width,
          padding: const EdgeInsets.only(top: 24, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _timeLineButtonView(),
              const SizedBox(width: 8),
              _navigationAndShareLocationButtonView(),
            ],
          ),
        ),
        OnTapScale(
          onTap: () => widget.onDismiss(),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: context.colorScheme.surface),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: SvgPicture.asset(
                Assets.images.icDownArrowIcon,
                colorFilter: ColorFilter.mode(
                    context.colorScheme.textDisabled, BlendMode.srcATop),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _userProfileView(ApiUser user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ProfileImage(
          profileImageUrl: user.profile_image!,
          firstLetter: user.firstChar,
          size: 48,
          backgroundColor: context.colorScheme.primary,
        ),
        const SizedBox(height: 2),
        UserBatteryStatus(user: user)
      ],
    );
  }

  Widget _userDetailView(ApiUser user) {
    final (userState, textColor) = selectedUserState(user);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          user.fullName,
          style: AppTextStyle.subtitle2
              .copyWith(color: context.colorScheme.textPrimary),
        ),
        const SizedBox(height: 4),
        Text(userState, style: AppTextStyle.caption.copyWith(color: textColor)),
        const SizedBox(height: 12),
        _userAddressView(),
        const SizedBox(height: 4),
        _userTimeAgo(widget.userInfo?.updatedLocationAt ??
            DateTime.now().millisecondsSinceEpoch)
      ],
    );
  }

  Widget _userAddressView() {
    return Text(
      address ?? '',
      style: AppTextStyle.body2.copyWith(
        color: context.colorScheme.textPrimary,
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
    );
  }

  Widget _timeLineButtonView() {
    return IconPrimaryButton(
      onTap: () {
        JourneyTimelineRoute(
            JourneyTimelineRouteData(
                user: widget.userInfo!.user, space: widget.group))
            .push(context);
      },
      icon: SvgPicture.asset(
        Assets.images.icTimeLineHistoryIcon,
        colorFilter: ColorFilter.mode(
          context.colorScheme.textPrimary,
          BlendMode.srcATop,
        ),
      ),
    );
  }

  Widget _navigationAndShareLocationButtonView() {
    return IconPrimaryButton(
      onTap: () {
        if (widget.isCurrentUser) {
          final mapsLink =
              'https://www.google.com/maps/search/?api=1&query=${widget.userInfo?.latitude},${widget.userInfo?.longitude}';
          Share.share('Check out my location: $mapsLink');
        } else {
          final origin =
              '${widget.currentUserLocation.latitude}, ${widget.currentUserLocation.longitude}';
          final destination =
              '${widget.userInfo?.latitude},${widget.userInfo?.longitude}';
          final mapsLink =
              'https://www.google.com/maps/dir/?api=1&origin=$origin&destination=$destination';
          launchUrl(Uri.parse(mapsLink), mode: LaunchMode.externalApplication);
        }
      },
      icon: widget.isCurrentUser
          ? Icon(
              CupertinoIcons.paperplane,
              color: context.colorScheme.textPrimary,
              size: 18,
            )
          : SvgPicture.asset(
              Assets.images.icShareTwoLocation,
              colorFilter: ColorFilter.mode(
                context.colorScheme.textPrimary,
                BlendMode.srcATop,
              ),
            ),
    );
  }

  Widget _userTimeAgo(int? updateAt) {
    return Row(
      children: [
        Icon(
          Icons.access_time_outlined,
          color: context.colorScheme.textDisabled,
          size: 16,
        ),
        const SizedBox(width: 4),
        Text(
          updateAt.timeAgo(),
          style: AppTextStyle.caption
              .copyWith(color: context.colorScheme.textDisabled),
        )
      ],
    );
  }

  void getAddressDebounced(LatLng? location) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      getAddress(location);
    });
  }

  void getAddress(LatLng? latLng) async {
    if (latLng != null) {
      final fetchedAddress = await latLng.getAddressFromLocation();

      if (mounted) {
        setState(() {
          address = fetchedAddress;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          address = 'Location not available';
        });
      }
    }
  }

  (String, Color) selectedUserState(ApiUser user) {
    if (user.noNetWork) {
      return (
        context.l10n.map_selected_user_item_no_network_state_text,
        context.colorScheme.textSecondary
      );
    } else if (user.locationPermissionDenied) {
      return (
        context.l10n.map_selected_user_item_location_off_state_text,
        context.colorScheme.alert
      );
    } else {
      return (
        context.l10n.map_selected_user_item_online_state_text,
        context.colorScheme.positive
      );
    }
  }
}
