import 'package:data/api/auth/auth_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:style/text/app_text_dart.dart';
import 'package:yourspace_flutter/domain/extenstions/context_extenstions.dart';
import 'package:yourspace_flutter/domain/extenstions/widget_extensions.dart';
import 'package:yourspace_flutter/ui/components/app_page.dart';
import 'package:yourspace_flutter/ui/flow/message/chat/chat_view_model.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final List<ApiUserInfo> users;
  final String spaceName;

  const ChatScreen({
    super.key,
    required this.users,
    required this.spaceName,
  });

  @override
  ConsumerState createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  late ChatViewNotifier notifier;
  final Set<String> _selectedUsers = {};

  @override
  void initState() {
    super.initState();
    runPostFrame(() {
      notifier = ref.watch(chatViewStateProvider.notifier);
      notifier.setData(widget.users);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: context.l10n.chat_start_new_chat_title,
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    final state = ref.watch(chatViewStateProvider);
    return _memberSelectionView(context, state);
  }

  Widget _memberSelectionView(BuildContext context, ChatViewState state) {
    return Container(
      height: 112,
      decoration:
          BoxDecoration(color: context.colorScheme.containerLowOnSurface),
      child: Row(
        children: [
          const SizedBox(width: 16),
          _allItem(context),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: state.users.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final isSelected =
                    _selectedUsers.contains(state.users[index].user.id);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedUsers.remove(state.users[index].user.id);
                      } else {
                        _selectedUsers.add(state.users[index].user.id);
                      }
                    });
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 24),
                    child: Column(
                      children: [
                        if (isSelected) ...[
                          _selectedView(context),
                        ] else ... [
                          _profileImageView(context, state.users[index].user),
                        ],
                        const SizedBox(height: 8),
                        Text(
                          state.users[index].user.first_name ?? '',
                          style: AppTextStyle.caption
                              .copyWith(color: context.colorScheme.textPrimary),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _allItem(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedUsers.clear();
          });
        },
        child: Column(
          children: [
            if (_selectedUsers.isEmpty) ...[
              _selectedView(context),
            ] else ...[
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: context.colorScheme.primary,
                  ),
                ),
                child: Center(
                  child: Text(
                    'All',
                    style: AppTextStyle.subtitle2
                        .copyWith(color: context.colorScheme.primary),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              widget.spaceName,
              style: AppTextStyle.caption
                  .copyWith(color: context.colorScheme.textPrimary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _selectedView(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: context.colorScheme.positive,
      ),
      child: Icon(Icons.check_rounded, color: context.colorScheme.textPrimary,),
    );
  }

  Widget _profileImageView(BuildContext context, ApiUser user) {
    // final profileImageUrl = member.user.profile_image ?? '';
    final firstLetter = user.userNameFirstLetter;

    return SizedBox(
      width: 40,
      height: 40,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: //profileImageUrl.isNotEmpty
            //     ? CachedNetworkImage(
            //   imageUrl: profileImageUrl,
            //   placeholder: (context, url) => const AppProgressIndicator(
            //       size: AppProgressIndicatorSize.small),
            //   fit: BoxFit.cover,
            // )
            //     :
            Container(
          color: context.colorScheme.primary,
          child: Center(
            child: Text(firstLetter,
                style: AppTextStyle.header3
                    .copyWith(color: context.colorScheme.textPrimary)),
          ),
        ),
      ),
    );
  }

}
