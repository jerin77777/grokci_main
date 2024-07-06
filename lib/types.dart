import 'dart:async';

import 'package:flutter/material.dart';

// String userId = "";

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
  static Color primary2 = Color(0xFF30E287);
  static Color primary = Color(0xFF006D3C);
  static Color background = Colors.white;

  static Color font1 = Colors.black;
  static Color font2 = Color(0xFF434b44);
  static Color font3 = Color(0xFF999999);
  static Color fontInner = Colors.white;

  static Color inner1 = Color(0xFFeaefe9);
  static Color inner2 = Color(0xFFdee8e1);
  static Color shadow = Color(0xFFeaefe9);
}

class Style {
  static TextStyle h1 = TextStyle(fontSize: 25, fontWeight: FontWeight.w800);
  static TextStyle h2 = TextStyle(fontSize: 18, fontWeight: FontWeight.w800);
  static TextStyle h3 = TextStyle(fontSize: 15, fontWeight: FontWeight.w700);
  static TextStyle h4 = TextStyle(fontSize: 14, fontWeight: FontWeight.w700);
}
