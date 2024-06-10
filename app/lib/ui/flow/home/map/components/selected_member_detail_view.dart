import 'package:data/api/auth/auth_models.dart';
import 'package:data/api/location/location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:style/animation/on_tap_scale.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:style/text/app_text_dart.dart';
import 'package:yourspace_flutter/domain/extenstions/lat_lng_extenstion.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../components/user_battery_status.dart';
import '../../../../components/user_profile_image.dart';

class SelectedMemberDetailView extends StatefulWidget {
  final ApiUserInfo? userInfo;
  final void Function() onDismiss;
  final void Function() onTapTimeline;

  const SelectedMemberDetailView({
    super.key,
    required this.userInfo,
    required this.onDismiss,
    required this.onTapTimeline,
  });

  @override
  State<SelectedMemberDetailView> createState() =>
      _SelectedMemberDetailViewState();
}

class _SelectedMemberDetailViewState extends State<SelectedMemberDetailView> {
  @override
  Widget build(BuildContext context) {
    final userInfo = widget.userInfo;
    return userInfo != null ? _userDetailCardView(userInfo) : Container();
  }

  Widget _userDetailCardView(ApiUserInfo userInfo) {
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
                _userProfileView(userInfo),
                const SizedBox(width: 16),
                Expanded(child: _userDetailView(userInfo)),
              ],
            ),
          ),
        ),

        Container(
          width: context.mediaQuerySize.width,
          padding: const EdgeInsets.only(top: 24, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [_timeLineButtonView()],
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

  Widget _userProfileView(ApiUserInfo userInfo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ImageAvatar(
          imageUrl: userInfo.user.profile_image,
          initials: userInfo.user.firstChar,
        ),
        const SizedBox(height: 2),
        UserBatteryStatus(userInfo: userInfo)
      ],
    );
  }

  Widget _userDetailView(ApiUserInfo userInfo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          userInfo.user.fullName,
          style: AppTextStyle.subtitle2
              .copyWith(color: context.colorScheme.textPrimary),
        ),
        const SizedBox(height: 4),
        Text(
          'Online',
          style: AppTextStyle.caption
              .copyWith(color: context.colorScheme.positive),
        ),
        const SizedBox(height: 12),
        _userAddressView(userInfo.location),
        const SizedBox(height: 4),
        _userTimeAgo(userInfo.user.created_at)
      ],
    );
  }

  Widget _userAddressView(ApiLocation? location) {
    return FutureBuilder<String>(
      future: getAddress(location),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final address = snapshot.data ?? '';
          return Text(
            address,
            style: AppTextStyle.body2
                .copyWith(color: context.colorScheme.textPrimary),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          );
        } else {
          return const SizedBox(height: 16);
        }
      },
    );
  }

  Widget _timeLineButtonView() {
    return OnTapScale(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: context.colorScheme.containerLow),
        padding: const EdgeInsets.all(8),
        child: OnTapScale(
          onTap: () => widget.onTapTimeline(),
          child: SvgPicture.asset(
            Assets.images.icTimeLineHistoryIcon,
            colorFilter: ColorFilter.mode(
              context.colorScheme.textPrimary,
              BlendMode.srcATop,
            ),
          ),
        ),
      ),
    );
  }

  Widget _userTimeAgo(int? createdAt) {
    final time = timeAgo(createdAt);
    return Row(
      children: [
        Icon(
          Icons.access_time_outlined,
          color: context.colorScheme.textDisabled,
          size: 16,
        ),
        const SizedBox(width: 4),
        Text(
          time,
          style: AppTextStyle.caption
              .copyWith(color: context.colorScheme.textDisabled),
        )
      ],
    );
  }

  String timeAgo(int? timestamp) {
    if (timestamp == null) return "";

    final DateTime now = DateTime.now();
    final DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);

    final Duration diff = now.difference(date);

    if (diff.inSeconds < 60) {
      return "just now";
    } else if (diff.inMinutes < 60) {
      return "${diff.inMinutes} minutes ago";
    } else if (diff.inHours < 24) {
      return "${diff.inHours} hours ago";
    } else if (diff.inDays < 7) {
      return "${diff.inDays} days ago";
    } else if (diff.inDays < 30) {
      return "${diff.inDays ~/ 7} weeks ago";
    } else if (diff.inDays < 365) {
      return "${diff.inDays ~/ 30} months ago";
    } else {
      return "${diff.inDays ~/ 365} years ago";
    }
  }

  Future<String> getAddress(ApiLocation? location) async {
    // if (location == null) return '';
    // test LatLng(21.231981, 72.8364215)
    // LatLng(37.4219999, -122.0840575)
    final latLng = LatLng(21.231981, 72.8364215);
    final address = await latLng.getAddressFromLocation();
    return address;
  }
}
