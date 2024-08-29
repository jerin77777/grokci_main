import 'dart:async';
import 'package:flutter/services.dart';
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

ThemeData lightMode = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
        primary: Color(0xFF006D3C),
        onPrimary: Color(0xFFFFFFFF),
        secondary: Color(0xFF00696E),
        onSecondary: Color(0xFFFFFFFF),
        surface: Color(0xFFFBFDF8),
        onSurface: Color(0xFF191C19),
        error: Color(0xFFBA1A1A),
        onError: Color(0xFFFFFFFF),
        outline: Color(0xFF717971),
        outlineVariant: Color(0xFFC0C9BF),
        surfaceContainerHighest: Color(0xFFDDE5DB),
        surfaceContainerHigh: Color(0x296C897C),
        surfaceContainer: Color(0x1F6C897C),
        onSurfaceVariant: Color(0xFF414942),
        inverseSurface: Color(0xFF2E312E),
        onInverseSurface: Color(0xFFF0F1EC),
        surfaceContainerLow: Color(0xFFEEF6EF),
        shadow: Color.fromRGBO(0, 0, 0, 0.30),
        secondaryContainer: Color(0x26006D3C),
        surfaceTint: Colors.grey,
        scrim: Color.fromRGBO(0, 0, 0, 0.30)),
    appBarTheme: AppBarTheme(
        color: Color(0xFFFBFDF8),
        elevation: 0,
        titleTextStyle: Style.title3.copyWith(color: Color(0xFF191C19)),
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Color(0xFFFBFDF8),
            systemNavigationBarColor: Color(0xFFFBFDF8),
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light)),

    navigationBarTheme: NavigationBarThemeData(
        surfaceTintColor: Colors.grey,
        indicatorColor: Color(0x26006D3C),
        backgroundColor: Color(0xFFFBFDF8),
        elevation: 0,
        labelTextStyle: WidgetStateProperty.resolveWith((state) {
          if (state.contains(WidgetState.selected)) {
            return Style.caption2Emphasized.copyWith(
              color: Color(0xFF006D3C)
            );
          }
          return Style.caption2Emphasized;
        }),
        iconTheme: WidgetStateProperty.resolveWith((state) {
          if (state.contains(WidgetState.selected)) {
            return const IconThemeData(
              color: Color(0xFF006D3C),
            );
          }
        })));

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true,
  colorScheme: ColorScheme.dark(
      primary: const Color(0xFF30E287),
      onPrimary: const Color(0xFF00391D),
      secondary: const Color(0xFF36DAE3),
      onSecondary: const Color(0xFF003739),
      surface: const Color(0xFF191C19),
      onSurface: const Color(0xFFE1E3DE),
      error: const Color(0xFFFFB4AB),
      onError: const Color(0xFF690005),
      outline: const Color(0xFF8B938A),
      outlineVariant: const Color(0xFF414942),
      surfaceContainerHighest: const Color(0xFF414942),
      surfaceContainerHigh: const Color(0x526C897C),
      surfaceContainer: const Color(0x3D6C897C),
      onSurfaceVariant: const Color(0xFFC0C9BF),
      inverseSurface: const Color(0xFFE1E3DE),
      onInverseSurface: const Color(0xFF191C19),
      surfaceContainerLow: const Color(0xFF1A261F),
      shadow: const Color.fromRGBO(255, 255, 255, 0.30),
      secondaryContainer: const Color(0x2630E287),
      surfaceTint: Colors.grey.shade300,
      scrim: const Color.fromRGBO(235, 245, 241, 0.30)),
  appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF191C19),
      elevation: 0,
      titleTextStyle: Style.title3.copyWith(color: const Color(0xFFE1E3DE)),
      systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Color(0xFF191C19),
          systemNavigationBarColor: Color(0xFF191C19),
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark)),

  navigationBarTheme: NavigationBarThemeData(
        surfaceTintColor: Colors.grey.shade300,
        indicatorColor: Color(0x2630E287),
        backgroundColor: Color(0xFF191C19),
        elevation: 0,
        labelTextStyle: WidgetStateProperty.resolveWith((state) {
          if (state.contains(WidgetState.selected)) {
            return Style.caption2Emphasized.copyWith(
              color: Color(0xFF30E287),
            );
          }
          return Style.caption2Emphasized;
        }),
        iconTheme: WidgetStateProperty.resolveWith((state) {
          if (state.contains(WidgetState.selected)) {
            return const IconThemeData(
              color: Color(0xFF30E287),
            );
          }
        }))
);

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
