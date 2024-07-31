import 'dart:async';

import 'package:flutter/material.dart';
import 'package:grokci_main/globals.dart';

// String userId = "";
String mode = "system";
StreamController<Map> router = StreamController<Map>.broadcast();
StreamSink<Map> get routerSink => router.sink;
Stream<Map> get routerStream => router.stream;
showMessage(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Text(message),
  );

  // Find the ScaffoldMessenger in the widget tree
  // and use it to show a SnackBar.
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

class Pallet {
  static Color primary = isDark ? Color(0xFF30E287) : Color(0xFF006D3C);
  static Color onPrimary = isDark ? Color(0xFF00391D) : Color(0xFFFFFFFF);
  static Color secondary = isDark ? Color(0xFF36DAE3) : Color(0xFF00696E);
  static Color onSecondary = isDark ? Color(0xFF003739) : Color(0xFFFFFFFF);
  static Color background = isDark ? Color(0xFF191C19) : Color(0xFFFBFDF8);
  static Color onBackground = isDark ? Color(0xFFE1E3DE) : Color(0xFF191C19);
  static Color error = isDark ? Color(0xFFFFB4AB) : Color(0xFFBA1A1A);
  static Color onError = isDark ? Color(0xFF690005) : Color(0xFFFFFFFF);
  static Color outline = isDark ? Color(0xFF8B938A) : Color(0xFF717971);
  static Color outlineVariant = isDark ? Color(0xFF414942) : Color(0xFFC0C9BF);
  static Color surfaceVariant = isDark ? Color(0xFF414942) : Color(0xFFDDE5DB);
  static Color onSurfaceVariant =
      isDark ? Color(0xFFC0C9BF) : Color(0xFF414942);
  static Color inverseSurface = isDark ? Color(0xFFE1E3DE) : Color(0xFF2E312E);
  static Color onInverseSurface =
      isDark ? Color(0xFF191C19) : Color(0xFFF0F1EC);
  static Color surface1 = isDark ? Color(0xFF1A261F) : Color(0xFFEEF6EF);
  static Color tonal = isDark ? Color(0x2630E287) : Color(0x26006D3C);
  static Color primaryFill = isDark ? Color(0x5C6C897C) : Color(0x336C897C);
  static Color secondaryFill = isDark ? Color(0x526C897C) : Color(0x296C897C);
  static Color tertiaryFill = isDark ? Color(0x3D6C897C) : Color(0x1F6C897C);
  static Color tintColor = isDark ? Colors.grey.shade300 : Colors.grey;
  static Color shadowColor = isDark
      ? Color.fromRGBO(255, 255, 255, 0.30)
      : Color.fromRGBO(0, 0, 0, 0.30);
  static Color tertiaryLabel = isDark
      ? Color.fromRGBO(235, 245, 241, 0.30)
      : Color.fromRGBO(60, 67, 64, 0.30);
}

class Style {
  static const TextStyle largeTitle = TextStyle(
      fontSize: 34,
      letterSpacing: -0.4,
      height: 41,
      fontWeight: FontWeight.w400);
  static const TextStyle largeTitleEmphasized = TextStyle(
      fontSize: 34,
      letterSpacing: -0.4,
      height: 41,
      fontWeight: FontWeight.w700);
  static const TextStyle title1 = TextStyle(
      fontSize: 28,
      letterSpacing: -0.4,
      height: 34,
      fontWeight: FontWeight.w400);
  static const TextStyle title1Emphasized = TextStyle(
      fontSize: 28,
      letterSpacing: -0.4,
      height: 34,
      fontWeight: FontWeight.w700);
  static const TextStyle title2 = TextStyle(
      fontSize: 22,
      letterSpacing: -0.4,
      height: 28,
      fontWeight: FontWeight.w400);
  static const TextStyle title2Emphasized = TextStyle(
      fontSize: 22,
      letterSpacing: -0.4,
      height: 28,
      fontWeight: FontWeight.w700);
  static const TextStyle title3 = TextStyle(
      fontSize: 20,
      letterSpacing: -0.4,
      height: 25,
      fontWeight: FontWeight.w400);
  static const TextStyle title3Emphasized = TextStyle(
      fontSize: 20,
      letterSpacing: -0.4,
      height: 25,
      fontWeight: FontWeight.w600);
  static const TextStyle headline = TextStyle(
      fontSize: 17,
      letterSpacing: -0.4,
      height: 22,
      fontWeight: FontWeight.w600);
  static const TextStyle headlineItalic = TextStyle(
      fontSize: 17,
      letterSpacing: -0.4,
      height: 22,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.italic);
  static const TextStyle body = TextStyle(
      fontSize: 17,
      letterSpacing: -0.4,
      height: 22,
      fontWeight: FontWeight.w400);
  static const TextStyle bodyEmphasized = TextStyle(
      fontSize: 17,
      letterSpacing: -0.4,
      height: 22,
      fontWeight: FontWeight.w600);
  static const TextStyle bodyItalic = TextStyle(
      fontSize: 17,
      letterSpacing: -0.4,
      height: 22,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.italic);
  static const TextStyle bodyEmphasizedItalic = TextStyle(
      fontSize: 17,
      letterSpacing: -0.4,
      height: 22,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.italic);
  static const TextStyle callout = TextStyle(
      fontSize: 16,
      letterSpacing: -0.4,
      height: 21,
      fontWeight: FontWeight.w400);
  static const TextStyle calloutEmphasized = TextStyle(
      fontSize: 16,
      letterSpacing: -0.4,
      height: 21,
      fontWeight: FontWeight.w600);
  static const TextStyle calloutItalic = TextStyle(
      fontSize: 16,
      letterSpacing: -0.4,
      height: 21,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.italic);
  static const TextStyle calloutEmphasizedItalic = TextStyle(
      fontSize: 16,
      letterSpacing: -0.4,
      height: 21,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.italic);
  static const TextStyle subHeadline = TextStyle(
      fontSize: 15,
      letterSpacing: -0.4,
      height: 20,
      fontWeight: FontWeight.w400);
  static const TextStyle subHeadlineEmphasized = TextStyle(
      fontSize: 15,
      letterSpacing: -0.4,
      height: 20,
      fontWeight: FontWeight.w600);
  static const TextStyle subHeadlineItalic = TextStyle(
      fontSize: 15,
      letterSpacing: -0.4,
      height: 20,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.italic);
  static const TextStyle subHeadlineEmphasizedItalic = TextStyle(
      fontSize: 15,
      letterSpacing: -0.4,
      height: 20,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.italic);
  static const TextStyle footnote = TextStyle(
      fontSize: 13,
      letterSpacing: -0.4,
      height: 18,
      fontWeight: FontWeight.w400);
  static const TextStyle footnoteEmphasized = TextStyle(
      fontSize: 13,
      letterSpacing: -0.4,
      height: 18,
      fontWeight: FontWeight.w600);
  static const TextStyle footnoteItalic = TextStyle(
      fontSize: 13,
      letterSpacing: -0.4,
      height: 18,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.italic);
  static const TextStyle footnoteEmphasizedItalic = TextStyle(
      fontSize: 13,
      letterSpacing: -0.4,
      height: 18,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.italic);
  static const TextStyle caption1 = TextStyle(
      fontSize: 12,
      letterSpacing: -0.4,
      height: 16,
      fontWeight: FontWeight.w400);
  static const TextStyle caption1Emphasized = TextStyle(
      fontSize: 12,
      letterSpacing: -0.4,
      height: 16,
      fontWeight: FontWeight.w500);
  static const TextStyle caption1Italic = TextStyle(
      fontSize: 12,
      letterSpacing: -0.4,
      height: 16,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.italic);
  static const TextStyle caption1EmphasizedItalic = TextStyle(
      fontSize: 12,
      letterSpacing: -0.4,
      height: 16,
      fontWeight: FontWeight.w500,
      fontStyle: FontStyle.italic);
  static const TextStyle caption2 = TextStyle(
      fontSize: 11,
      letterSpacing: -0.4,
      height: 13,
      fontWeight: FontWeight.w400);
  static const TextStyle caption2Emphasized = TextStyle(
      fontSize: 11,
      letterSpacing: -0.4,
      height: 13,
      fontWeight: FontWeight.w600);
  static const TextStyle caption2Italic = TextStyle(
      fontSize: 11,
      letterSpacing: -0.4,
      height: 13,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.italic);
  static const TextStyle caption2EmphasizedItalic = TextStyle(
      fontSize: 11,
      letterSpacing: -0.4,
      height: 13,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.italic);
  static const TextStyle ellipsisText =
      TextStyle(overflow: TextOverflow.ellipsis);
}
