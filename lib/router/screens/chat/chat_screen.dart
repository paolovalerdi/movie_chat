import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:movie_chat/router/screens/chat/chat_state_holder.dart';
import 'package:movie_chat/router/screens/chat/widgets/composer.dart';
import 'package:movie_chat/router/screens/chat/widgets/message_bubble.dart';
import 'package:movie_chat/service_locator.dart';
import 'package:movie_chat/widgets/widget_utils.dart';
import 'package:provider/provider.dart';

class ChatScreen extends HookWidget {
  ChatScreen._();

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
      backgroundColor: const Color(0xFF0F221C),
      child: Column(
        children: [
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
