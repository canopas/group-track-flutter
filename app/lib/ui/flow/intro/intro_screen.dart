import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:yourspace_flutter/ui/components/app_page.dart';
import 'package:yourspace_flutter/ui/flow/intro/intro_page_item.dart';

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
            setState(() {
            });
          },
        )),
        const SizedBox(height: 40),
        SmoothPageIndicator(
          controller: _controller,
          count: _items.length,
          effect: ExpandingDotsEffect(
              expansionFactor: 2,
              dotHeight: 8,
              dotWidth: 8,
              dotColor: context.colorScheme.containerHigh,
              activeDotColor: context.colorScheme.primary,
            ),
          ),
        ],
      );
  }
}
