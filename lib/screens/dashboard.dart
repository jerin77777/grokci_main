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
import 'notifications.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List monthlyPicks = [];
  List categories = [];
  Map address = {};
  getData() async {
    address = await getAddress();
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
        color: Theme.of(context).colorScheme.primary,
      ));
    }
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Column(
          children: [
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
                if (address["address"] != null)
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        mainContext,
                        MaterialPageRoute(builder: (context) => Address()),
                      );
                    },
                    child: Container(
                      width: 180,
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Theme.of(context).colorScheme.surfaceContainer,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Delivery Address',
                                  style: Style.caption2Emphasized.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  address["address"],
                                  overflow: TextOverflow.ellipsis,
                                  style: Style.caption1.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface),
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
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                        mainContext,
                        MaterialPageRoute(
                            builder: (context) => Notifications()),
                      );
                    },
                    child: Icon(Icons.notifications_none))
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
                    style: Style.headline.copyWith(
                        color: Theme.of(context).colorScheme.onSurface),
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
                          style: Style.headline.copyWith(
                              color: Theme.of(context).colorScheme.onSurface)),
                      Button(
                        size: ButtonSize.medium,
                        type: ButtonType.filled,
                        label: "View More",
                        onPress: () {
                          Navigator.push(
                            mainContext,
                            MaterialPageRoute(
                                builder: (context) => Categories()),
                          );
                        },
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Material(
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(14),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var category in monthlyPicks)
                          InkWell(
                            splashColor:
                                Theme.of(context).colorScheme.surfaceContainer,
                            onTap: () {
                              Navigator.push(
                                mainContext,
                                MaterialPageRoute(
                                    builder: (context) => ProductsInCategory(
                                          categoryId: category["id"],
                                          categoryName:
                                              category["categoryName"],
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
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                        shadowColor: Theme.of(context)
                                            .colorScheme
                                            .shadow,
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
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurface),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "Bulk Discounts",
                                            style: Style.caption1.copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary),
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
      ),
    );
  }
}
