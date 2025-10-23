import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:movie_chat/features/feedback/feedback_repository.dart';

final class FeedbackState extends Equatable {
  const FeedbackState({
    required this.isSubmitting,
    this.savedToken,
    this.successMessage,
    this.errorMessage,
  });

  final bool isSubmitting;
  final String? savedToken;
  final String? successMessage;
  final String? errorMessage;

  FeedbackState copyWith({
    bool? isSubmitting,
    String? savedToken,
    String? successMessage,
    String? errorMessage,
  }) {
    return FeedbackState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      savedToken: savedToken ?? this.savedToken,
      successMessage: successMessage,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    isSubmitting,
    savedToken,
    successMessage,
    errorMessage,
  ];
}

final class FeedbackStateHolder {
  FeedbackStateHolder({required this.repository}) {
    _init();
  }

  final FeedbackRepository repository;

  final state = ValueNotifier<FeedbackState>(
    const FeedbackState(isSubmitting: false),
  );

  void _init() async {
    final token = await repository.getSavedToken();
    state.value = state.value.copyWith(savedToken: token);
  }

  Future<void> submitFeedback(String comment) async {
    if (state.value.isSubmitting || comment.trim().isEmpty) return;

    state.value = state.value.copyWith(
      isSubmitting: true,
      successMessage: null,
      errorMessage: null,
    );

    try {
      await repository.submitFeedback(comment);
      final token = await repository.getSavedToken();
      state.value = state.value.copyWith(
        isSubmitting: false,
        savedToken: token,
        successMessage: 'Gracias! Tu comentario ha sido enviado.',
      );

      // Clear success message after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        if (state.value.successMessage != null) {
          state.value = state.value.copyWith(successMessage: null);
        }
      });
    } catch (e) {
      state.value = state.value.copyWith(
        isSubmitting: false,
        errorMessage:
            'Error al enviar el comentario. Por favor, intenta nuevamente.',
      );
    }
  }

  void clearMessages() {
    state.value = state.value.copyWith(
      successMessage: null,
      errorMessage: null,
    );
  }

  void dispose() {
    state.dispose();
  }
}
