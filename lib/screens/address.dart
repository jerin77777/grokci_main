import 'dart:convert';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import '../backend/server.dart';
import '../types.dart';
import '../widgets.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

Future<void> saveAddress(BuildContext context, Map address) async {
  String userId = sharedPreferences!.get("phone").toString();

  DocumentList temp = await db.listDocuments(
      databaseId: AppConfig.database, collectionId: AppConfig.address, queries: [Query.equal("userId", userId)]);
  int cn = temp.documents.length;

  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: 'AIzaSyBkCHRvyRkdln13aHPVfVuxop5eFTqay8k');
  TextEditingController name = TextEditingController(text: "Address ${(cn + 1)}");
  await showDialog(
      context: context,
      builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            backgroundColor: Pallet.background,
            content: SizedBox(
              width: 200,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Save this Address?",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Enter Address Name",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 5),
                  TextBox(controller: name),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SmallButton(
                        label: "Cancel",
                        onPress: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      SizedBox(width: 10),
                      SmallButton(
                        label: "Done",
                        onPress: () async {
                          PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(address["place_id"]);
                          final lat = detail.result.geometry!.location.lat;
                          final lng = detail.result.geometry!.location.lng;

                          await db.createDocument(
                              databaseId: AppConfig.database,
                              collectionId: AppConfig.address,
                              documentId: Uuid().v4(),
                              data: {
                                "userId": userId,
                                "name": name.text,
                                "address": address["description"],
                                "lat": detail.result.geometry!.location.lat,
                                "lng": detail.result.geometry!.location.lng,
                                "selected": temp.documents.isEmpty
                              });
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ));
}

class GetAddress extends StatefulWidget {
  const GetAddress({super.key});

  @override
  State<GetAddress> createState() => GetAddressState();
}

class GetAddressState extends State<GetAddress> {
  List places = [];
  String st = Uuid().v4();

  void getSuggestion(String input, st) async {
    // String type = '(regions)';
    String baseURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request = '$baseURL?input=$input&components=country:in&key=${AppConfig.mapKey}&sessiontoken=$st';
    var response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      places = json.decode(response.body)['predictions'];
      print(places);
      setState(() {});
    } else {
      print("herar");
      throw Exception('Failed to load predictions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
                backgroundColor: Pallet.background,
  
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(color: Pallet.inner1, borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  Icon(Icons.search),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      onChanged: (value) async {
                        getSuggestion(value, st);
                        setState(() {});
                      },
                      decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          hintText: "Search Address...",
                          border: InputBorder.none),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 10),
            Expanded(
                child: ListView(
              children: [
                for (var place in places)
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context, place);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [Text(place["description"]), Divider()],
                      ))
              ],
            ))
          ],
        ),
      ),
    ));
  }
}

class Address extends StatefulWidget {
  const Address({super.key});

  @override
  State<Address> createState() => _AddressState();
}

class _AddressState extends State<Address> {
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: AppConfig.mapKey);
  List addresses = [];
  String selected = "";
  getData() async {
    addresses = await getAddresses();
    for (var address in addresses) {
      if (address["selected"]) {
        selected = address["id"];
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    getData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(height: 5),
              Row(
                children: [
                  Icon(Icons.arrow_back),
                  SizedBox(width: 15),
                  Text(
                    "Manage Addresses",
                    style: Style.h3,
                  ),
                  Expanded(child: SizedBox()),
                  Icon(Icons.notifications_none)
                ],
              ),
              SizedBox(height: 15),
              Expanded(
                child: ListView(
                  children: [
                    Button(
                        color: Pallet.inner1,
                        fontColor: Pallet.primary,
                        label: "Add New Addres",
                        onPress: () {
                          Navigator.push(
                            mainContext,
                            MaterialPageRoute(builder: (context) => GetAddress()),
                          ).then((value) async {
                            if (value["place_id"] != null) {
                              await saveAddress(context, value);
                              getData();
                            }

                            // }
                          });
                        }),
                    SizedBox(height: 10),
                    Text("Default Address"),
                    SizedBox(height: 5),
                    if (addresses.isNotEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Pallet.inner1),
                        child: Column(
                          children: [
                            SizedBox(width: 5),
                            for (var address in addresses)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Radio(
                                    value: address["id"],
                                    groupValue: selected,
                                    onChanged: (value) async {
                                      for (var temp in addresses) {
                                        await db.updateDocument(
                                            databaseId: AppConfig.database,
                                            collectionId: AppConfig.address,
                                            documentId: temp["id"],
                                            data: {"selected": false});
                                      }
                                      await db.updateDocument(
                                          databaseId: AppConfig.database,
                                          collectionId: AppConfig.address,
                                          documentId: address["id"],
                                          data: {"selected": true});

                                      getData();
                                    },
                                  ),
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        address["name"],
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Text(address["address"]),
                                    ],
                                  )),
                                  SizedBox(width: 10),
                                  Button(
                                      color: Pallet.inner2,
                                      fontColor: Pallet.primary,
                                      radius: 20,
                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      label: "Edit",
                                      onPress: () {}),
                                  SizedBox(width: 15),
                                ],
                              )
                          ],
                        ),
                      )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
