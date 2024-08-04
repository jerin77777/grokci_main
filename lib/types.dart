import 'dart:async';

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
  static Color primary = Color(0xFF006D3C);
  static Color background = Color(0xfffbfdf8);
  static Color secondary = Color(0xff00696E);
  static Color font1 = Colors.black;
  static Color font2 = Color(0xFF434b44);
  static Color font3 = Color(0xFF999999);
  static Color fontInner = Colors.white;

  static Color inner1 = Color(0xFFeaefe9);
  static Color inner2 = Color(0xFFdee8e1);
  static Color shadow = Color(0xFFeaefe9);
  static Color divider = Colors.grey[300]!;

  static lightMode() {
    Pallet.primary = Color(0xFF006D3C);
    Pallet.background = Color(0xfffbfdf8);
    Pallet.secondary = Color(0xff00696E);
    Pallet.font1 = Colors.black;
    Pallet.font2 = Color(0xFF434b44);
    Pallet.font3 = Color(0xFF999999);
    Pallet.fontInner = Colors.white;

    Pallet.inner1 = Color(0xFFeaefe9);
    Pallet.inner2 = Color(0xFFdee8e1);
    Pallet.shadow = Color(0xFFeaefe9);
    Pallet.divider = Colors.grey[300]!;

    themeSink.add("");
  }


  static darkMode() {
    Pallet.primary = Color(0xFF30E287);
    Pallet.background = Color(0xff191c19);
    Pallet.secondary = Color(0xff26DAE3);
    Pallet.font1 = Colors.white;
    
    Pallet.font2 = Color.fromARGB(255, 149, 172, 152);
    Pallet.font3 = Color.fromARGB(255, 211, 211, 211);
    Pallet.fontInner = Colors.white;

    Pallet.inner1 = Color(0xff6C897C);
    Pallet.inner2 = Color.fromARGB(255, 22, 23, 22);
    Pallet.shadow = Color(0xFFeaefe9);
    Pallet.divider = Colors.grey[300]!;

    themeSink.add("");
  }
}

class Style {
  static TextStyle h1 = TextStyle(fontSize: 25, fontWeight: FontWeight.w800);
  static TextStyle h2 = TextStyle(fontSize: 18, fontWeight: FontWeight.w800);
  static TextStyle h3 = TextStyle(fontSize: 15, fontWeight: FontWeight.w700);
  static TextStyle h4 = TextStyle(fontSize: 14, fontWeight: FontWeight.w700);
  static TextStyle ellipsisText =
      TextStyle(color: Pallet.font3, overflow: TextOverflow.ellipsis);
}
