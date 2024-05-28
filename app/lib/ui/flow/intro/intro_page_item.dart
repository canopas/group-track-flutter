import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:style/text/app_text_dart.dart';
import 'package:yourspace_flutter/domain/extenstions/context_extenstions.dart';

import '../../../gen/assets.gen.dart';

class IntroPageItem {
  final String title;
  final String subtitle;
  final String image;

  IntroPageItem({
    required this.title,
    required this.subtitle,
    required this.image,
  });

  static List<IntroPageItem> generate(BuildContext context) {
    return [
      IntroPageItem(
        title: context.l10n.intro_1_title,
        subtitle: context.l10n.intro_1_subTitle,
        image: Assets.images.intro1
      ),
      IntroPageItem(
        title: context.l10n.intro_2_title,
        subtitle: context.l10n.intro_1_subTitle,
        image: Assets.images.intro2
      ),
      IntroPageItem(
        title: context.l10n.intro_3_title,
        subtitle: context.l10n.intro_1_subTitle,
        image: Assets.images.intro3
      ),
    ];
  }
}

class IntroPageWidget extends StatelessWidget {
  final IntroPageItem item;

  const IntroPageWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            item.title,
            style: AppTextStyle.header1
                .copyWith(color: context.colorScheme.textPrimary),
          ),
          AspectRatio(
            aspectRatio: 1.3,
            child: SvgPicture.asset(item.image, width: double.infinity),
          ),
          const SizedBox(height: 40),
          const SizedBox(height: 8),
          Text(
            item.subtitle,
            textAlign: TextAlign.center,
            style: AppTextStyle.subtitle1
                .copyWith(color: context.colorScheme.textSecondary),
          ),
          const Spacer(flex: 5),
        ],
      ),
    );
  }
}
