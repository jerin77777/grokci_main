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
  static Color background = isDark ? Color(0xff191c19) : Color(0xfffbfdf8);
  static Color secondary = isDark ? Color(0xff26DAE3) : Color(0xff00696E);
  static Color font1 = isDark ? Colors.white : Colors.black;
  static Color font2 =
      isDark ? Color.fromARGB(255, 216, 224, 217) : Color(0xFF434b44);
  static Color font3 =
      isDark ? Color.fromARGB(255, 211, 211, 211) : Color(0xFF999999);
  static Color fontInner = Colors.white;

  static Color inner1 =
      isDark ? Color(0xff6C897C) : Color(0xFFeaefe9);
  static Color inner2 =
      isDark ? Color.fromARGB(255, 22, 23, 22) : Color(0xFFdee8e1);
  static Color shadow = Color(0xFFeaefe9);
  static Color divider = Colors.grey[300]!;
}

class Style {
  static TextStyle h1 = TextStyle(fontSize: 25, fontWeight: FontWeight.w800);
  static TextStyle h2 = TextStyle(fontSize: 18, fontWeight: FontWeight.w800);
  static TextStyle h3 = TextStyle(fontSize: 15, fontWeight: FontWeight.w700);
  static TextStyle h4 = TextStyle(fontSize: 14, fontWeight: FontWeight.w700);
  static TextStyle ellipsisText =
      TextStyle(color: Pallet.font3, overflow: TextOverflow.ellipsis);
}
