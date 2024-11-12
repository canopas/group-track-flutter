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
                      Assets.images.icTimelineLocationPinIcon,
                      colorFilter: ColorFilter.mode(
                        context.colorScheme.primary,
                        BlendMode.srcATop,
                      ),
                    )
                  : SvgPicture.asset(
                      Assets.images.icTimelineJourneyIcon,
                      colorFilter: ColorFilter.mode(
                        context.colorScheme.primary,
                        BlendMode.srcATop,
                      ),
                    )),
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

class DetailJourneyDottedLineView extends StatelessWidget {
  final bool isSteadyLocation;

  const DetailJourneyDottedLineView(
      {super.key, required this.isSteadyLocation});

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
            color: !isSteadyLocation
                ? context.colorScheme.surface
                : context.colorScheme.containerLowOnSurface,
            shape: BoxShape.circle,
            border: Border.all(
              color: !isSteadyLocation
                  ? context.colorScheme.outline
                  : Colors.transparent,
              width: 1,
            ),
          ),
          child: Center(
              child: !isSteadyLocation
                  ? Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: context.colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                    )
                  : SvgPicture.asset(
                      Assets.images.icFlagIcon,
                      colorFilter: ColorFilter.mode(
                        context.colorScheme.primary,
                        BlendMode.srcATop,
                      ),
                    )),
        ),
        if (!isSteadyLocation)
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
