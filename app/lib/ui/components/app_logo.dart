import 'package:flutter/material.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:style/text/app_text_dart.dart';
import 'package:yourspace_flutter/domain/extenstions/context_extenstions.dart';

import '../../gen/assets.gen.dart';

class AppLogo extends StatelessWidget {
  final Color? contentColor;

  const AppLogo({super.key, this.contentColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Assets.images.appLogo.image(
            width: 50,
            height: 50,
            color: contentColor ?? context.colorScheme.primary),
        Text(
          context.l10n.app_title,
          textAlign: TextAlign.center,
          style: AppTextStyle.logo
              .copyWith(color: contentColor ?? context.colorScheme.primary),
        )
      ],
    );
  }
}
