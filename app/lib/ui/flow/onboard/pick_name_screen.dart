import 'package:data/api/auth/auth_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:style/button/bottom_sticky_overlay.dart';
import 'package:style/button/primary_button.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:style/text/app_text_dart.dart';
import 'package:style/text/app_text_field.dart';
import 'package:yourspace_flutter/domain/extenstions/context_extenstions.dart';
import 'package:yourspace_flutter/ui/app_route.dart';
import 'package:yourspace_flutter/ui/components/app_page.dart';
import 'package:yourspace_flutter/ui/components/error_snakebar.dart';
import 'package:yourspace_flutter/ui/flow/onboard/pick_name_view_model.dart';

class PickNameScreen extends ConsumerStatefulWidget {
  final ApiUser? user;
  const PickNameScreen({super.key, this.user});

  @override
  ConsumerState<PickNameScreen> createState() => _PickNameScreenState();
}

class _PickNameScreenState extends ConsumerState<PickNameScreen> {
  late PickNameStateNotifier _notifier;

  @override
  void initState() {
    _notifier = ref.read(pickNameStateNotifierProvider.notifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pickNameStateNotifierProvider);
    _observeError();
    _navToConnectionScreen();

    return AppPage(body: Builder(builder: (context) {
      return Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
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
              _nameTextField(state.firstName),
              const SizedBox(height: 6),
              Text(
                  context.l10n.onboard_pick_name_hint_last_name
                      .toUpperCase(),
                  style: AppTextStyle.subtitle1.copyWith(
                    color: context.colorScheme.textSecondary,
                  )),
              _nameTextField(state.lastName),
            ],
          ),
          BottomStickyOverlay(
            child: PrimaryButton(
              context.l10n.common_next,
              enabled: state.enableBtn,
              progress: state.savingUser,
              onPressed: () {
                _notifier.saveUser(widget.user ?? _notifier.user!);
              },
            ),
          )
        ],
      );
    }));
  }

  Widget _nameTextField(TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: AppTextField(
        controller: controller,
        onChanged: (value) => _notifier.enableNextButton(),
        keyboardType: TextInputType.text,
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        style: AppTextStyle.subtitle2.copyWith(
          color: context.colorScheme.textPrimary,
        ),
        borderType: AppTextFieldBorderType.underline,
      ),
    );
  }

  void _navToConnectionScreen() {
    ref.listen(pickNameStateNotifierProvider.select((value) => value.saved),
        (previous, next) {
      if (next) {
        AppRoute.connection.go(context);
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
