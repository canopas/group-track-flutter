import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:style/button/bottom_sticky_overlay.dart';
import 'package:style/button/primary_button.dart';
import 'package:style/button/secondary_button.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:style/text/app_text_dart.dart';
import 'package:yourspace_flutter/domain/extenstions/context_extenstions.dart';
import 'package:yourspace_flutter/ui/app_route.dart';
import 'package:yourspace_flutter/ui/components/alert.dart';
import 'package:yourspace_flutter/ui/components/error_snakebar.dart';
import 'package:yourspace_flutter/ui/flow/space/join/join_space_view_model.dart';

import '../../../components/app_page.dart';
import '../../../components/no_internet_screen.dart';

class JoinSpace extends ConsumerStatefulWidget {
  final bool fromOnboard;

  const JoinSpace({super.key, this.fromOnboard = false});

  @override
  ConsumerState createState() => _JoinSpaceState();
}

class _JoinSpaceState extends ConsumerState<JoinSpace> {
  late JoinSpaceViewNotifier notifier;

  @override
  Widget build(BuildContext context) {
    notifier = ref.watch(joinSpaceViewStateProvider.notifier);
    _observeError();
    _showCongratulationPrompt();
    _observePop();

    return AppPage(
      title: widget.fromOnboard ? '' : context.l10n.join_space_title,
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    final state = ref.watch(joinSpaceViewStateProvider);
    return Stack(children: [
      ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            widget.fromOnboard
                ? context.l10n.join_space_invitation_title
                : context.l10n.join_space_invite_code_title,
            style: AppTextStyle.header3.copyWith(
              color: context.colorScheme.textPrimary,
            ),
          ),
          if (widget.fromOnboard) ...[
            const SizedBox(height: 16),
            Text(
              context.l10n.join_space_get_code_from_space_creator_title,
              style: AppTextStyle.subtitle1.copyWith(
                color: context.colorScheme.textDisabled,
              ),
            )
          ],
          const SizedBox(height: 40),
          _inviteCode(context, state),
          const SizedBox(height: 40),
          Text(
            widget.fromOnboard
                ? ''
                : context.l10n.join_space_get_code_from_space_text,
            style: AppTextStyle.subtitle1.copyWith(
              color: context.colorScheme.textDisabled,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      _joinSpaceButton(context, state),
    ]);
  }

  Widget _inviteCode(BuildContext context, JoinSpaceViewState state) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double containerWidth = (constraints.maxWidth - 48) / 7;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < 3; i++) ...[
              _buildCodeBox(context, containerWidth, i, state),
              const SizedBox(width: 4),
            ],
            Text(
              '-',
              style: AppTextStyle.header3.copyWith(
                color: context.colorScheme.textPrimary,
              ),
            ),
            const SizedBox(width: 8),
            for (int i = 3; i < 6; i++) ...[
              _buildCodeBox(context, containerWidth, i, state),
              const SizedBox(width: 4),
            ],
          ],
        );
      },
    );
  }

  Widget _buildCodeBox(
      BuildContext context,
      double width,
      int index,
      JoinSpaceViewState state,
      ) {
    return Container(
      width: width,
      height: 64,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: context.colorScheme.containerLow,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: TextField(
          controller: state.controllers[index],
          focusNode: state.focusNodes[index],
          textAlign: TextAlign.center,
          maxLength: 2,
          decoration: const InputDecoration(
            border: InputBorder.none,
            counterText: '',
          ),
          textCapitalization: TextCapitalization.characters,
          style: AppTextStyle.header2.copyWith(
            color: context.colorScheme.textPrimary,
          ),
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          onChanged: (text) {
            notifier.onChange(text, index);
          },
        ),
      ),
    );
  }

  Widget _joinSpaceButton(BuildContext context, JoinSpaceViewState state) {
    return BottomStickyOverlay(
      child: Column(
        children: [
          _joinSpaceError(context, state),
          const SizedBox(height: 16),
          PrimaryButton(
            context.l10n.join_space_title,
            progress: state.verifying,
            enabled: state.enabled,
            onPressed: () {
              notifier.getSpace();
            },
          ),
          if (widget.fromOnboard) ...[
            const SizedBox(height: 16),
            SecondaryButton(
              context.l10n.join_space_create_new_space_title,
              onPressed: () {
                AppRoute.createSpace(fromOnboard: true).push(context);
              },
            )
          ],
        ],
      ),
    );
  }

  Widget _joinSpaceError(BuildContext context, JoinSpaceViewState state) {
    return Visibility(
      visible: state.errorInvalidInvitationCode || state.alreadySpaceMember,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: context.colorScheme.alert),
        child: Text(
          state.errorInvalidInvitationCode
              ? context.l10n.join_space_invalid_code_error_text
              : context.l10n.join_space_already_joined_error_text,
          style: AppTextStyle.subtitle2.copyWith(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _observeError() {
    ref.listen(joinSpaceViewStateProvider.select((state) => state.error),
        (previous, next) {
      if (next != null) {
        showErrorSnackBar(context, next.toString());
      }
    });
  }

  void _observePop() {
    ref.listen(joinSpaceViewStateProvider.select((state) => state.spaceJoined), (previous, next) {
      if (next) {
        context.pop();
      }
    });
  }

  void _showCongratulationPrompt() {
    final state = ref.watch(joinSpaceViewStateProvider);
    ref.listen(joinSpaceViewStateProvider.select((state) => state.space),
        (previous, next) {
      if (next != null) {
        showConfirmation(
          context,
          title: context.l10n.join_space_title,
          message: context.l10n.join_space_prompt_subtitle(next.name),
          onConfirm: () {
            _checkInternet(state.invitationCode);
          },
          onCancel: () => context.pop(),
        );
      }
    });
  }

  void _checkInternet(String inviteCode) async {
    final isNetworkOff = await checkInternetConnectivity();
    isNetworkOff
        ? _showSnackBar()
        : notifier.joinSpace();
  }

  void _showSnackBar() {
    showErrorSnackBar(context, context.l10n.on_internet_error_sub_title);
  }
}
