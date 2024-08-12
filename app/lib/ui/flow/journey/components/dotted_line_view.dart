import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:style/extenstions/context_extenstions.dart';

import '../../../../gen/assets.gen.dart';
import '../../../components/dashed_divider.dart';

class DottedLineView extends StatelessWidget {
  final bool isSteadyLocation;
  final bool isLastItem;

  const DottedLineView(
      {super.key, required this.isSteadyLocation, required this.isLastItem});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isSteadyLocation
                ? context.colorScheme.containerLowOnSurface
                : context.colorScheme.surface,
            shape: BoxShape.circle,
            border: Border.all(
              color: isSteadyLocation
                  ? Colors.transparent
                  : context.colorScheme.outline,
              width: 1,
            ),
          ),
          child: Center(
            child: isSteadyLocation
                ? SvgPicture.asset(
                    Assets.images.icFeedLocationPin,
                    colorFilter: ColorFilter.mode(
                      context.colorScheme.primary,
                      BlendMode.srcATop,
                    ),
                  )
                : Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: context.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
          ),
        ),
        if (!isLastItem)
          Expanded(
            child: CustomPaint(
              size: const Size(1, double.infinity),
              painter: DashedLineVerticalPainter(
                color: context.colorScheme.textPrimary,
              ),
            ),
          ),
      ],
    );
  }
}
