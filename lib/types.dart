import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

// String userId = "";
// String mode = "system";
StreamController<Map> router = StreamController<Map>.broadcast();
StreamSink<Map> get routerSink => router.sink;
Stream<Map> get routerStream => router.stream;

StreamController<String> theme = StreamController<String>.broadcast();
StreamSink<String> get themeSink => theme.sink;
Stream<String> get themeStream => theme.stream;

showMessage(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Text(message),
  );

  // Find the ScaffoldMessenger in the widget tree
  // and use it to show a SnackBar.
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

class Pallet {
  static Color primary = const Color(0xFF006D3C);
  static Color onPrimary = const Color(0xFFFFFFFF);
  static Color secondary = const Color(0xFF00696E);
  static Color onSecondary = const Color(0xFFFFFFFF);
  static Color background = const Color(0xFFFBFDF8);
  static Color onBackground = const Color(0xFF191C19);
  static Color error = const Color(0xFFBA1A1A);
  static Color onError = const Color(0xFFFFFFFF);
  static Color outline = const Color(0xFF717971);
  static Color outlineVariant = const Color(0xFFC0C9BF);
  static Color surfaceVariant = const Color(0xFFDDE5DB);
  static Color onSurfaceVariant = const Color(0xFF414942);
  static Color inverseSurface = const Color(0xFF2E312E);
  static Color onInverseSurface = const Color(0xFFF0F1EC);
  static Color surface1 = const Color(0xFFEEF6EF);
  static Color tonal = const Color(0x26006D3C);
  static Color primaryFill = const Color(0x336C897C);
  static Color secondaryFill = const Color(0x296C897C);
  static Color tertiaryFill = const Color(0x1F6C897C);
  static Color tintColor = Colors.grey;
  static Color shadowColor = const Color.fromRGBO(0, 0, 0, 0.30);
  static Color tertiaryLabel = const Color.fromRGBO(0, 0, 0, 0.30);
  static Brightness systemBrightness = Brightness.dark;

  static lightMode() {
    Pallet.primary = const Color(0xFF006D3C);
    Pallet.onPrimary = const Color(0xFFFFFFFF);
    Pallet.secondary = const Color(0xFF00696E);
    Pallet.onSecondary = const Color(0xFFFFFFFF);
    Pallet.background = const Color(0xFFFBFDF8);
    Pallet.onBackground = const Color(0xFF191C19);
    Pallet.error = const Color(0xFFBA1A1A);
    Pallet.onError = const Color(0xFFFFFFFF);
    Pallet.outline = const Color(0xFF717971);
    Pallet.outlineVariant = const Color(0xFFC0C9BF);
    Pallet.surfaceVariant = const Color(0xFFDDE5DB);
    Pallet.onSurfaceVariant = const Color(0xFF414942);
    Pallet.inverseSurface = const Color(0xFF2E312E);
    Pallet.onInverseSurface = const Color(0xFFF0F1EC);
    Pallet.surface1 = const Color(0xFFEEF6EF);
    Pallet.tonal = const Color(0x26006D3C);
    Pallet.primaryFill = const Color(0x336C897C);
    Pallet.secondaryFill = const Color(0x296C897C);
    Pallet.tertiaryFill = const Color(0x1F6C897C);
    Pallet.tintColor = Colors.grey;
    Pallet.shadowColor = const Color.fromRGBO(0, 0, 0, 0.30);
    Pallet.tertiaryLabel = const Color.fromRGBO(0, 0, 0, 0.30);

    Pallet.systemBrightness = Brightness.dark;

    themeSink.add("");
  }

  static darkMode() {
    Pallet.primary = const Color(0xFF30E287);
    Pallet.onPrimary = const Color(0xFF00391D);
    Pallet.secondary = const Color(0xFF36DAE3);
    Pallet.onSecondary = const Color(0xFF003739);
    Pallet.background = const Color(0xFF191C19);
    Pallet.onBackground = const Color(0xFFE1E3DE);
    Pallet.error = const Color(0xFFFFB4AB);
    Pallet.onError = const Color(0xFF690005);
    Pallet.outline = const Color(0xFF8B938A);
    Pallet.outlineVariant = const Color(0xFF414942);
    Pallet.surfaceVariant = const Color(0xFF414942);
    Pallet.onSurfaceVariant = const Color(0xFFC0C9BF);
    Pallet.inverseSurface = const Color(0xFFE1E3DE);
    Pallet.onInverseSurface = const Color(0xFF191C19);
    Pallet.surface1 = const Color(0xFF1A261F);
    Pallet.tonal = const Color(0x2630E287);
    Pallet.primaryFill = const Color(0x5C6C897C);
    Pallet.secondaryFill = const Color(0x526C897C);
    Pallet.tertiaryFill = const Color(0x3D6C897C);
    Pallet.tintColor = Colors.grey.shade300;
    Pallet.shadowColor = const Color.fromRGBO(255, 255, 255, 0.30);
    Pallet.tertiaryLabel = const Color.fromRGBO(235, 245, 241, 0.30);

    Pallet.systemBrightness = Brightness.light;

    themeSink.add("");
  }
}

class Style {
  static TextStyle largeTitle = GoogleFonts.beVietnamPro(
      fontSize: 34,
      letterSpacing: -0.4,
      height: 1.2,
      fontWeight: FontWeight.w400);
  static TextStyle largeTitleEmphasized = GoogleFonts.beVietnamPro(
      fontSize: 34,
      letterSpacing: -0.4,
      height: 1.2,
      fontWeight: FontWeight.w700);
  static TextStyle title1 = GoogleFonts.beVietnamPro(
      fontSize: 1.2,
      letterSpacing: -0.4,
      height: 34,
      fontWeight: FontWeight.w400);
  static TextStyle title1Emphasized = GoogleFonts.beVietnamPro(
      fontSize: 28,
      letterSpacing: -0.4,
      height: 1.2,
      fontWeight: FontWeight.w700);
  static TextStyle title2 = GoogleFonts.beVietnamPro(
      fontSize: 22,
      letterSpacing: -0.4,
      height: 1.27,
      fontWeight: FontWeight.w400);
  static TextStyle title2Emphasized = GoogleFonts.beVietnamPro(
      fontSize: 22,
      letterSpacing: -0.4,
      height: 1.27,
      fontWeight: FontWeight.w700);
  static TextStyle title3 = GoogleFonts.beVietnamPro(
      fontSize: 20,
      letterSpacing: -0.4,
      height: 1.25,
      fontWeight: FontWeight.w400);
  static TextStyle title3Emphasized = GoogleFonts.beVietnamPro(
      fontSize: 20,
      letterSpacing: -0.4,
      height: 1.25,
      fontWeight: FontWeight.w600);
  static TextStyle headline = GoogleFonts.beVietnamPro(
      fontSize: 17,
      letterSpacing: -0.4,
      height: 1.3,
      fontWeight: FontWeight.w600);
  static TextStyle headlineItalic = GoogleFonts.beVietnamPro(
      fontSize: 17,
      letterSpacing: -0.4,
      height: 1.3,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.italic);
  static TextStyle body = GoogleFonts.beVietnamPro(
      fontSize: 17,
      letterSpacing: -0.4,
      height: 1.3,
      fontWeight: FontWeight.w400);
  static TextStyle bodyEmphasized = GoogleFonts.beVietnamPro(
      fontSize: 17,
      letterSpacing: -0.4,
      height: 1.3,
      fontWeight: FontWeight.w600);
  static TextStyle bodyItalic = GoogleFonts.beVietnamPro(
      fontSize: 17,
      letterSpacing: -0.4,
      height: 1.3,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.italic);
  static TextStyle bodyEmphasizedItalic = GoogleFonts.beVietnamPro(
      fontSize: 17,
      letterSpacing: -0.4,
      height: 1.3,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.italic);
  static TextStyle callout = GoogleFonts.beVietnamPro(
      fontSize: 16,
      letterSpacing: -0.4,
      height: 1.3,
      fontWeight: FontWeight.w400);
  static TextStyle calloutEmphasized = GoogleFonts.beVietnamPro(
      fontSize: 16,
      letterSpacing: -0.4,
      height: 1.3,
      fontWeight: FontWeight.w600);
  static TextStyle calloutItalic = GoogleFonts.beVietnamPro(
      fontSize: 16,
      letterSpacing: -0.4,
      height: 1.3,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.italic);
  static TextStyle calloutEmphasizedItalic = GoogleFonts.beVietnamPro(
      fontSize: 16,
      letterSpacing: -0.4,
      height: 1.3,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.italic);
  static TextStyle subHeadline = GoogleFonts.beVietnamPro(
      fontSize: 15,
      letterSpacing: -0.4,
      height: 1.33,
      fontWeight: FontWeight.w400);
  static TextStyle subHeadlineEmphasized = GoogleFonts.beVietnamPro(
      fontSize: 15,
      letterSpacing: -0.4,
      height: 1.33,
      fontWeight: FontWeight.w600);
  static TextStyle subHeadlineItalic = GoogleFonts.beVietnamPro(
      fontSize: 15,
      letterSpacing: -0.4,
      height: 1.33,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.italic);
  static TextStyle subHeadlineEmphasizedItalic = GoogleFonts.beVietnamPro(
      fontSize: 15,
      letterSpacing: -0.4,
      height: 1.33,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.italic);
  static TextStyle footnote = GoogleFonts.beVietnamPro(
      fontSize: 13,
      letterSpacing: -0.4,
      height: 1.38,
      fontWeight: FontWeight.w400);
  static TextStyle footnoteEmphasized = GoogleFonts.beVietnamPro(
      fontSize: 13,
      letterSpacing: -0.4,
      height: 1.38,
      fontWeight: FontWeight.w600);
  static TextStyle footnoteItalic = GoogleFonts.beVietnamPro(
      fontSize: 13,
      letterSpacing: -0.4,
      height: 1.38,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.italic);
  static TextStyle footnoteEmphasizedItalic = GoogleFonts.beVietnamPro(
      fontSize: 13,
      letterSpacing: -0.4,
      height: 1.38,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.italic);
  static TextStyle caption1 = GoogleFonts.beVietnamPro(
      fontSize: 12,
      letterSpacing: -0.4,
      height: 1.33,
      fontWeight: FontWeight.w400);
  static TextStyle caption1Emphasized = GoogleFonts.beVietnamPro(
      fontSize: 12,
      letterSpacing: -0.4,
      height: 1.33,
      fontWeight: FontWeight.w500);
  static TextStyle caption1Italic = GoogleFonts.beVietnamPro(
      fontSize: 12,
      letterSpacing: -0.4,
      height: 1.33,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.italic);
  static TextStyle caption1EmphasizedItalic = GoogleFonts.beVietnamPro(
      fontSize: 12,
      letterSpacing: -0.4,
      height: 1.33,
      fontWeight: FontWeight.w500,
      fontStyle: FontStyle.italic);
  static TextStyle caption2 = GoogleFonts.beVietnamPro(
      fontSize: 11,
      letterSpacing: -0.4,
      height: 1.18,
      fontWeight: FontWeight.w400);
  static TextStyle caption2Emphasized = GoogleFonts.beVietnamPro(
      fontSize: 11,
      letterSpacing: -0.4,
      height: 1.18,
      fontWeight: FontWeight.w600);
  static TextStyle caption2Italic = GoogleFonts.beVietnamPro(
      fontSize: 11,
      letterSpacing: -0.4,
      height: 1.18,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.italic);
  static TextStyle caption2EmphasizedItalic = GoogleFonts.beVietnamPro(
      fontSize: 11,
      letterSpacing: -0.4,
      height: 1.18,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.italic);
  static const TextStyle ellipsisText =
      TextStyle(overflow: TextOverflow.ellipsis);
}
