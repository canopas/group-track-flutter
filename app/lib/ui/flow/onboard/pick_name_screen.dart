import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:style/button/primary_button.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:style/text/app_text_dart.dart';
import 'package:yourspace_flutter/domain/extenstions/context_extenstions.dart';
import 'package:yourspace_flutter/ui/app_route.dart';
import 'package:yourspace_flutter/ui/components/app_page.dart';
import 'package:yourspace_flutter/ui/components/error_snakebar.dart';
import 'package:yourspace_flutter/ui/flow/onboard/pick_name_view_model.dart';

class PickNameScreen extends ConsumerStatefulWidget {
  const PickNameScreen({super.key});

  @override
  ConsumerState<PickNameScreen> createState() => _PickNameScreenState();
}

class _PickNameScreenState extends ConsumerState<PickNameScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  late PickNameStateNotifier _notifier;

  @override
  void initState() {
    _notifier = ref.read(pickNameStateNotifierProvider.notifier);
    super.initState();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pickNameStateNotifierProvider);
    _observeError();
    _navToHomeAfterSave();

    return AppPage(body: Builder(builder: (context) {
      return Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 80),
                    Text(context.l10n.onboard_pick_name_title,
                        style: AppTextStyle.header1
                            .copyWith(color: context.colorScheme.textPrimary)),
                    const SizedBox(height: 40),
                    Text(
                        context.l10n.onboard_pick_name_hint_first_name
                            .toUpperCase(),
                        style: AppTextStyle.subtitle1.copyWith(
                            color: context.colorScheme.textSecondary)),
                    _nameTextField(_firstNameController, (value) {
                      _notifier.onFirstNameChanged(value ?? '');
                    }),
                    const SizedBox(height: 6),
                    Text(
                        context.l10n.onboard_pick_name_hint_last_name
                            .toUpperCase(),
                        style: AppTextStyle.subtitle1.copyWith(
                          color: context.colorScheme.textSecondary,
                        )),
                    _nameTextField(_lastNameController, (value) {
                      _notifier.onLastNameChanged(value ?? '');
                    }),
                  ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 30),
            child: PrimaryButton(
              context.l10n.common_next,
              enabled: state.enableBtn,
              progress: state.savingUser,
              onPressed: () {
                _notifier.saveUser();
              },
            ),
          )
        ],
      );
    }));
  }

  Widget _nameTextField(
      TextEditingController controller, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: CupertinoTextField(
        controller: controller,
        onChanged: onChanged,
        keyboardType: TextInputType.text,
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        style: AppTextStyle.subtitle2.copyWith(
          color: context.colorScheme.textPrimary,
        ),
        decoration: BoxDecoration(
            border: Border(
                bottom:
                    BorderSide(color: context.colorScheme.containerNormal))),
      ),
    );
  }

  void _navToHomeAfterSave() {
    ref.listen(pickNameStateNotifierProvider.select((value) => value.saved),
        (previous, next) {
      if (next) {
        AppRoute.home.go(context);
      }
    });
  }

  void _observeError() {
    ref.listen(pickNameStateNotifierProvider.select((state) => state.error), (previous, next) {
      if (next != null) {
        showErrorSnackBar(context, next.toString());
      }
    });
  }
}
