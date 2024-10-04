import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:style/button/primary_button.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:style/text/app_text_dart.dart';
import 'package:yourspace_flutter/domain/extenstions/context_extenstions.dart';

import '../../gen/assets.gen.dart';

class NoInternetScreen extends StatefulWidget {
  final Function() onPressed;

  const NoInternetScreen({super.key, required this.onPressed});

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(Assets.images.icNoConnectionIcon),
              const SizedBox(height: 40),
              Text(
                context.l10n.on_internet_error_title,
                style: AppTextStyle.header1
                    .copyWith(color: context.colorScheme.textPrimary),
              ),
              const SizedBox(height: 16),
              Text(
                context.l10n.on_internet_error_sub_title,
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
                  widget.onPressed();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<bool> checkInternetConnectivity() async {
  final result = await Connectivity().checkConnectivity();
  return result.first == ConnectivityResult.none;
}
