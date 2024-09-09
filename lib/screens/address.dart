import 'dart:async';
import 'dart:convert';
// import 'dart:io';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../backend/server.dart';
import '../types.dart';
import '../widgets.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:permission_handler/permission_handler.dart' as local;
import 'package:google_geocoding/google_geocoding.dart';

import 'notifications.dart';

Future<bool> makeDefault(BuildContext context) async {
  bool selected = false;
  await showDialog(
      context: context,
      builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            backgroundColor: Theme.of(context).colorScheme.surface,
            content: SizedBox(
              width: 150,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Make this defaut this Address?",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Button(
                        size: ButtonSize.small,
                        type: ButtonType.gray,
                        label: "Cancel",
                        onPress: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      SizedBox(width: 10),
                      Button(
                        size: ButtonSize.small,
                        type: ButtonType.filled,
                        label: "Done",
                        onPress: () async {
                          selected = true;

                          // await db.createDocument(
                          //     databaseId: AppConfig.database,
                          //     collectionId: AppConfig.address,
                          //     documentId: Uuid().v4(),
                          //     data: {
                          //       "userId": userId,
                          //       "name": name.text,
                          //       "address": address["description"],
                          //       "lat": detail.result.geometry!.location.lat,
                          //       "lng": detail.result.geometry!.location.lng,
                          //       "selected": temp.documents.isEmpty
                          //     });
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ));

  return selected;
}

class AddAddress extends StatefulWidget {
  const AddAddress({super.key, this.addressId, this.data});
  final String? addressId;
  final Map? data;

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  GoogleMapController? controller;
  bool gotLocation = false;
  bool addAddress = false;

  String userId = "";
  int addressCount = 0;
  bool selected = false;
  TextEditingController name = TextEditingController();
  TextEditingController houseNo = TextEditingController();
  TextEditingController street = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController pincode = TextEditingController();
  TextEditingController phone = TextEditingController();

  String nameError = "";
  String houseNoError = "";
  String streetError = "";
  String cityError = "";
  String pincodeError = "";
  String phoneError = "";

  Map place = {};

  LatLng marker = LatLng(11.0940144, 77.0228223);

  CameraPosition myLocation = CameraPosition(
    target: LatLng(11.0940144, 77.0228223),
    zoom: 15.0,
  );

  getLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission != LocationPermission.always &&
        permission != LocationPermission.whileInUse) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      Position pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);

      myLocation = CameraPosition(
        target: LatLng(pos.latitude, pos.longitude),
        zoom: 15.0,
      );
      marker = LatLng(pos.latitude, pos.longitude);
    }

    userId = sharedPreferences!.get("phone").toString();
    phone.text = userId;

    var doc = await db.getDocument(
        databaseId: AppConfig.database,
        collectionId: AppConfig.users,
        documentId: phone.text);

    gotLocation = true;
    setState(() {});
    DocumentList temp = await db.listDocuments(
        databaseId: AppConfig.database,
        collectionId: AppConfig.address,
        queries: [Query.equal("userId", userId)]);
    addressCount = temp.documents.length;

    // name.text = "Address ${(addressCount + 1)}";
    name.text = doc.data["userName"];
  }

  @override
  void initState() {
    final GoogleMapsFlutterPlatform mapsImplementation =
        GoogleMapsFlutterPlatform.instance;
    if (mapsImplementation is GoogleMapsFlutterAndroid) {
      mapsImplementation.useAndroidViewSurface = true;
    }
    if (widget.data != null) {
      name.text = widget.data!["name"];
      houseNo.text = widget.data!["houseNumber"];
      street.text = widget.data!["street"];
      city.text = widget.data!["city"];
      pincode.text = widget.data!["pincode"];
      phone.text = widget.data!["phone"];

      marker = LatLng(widget.data!["lat"], widget.data!["lng"]);

      myLocation = CameraPosition(
        target: LatLng(widget.data!["lat"], widget.data!["lng"]),
        zoom: 15.0,
      );
      gotLocation = true;

      setState(() {});
    } else {
      getLocation();
    }

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      bottomSheet: SizedBox(
        width: width,
        height: addAddress ? height : 0,
        child: Column(
          children: [
            Expanded(
                child: GestureDetector(
                    behavior: HitTestBehavior.deferToChild,
                    onTap: () {
                      addAddress = false;
                      setState(() {});
                    },
                    child: Container(
                      color: Colors.transparent,
                    ))),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              width: width,
              height: (addAddress) ? 650 : 0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                  color: Theme.of(context).colorScheme.surface,
                  boxShadow: [
                    if (addAddress)
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: Offset(0, -10), // changes position of shadow
                      ),
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: ListView(
                    children: [
                      SizedBox(height: 10),
                      Text(
                        "Full name *",
                        style: Style.footnoteEmphasized.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                      SizedBox(height: 8),
                      TextBox(
                        controller: name,
                        onType: (_) {
                          nameError = "";
                          setState(() {});
                        },
                      ),
                      Text(nameError,
                          style: Style.caption2.copyWith(
                              color: Theme.of(context).colorScheme.error)),
                      SizedBox(height: 10),
                      Text(
                        "House No. / Block. Building name *",
                        style: Style.footnoteEmphasized.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                      SizedBox(height: 8),
                      TextBox(
                        controller: houseNo,
                        onType: (_) {
                          houseNoError = "";
                          setState(() {});
                        },
                      ),
                      Text(houseNoError,
                          style: Style.caption2.copyWith(
                              color: Theme.of(context).colorScheme.error)),
                      SizedBox(height: 10),
                      Text(
                        "Road Name. Area Locality *",
                        style: Style.footnoteEmphasized.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                      SizedBox(height: 8),
                      TextBox(
                        controller: street,
                        onType: (_) {
                          streetError = "";
                          setState(() {});
                        },
                      ),
                      Text(streetError,
                          style: Style.caption2.copyWith(
                              color: Theme.of(context).colorScheme.error)),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "City *",
                                  style: Style.footnoteEmphasized.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface),
                                ),
                                SizedBox(height: 8),
                                TextBox(
                                  controller: city,
                                ),
                                Text(cityError,
                                    style: Style.caption2.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .error)),
                              ],
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Pincode *",
                                  style: Style.footnoteEmphasized.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface),
                                ),
                                SizedBox(height: 8),
                                TextBox(
                                  controller: pincode,
                                  onType: (_) {
                                    pincodeError = "";
                                    setState(() {});
                                  },
                                ),
                                Text(pincodeError,
                                    style: Style.caption2.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .error)),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Phone number *",
                        style: Style.footnoteEmphasized.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                      SizedBox(height: 8),
                      TextBox(
                        controller: phone,
                        onType: (_) {
                          phoneError = "";
                          setState(() {});
                        },
                      ),
                      Text(phoneError,
                          style: Style.caption2.copyWith(
                              color: Theme.of(context).colorScheme.error)),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () async {
                          selected = await makeDefault(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainer),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Make this default address"),
                          ),
                        ),
                      )
                    ],
                  )),
                  SizedBox(height: 20),
                  Button(
                      size: ButtonSize.large,
                      type: ButtonType.filled,
                      label: "Save Address",
                      onPress: () async {
                        if (name.text.isEmpty) {
                          nameError = "required";
                        }
                        if (houseNo.text.isEmpty) {
                          houseNoError = "required";
                        }

                        if (street.text.isEmpty) {
                          streetError = "required";
                        }
                        if (city.text.isEmpty) {
                          cityError = "required";
                        }
                        if (pincode.text.isEmpty) {
                          pincodeError = "required";
                        }
                        selected = addressCount == 0;
                        setState(() {});

                        if (nameError.isEmpty &&
                            houseNoError.isEmpty &&
                            streetError.isEmpty &&
                            cityError.isEmpty &&
                            pincodeError.isEmpty) {
                          Map data = {
                            "userId": userId,
                            "name": name.text,
                            "address":
                                "${houseNo.text}, ${street.text}, ${city.text}, ${pincode.text}",
                            "lat": marker.latitude,
                            "lng": marker.longitude,
                            "houseNumber": houseNo.text,
                            "street": street.text,
                            "city": city.text,
                            "pincode": pincode.text,
                            "phone": phone.text,
                            "selected": selected
                          };
                          if (widget.addressId == null) {
                            await db.createDocument(
                                databaseId: AppConfig.database,
                                collectionId: AppConfig.address,
                                documentId: Uuid().v4(),
                                data: data);
                          } else {
                            await db.updateDocument(
                                databaseId: AppConfig.database,
                                collectionId: AppConfig.address,
                                documentId: widget.addressId!,
                                data: data);
                          }
                          Navigator.pop(context);
                        }

                        setState(() {});
                      })
                ],
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back, size: 22)),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                        color:
                            Theme.of(context).colorScheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child:
                              PlaceAutocomplete.widget(onDone: (place) async {
                            print("done");
                            print(place);
                            myLocation = CameraPosition(
                              target: LatLng(place["lat"], place["lng"]),
                              zoom: 15.0,
                            );
                            marker = LatLng(place["lat"], place["lng"]);
                            setState(() {});

                            await controller?.animateCamera(
                                CameraUpdate.newCameraPosition(myLocation));
                          }),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: GestureDetector(
                      onTap: () async {},
                      child: Icon(Icons.my_location_rounded, size: 22)),
                ),
              ],
            ),
            SizedBox(height: 20),
            if (gotLocation)
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: GoogleMap(
                    myLocationButtonEnabled: false,
                    onTap: (location) {
                      marker = location;
                      setState(() {});
                    },
                    initialCameraPosition: myLocation,
                    onMapCreated: (value) {
                      controller = value;
                      setState(() {});
                    },
                    markers: {
                      Marker(
                          markerId: MarkerId('My Location'),
                          position: marker,
                          draggable: true)
                    },
                  ),
                ),
              )
            else
              Expanded(
                child: Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            SizedBox(height: 20),
            Row(children: [
              Expanded(
                child: Button(
                    size: ButtonSize.large,
                    type: ButtonType.filled,
                    label: "Continue",
                    onPress: () async {
                      var googleGeocoding = GoogleGeocoding(
                          "AIzaSyCbU5_ADBeu0-SXrzaTRsAfFkRrLq5TigI");
                      var result = await googleGeocoding.geocoding.getReverse(
                          LatLon(marker.latitude, marker.longitude));

                      if (result?.results != null) {
                        for (var result
                            in result!.results![0].addressComponents!) {
                          if (result.types!.contains('street_number') ||
                              result.types!.contains('route')) {
                            if (result.longName != null) {
                              street.text = result.longName!;
                            }
                          } else if (result.types!.contains('locality')) {
                            if (result.longName != null) {
                              city.text = result.longName!;
                            }
                          } else if (result.types!.contains('postal_code')) {
                            if (result.longName != null) {
                              pincode.text = result.longName!;
                            }
                          }
                        }
                      }

                      addAddress = true;
                      setState(() {});
                    }),
              )
            ]),
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
    addresses = getAddressLocal();
    setState(() {});

    addresses = await getAddresses();
    for (var address in addresses) {
      if (address["selected"]) {
        selected = address["id"];
      }
    }

    saveAddress(addresses);
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
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          leadingWidth: 60,
          title: const Text("Manage Address"),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.notifications_none),
              onPressed: () {
                Navigator.push(
                  mainContext,
                  MaterialPageRoute(builder: (context) => Notifications()),
                );
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              // SizedBox(height: 5),
              // Row(
              //   children: [
              //     GestureDetector(
              //         onTap: () {
              //           Navigator.pop(context);
              //         },
              //         child: Icon(Icons.arrow_back)),
              //     SizedBox(width: 15),
              //     Text(
              //       "Manage Addresses",
              //       style: Style.headline.copyWith(
              //           color: Theme.of(context).colorScheme.onSurface),
              //     ),
              //     Expanded(child: SizedBox()),
              //     Icon(Icons.notifications_none)
              //   ],
              // ),
              // SizedBox(height: 15),
              Expanded(
                child: ListView(
                  children: [
                    Row(children: [
                      Expanded(
                        child: Button(
                            size: ButtonSize.large,
                            type: ButtonType.gray,
                            label: "Add New Address",
                            onPress: () {
                              Navigator.push(
                                mainContext,
                                MaterialPageRoute(
                                    builder: (context) => AddAddress()),
                              ).then((_) {
                                getData();
                              });
                            }),
                      )
                    ]),
                    const SizedBox(height: 24),
                    Text(
                      "Default address",
                      style: Style.footnoteEmphasized.copyWith(
                          color: Theme.of(context).colorScheme.onSurface),
                    ),
                    const SizedBox(height: 8),
                    if (addresses.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHigh),
                        child: Column(
                          children: [
                            SizedBox(width: 5),
                            for (var address in addresses)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Radio(
                                    activeColor:
                                        Theme.of(context).colorScheme.primary,
                                    value: address["id"],
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    groupValue: selected,
                                    onChanged: (value) async {
                                      selected = address["id"];
                                      setState(() {});

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

                                      // getData();
                                    },
                                  ),
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        address["name"],
                                        style: Style.callout.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        address["address"],
                                        style: Style.footnote.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface),
                                      ),
                                    ],
                                  )),
                                  const SizedBox(width: 10),
                                  Button(
                                      size: ButtonSize.small,
                                      type: ButtonType.gray,
                                      label: "Edit",
                                      onPress: () {
                                        Navigator.push(
                                          mainContext,
                                          MaterialPageRoute(
                                              builder: (context) => AddAddress(
                                                    addressId: address["id"],
                                                    data: address,
                                                  )),
                                        ).then((_) {
                                          getData();
                                        });
                                      }),
                                  SizedBox(width: 15),
                                ],
                              )
                          ],
                        ),
                      )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchWidget extends StatefulWidget {
  final bool isPopup;
  final bool autoFocus;
  final InputDecoration? decoration;
  final void Function(Map) onDone;
  final int suggestionLimit;
  final int minLengthToStartSearch;

  const SearchWidget(
      {Key? key,
      required this.onDone,
      this.isPopup = false,
      this.autoFocus = false,
      this.decoration,
      this.suggestionLimit = 5,
      this.minLengthToStartSearch = 3})
      : super(key: key);

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  String st = Uuid().v4();

  // ValueNotifier<Map?> notifierGeoPoint = ValueNotifier(null);
  ValueNotifier<bool> notifierAutoCompletion = ValueNotifier(false);

  late StreamController<List<Map>> streamSuggestion = StreamController();
  // late Future<List<Map>> _futureSuggestionAddress;
  String oldText = "";
  Timer? _timerToStartSuggestionReq;
  final Key streamKey = const Key("streamAddressSug");
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onSearchableTextChanged(String v) async {
    if (v.length > widget.minLengthToStartSearch && oldText != v) {
      oldText = v;
      if (_timerToStartSuggestionReq != null &&
          _timerToStartSuggestionReq!.isActive) {
        _timerToStartSuggestionReq!.cancel();
      }
      _timerToStartSuggestionReq =
          Timer.periodic(const Duration(milliseconds: 500), (timer) async {
        getSuggestion(v, st);
        // await suggestionProcessing(v);
        timer.cancel();
      });
    }
    if (v.isEmpty) {
      await reInitStream();
    }
  }

  Future reInitStream() async {
    notifierAutoCompletion.value = false;
    await streamSuggestion.close();
    setState(() {
      streamSuggestion = StreamController();
    });
  }

  Future<Map> fetchPlaceDetails(String placeId) async {
    Map place = {};
    GoogleMapsPlaces _places = GoogleMapsPlaces(
      apiKey: AppConfig.mapKey,
      apiHeaders: await GoogleApiHeaders().getHeaders(),
    );
// detail.result
    PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(placeId);
    place["lat"] = detail.result.geometry?.location.lat;
    place["lng"] = detail.result.geometry?.location.lng;

    return place;
    // } else {
    // throw Exception('Failed to load place details');
    // }
  }

  void getSuggestion(String input, st) async {
    notifierAutoCompletion.value = true;

    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&components=country:in&key=${AppConfig.mapKey}&sessiontoken=$st';
    var response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      List<Map> places =
          List<Map>.from(json.decode(response.body)['predictions']);
      print(places);
      streamSuggestion.sink.add(places);
    } else {
      print("herar");
      throw Exception('Failed to load predictions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Icon(Icons.search, size: 22),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  cursorColor: Theme.of(context).colorScheme.onSurface,
                  controller: controller,
                  style: Style.body
                      .copyWith(color: Theme.of(context).colorScheme.onSurface),
                  onChanged: onSearchableTextChanged,
                  decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      hintText: "Search Address...",
                      hintStyle: Style.body.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant),
                      border: InputBorder.none),
                ),
              ),
            ],
          ),
          ValueListenableBuilder<bool>(
            valueListenable: notifierAutoCompletion,
            builder: (ctx, isVisible, child) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                height: isVisible
                    ? widget.isPopup
                        ? MediaQuery.of(context).size.height / 3
                        : MediaQuery.of(context).size.height / 4
                    : 0,
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).colorScheme.surfaceContainerLow),
                  child: child!,
                ),
              );
            },
            child: StreamBuilder<List<Map>>(
              stream: streamSuggestion.stream,
              key: streamKey,
              builder: (ctx, snap) {
                if (snap.hasData) {
                  return ListView.builder(
                    itemCount: snap.data!.length,
                    itemBuilder: (ctx, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Text(
                                snap.data![index]["description"].toString(),
                                maxLines: 1,
                                overflow: TextOverflow.fade,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                            onTap: () async {
                              Map place = await fetchPlaceDetails(
                                  snap.data![index]["place_id"]);
                              // controller.text = snap.data![index].address.toString();
                              // // log(snap.data![index].address.toString());
                              widget.onDone(place);

                              // /// hide suggestion card
                              notifierAutoCompletion.value = false;
                              await reInitStream();
                              FocusScope.of(context).requestFocus(
                                FocusNode(),
                              );
                            },
                          ),
                          if (index != snap.data!.length - 1)
                            Divider(
                              height: 0.5,
                              thickness: 0.5,
                            )
                        ],
                      );
                    },
                  );
                }
                if (snap.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PlaceAutocomplete {
  static show(
      {required BuildContext context,
      Mode mode = Mode.overlay,
      final bool autoFocus = false,
      final InputDecoration? textfieldDecoration,
      final Decoration? containerDecoration,
      final int suggestionLimit = 5,
      final int minLengthToStartSearch = 3,
      final EdgeInsetsGeometry? borderPadding,
      required Function(Map) onDone}) {
    // ignore: prefer_function_declarations_over_variables
    final builder = (BuildContext ctx) => Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: borderPadding ?? const EdgeInsets.all(8.0),
          child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              child: SearchWidget(
                onDone: onDone,
                suggestionLimit: suggestionLimit,
                minLengthToStartSearch: minLengthToStartSearch,
                isPopup: mode == Mode.overlay,
                autoFocus: autoFocus,
                decoration: textfieldDecoration,
              )),
        ));
    if (mode == Mode.overlay) {
      return showDialog(context: context, builder: builder);
    } else {
      return Navigator.push(context, MaterialPageRoute(builder: builder));
    }
  }

  static widget({
    required Function(Map) onDone,
    final bool autoFocus = false,
    final InputDecoration? textfieldDecoration,
    final int suggestionLimit = 5,
    final int minLengthToStartSearch = 3,
  }) {
    return SearchWidget(
      onDone: onDone,
      isPopup: false,
      autoFocus: autoFocus,
      decoration: textfieldDecoration,
      suggestionLimit: suggestionLimit,
      minLengthToStartSearch: minLengthToStartSearch,
    );
  }
}
