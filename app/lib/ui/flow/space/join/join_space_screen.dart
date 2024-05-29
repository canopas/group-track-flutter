import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:style/button/bottom_sticky_overlay.dart';
import 'package:style/button/primary_button.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:style/text/app_text_dart.dart';
import 'package:yourspace_flutter/domain/extenstions/context_extenstions.dart';
import 'package:yourspace_flutter/ui/flow/space/join/join_space_view_model.dart';

import '../../../components/app_page.dart';

class JoinSpace extends ConsumerStatefulWidget {
  const JoinSpace({super.key});

  @override
  ConsumerState createState() => _JoinSpaceState();
}

class _JoinSpaceState extends ConsumerState<JoinSpace> {
  late JoinSpaceViewNotifier notifier;
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final _focusNodes = List.generate(6, (index) => FocusNode());

  @override
  Widget build(BuildContext context) {
    notifier = ref.watch(joinSpaceViewStateProvider.notifier);
    return AppPage(
      title: context.l10n.join_space_title,
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return Stack(children: [
      ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            context.l10n.join_space_invite_code_title,
            style: AppTextStyle.header3.copyWith(
              color: context.colorScheme.textPrimary,
            ),
          ),
          const SizedBox(height: 40),
          _inviteCode(context),
          const SizedBox(height: 40),
          Text(
            context.l10n.join_space_get_code_from_space_text,
            style: AppTextStyle.subtitle1.copyWith(
              color: context.colorScheme.textDisabled,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      _joinSpaceButton(context),
    ]);
  }

  Widget _inviteCode(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double containerWidth = (constraints.maxWidth - 48) / 7;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < 6; i++) ...[
              _buildCodeBox(context, containerWidth, i),
              const SizedBox(width: 4),
            ],
            // Text(
            //   '-',
            //   style: AppTextStyle.header3.copyWith(
            //     color: context.colorScheme.textPrimary,
            //   ),
            // ),
            // const SizedBox(width: 8),
            // for (int i = 3; i < 6; i++) ...[
            //   _buildCodeBox(context, containerWidth, i),
            //   const SizedBox(width: 4),
            // ],
          ],
        );
      },
    );
  }

  Widget _buildCodeBox(BuildContext context, double width, int index) {
    return Container(
      width: width,
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: context.colorScheme.containerLow,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number, // Ensure numerical input
        maxLength: 1,
        decoration: const InputDecoration(
          border: InputBorder.none,
          counterText: '',
        ),
        style: AppTextStyle.header2.copyWith(
          color: context.colorScheme.textPrimary,
        ),
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        onChanged: (text) {
          if (text.isEmpty) {
            _focusNodes[index - 1].requestFocus();
          } else {
            _focusNodes[index + 1].requestFocus();
          }
        },
      ),
    );
  }

  Widget _joinSpaceButton(BuildContext context) {
    return BottomStickyOverlay(
      child: PrimaryButton(
        context.l10n.join_space_title,
        onPressed: () {
          notifier.joinSpace();
        },
      ),
    );
  }
}
