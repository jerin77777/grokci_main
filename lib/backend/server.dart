// import 'dart:js_interop';

import 'dart:math';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twilio_flutter/twilio_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../main.dart';
import '../screens/login.dart';
import '../types.dart';
// import 'package:grokci/main.dart';
// import 'package:grokci/screens/login.dart';
// import 'package:twilio_flutter/twilio_flutter.dart';
// import 'package:localstorage/localstorage.dart';
import 'dart:io' as fl;
import 'package:path/path.dart';

late Databases db;
late Account account;
late Storage storage;
late BuildContext mainContext;
SharedPreferences? sharedPreferences;
// final LocalStorage local = LocalStorage('grokci');

// late TwilioFlutter twilioFlutter;

// delivery states picking, delivering, completed
// order states delivering, delivered, payed
// all database details used from here
class AppConfig {
  static String endpoint = "*";
  static String project = "*";
  static String mapKey = "*";
  static String database = "*";
  static String orders = "*";
  static String products = "*";
  static String orderProductMap = "*";
  static String drivers = "*";
  static String users = "*";
  static String categories = "*";
  static String warehouses = "*";
  static String promotions = "*";
  static String monthlyPicks = "*";
  static String cart = "*";
  static String address = "*";

  static String twilloSid = "*";
  static String twilloToken = "*";
  static String twilloNumber = "*";
}

class Bucket {
  static String categories = "6650a1990032c806f041";
  static String products = "66432daf000dc57d6cf0";
}

createAccount(
  context,
  String phoneNumber,
  String userName,
  String language,
) async {
  var doc = await db
      .createDocument(databaseId: AppConfig.database, collectionId: AppConfig.users, documentId: phoneNumber, data: {
    "userName": userName,
    "phoneNumber": phoneNumber,
    "language": language,
  });
  sharedPreferences!.setString("phone", phoneNumber);
  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home()));
}

login(context, phoneNumber) async {
  try {
    Document temp =
        await db.getDocument(databaseId: AppConfig.database, collectionId: AppConfig.users, documentId: phoneNumber);

    sharedPreferences!.setString("phone", phoneNumber);
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home()));
  } catch (e) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SignUp(
              phoneNumber: phoneNumber,
            )));
  }
}

Future<int> sendOtp(phoneNumber) async {
  TwilioFlutter twilioFlutter = TwilioFlutter(
      accountSid: AppConfig.twilloSid, authToken: AppConfig.twilloToken, twilioNumber: AppConfig.twilloNumber);

  final Random _random = Random();
  int _otp = 1000 + _random.nextInt(9000);
  await twilioFlutter.sendSMS(toNumber: "+91 ${phoneNumber}", messageBody: "your one time otp is: ${_otp}");
  return _otp;
}

getMonthlyPicks() async {
  List<Map> result = [];

  DocumentList temp = await db.listDocuments(
    databaseId: AppConfig.database,
    collectionId: AppConfig.monthlyPicks,
    queries: [],
  );
  // print(temp.documents.first.data["categories"].runtimeType);
  // db.getDocument(databaseId: AppConfig.database, collectionId: AppConfig.categories, documentId: documentId)
  DocumentList temp2 = await db.listDocuments(
    databaseId: AppConfig.database,
    collectionId: AppConfig.categories,
    queries: [Query.equal("\$id", temp.documents.first.data["categories"])],
  );
  result = getResult(temp2.documents);

  return result;
}

getCategories({int? limit}) async {
  List<Map> result = [];
  DocumentList temp = await db.listDocuments(
    databaseId: AppConfig.database,
    collectionId: AppConfig.categories,
    queries: [Query.equal("deleted", false), if (limit != null) Query.limit(limit)],
  );
  result = getResult(temp.documents);
  return result;
}

getProducts(categoryId) async {
  List<Map> products = [];

  DocumentList result =
      await db.listDocuments(databaseId: AppConfig.database, collectionId: AppConfig.products, queries: [
    Query.equal("categoryId", categoryId),
  ]);

  products = getResult(result.documents);

  return products;
}

Future<List<Map>> searchProducts(String search) async {
  List<Map> result = [];
  DocumentList temp =
      await db.listDocuments(databaseId: AppConfig.database, collectionId: AppConfig.products, queries: [
    Query.search("name", search),
  ]);
  result = getResult(temp.documents);
  print(result);
  return result;
}

Future<Map> getProduct(String productId) async {
  Document temp =
      await db.getDocument(databaseId: AppConfig.database, collectionId: AppConfig.products, documentId: productId);
  return getResult([temp])[0];
}

Future<List> getAddresses() async {
  DocumentList temp = await db.listDocuments(databaseId: AppConfig.database, collectionId: AppConfig.address, queries: [
    Query.equal("userId", userId),
  ]);
  return getResult(temp.documents);
}

getBag() async {
  List<Map> result = [];
  DocumentList products = await db.listDocuments(
      databaseId: AppConfig.database,
      collectionId: AppConfig.cart,
      queries: [Query.equal("userId", userId), Query.equal("saveForLater", false)]);
  result = getResult(products.documents);
  return result;
}

getSaveForLater() async {
  List<Map> result = [];
  DocumentList products = await db.listDocuments(
      databaseId: AppConfig.database,
      collectionId: AppConfig.cart,
      queries: [Query.equal("userId", userId), Query.equal("saveForLater", true)]);
  result = getResult(products.documents);
  return result;
}

addToBag(String productId) async {
  DocumentList product = await db.listDocuments(databaseId: AppConfig.database, collectionId: AppConfig.cart, queries: [
    Query.equal("userId", userId),
    Query.equal("productId", productId),
    Query.equal("saveForLater", false)
  ]);
  if (product.documents.isEmpty) {
    db.createDocument(databaseId: AppConfig.database, collectionId: AppConfig.cart, documentId: Uuid().v4(), data: {
      "userId": userId,
      "productId": productId,
    });
  }
}

updateBag(String productId, int qty) async {
  DocumentList product = await db.listDocuments(
      databaseId: AppConfig.database,
      collectionId: AppConfig.cart,
      queries: [Query.equal("userId", userId), Query.equal("productId", productId)]);
  if (qty == 0) {
    db.deleteDocument(
        databaseId: AppConfig.database, collectionId: AppConfig.cart, documentId: product.documents.first.$id);
  } else {
    db.updateDocument(
        databaseId: AppConfig.database,
        collectionId: AppConfig.cart,
        documentId: product.documents.first.$id,
        data: {"qty": qty});
  }
}

saveForLater(String productId, bool saveForLater) async {
  DocumentList product = await db.listDocuments(
      databaseId: AppConfig.database,
      collectionId: AppConfig.cart,
      queries: [Query.equal("userId", userId), Query.equal("productId", productId)]);
  await db.updateDocument(
      databaseId: AppConfig.database,
      collectionId: AppConfig.cart,
      documentId: product.documents.first.$id,
      data: {"saveForLater": saveForLater});
}

List<Map> getResult(List<Document> documents) {
  List<Map> result = [];

  for (var doc in documents) {
    doc.data["id"] = doc.$id;
    result.add(doc.data);
  }
  return result;
}

String getUrl(String bucketId, String imageId) {
  print("imaaageeeeee " + imageId);
  return "https://cloud.appwrite.io/v1/storage/buckets/${bucketId}/files/${imageId}/view?project=grokci&mode=admin";
}
