import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:style/extenstions/context_extenstions.dart';

import '../../../../../gen/assets.gen.dart';

class PlaceMarker extends StatelessWidget {
  final double radius;

  const PlaceMarker({super.key, required this.radius});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ClipRect(
          child: OverflowBox(
            maxHeight: radius,
            maxWidth: radius,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: radius,
              height: radius,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius),
                color: context.colorScheme.primary.withAlpha((0.5 * 255).toInt()),
              ),
            ),
          ),
        ),
        Container(
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
        ),
      ],
    );
  }
}
