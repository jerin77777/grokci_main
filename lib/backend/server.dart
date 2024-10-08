// import 'dart:js_interop';

import 'dart:convert';
import 'dart:math';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
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

// delivery states picking, delivering, completed
// order states delivering, delivered, payed
// all database details used from here

class AppConfig {
  static String endpoint = "***";
  static String project = "***";
  static String database = "***";
  static String keys = "***";

  static String mapKey = "*";
  static String geoCode = "*";
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
  static String notifications = "*";
  static String support = "*";
  static String feedback = "*";
}

class Bucket {
  static String categories = "6650a1990032c806f041";
  static String products = "66432daf000dc57d6cf0";
}

setKeys() async {
  DocumentList temp2 = await db.listDocuments(
      databaseId: AppConfig.database, collectionId: AppConfig.keys);

  Map keys = jsonDecode(getResult(temp2.documents).first["keys"]);
  print(keys);

  AppConfig.mapKey = keys["mapKey"];
  AppConfig.geoCode = keys["geoCode"];
  AppConfig.orders = keys["orders"];
  AppConfig.products = keys["products"];
  AppConfig.orderProductMap = keys["orderProductMap"];
  AppConfig.drivers = keys["drivers"];
  AppConfig.users = keys["users"];
  AppConfig.categories = keys["categories"];
  AppConfig.warehouses = keys["warehouses"];
  AppConfig.promotions = keys["promotions"];
  AppConfig.monthlyPicks = keys["monthlyPicks"];
  AppConfig.cart = keys["cart"];
  AppConfig.address = keys["address"];
  AppConfig.notifications = keys["notifications"];
  AppConfig.support = keys["support"];
  AppConfig.feedback = keys["feedback"];
  print("keys set");
  print(AppConfig.users);
}

class Auth {
  final _authtoken = sharedPreferences?.getString("authToken");

  Future<String> sendOtp(phoneNumber, BuildContext context) async {
    Client client = Client();
    Functions functions = Functions(client);

    client.setEndpoint(AppConfig.endpoint).setProject(AppConfig.project);

    try {
      final result = await functions.createExecution(
        functionId: "66d9de7a002bd5bea60b",
        body: '{"mobileNumber": "$phoneNumber"}',
      );

      // Parse the response
      final responseData = jsonDecode(result.responseBody);

      if (responseData["success"] == true) {
        sharedPreferences?.setString("authToken", responseData["token"]);
        showMessage(context, "OTP sent successfully!");
        return responseData["data"]["data"]['verificationId'];
      } else {
        showMessage(context, "Unable to send OTP. Please try again!");
        return "";
      }
    } catch (e) {
      showMessage(context, "Unable to send OTP. Try again later!");
      return "";
    }
  }

  Future<String> verifyOTP(
      String? verificationId, String otpCode, BuildContext context) async {
    Client client = Client();
    Functions functions = Functions(client);

    client.setEndpoint(AppConfig.endpoint).setProject(AppConfig.project);

    final result = await functions.createExecution(
      functionId: '66d9e7f700103761e48e',
      body:
          '{"token": "$_authtoken", "verificationId": "$verificationId", "otpCode": "$otpCode"}',
    );

    final responseData = jsonDecode(result.responseBody);

    if (responseData["success"] == true) {
      return responseData["data"]["message"];
    } else {
      showMessage(context, "Please Enter correct OTP!");
      return "";
    }
  }
}

createAccount(
  context,
  String phoneNumber,
  String userName,
) async {
  debugPrint(phoneNumber);
  var doc = await db.createDocument(
      databaseId: AppConfig.database,
      collectionId: AppConfig.users,
      documentId: phoneNumber,
      data: {
        "userName": userName,
        "phoneNumber": phoneNumber,
      });
  sharedPreferences!.setString("phone", phoneNumber);
  Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (context) => Home()));
}

login(context, phoneNumber) async {
  try {
    Document temp = await db.getDocument(
        databaseId: AppConfig.database,
        collectionId: AppConfig.users,
        documentId: phoneNumber);

    sharedPreferences!.setString("phone", phoneNumber);
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => Home()));
  } catch (e) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SignUp(
              phoneNumber: phoneNumber,
            )));
  }
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
    queries: [
      Query.equal("deleted", false),
      if (limit != null) Query.limit(limit)
    ],
  );
  result = getResult(temp.documents);
  return result;
}

getProducts(categoryId) async {
  List<Map> products = [];

  DocumentList result = await db.listDocuments(
      databaseId: AppConfig.database,
      collectionId: AppConfig.products,
      queries: [
        Query.equal("categoryId", categoryId),
      ]);

  products = getResult(result.documents);

  return products;
}

Future<List<Map>> searchProducts(String search) async {
  List<Map> result = [];
  DocumentList temp = await db.listDocuments(
      databaseId: AppConfig.database,
      collectionId: AppConfig.products,
      queries: [
        Query.search("name", search),
      ]);
  result = getResult(temp.documents);
  return result;
}

Future<Map> getProduct(String productId) async {
  Document temp = await db.getDocument(
      databaseId: AppConfig.database,
      collectionId: AppConfig.products,
      documentId: productId);
  return getResult([temp])[0];
}

Future<List> getAddresses() async {
  String userId = sharedPreferences!.get("phone").toString();

  DocumentList temp = await db.listDocuments(
      databaseId: AppConfig.database,
      collectionId: AppConfig.address,
      queries: [
        Query.equal("userId", userId),
      ]);
  return getResult(temp.documents);
}

getCartProductIds() async {
  String userId = sharedPreferences!.get("phone").toString();

  List<String> productIds = [];
  DocumentList products = await db.listDocuments(
      databaseId: AppConfig.database,
      collectionId: AppConfig.cart,
      queries: [Query.equal("userId", userId)]);

  for (var product in products.documents) {
    productIds.add(product.data["productId"]);
  }
  return productIds;
  //  getResult(products.documents);
}

getQty(String productId) async {
  String userId = sharedPreferences!.get("phone").toString();

  DocumentList products = await db.listDocuments(
      databaseId: AppConfig.database,
      collectionId: AppConfig.cart,
      queries: [
        Query.equal("userId", userId),
        Query.equal("productId", productId)
      ]);

  return getResult(products.documents)[0]["qty"];
}

getAddress() async {
  String userId = sharedPreferences!.get("phone").toString();
  List<Map> result = [];

  DocumentList address = await db.listDocuments(
      databaseId: AppConfig.database,
      collectionId: AppConfig.address,
      queries: [Query.equal("userId", userId), Query.equal("selected", true)]);
  result = getResult(address.documents);
  if (result.isEmpty) {
    return {"address": "Select Address"};
  }
  return result[0];
}

getWareHouse() async {
  List<Map> result = [];
  DocumentList warehouse = await db.listDocuments(
    databaseId: AppConfig.database,
    collectionId: AppConfig.warehouses,
  );
  result = getResult(warehouse.documents);
  return result[0];
}

getBag() async {
  String userId = sharedPreferences!.get("phone").toString();

  List<Map> result = [];
  DocumentList products = await db.listDocuments(
      databaseId: AppConfig.database,
      collectionId: AppConfig.cart,
      queries: [
        Query.equal("userId", userId),
        Query.equal("saveForLater", false)
      ]);
  result = getResult(products.documents);

  return result;
}

getSaveForLater() async {
  String userId = sharedPreferences!.get("phone").toString();

  List<Map> result = [];
  DocumentList products = await db.listDocuments(
      databaseId: AppConfig.database,
      collectionId: AppConfig.cart,
      queries: [
        Query.equal("userId", userId),
        Query.equal("saveForLater", true)
      ]);

  result = getResult(products.documents);
  return result;
}

addToBag(String productId) async {
  String userId = sharedPreferences!.get("phone").toString();

  DocumentList product = await db.listDocuments(
      databaseId: AppConfig.database,
      collectionId: AppConfig.cart,
      queries: [
        Query.equal("userId", userId),
        Query.equal("productId", productId),
        Query.equal("saveForLater", false)
      ]);
  if (product.documents.isEmpty) {
    db.createDocument(
        databaseId: AppConfig.database,
        collectionId: AppConfig.cart,
        documentId: Uuid().v4(),
        data: {
          "userId": userId,
          "productId": productId,
        });
  }
}

clearBag() async {
  String userId = sharedPreferences!.get("phone").toString();
  DocumentList cart = await db.listDocuments(
      databaseId: AppConfig.database,
      collectionId: AppConfig.cart,
      queries: [
        Query.equal("userId", userId),
        Query.equal("saveForLater", false)
      ]);

  for (var product in cart.documents) {
    await db.deleteDocument(
        databaseId: AppConfig.database,
        collectionId: AppConfig.cart,
        documentId: product.$id);
  }
}

updateBag(String productId, int qty) async {
  String userId = sharedPreferences!.get("phone").toString();
  DocumentList product = await db.listDocuments(
      databaseId: AppConfig.database,
      collectionId: AppConfig.cart,
      queries: [
        Query.equal("userId", userId),
        Query.equal("productId", productId)
      ]);
  if (qty == 0) {
    db.deleteDocument(
        databaseId: AppConfig.database,
        collectionId: AppConfig.cart,
        documentId: product.documents.first.$id);
  } else {
    db.updateDocument(
        databaseId: AppConfig.database,
        collectionId: AppConfig.cart,
        documentId: product.documents.first.$id,
        data: {"qty": qty});
  }
}

saveForLater(String productId, bool saveForLater) async {
  String userId = sharedPreferences!.get("phone").toString();

  DocumentList product = await db.listDocuments(
      databaseId: AppConfig.database,
      collectionId: AppConfig.cart,
      queries: [
        Query.equal("userId", userId),
        Query.equal("productId", productId)
      ]);
  await db.updateDocument(
      databaseId: AppConfig.database,
      collectionId: AppConfig.cart,
      documentId: product.documents.first.$id,
      data: {"saveForLater": saveForLater});
}

getOrders() async {
  String userId = sharedPreferences!.get("phone").toString();
  List<Map> result = [];

  DocumentList temp = await db.listDocuments(
      databaseId: AppConfig.database,
      collectionId: AppConfig.orders,
      queries: [
        Query.equal("userId", userId),
      ]);

  result = getResult(temp.documents);
  return result;
}

getOrderProducts(String orderId) async {
  List<Map> result = [];

  DocumentList temp = await db.listDocuments(
      databaseId: AppConfig.database,
      collectionId: AppConfig.orderProductMap,
      queries: [
        Query.equal("orderId", orderId),
      ]);

  result = getResult(temp.documents);
  return result;
}

getSupport() async {
  String userId = sharedPreferences!.get("phone").toString();

  List<Map> result = [];

  DocumentList temp = await db.listDocuments(
      databaseId: AppConfig.database,
      collectionId: AppConfig.support,
      queries: [
        Query.equal("userId", userId),
      ]);

  result = getResult(temp.documents);

  return result;
}

getFeedBack() async {
  String userId = sharedPreferences!.get("phone").toString();

  List<Map> result = [];

  DocumentList temp = await db.listDocuments(
      databaseId: AppConfig.database,
      collectionId: AppConfig.feedback,
      queries: [
        Query.equal("userId", userId),
      ]);

  result = getResult(temp.documents);

  return result;
}

getNotifications() async {
  String userId = sharedPreferences!.get("phone").toString();

  List<Map> result = [];

  DocumentList temp = await db.listDocuments(
      databaseId: AppConfig.database,
      collectionId: AppConfig.notifications,
      queries: [
        Query.equal("userId", userId),
      ]);

  result = getResult(temp.documents);

  return result;
}

saveThemeType(String value) {
  if (value == "Light") {
    themeMode = ThemeMode.light;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: lightMode.colorScheme.surface,
      systemNavigationBarColor: lightMode.colorScheme.surface,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));
  } else if (value == "Dark") {
    themeMode = ThemeMode.dark;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: darkMode.colorScheme.surface,
      systemNavigationBarColor: darkMode.colorScheme.surface,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ));
  } else {
    themeMode = ThemeMode.system;
    Brightness _brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: _brightness == Brightness.dark
          ? darkMode.colorScheme.surface
          : lightMode.colorScheme.surface,
      systemNavigationBarColor: _brightness == Brightness.dark
          ? darkMode.colorScheme.surface
          : lightMode.colorScheme.surface,
      statusBarIconBrightness:
          _brightness == Brightness.dark ? Brightness.light : Brightness.dark,
      systemNavigationBarIconBrightness:
          _brightness == Brightness.dark ? Brightness.light : Brightness.dark,
      statusBarBrightness: _brightness,
    ));
  }
  themeSink.add("");

  return sharedPreferences!.setString("theme", value);
}

getThemeType() {
  return sharedPreferences!.get("theme");
}

saveBag(List bag) {
  return sharedPreferences!.setString("bag", jsonEncode(bag));
}

List getBagLocal() {
  if (sharedPreferences!.get("bag") != null) {
    return jsonDecode(sharedPreferences!.get("bag").toString());
  } else {
    return [];
  }
}

saveAddress(List address) {
  return sharedPreferences!.setString("address", jsonEncode(address));
}

List getAddressLocal() {
  if (sharedPreferences!.get("address") != null) {
    return jsonDecode(sharedPreferences!.get("address").toString());
  } else {
    return [];
  }
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
