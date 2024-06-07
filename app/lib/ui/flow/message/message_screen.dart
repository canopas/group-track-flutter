import 'package:data/api/space/space_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:style/button/primary_button.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:style/button/large_icon_button.dart';
import 'package:style/text/app_text_dart.dart';
import 'package:yourspace_flutter/domain/extenstions/context_extenstions.dart';
import 'package:yourspace_flutter/domain/extenstions/widget_extensions.dart';
import 'package:yourspace_flutter/ui/app_route.dart';
import 'package:yourspace_flutter/ui/components/app_page.dart';
import 'package:yourspace_flutter/ui/flow/message/message_view_model.dart';

import '../../../gen/assets.gen.dart';

class MessageScreen extends ConsumerStatefulWidget {
  final SpaceInfo spaceInfo;

  const MessageScreen({
    super.key,
    required this.spaceInfo,
  });

  @override
  ConsumerState createState() => _MessageScreenState();
}

class _MessageScreenState extends ConsumerState<MessageScreen> {
  late MessageViewNotifier notifier;

  @override
  void initState() {
    super.initState();
    runPostFrame(() {
      notifier = ref.watch(messageViewStateProvider.notifier);
      notifier.setSpace(widget.spaceInfo);
    });
  }

  @override
  Widget build(BuildContext context) {
    _observeInviteScreenNavigation();

    return AppPage(
      title: widget.spaceInfo.space.name,
      body: _body(context),
      floatingActionButton: widget.spaceInfo.members.length >= 2
      ? LargeIconButton(
        onTap: () {
          AppRoute.chat(
              users: widget.spaceInfo.members,
              spaceName: widget.spaceInfo.space.name
          ).push(context);
        },
        icon: Icon(
          Icons.add_rounded,
          color: context.colorScheme.onPrimary,
        ),
      )
      : null
    );
  }

  Widget _body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: _emptyView(context),
    );
  }
  
  Widget _emptyView(BuildContext context) {
    if (widget.spaceInfo.members.length >= 2) {
      return _emptyMessageView(context);
    } else {
      return _emptyMessageViewWith0Member(context);
    }
  }
 
  Widget _emptyMessageView(BuildContext context) {
    return Center(
      child: Text(
        context.l10n.message_tap_to_send_new_message_text,
        style: AppTextStyle.subtitle1.copyWith(
          color: context.colorScheme.textPrimary,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _emptyMessageViewWith0Member(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            Assets.images.icSendMessage,
            colorFilter: ColorFilter.mode(
              context.colorScheme.textPrimary,
              BlendMode.srcATop,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            context.l10n.message_add_member_to_send_message_title,
            style: AppTextStyle.header3.copyWith(
              color: context.colorScheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            context.l10n.message_add_member_to_send_message_subtitle,
            style: AppTextStyle.subtitle1.copyWith(
              color: context.colorScheme.textDisabled,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          PrimaryButton(
              context.l10n.message_add_new_member_title,
            onPressed: () => notifier.onAddNewMemberTap(),
          ),
        ],
      ),
    );
  }

  void _observeInviteScreenNavigation() {
    ref.listen(messageViewStateProvider.select((state) => state.spaceInvitationCode), (previous, next) {
      if (next.isNotEmpty) {
        AppRoute.inviteCode(code: next, spaceName: widget.spaceInfo.space.name).push(context);
      }
    });
  }
}
