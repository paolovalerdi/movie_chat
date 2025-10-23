import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class Toolbar extends StatelessWidget {
  const Toolbar({
    super.key,
    this.leading,
    required this.child,
    this.padding,
    this.trailing,
  });

  final Widget? leading;
  final Widget child;
  final Widget? trailing;
  final EdgeInsets? padding;

  factory Toolbar.navigation({required Widget child, Widget? trailing}) {
    return Toolbar(
      padding: const EdgeInsets.only(bottom: 2),
      leading: Builder(
        builder: (context) {
          return IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: Icon(LucideIcons.chevronLeft),
          );
        },
      ),
      trailing: trailing,
      child: DefaultTextStyle(
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: const Color(0xFF0F221C),
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (leading != null) leading!,
            Expanded(child: child),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
