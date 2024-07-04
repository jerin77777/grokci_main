import 'dart:async';

import 'package:flutter/material.dart';

String userId = "";

StreamController<Map> router = StreamController<Map>.broadcast();
StreamSink<Map> get routerSink => router.sink;
Stream<Map> get routerStream => router.stream;

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
  static TextStyle h3 = TextStyle(fontWeight: FontWeight.w700);
}

Map googlePayConfig = {
  "provider": "google_pay",
  "data": {
    "environment": "TEST",
    "apiVersion": 2,
    "apiVersionMinor": 0,
    "allowedPaymentMethods": [
      {
        "type": "CARD",
        "tokenizationSpecification": {
          "type": "PAYMENT_GATEWAY",
          "parameters": {
            "gateway": "example",
            "gatewayMerchantId": "gatewayMerchantId"
          }
        },
        "parameters": {
          "allowedCardNetworks": ["VISA", "MASTERCARD"],
          "allowedAuthMethods": ["PAN_ONLY", "CRYPTOGRAM_3DS"],
          "billingAddressRequired": true,
          "billingAddressParameters": {
            "format": "FULL",
            "phoneNumberRequired": true
          }
        }
      }
    ],
    "merchantInfo": {
      "merchantId": "01234567890123456789",
      "merchantName": "Example Merchant Name"
    },
    "transactionInfo": {
      "countryCode": "US",
      "currencyCode": "USD"
    }
  }
};
