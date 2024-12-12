import 'package:data/api/space/space_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:style/button/action_button.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:style/indicator/progress_indicator.dart';
import 'package:style/text/app_text_dart.dart';
import 'package:yourspace_flutter/domain/extenstions/context_extenstions.dart';
import 'package:yourspace_flutter/ui/components/app_page.dart';
import 'package:yourspace_flutter/ui/components/error_snakebar.dart';

import '../../../../components/no_internet_screen.dart';
import '../../../../components/profile_picture.dart';
import 'change_admin_view_model.dart';

class ChangeAdminScreen extends ConsumerStatefulWidget {
  final SpaceInfo spaceInfo;

  const ChangeAdminScreen({super.key, required this.spaceInfo});

  @override
  ConsumerState createState() => _ChangeAdminScreenState();
}

class _ChangeAdminScreenState extends ConsumerState<ChangeAdminScreen> {
  late ChangAdminViewNotifier notifier;

  @override
  Widget build(BuildContext context) {
    notifier = ref.watch(changeAdminViewStateProvider.notifier);
    final state = ref.watch(changeAdminViewStateProvider);
    _observePop();
    _observeError();

    return AppPage(
      title: context.l10n.edit_space_change_admin_title,
      actions: [
        actionButton(
          context: context,
          icon: state.saving
              ? const AppProgressIndicator(size: AppProgressIndicatorSize.small)
              : Icon(
            Icons.check,
            size: 24,
            color: state.allowSave
                ? context.colorScheme.primary
                : context.colorScheme.textDisabled,
          ),
          onPressed: () {
            _checkUserInternet(() {
              if (state.allowSave) {
                _checkUserInternet(() {
                  notifier.updateSpaceAdmin(widget.spaceInfo.space);
                });
              }
            });
          },
        ),
      ],
      body: SafeArea(child: _body(context, state)),
    );
  }

  Widget _body(BuildContext context, ChangeAdminViewState state) {
    return _memberListItem(state);
  }

  Widget _memberListItem(ChangeAdminViewState state) {
    final members = widget.spaceInfo.members
        .where((member) => member.user.id != state.currentUserId)
        .toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: members.length,
      itemBuilder: (context, index) {
        final user = members[index].user;
        final isSelected = state.newAdminId == user.id;

        return GestureDetector(
          onTap: () => notifier.updateNewAdminId(user.id),
          child: Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: ProfileImage(
                  profileImageUrl: user.profile_image!,
                  firstLetter: user.firstChar,
                  size: 40,
                  backgroundColor: context.colorScheme.primary,
                ),
                title: Text(
                  user.fullName,
                  style: AppTextStyle.subtitle2.copyWith(
                    color: context.colorScheme.textPrimary,
                  ),
                ),
                trailing: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: isSelected ? context.colorScheme.positive : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(color: isSelected ? context.colorScheme.positive : context.colorScheme.textPrimary)
                  ),
                  child: isSelected
                      ? const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 16,
                  )
                      : null,
                ),
              ),
              if (index != members.length - 1) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 50),
                  child: Divider(
                    thickness: 1,
                    color: context.colorScheme.outline,
                  ),
                )
              ]
            ],
          ),
        );
      },
    );
  }

  void _observePop() {
    ref.listen(changeAdminViewStateProvider.select((state) => state.adminIdChanged),
        (previous, next) {
      if (next) {
        context.pop();
      }
    });
  }

  void _observeError() {
    ref.listen(changeAdminViewStateProvider.select((state) => state.error),
        (previous, next) {
      if (next != null) {
        showErrorSnackBar(context, next.toString());
      }
    });
  }

  void _checkUserInternet(VoidCallback onCallback) async {
    final isNetworkOff = await checkInternetConnectivity();
    isNetworkOff ? _showSnackBar() : onCallback();
  }

  void _showSnackBar() {
    showErrorSnackBar(context, context.l10n.on_internet_error_sub_title);
  }
}