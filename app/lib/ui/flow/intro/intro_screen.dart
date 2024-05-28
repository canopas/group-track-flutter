import 'package:data/storage/app_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:style/button/bottom_sticky_overlay.dart';
import 'package:style/button/primary_button.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:yourspace_flutter/domain/extenstions/context_extenstions.dart';
import 'package:yourspace_flutter/ui/components/app_page.dart';
import 'package:yourspace_flutter/ui/flow/intro/intro_page_item.dart';

import '../../app_route.dart';

class IntroScreen extends ConsumerStatefulWidget {
  const IntroScreen({super.key});

  @override
  ConsumerState<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends ConsumerState<IntroScreen> {
  final _controller = PageController(keepPage: true);
  List<IntroPageItem> _items = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _items = IntroPageItem.generate(context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      body: _body(),
    );
  }

  Widget _body() {
    return Column(
      children: [
        Expanded(
            child: PageView(
          controller: _controller,
          children: _items.map((e) => IntroPageWidget(item: e)).toList(),
          onPageChanged: (newPage) {
            setState(() {});
          },
        )),
        SmoothPageIndicator(
          controller: _controller,
          count: _items.length,
          effect: ExpandingDotsEffect(
            expansionFactor: 4,
            dotHeight: 8,
            dotWidth: 8,
            dotColor: context.colorScheme.containerHigh,
            activeDotColor: context.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 60),
        BottomStickyOverlay(
          child: PrimaryButton(
            context.l10n.common_next,
            onPressed: () {
              if (_controller.page == _items.length - 1) {
                ref.read(isIntroScreenShownPod.notifier).state = true;
                AppRoute.signInMethod.push(context);
              } else {
                _controller.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
