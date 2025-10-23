import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          WidgetSpan(
            child: Transform.translate(
              offset: Offset(0, -3),
              child: Icon(LucideIcons.popcorn, size: 26, color: Colors.white),
            ),
            alignment: PlaceholderAlignment.middle,
          ),
          TextSpan(
            text: " CineBot",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class CupertinoColors {}
