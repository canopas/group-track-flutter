import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:style/button/bottom_sticky_overlay.dart';
import 'package:style/button/primary_button.dart';
import 'package:style/button/secondary_button.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:style/text/app_text_dart.dart';
import 'package:yourspace_flutter/domain/extenstions/context_extenstions.dart';
import 'package:yourspace_flutter/ui/components/app_page.dart';
import 'package:yourspace_flutter/ui/flow/navigation/routes.dart';

import '../../../gen/assets.gen.dart';

class ConnectionScreen extends StatefulWidget {
  const ConnectionScreen({super.key});

  @override
  State<ConnectionScreen> createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen> {
  @override
  Widget build(BuildContext context) {
    return AppPage(
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return Center(
      child: Stack(children: [
        ListView(
            children: [
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              context.l10n.connection_share_title,
              style: AppTextStyle.header3.copyWith(
                color: context.colorScheme.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 40),
          SvgPicture.asset(Assets.images.connection),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              context.l10n.connection_share_subtitle,
              style: AppTextStyle.subtitle1.copyWith(
                color: context.colorScheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          )
        ]),
        _continueAndSkipButton(context),
      ]),
    );
  }

  Widget _continueAndSkipButton(BuildContext context) {
    return BottomStickyOverlay(
      child: Column(children: [
        PrimaryButton(
          context.l10n.connection_continue_title,
          onPressed: () {
            const JoinSpaceRoute(fromOnboard: true).go(context);
          },
        ),
        const SizedBox(height: 16),
        SecondaryButton(
          context.l10n.common_skip,
          onPressed: () {
            HomeRoute().go(context);
          },
        )
      ]),
    );
  }
}
