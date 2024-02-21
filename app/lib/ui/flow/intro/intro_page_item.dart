import 'package:flutter/cupertino.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:style/text/app_text_dart.dart';

class IntroPageItem extends StatelessWidget {
  final String title;

  const IntroPageItem({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(
            flex: 1,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyle.header3
                .copyWith(color: context.colorScheme.onPrimary),
          ),
        ],
      ),
    );
  }
}
