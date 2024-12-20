import 'package:data/api/auth/auth_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:style/text/app_text_dart.dart';

import '../../gen/assets.gen.dart';

class UserBatteryStatus extends StatelessWidget {
  final ApiUser user;

  const UserBatteryStatus({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final batteryPct = user.battery_pct ?? 0;
    String icon;
    Color color;

    if (batteryPct > 70) {
      icon = Assets.images.icFullBetteryIcon;
      color = context.colorScheme.positive;
    } else if (batteryPct > 50) {
      icon = Assets.images.ic50BatteryIcon;
      color = context.colorScheme.positive;
    } else if (batteryPct > 30) {
      icon = Assets.images.ic30BatteryIcon;
      color = context.colorScheme.positive;
    } else if (batteryPct >= 1) {
      icon = Assets.images.icEmptyBatteryIcon;
      color = context.colorScheme.alert;
    } else {
      icon = Assets.images.icUnknownBatteryIcon;
      color = context.colorScheme.textDisabled;
    }

    return Row(
      children: [
        SvgPicture.asset(
          icon,
          colorFilter: ColorFilter.mode(color, BlendMode.srcATop),
        ),
        Visibility(
          visible: batteryPct >= 1,
          child: Text(
            '${batteryPct.toInt()}%',
            style: AppTextStyle.caption
                .copyWith(color: context.colorScheme.textPrimary),
          ),
        )
      ],
    );
  }
}
