import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class Composer extends HookWidget {
  const Composer({
    super.key,
    required this.isLoading,
    required this.onMessageSent,
  });

  final bool isLoading;
  final ValueChanged<String> onMessageSent;

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    String text() => controller.text.trim();

    final sendMessage = useCallback(() {
      if (text().isEmpty) return;
      onMessageSent(text());
      controller.clear();
    });

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.1), width: 1),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: SafeArea(
        top: false,
        child: Row(
          spacing: 8,
          children: [
            Expanded(
              child: AnimatedOpacity(
                opacity: isLoading ? 0.25 : 1,
                duration: const Duration(milliseconds: 550),
                curve: Curves.easeInOut,
                child: Container(
                  decoration: ShapeDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    shape: RoundedSuperellipseBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: CupertinoTextField(
                    controller: controller,
                    placeholder: "Escribe tu mensaje...",
                    enabled: !isLoading,
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(color: Colors.transparent),
                    placeholderStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ),
            ),
            ListenableBuilder(
              listenable: controller,
              builder: (_, _) {
                final enabled = !isLoading && text().isNotEmpty;
                return GestureDetector(
                  onTap: sendMessage,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 550),
                    curve: Curves.easeInOut,
                    padding: EdgeInsets.all(8),
                    decoration: ShapeDecoration(
                      color: enabled
                          ? Color(0xFF1D9963)
                          : Colors.white.withValues(alpha: 0.1),
                      shape: RoundedSuperellipseBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: AnimatedOpacity(
                      opacity: enabled ? 1 : 0.5,
                      duration: const Duration(milliseconds: 550),
                      curve: Curves.easeInOut,
                      child: Icon(
                        LucideIcons.send,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
