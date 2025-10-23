import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:movie_chat/router/screens/account/feedback_state_holder.dart';
import 'package:movie_chat/service_locator.dart';
import 'package:movie_chat/widgets/toolbar.dart';
import 'package:movie_chat/widgets/widget_utils.dart';
import 'package:provider/provider.dart';

class FeedbackScreen extends HookWidget {
  const FeedbackScreen._();

  static Widget route() {
    return Provider(
      create: (context) => locator<FeedbackStateHolder>(),
      dispose: (context, holder) => holder.dispose(),
      child: FeedbackScreen._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final holder = context.read<FeedbackStateHolder>();
    final state = useValueListenable(holder.state);
    final controller = useTextEditingController();

    Future<void> handleSubmit() async {
      await holder.submitFeedback(controller.text);
      if (state.successMessage != null) {
        controller.clear();
      }
    }

    // Show error dialog when there's an error
    useEffect(() {
      if (state.errorMessage != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: Text('Error'),
              content: Text(state.errorMessage!),
              actions: [
                CupertinoDialogAction(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.pop(context);
                    holder.clearMessages();
                  },
                ),
              ],
            ),
          );
        });
      }
      return null;
    }, [state.errorMessage]);

    return CupertinoPageScaffold(
      child: Column(
        children: [
          Toolbar.navigation(child: Text('Comentarios')),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Nos encantaría escuchar tus comentarios!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Comparte tus ideas, sugerencias o reporta cualquier problema.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 24),
                  Container(
                    decoration: textFieldDecoration,
                    child: CupertinoTextField(
                      controller: controller,
                      placeholder: 'Escribe tu comentario aquí...',
                      placeholderStyle: TextStyle(
                        color: Colors.white.withValues(alpha: 0.4),
                      ),
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      maxLines: 10,
                      minLines: 10,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(),
                      enabled: !state.isSubmitting,
                    ),
                  ),
                  SizedBox(height: 16),
                  CupertinoButton.filled(
                    onPressed: state.isSubmitting ? null : handleSubmit,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: state.isSubmitting
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CupertinoActivityIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'Enviar comentario',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                  if (state.successMessage != null) ...[
                    SizedBox(height: 16),
                    _SuccessMessage(message: state.successMessage!),
                  ],
                  if (state.savedToken != null) ...[
                    SizedBox(height: 16),
                    _TokenCard(token: state.savedToken!),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TokenCard extends StatelessWidget {
  const _TokenCard({required this.token});

  final String token;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        shape: RoundedSuperellipseBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: [
          Row(
            spacing: 8,
            children: [
              Icon(LucideIcons.key, color: Color(0xFF2D9D78), size: 20),
              Text(
                'Token',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(12),
            decoration: ShapeDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              shape: RoundedSuperellipseBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
              ),
            ),
            child: Text(
              token,
              style: TextStyle(color: Color(0xFF2D9D78), fontSize: 14),
            ),
          ),
          Text(
            'Este token confirma tu comentario. Está guardado de manera segura en tu dispositivo.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _SuccessMessage extends StatelessWidget {
  const _SuccessMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: Colors.green.withValues(alpha: 0.2),
        shape: RoundedSuperellipseBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.green.withValues(alpha: 0.4)),
        ),
      ),
      child: Row(
        spacing: 12,
        children: [
          Icon(LucideIcons.circleCheck, color: Colors.green, size: 24),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
