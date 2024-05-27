import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:style/text/app_text_dart.dart';
import 'package:yourspace_flutter/domain/extenstions/context_extenstions.dart';

import '../../../components/app_page.dart';

class JoinSpace extends ConsumerStatefulWidget {
  final String invitationCode;
  final String spaceName;

  const JoinSpace({
    super.key,
    required this.invitationCode,
    required this.spaceName,
  });

  @override
  ConsumerState createState() => _JoinSpaceState();
}

class _JoinSpaceState extends ConsumerState<JoinSpace> {
  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: context.l10n.join_space_title,
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
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
    );
  }

  Widget _inviteCode(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double containerWidth = (constraints.maxWidth - 48) / 7;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCodeBox(context, containerWidth),
            _buildCodeBox(context, containerWidth),
            _buildCodeBox(context, containerWidth),
            const SizedBox(width: 8),
            Text(
              '-',
              style: AppTextStyle.header3.copyWith(
                color: context.colorScheme.textPrimary,
              ),
            ),
            const SizedBox(width: 8),
            _buildCodeBox(context, containerWidth),
            _buildCodeBox(context, containerWidth),
            _buildCodeBox(context, containerWidth),
          ],
        );
      },
    );
  }

  Widget _buildCodeBox(BuildContext context, double width) {
    return Container(
      width: width,
      height: 64,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        border: Border.all(color: context.colorScheme.primary),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const TextField(
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: InputDecoration(
          border: InputBorder.none,
          counterText: '',
        ),
      ),
    );
  }
}
