import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:style/text/app_text_dart.dart';
import 'package:yourspace_flutter/domain/extenstions/context_extenstions.dart';

import '../../../gen/assets.gen.dart';

const maxImageSize = 400;

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
          image: Assets.images.intro1),
      IntroPageItem(
          title: context.l10n.intro_2_title,
          subtitle: context.l10n.intro_2_subTitle,
          image: Assets.images.intro2),
      IntroPageItem(
          title: context.l10n.intro_3_title,
          subtitle: context.l10n.intro_3_subTitle,
          image: Assets.images.intro3),
    ];
  }
}

class IntroPageWidget extends StatelessWidget {
  final IntroPageItem item;

  const IntroPageWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size.width;
    final size = screenSize > maxImageSize ? maxImageSize : screenSize;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              Text(
                item.title,
                style: AppTextStyle.header1
                    .copyWith(color: context.colorScheme.textPrimary),
              ),
              const SizedBox(height: 24),
              SvgPicture.asset(item.image, width: size - 32, height: size - 32),
              const SizedBox(height: 16),
              Text(
                item.subtitle,
                textAlign: TextAlign.center,
                style: AppTextStyle.subtitle1
                    .copyWith(color: context.colorScheme.textSecondary),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
