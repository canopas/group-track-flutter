import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:yourspace_flutter/ui/components/app_page.dart';

import 'components/home_top_bar.dart';
import 'components/map_view.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return AppPage(
        body: Padding(
      padding: context.mediaQueryPadding,
      child: const Stack(
        children: [
          MapView(),
          HomeTopBar(),
          // SpaceUserFooter()
        ],
      ),
    ));
  }
}
