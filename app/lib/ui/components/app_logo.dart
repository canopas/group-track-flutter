import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
        SvgPicture.asset(Assets.images.appNameLogo),
      ],
    );
  }
}
