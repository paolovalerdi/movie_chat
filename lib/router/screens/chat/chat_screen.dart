import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:movie_chat/router/router.dart';
import 'package:movie_chat/router/screens/chat/chat_state_holder.dart';
import 'package:movie_chat/router/screens/chat/widgets/composer.dart';
import 'package:movie_chat/router/screens/chat/widgets/message_bubble.dart';
import 'package:movie_chat/service_locator.dart';
import 'package:movie_chat/widgets/app_logo.dart';
import 'package:movie_chat/widgets/toolbar.dart';
import 'package:movie_chat/widgets/widget_utils.dart';
import 'package:provider/provider.dart';

class ChatScreen extends HookWidget {
  const ChatScreen._();

  static Widget route() {
    return Provider(
      create: (context) => locator<ChatStateHolder>(),
      child: ChatScreen._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final holder = context.read<ChatStateHolder>();
    final state = useValueListenable(holder.state);

    return CupertinoPageScaffold(
      child: Column(
        children: [
          Toolbar(
            padding: EdgeInsets.fromLTRB(16, 8, 10, 8),
            trailing: Row(
              spacing: 8,
              children: [
                GestureDetector(
                  onTap: () => gotoWatchlist(context),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(LucideIcons.clapperboard),
                  ),
                ),
                GestureDetector(
                  onTap: () => gotoFeedback(context),
                  child: Icon(LucideIcons.messageCircleHeart),
                ),
              ],
            ),
            child: AppLogo(),
          ),
          Expanded(child: ChatList(state)),
          Composer(
            isLoading: state.isSendingMessage,
            onMessageSent: holder.sendMessage,
          ),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget ChatList(ChatState state) {
    if (state.messages.isEmpty) {
      return const Center(child: Text('No messages yet'));
    }

    final builders = <WidgetBuilder>[
      if (state.isSendingMessage)
        (_) => KeyedSubtree(
          key: ValueKey('sending_message'),
          child: MessageBubble.asAnimatedPlaceholder(),
        ),
      for (final message in state.messages)
        (_) => MessageBubble(message: message),
    ];

    return ListView.separated(
      padding: EdgeInsets.fromLTRB(16, 64, 16, 16),
      itemCount: builders.length,
      reverse: true,
      separatorBuilder: separator(height: 20),
      itemBuilder: (context, index) => builders[index](context),
    );
  }
}
