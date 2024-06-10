import 'package:cached_network_image/cached_network_image.dart';
import 'package:data/api/auth/auth_models.dart';
import 'package:data/api/message/message_models.dart';
import 'package:data/api/space/space_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:style/button/primary_button.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:style/button/large_icon_button.dart';
import 'package:style/indicator/progress_indicator.dart';
import 'package:style/text/app_text_dart.dart';
import 'package:yourspace_flutter/domain/extenstions/context_extenstions.dart';
import 'package:yourspace_flutter/domain/extenstions/date_formatter.dart';
import 'package:yourspace_flutter/domain/extenstions/widget_extensions.dart';
import 'package:yourspace_flutter/ui/app_route.dart';
import 'package:yourspace_flutter/ui/components/app_page.dart';
import 'package:yourspace_flutter/ui/components/error_snakebar.dart';
import 'package:yourspace_flutter/ui/flow/message/message_view_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../gen/assets.gen.dart';
import '../../components/alert.dart';

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
      notifier.listenThreads(widget.spaceInfo.space.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(messageViewStateProvider);
    _observeInviteScreenNavigation();
    _observeError();

    return AppPage(
      title: widget.spaceInfo.space.name,
      body: _body(context, state),
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

  Widget _body(BuildContext context, MessageViewState state) {
    if (state.loading) {
      return const Center(child: AppProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: state.threadInfo.isEmpty
          ? _emptyView(context)
          : _list(context, state.threadInfo),
    );
  }

  Widget _list(BuildContext context, List<ThreadInfo> threads) {
    return ListView.builder(
      itemCount: threads.length,
      itemBuilder: (context, index) {
        final thread = threads[index];
        final members = thread.members.where((member) => member.user.id != notifier.currentUser?.id).toList();
        final displayedMembers = members.take(2).toList();
        final isLastItem = index == threads.length - 1;
        final date = thread.threadMessage.isNotEmpty ? thread.threadMessage.last.created_at : null;
        final hasUnreadMessage = thread.threadMessage
            .any((message) => message.seen_by.contains(notifier.currentUser?.id));

        return Slidable(
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) {
                  _onDeleteTap(() {
                    notifier.deleteThread(thread.thread);
                    threads.removeAt(index);
                  });
                },
                backgroundColor: context.colorScheme.alert,
                foregroundColor: context.colorScheme.textPrimaryDark,
                icon: Icons.delete_outline_rounded,
                label: 'Delete',
              ),
            ],
          ),
          child: Column(
            children: [
              _threadItem(
                context: context,
                members: members,
                displayedMembers: displayedMembers,
                message: thread.threadMessage.isNotEmpty
                    ? thread.threadMessage.last.message ?? ''
                    : '',
                date: date ?? DateTime.now(),
                hasUnreadMessage: hasUnreadMessage,
              ),
              if (!isLastItem) ...[
                const SizedBox(height: 4),
                _divider(context)
              ],
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _threadItem({
    required BuildContext context,
    required List<ApiUserInfo> members,
    required List<ApiUserInfo> displayedMembers,
    required String message,
    required DateTime date,
    required bool hasUnreadMessage,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _threadProfile(context, members),
        const SizedBox(width: 16),
        Expanded(child: _threadNamesAndMessage(context: context, members: members, displayedMembers: displayedMembers, message: message)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              date.format(context, DateFormatType.pastTime),
              style: AppTextStyle.caption.copyWith(
                color: context.colorScheme.textDisabled,
              ),
            ),
            const SizedBox(height: 12),
            if (!hasUnreadMessage) ...[
              Container(
                height: 8,
                width: 8,
                decoration: BoxDecoration(
                  color: context.colorScheme.positive,
                  borderRadius: BorderRadius.circular(4),
                ),
              )
            ],
          ],
        ),
      ],
    );
  }

  Widget _divider(BuildContext context) {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        color: context.colorScheme.outline,
      ),
    );
  }

  Widget _threadNamesAndMessage({
    required BuildContext context,
    required List<ApiUserInfo> members,
    required List<ApiUserInfo> displayedMembers,
    required String message,
  }) {
    final remainingCount = members.length - displayedMembers.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            for (var i = 0; i < displayedMembers.length; i++)
              Row(
                children: [
                  Text(
                    displayedMembers[i].user.first_name ?? '',
                    style: AppTextStyle.subtitle2.copyWith(
                      color: context.colorScheme.textPrimary,
                    ),
                  ),
                  if (i != displayedMembers.length - 1)
                    Text(', ', style: AppTextStyle.subtitle2.copyWith(color: context.colorScheme.textPrimary)),
                ],
              ),
            if (remainingCount > 0)
              Text(
                ' + $remainingCount',
                style: AppTextStyle.subtitle2.copyWith(
                  color: context.colorScheme.textPrimary,
                ),
              ),
          ],
        ),
        Text(
          message,
          style: AppTextStyle.caption.copyWith(
            color: context.colorScheme.textDisabled,
          ),
        )
      ],
    );
  }

  Widget _threadProfile(BuildContext context, List<ApiUserInfo> members) {
    if (members.length == 1) {
      return _profileImageView(context, members[0], size: 50);
    } else {
      return SizedBox(
        width: 56,
        height: 56,
        child: Stack(
          children: [
            for (var i = 0; i < (members.length > 2 ? 2 : members.length); i++)
              Positioned(
                left: i * 16.0,
                child: _profileImageView(
                    context,
                    members[i],
                    size: 40,
                    isMoreMember: members.length > 2 && i == 1,
                    count: members.length - 2),
              ),
          ],
        ),
      );
    }
  }

  Widget _profileImageView(BuildContext context, ApiUserInfo member,
      {required double size, bool isMoreMember = false, int count = 0}) {
    final profileImageUrl = member.user.profile_image ?? '';
    final firstLetter = member.user.userNameFirstLetter;

    return SizedBox(
      width: size,
      height: size,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: isMoreMember
            ? Container(
                color: context.colorScheme.primary,
                child: Center(
                  child: Text(count > 0 ? '+$count' : '',
                      style: AppTextStyle.subtitle2
                          .copyWith(color: context.colorScheme.textPrimary)),
                ),
              )
            : profileImageUrl.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: profileImageUrl,
                    placeholder: (context, url) => const AppProgressIndicator(
                        size: AppProgressIndicatorSize.small),
                    fit: BoxFit.cover,
                  )
                : Container(
                    color: context.colorScheme.primary,
                    child: Center(
                      child: Text(firstLetter,
                          style: AppTextStyle.subtitle2.copyWith(
                              color: context.colorScheme.textPrimary)),
                    ),
                  ),
      ),
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

  void _observeError() {
    ref.listen(messageViewStateProvider.select((state) => state.error), (previous, next) {
      if (next != null) {
        showErrorSnackBar(context, next.toString());
      }
    });
  }

  void _onDeleteTap(Function() onTap) {
    showConfirmation(
        context,
        confirmBtnText: context.l10n.common_delete,
        title: context.l10n.message_delete_thread_title,
        message: context.l10n.message_delete_thread_subtitle,
        onConfirm: () => onTap(),
    );
  }
}
