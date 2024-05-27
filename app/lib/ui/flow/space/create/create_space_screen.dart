import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:style/animation/on_tap_scale.dart';
import 'package:style/button/primary_button.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:style/text/app_text_dart.dart';
import 'package:yourspace_flutter/domain/extenstions/context_extenstions.dart';
import 'package:yourspace_flutter/ui/app_route.dart';
import 'package:yourspace_flutter/ui/components/app_page.dart';
import 'package:yourspace_flutter/ui/flow/space/create/create_space_view_model.dart';
import 'package:style/button/bottom_sticky_overlay.dart';

class CreateSpace extends ConsumerStatefulWidget {
  const CreateSpace({super.key});

  @override
  ConsumerState createState() => _CreateSpaceState();
}

class _CreateSpaceState extends ConsumerState<CreateSpace> {
  late CreateSpaceViewNotifier notifier;

  void _observeNavigation(CreateSpaceViewState state) {
    ref.listen(createSpaceViewStateProvider.select((state) => state.invitationCode),
        (_, next) {
      if (next.isNotEmpty) {
        AppRoute.inviteCode(
            code: next, spaceName: state.spaceName.text).push(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    notifier = ref.read(createSpaceViewStateProvider.notifier);
    final state = ref.watch(createSpaceViewStateProvider);
    _observeNavigation(state);

    return AppPage(
      title: '',
      body: SafeArea(
        child: _body(context, state),
      ),
    );
  }

  Widget _body(BuildContext context, CreateSpaceViewState state) {
    return Stack(children: [
      ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 8),
          Text(
            context.l10n.create_space_give_your_space_name_title,
            style: AppTextStyle.header4
                .copyWith(color: context.colorScheme.textPrimary),
          ),
          const SizedBox(height: 16),
          Text(
            context.l10n.create_space_tip_text,
            style: AppTextStyle.body1
                .copyWith(color: context.colorScheme.textDisabled),
          ),
          const SizedBox(height: 24),
          _textField(context, state),
          const SizedBox(height: 30),
          _suggestion(context, state),
        ],
      ),
      _nextButton(context, state),
    ]);
  }

  Widget _textField(BuildContext context, CreateSpaceViewState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.create_space_name_title,
          style: AppTextStyle.caption.copyWith(
            color: context.colorScheme.textDisabled,
          ),
        ),
        Material(
          type: MaterialType.transparency,
          child: TextField(
            controller: state.spaceName,
            decoration: InputDecoration(
              focusedBorder: _border(context, true),
              enabledBorder: _border(context, false),
            ),
            onTapOutside: (event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            onChanged: (text) {
              notifier.onChange(text);
            },
            style: AppTextStyle.subtitle2
                .copyWith(color: context.colorScheme.textPrimary),
          ),
        ),
      ],
    );
  }

  UnderlineInputBorder _border(BuildContext context, bool focused) {
    return UnderlineInputBorder(
      borderSide: BorderSide(
        color:
            focused ? context.colorScheme.primary : context.colorScheme.outline,
        width: 1,
      ),
    );
  }

  Widget _suggestion(BuildContext context, CreateSpaceViewState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.create_space_some_suggestion_title,
          style: AppTextStyle.caption
              .copyWith(color: context.colorScheme.textDisabled),
        ),
        const SizedBox(height: 16),
        _suggestionList(context, state),
      ],
    );
  }

  Widget _suggestionList(BuildContext context, CreateSpaceViewState state) {
    final List<String> suggestions = [
      context.l10n.create_space_suggestion_family_text,
      context.l10n.create_space_suggestion_friends_text,
      context.l10n.create_space_suggestion_special_someone_text,
      context.l10n.create_space_suggestion_siblings_text,
      context.l10n.create_space_suggestion_office_squad_text,
      context.l10n.create_space_suggestion_colleagues_text,
      context.l10n.create_space_suggestion_team_unity_text,
      context.l10n.create_space_suggestion_my_squad_text,
      context.l10n.create_space_suggestion_heart_mates_text,
      context.l10n.create_space_suggestion_blood_bond_text
    ];

    return Wrap(
      alignment: WrapAlignment.start,
      spacing: 8,
      children: suggestions.map((element) {
        return OnTapScale(
          onTap: () {
            notifier.updateSelectedNudgeMessage(element);
          },
          child: Chip(
            label: Text(element,
                style: AppTextStyle.body2.copyWith(
                    color: state.selectedSpaceName == element
                        ? context.colorScheme.onPrimary
                        : context.colorScheme.textSecondary)),
            labelPadding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            backgroundColor: state.selectedSpaceName == element
                ? context.colorScheme.primary
                : context.colorScheme.containerLowOnSurface,
            side: const BorderSide(color: Colors.transparent),
          ),
        );
      }).toList(),
    );
  }

  Widget _nextButton(BuildContext context, CreateSpaceViewState state) {
    return BottomStickyOverlay(
      child: PrimaryButton(
        context.l10n.common_next,
        onPressed: () {
          notifier.createSpace();
        },
        enabled: state.allowSave || state.selectedSpaceName.isNotEmpty,
        progress: state.isCreating,
      ),
    );
  }
}
