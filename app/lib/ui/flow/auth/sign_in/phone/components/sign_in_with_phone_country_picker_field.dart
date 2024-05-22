import 'package:canopas_country_picker/canopas_country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:style/animation/on_tap_scale.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:style/text/app_text_dart.dart';

import '../sign_in_with_phone_view_model.dart';

class SignInWithPhoneCountryPicker extends ConsumerWidget {
  const SignInWithPhoneCountryPicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(signInWithPhoneStateProvider.notifier);
    final countryCode = ref.watch(
      signInWithPhoneStateProvider.select((value) => value.code),
    );

    return Row(
      children: [
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: OnTapScale(
              onTap: () async {
                final code = await showCountryCodePickerSheet(
                  customizationBuilders: CustomizationBuilders(
                    textFieldBuilder: (filter) =>
                        DefaultCountryCodeFilterTextField(
                      prefixIcon: Icon(
                        Icons.search,
                        color: context.colorScheme.textSecondary,
                        size: 22,
                      ),
                      fillColor: context.colorScheme.containerNormal,
                      style: AppTextStyle.subtitle2.copyWith(
                        color: context.colorScheme.textPrimary,
                      ),
                      hintStyle: AppTextStyle.subtitle2.copyWith(
                        color: context.colorScheme.textSecondary,
                      ),
                      filter: filter,
                    ),
                    codeBuilder: (code) => OnTapScale(
                      onTap: () {
                        context.pop(code);
                      },
                      child: DefaultCountryCodeListItemView(
                        code: code,
                        dialCodeStyle: AppTextStyle.subtitle2.copyWith(
                          color: context.colorScheme.textPrimary,
                        ),
                        nameStyle: AppTextStyle.subtitle2.copyWith(
                          color: context.colorScheme.textPrimary,
                        ),
                      ),
                    ),
                    backgroundColor: () => context.colorScheme.surface,
                  ),
                  context: context,
                );
                notifier.changeCountryCode(code!);
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    countryCode.dialCode,
                    style: AppTextStyle.subtitle1
                        .copyWith(color: context.colorScheme.textSecondary),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4, left: 2),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 24,
                      color: context.colorScheme.textSecondary,
                    ),
                  ),
                ],
              ),
            )),
        Container(
          height: 30,
          width: 1,
          color: context.colorScheme.outline,
        )
      ],
    );
  }
}
