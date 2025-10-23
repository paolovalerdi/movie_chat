import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:movie_chat/features/chat/chat_repository.dart';
import 'package:movie_chat/features/chat/models/chat_message.dart';
import 'package:movie_chat/features/llm/llm_service.dart';

final class ChatState extends Equatable {
  const ChatState({
    required this.messages,
    required this.isSendingMessage,
    this.errorMessage,
  });

  final List<ChatMessage> messages;
  final bool isSendingMessage;
  final String? errorMessage;

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isSendingMessage,
    String? errorMessage,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isSendingMessage: isSendingMessage ?? this.isSendingMessage,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [messages, isSendingMessage];
}

final class ChatStateHolder {
  ChatStateHolder({required this.repository}) {
    _init();
  }

  final ChatRepository repository;

  StreamSubscription? subscription;
  final state = ValueNotifier<ChatState>(
    const ChatState(messages: [], isSendingMessage: false),
  );

  void _init() {
    subscription = repository.streamMessages().listen((messages) {
      state.value = state.value.copyWith(messages: messages);
    });
  }

  void sendMessage(String message) async {
    if (state.value.isSendingMessage) return;
    try {
      state.value = state.value.copyWith(isSendingMessage: true);
      await repository.sendMessage(message);
      state.value = state.value.copyWith(isSendingMessage: false);
    } on LLMResponseException catch (e) {
      state.value = state.value.copyWith(
        isSendingMessage: false,
        errorMessage: e.message,
      );
    }
  }

  void dispose() {
    subscription?.cancel();
  }
}
