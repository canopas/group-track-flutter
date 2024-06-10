import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:yourspace_flutter/domain/extenstions/widget_extensions.dart';
import 'package:yourspace_flutter/ui/app_route.dart';
import 'package:yourspace_flutter/ui/components/app_page.dart';
import 'package:yourspace_flutter/ui/components/error_snakebar.dart';
import 'package:yourspace_flutter/ui/components/resume_detector.dart';
import 'package:yourspace_flutter/ui/flow/home/home_screen_viewmodel.dart';

import 'components/home_top_bar.dart';
import 'components/space_user_footer.dart';
import 'map/map_view.dart';

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
    final state = ref.watch(homeViewStateProvider);
    _observeNavigation(state);
    _observeError();

    return AppPage(
      body: ResumeDetector(
        onResume: () {
          notifier.getAllSpace();
        },
        child: _body(context, state),
      ),
    );
  }

  Widget _body(BuildContext context, HomeViewState state) {
    return Padding(
      padding: context.mediaQueryPadding,
      child: Stack(
        children: [
          const MapView(),
          HomeTopBar(
            spaces: state.spaceList,
            onSpaceItemTap: (name) => notifier.updateSelectedSpace(name),
            onAddMemberTap: () => notifier.onAddMemberTap(),
            selectedSpace: state.selectedSpace,
            loading: state.loading,
            fetchingInviteCode: state.fetchingInviteCode,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SpaceUserFooter(
              members: state.selectedSpace?.members,
              selectedMember: state.selectedMember,
              onAddMemberTap: () => notifier.onAddMemberTap(),
              onMemberTap: (member) {
                notifier.onSelectMember(member);
              },
              onRelocateTap: () {},
              onPlacesTap: () {},
              onDismiss: () => notifier.onDismissMemberDetail(),
              onTapTimeline: () {},
            ),
          ),
        ],
      ),
    );
  }

  void _observeNavigation(HomeViewState state) {
    ref.listen(
        homeViewStateProvider.select((state) => state.spaceInvitationCode),
        (_, next) {
      if (next.isNotEmpty) {
        AppRoute.inviteCode(
                code: next, spaceName: state.selectedSpace?.space.name ?? '')
            .push(context);
      }
    });
  }

  void _observeError() {
    ref.listen(homeViewStateProvider.select((state) => state.error),
        (previous, next) {
      if (next != null) {
        showErrorSnackBar(context, next.toString());
      }
    });
  }
}
