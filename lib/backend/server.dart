// import 'dart:js_interop';

import 'dart:convert';
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

// delivery states picking, delivering, completed
// order states delivering, delivered, payed
// all database details used from here

class AppConfig {
  static String endpoint = "***";
  static String project = "***";
  static String mapKey = "***";
  static String geoCode = "***";
  static String database = "***";
  static String orders = "***";
  static String products = "***";
  static String orderProductMap = "***";
  static String drivers = "***";
  static String users = "***";
  static String categories = "***";
  static String warehouses = "***";
  static String promotions = "***";
  static String monthlyPicks = "***";
  static String cart = "***";
  static String address = "***";
  static String notifications = "***";
  static String support = "***";
  static String feedback = "***";
}

class Bucket {
  static String categories = "***";
  static String products = "***";
}

createAccount(
  context,
  String phoneNumber,
  String userName,
) async {
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

  Future<String> verifyOTP(String? verificationId, String otpCode, BuildContext context) async {
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
