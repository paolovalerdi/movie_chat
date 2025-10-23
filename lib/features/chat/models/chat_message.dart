import 'package:equatable/equatable.dart';

enum ChatMessageRole { llm, user }

final class ChatMessage extends Equatable {
  final String content;
  final ChatMessageRole role;
  final DateTime timestamp;

  const ChatMessage({
    required this.content,
    required this.role,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'role': role.index,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      content: json['content'],
      role: ChatMessageRole.values[json['role']],
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
    );
  }

  @override
  List<Object?> get props => [content, role, timestamp];
}
