import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grokci_main/screens/products.dart';
// import 'package:pay/pay.dart';

import 'address.dart';
import '../backend/server.dart';
import '../types.dart';
import '../widgets.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List monthlyPicks = [];
  List categories = [];

  // List constCategories = [
  //   {"id": "ec7fc75e-dca2-49f2-b1eb-52743d9af198", "name": "Fruits", "imageId": ""},
  //   {"id": "829faa17-5890-4b64-8d84-f01599d6c63d", "name": "Atta & Ghee", "imageId": ""},
  //   {"id": "829faa17-5890-4b64-8d84-f01599d6c63d", "name": "Snacks & Biscuits", "imageId": ""},
  //   {"id": "829faa17-5890-4b64-8d84-f01599d6c63d", "name": "Cleaning & Household", "imageId": ""},
  // ];

  // var _paymentItems = [
  //   PaymentItem(
  //     label: 'Total',
  //     amount: '99.99',
  //     status: PaymentItemStatus.final_price,
  //   )
  // ];

  getData() async {
    monthlyPicks = await getMonthlyPicks();
    categories = await getCategories(limit: 4);

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
    if (monthlyPicks.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        children: [
          // GooglePayButton(
          //   paymentConfiguration: PaymentConfiguration.fromJsonString(jsonEncode(googlePayConfig)),
          //   paymentItems: _paymentItems,
          //   type: GooglePayButtonType.pay,
          //   margin: const EdgeInsets.only(top: 15.0),
          //   onPaymentResult: (value) {
          //     print(value.toString());
          //   },
          //   loadingIndicator: const Center(
          //     child: CircularProgressIndicator(),
          //   ),
          // ),
          Row(
            children: [
              SvgPicture.asset(
                width: 100,
                "assets/logo.svg",
              ),
              Expanded(child: SizedBox()),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    mainContext,
                    MaterialPageRoute(builder: (context) => Address()),
                  );
                  // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Address()));
                },
                child: Container(
                  width: 150,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Pallet.inner1,
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Delivery Address',
                              style: GoogleFonts.beVietnamPro(fontSize: 10, fontWeight: FontWeight.w700),
                            ),
                            Text(
                              'L2, 204, Tiruvant puram',
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.beVietnamPro(fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                      // SizedBox(width: 5),
                      Icon(
                        Icons.keyboard_arrow_down,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Icon(Icons.notifications_none)
            ],
          ),
          SizedBox(height: 10),

          // SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                Text(
                  "Shop by Category",
                  style: Style.h2,
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (var category in categories)
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            mainContext,
                            MaterialPageRoute(
                                builder: (context) => ProductsInCategory(
                                      categoryId: category["id"],
                                      categoryName: category["categoryName"],
                                    )),
                          );
                        },
                        child: Container(
                          width: 70,
                          decoration: BoxDecoration(
                            color: Pallet.inner1,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50),
                              topRight: Radius.circular(50),
                            ),
                          ),
                          child: Stack(children: [
                            Center(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Image.network(
                                    height: 60,
                                    width: 55,
                                    getUrl(Bucket.categories, category["imageId"]),
                                    fit: BoxFit.contain,
                                  ),
                                  SizedBox(
                                    height: 35,
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              child: Container(
                                width: 70,
                                height: 40,
                                padding: EdgeInsets.symmetric(horizontal: 2),
                                decoration: BoxDecoration(
                                  color: Pallet.primary,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                ),
                                child: Center(
                                    child: Text(
                                  category["categoryName"],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Pallet.fontInner, fontSize: 12),
                                )),
                              ),
                            )
                          ]),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Monthly Picks", style: Style.h2),
                    Button(
                      radius: 20,
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                      label: "View More",
                      onPress: () {
                        Navigator.push(
                          mainContext,
                          MaterialPageRoute(builder: (context) => Categories()),
                        );
                      },
                    )
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(color: Pallet.inner1, borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var category in monthlyPicks)
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              mainContext,
                              MaterialPageRoute(
                                  builder: (context) => ProductsInCategory(
                                        categoryId: category["id"],
                                        categoryName: category["categoryName"],
                                      )),
                            );
                          },
                          child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      color: Colors.white,
                                      child: Image.network(
                                        getUrl(Bucket.categories, category["imageId"]),
                                        width: 65,
                                        height: 65,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          category["categoryName"],
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          "Bulk Discounts",
                                          style: TextStyle(fontSize: 12, color: Pallet.primary),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              )),
                        ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
