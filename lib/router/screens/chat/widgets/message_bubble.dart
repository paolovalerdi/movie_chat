import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:movie_chat/features/chat/models/chat_message.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    this.asAnimatedPlaceholder = false,
  });

  factory MessageBubble.asAnimatedPlaceholder() {
    return MessageBubble(
      message: ChatMessage(
        content: '',
        role: ChatMessageRole.llm,
        timestamp: DateTime.now(),
      ),
      asAnimatedPlaceholder: true,
    );
  }

  final ChatMessage message;
  final bool asAnimatedPlaceholder;

  @override
  Widget build(BuildContext context) {
    final children = [
      Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.25),
          shape: BoxShape.circle,
        ),
      ),
      SizedBox(width: 12),
      Expanded(
        child: Align(
          alignment: message.role == ChatMessageRole.llm
              ? Alignment.centerLeft
              : Alignment.centerRight,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 4,
            crossAxisAlignment: switch (message.role) {
              ChatMessageRole.llm => CrossAxisAlignment.start,
              ChatMessageRole.user => CrossAxisAlignment.end,
            },
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  switch (message.role) {
                    ChatMessageRole.llm => 'CineBot',
                    ChatMessageRole.user => 'Paolo',
                  },
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 14,
                  ),
                ),
              ),
              Container(
                    decoration: ShapeDecoration(
                      color: switch (message.role) {
                        ChatMessageRole.llm => Color(0xFF2C2C2C),
                        ChatMessageRole.user => Color(0xFF1D9963),
                      },
                      shape: RoundedSuperellipseBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(
                            message.role == ChatMessageRole.llm ? 0 : 14,
                          ),
                          topRight: Radius.circular(
                            message.role == ChatMessageRole.user ? 0 : 14,
                          ),
                          bottomLeft: Radius.circular(14),
                          bottomRight: Radius.circular(14),
                        ),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: asAnimatedPlaceholder
                        ? Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Pensando... ',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.6),
                                    fontSize: 16,
                                  ),
                                ),
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child:
                                      Icon(
                                            LucideIcons.sparkles,
                                            size: 16,
                                            color: Colors.white.withValues(
                                              alpha: 0.6,
                                            ),
                                          )
                                          .animate(
                                            autoPlay: asAnimatedPlaceholder,
                                            onComplete: (controller) {
                                              controller.repeat();
                                            },
                                          )
                                          .shake(
                                            hz: 3,
                                            duration: 650.ms,
                                            curve: Curves.easeInOut,
                                          ),
                                ),
                              ],
                            ),
                          )
                        : Text(
                            message.content,
                            textAlign: switch (message.role) {
                              ChatMessageRole.llm => TextAlign.left,
                              ChatMessageRole.user => TextAlign.right,
                            },
                            style: const TextStyle(color: Colors.white),
                          ),
                  )
                  .animate(
                    autoPlay: asAnimatedPlaceholder,
                    onComplete: (controller) {
                      if (!asAnimatedPlaceholder) return;

                      controller.repeat();
                    },
                  )
                  .shimmer(
                    color: Color(0xFF1D9963).withValues(alpha: 0.15),
                    duration: 1.seconds,
                    curve: Curves.easeInOut,
                  ),
              if (!asAnimatedPlaceholder)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  child: Text(
                    displayDateTimeText(message.timestamp),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.35),
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: switch (message.role) {
        ChatMessageRole.llm => children,
        ChatMessageRole.user => [...children.reversed],
      },
    );
  }

  String displayDateTimeText(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    return '$day/$month $hour:$minute';
  }
}
