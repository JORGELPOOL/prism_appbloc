import 'package:flutter/material.dart';
import 'app.dart';

void main() {
  // Surface layout/build errors as visible red text instead of leaving
  // that part of the screen silently blank — this is how we caught the
  // "stretch inside an unbounded-height scroll view" crash in the stat
  // card row. Safe to keep in for the rest of development.
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Container(
      color: const Color(0xFF3B0A0A),
      padding: const EdgeInsets.all(12),
      alignment: Alignment.topLeft,
      child: Text(
        details.exceptionAsString(),
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  };

  runApp(const PrismAdminApp());
}
