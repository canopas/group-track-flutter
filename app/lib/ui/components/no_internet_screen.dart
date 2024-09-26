import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:style/button/primary_button.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:style/text/app_text_dart.dart';
import 'package:yourspace_flutter/domain/extenstions/context_extenstions.dart';

import '../../gen/assets.gen.dart';

class NoInternetScreen extends StatelessWidget {
  final Function() onPressed;

  const NoInternetScreen({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                Assets.images.icNoConnectionIcon,
                // colorFilter: ColorFilter.mode(
                //   context.colorScheme.onPrimary,
                //   BlendMode.srcATop,
                // ),
              ),
              const SizedBox(height: 40),
              Text(
                context.l10n.no_internet_error_title,
                style: AppTextStyle.header1
                    .copyWith(color: context.colorScheme.textPrimary),
              ),
              const SizedBox(height: 16),
              Text(
                context.l10n.no_internet_error_sub_title,
                style: AppTextStyle.subtitle2
                    .copyWith(color: context.colorScheme.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              PrimaryButton(
                context.l10n.common_retry,
                edgeInsets: const EdgeInsets.symmetric(
                    vertical: 14.0, horizontal: 42.0),
                expanded: false,
                onPressed: () {
                  onPressed();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
