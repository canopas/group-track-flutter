import 'package:data/storage/app_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:style/button/primary_button.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:style/text/app_text_dart.dart';
import 'package:yourspace_flutter/domain/extenstions/context_extenstions.dart';
import 'package:yourspace_flutter/ui/app_route.dart';
import 'package:yourspace_flutter/ui/components/app_logo.dart';
import 'package:yourspace_flutter/ui/components/app_page.dart';
import 'package:yourspace_flutter/ui/flow/intro/intro_page_item.dart';

import '../../../gen/assets.gen.dart';

class IntroScreen extends ConsumerStatefulWidget {
  const IntroScreen({super.key});

  @override
  ConsumerState<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends ConsumerState<IntroScreen> {
  final _controller = PageController(keepPage: true);
  List<String> _items = [];

  var _currentPage = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _items = [
          context.l10n.intro_1_title,
          context.l10n.intro_2_title,
          context.l10n.intro_3_title,
        ];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      body: SafeArea(
        child: _content(),
      ),
    );
  }

  Widget _content() {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: Assets.images.introBg.provider(),
              fit: BoxFit.fill,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.6), BlendMode.srcOver))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 80,
          ),
          AppLogo(
            contentColor: context.colorScheme.onPrimary,
          ),
          SizedBox(
            width: 20,
            height: 1,
            child: Divider(
              color: context.colorScheme.onPrimary,
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          Text(
            context.l10n.app_tag_line,
            textAlign: TextAlign.center,
            style: AppTextStyle.caption
                .copyWith(color: context.colorScheme.onPrimary),
          ),
          Expanded(
              child: PageView(
            controller: _controller,
            children: _items.map((e) => IntroPageItem(title: e)).toList(),
            onPageChanged: (newPage) {
              setState(() {
                _currentPage = newPage;
              });
            },
          )),
          const SizedBox(height: 16),
          SmoothPageIndicator(
            controller: _controller,
            count: _items.length,
            effect: ExpandingDotsEffect(
                expansionFactor: 2,
                dotHeight: 8,
                dotWidth: 8,
                dotColor: context.colorScheme.onPrimary.withOpacity(0.5),
                activeDotColor: context.colorScheme.primary),
          ),
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: PrimaryButton(
              context.l10n.common_get_started,
              progress: false,
              onPressed: () {
                ref.read(isIntroScreenShownPod.notifier).state = true;
                AppRoute.signInMethod.push(context);
              },
            ),
          ),
          const SizedBox(
            height: 80,
          ),
        ],
      ),
    );
  }
}
