import 'package:flutter/material.dart';

IndexedWidgetBuilder separator({double? width, double? height}) {
  return (_, __) => SizedBox(width: width, height: height);
}

// ignore: non_constant_identifier_names
final textFieldDecoration = ShapeDecoration(
  color: Colors.white.withValues(alpha: 0.15),
  shape: RoundedSuperellipseBorder(
    borderRadius: BorderRadius.circular(12),
    side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
  ),
);
