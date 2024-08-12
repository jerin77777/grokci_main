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
      return Center(
          child: CircularProgressIndicator(
        color: Pallet.primary,
      ));
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
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
          const SizedBox(
            height: 6,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset(
                width: 110,
                "assets/logo.svg",
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    mainContext,
                    MaterialPageRoute(builder: (context) => Address()),
                  );
                  // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Address()));
                },
                child: Container(
                  width: 180,
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Pallet.tertiaryFill,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Delivery Address',
                              style: Style.caption2Emphasized
                                  .copyWith(color: Pallet.onBackground),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              'L2, 204, Tiruvant puram',
                              overflow: TextOverflow.ellipsis,
                              style: Style.caption1
                                  .copyWith(color: Pallet.onBackground),
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
              Icon(Icons.notifications_none)
            ],
          ),
          SizedBox(height: 16),

          // SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                const SizedBox(height: 20),
                Text(
                  "Shop by Category",
                  style: Style.headline.copyWith(color: Pallet.onBackground),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    for (var category in categories)
                      Container(
                          margin: const EdgeInsets.only(right: 16),
                          child: Category(category: category)),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Monthly Picks",
                        style: Style.headline
                            .copyWith(color: Pallet.onBackground)),
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

                Material(
                    color: Pallet.tertiaryFill,
                    borderRadius: BorderRadius.circular(14),
                    clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var category in monthlyPicks)
                        InkWell(
                          splashColor: Pallet.tertiaryFill,
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
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Material(
                                    borderRadius: BorderRadius.circular(6),
                                    color: Pallet.background,
                                    shadowColor: Pallet.shadowColor,
                                    elevation: 3,
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      child: Image.network(
                                        getUrl(Bucket.categories,
                                            category["imageId"]),
                                        width: 52,
                                        height: 52,
                                        fit: BoxFit.contain,
                                      ),
                                    )),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          category["categoryName"],
                                          style: Style.subHeadlineEmphasized
                                              .copyWith(
                                                  color: Pallet.onBackground),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "Bulk Discounts",
                                          style: Style.caption1
                                              .copyWith(color: Pallet.primary),
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
