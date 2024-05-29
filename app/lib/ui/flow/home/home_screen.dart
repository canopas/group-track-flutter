import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:yourspace_flutter/domain/extenstions/widget_extensions.dart';
import 'package:yourspace_flutter/ui/components/app_page.dart';
import 'package:yourspace_flutter/ui/components/resume_detector.dart';
import 'package:yourspace_flutter/ui/flow/home/home_screen_viewmodel.dart';

import 'components/home_top_bar.dart';
import 'components/map_view.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late HomeViewNotifier notifier;

  @override
  void initState() {
    super.initState();
    runPostFrame(() {
      notifier = ref.watch(homeViewStateProvider.notifier);
      notifier.getAllSpace();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      body: ResumeDetector(
        onResume: () {
          notifier.getAllSpace();
        },
        child: _body(context),
      ),
    );
  }

  Widget _body(BuildContext context) {
    final state = ref.watch(homeViewStateProvider);

    return Padding(
      padding: context.mediaQueryPadding,
      child: Stack(
        children: [
          const MapView(),
          HomeTopBar(
            spaces: state.spaceList,
            onSpaceItemTap: (name) {
              notifier.updateSelectedSpaceName(name);
            },
            title: state.selectedSpaceName,
            loading: state.loading,
          ),
          // SpaceUserFooter()
        ],
      ),
    );
  }
}
