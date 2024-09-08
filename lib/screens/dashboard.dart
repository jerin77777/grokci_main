import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grokci_main/screens/products.dart';
import 'package:intl/intl.dart';

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
  List<String> cart = [];

  bool showDetail = false;
  Map productData = {};
  int imageIdx = 0;
  double stars = 0;
  String direction = "";

  getData() async {
    address = await getAddress();
    monthlyPicks = await getMonthlyPicks();
    categories = await getCategories(limit: 5);
    cart = await getCartProductIds();

    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    if (monthlyPicks.isEmpty) {
      return Center(
          child: CircularProgressIndicator(
        color: Theme.of(context).colorScheme.primary,
      ));
    }
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      bottomSheet: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        width: width,
        height: showDetail ? height : 0,
        child: !showDetail
            ? SizedBox()
            : GestureDetector(
                behavior: HitTestBehavior.opaque,
                onPanUpdate: (details) {
                  print(details.delta.dy);
                },
                child: Column(
                  children: [
                    Expanded(
                        child: ListView(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      children: [
                        SizedBox(height: 10),
                        GestureDetector(
                            onVerticalDragUpdate: (details) {
                              if (details.delta.dy > 0) {
                                direction = "down";
                              } else {
                                direction = "";
                              }
                            },
                            onVerticalDragEnd: (details) {
                              if (direction == "down") {
                                showDetail = false;
                                setState(() {});
                              }
                            },
                            onPanEnd: (_) {
                              if (direction == "right") {
                                if (imageIdx > 0) {
                                  imageIdx--;
                                  setState(() {});
                                }
                              }

                              // Swiping in left direction.
                              if (direction == "left") {
                                if (imageIdx <
                                    productData!["images"].length - 1) {
                                  imageIdx++;
                                  setState(() {});
                                }
                              }
                            },
                            onPanUpdate: (details) {
                              // Swiping in right direction.
                              if (details.delta.dx > 0) {
                                direction = "right";
                              }

                              // Swiping in left direction.
                              if (details.delta.dx < 0) {
                                direction = "left";
                              }
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(getUrl(Bucket.products,
                                  productData!["images"][imageIdx])),
                            )),
                        SizedBox(height: 10),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (var i = 0;
                                  i < productData!["images"].length;
                                  i++)
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 2),
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: (i == imageIdx)
                                          ? Theme.of(context)
                                              .colorScheme
                                              .surfaceTint
                                          : Theme.of(context)
                                              .colorScheme
                                              .outline),
                                )
                            ]),
                        SizedBox(height: 10),
                        Text(
                          productData!["name"],
                          style: Style.body.copyWith(
                              color: Theme.of(context).colorScheme.onSurface),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            for (var i = 0; i < stars; i++)
                              Icon(
                                Icons.star,
                                color: Theme.of(context).colorScheme.primary,
                                size: 16,
                              ),
                            SizedBox(width: 15),
                            Text(
                              "${stars.toInt()} stars (${productData!["stars"].length} ratings)",
                              style: Style.caption1.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Text("Quantity:  ${productData!["netContent"]}")
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              "${productData!["discountPercentage"].toString()}% off",
                              style: Style.title3.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              productData!["originalPrice"].toString(),
                              style: Style.title3Emphasized.copyWith(
                                  decoration: TextDecoration.lineThrough,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "₹ ${productData!["sellingPrice"]}",
                              style: Style.title3Emphasized.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                            ),
                            Expanded(child: SizedBox()),
                            Text(
                              productData!["priceDescription"],
                              style: Style.caption1.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Product Details",
                          style: Style.footnoteEmphasized.copyWith(
                              color: Theme.of(context).colorScheme.onSurface),
                        ),
                        SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(14)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Icon(Icons.access_time_filled,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                  SizedBox(width: 10),
                                  Text(
                                    "Expiry Date: ${DateFormat('dd MMM yyyy').format(DateTime.parse(productData!["expiryDate"]))}",
                                    style: Style.callout.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface),
                                  )
                                ],
                              ),
                              SizedBox(height: 20),
                              if (productData!["about"] != null)
                                Accordion(
                                  title: "About the Product",
                                  children: [
                                    Text(
                                      productData!["about"],
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              if (productData!["ingredients"] != null)
                                Accordion(
                                  title: "Ingredients",
                                  children: [
                                    Text(
                                      productData!["ingredients"],
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              if (productData!["eanCode"] != null ||
                                  productData!["manufacturer"] != null)
                                Accordion(
                                  title: "Other Product Info",
                                  children: [
                                    if (productData!["eanCode"] != null)
                                      Text(
                                        "${productData!["EAN CODE: ${productData!["eanCode"]}"]}",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    if (productData!["manufacturer"] != null)
                                      Text(
                                        "${productData!["Manufactured & Marketed By: ${productData!["manufacturer"]}"]}",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                  ],
                                ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Icon(Icons.info,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                  SizedBox(width: 10),
                                  Text(
                                    "Additional details",
                                    style: Style.subHeadline.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                  ),
                                  Expanded(child: SizedBox()),
                                  Icon(Icons.keyboard_arrow_right_rounded,
                                      color:
                                          Theme.of(context).colorScheme.primary)
                                ],
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                        SizedBox(height: 50)
                      ],
                    )),
                    Divider(
                      color: Theme.of(context).colorScheme.outline,
                      height: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      child: Row(
                        children: [
                          Expanded(
                              child: Button(
                                  size: ButtonSize.medium,
                                  type: ButtonType.tonal,
                                  label: "Buy Now",
                                  onPress: () {})),
                          SizedBox(width: 20),
                          cart.contains(productData!["id"])
                              ? StepperWidget(
                                  quantity: productData!["qty"],
                                  decrementFunc: () async {
                                    if (productData!["qty"] > 0) {
                                      productData!["qty"] -= 1;
                                      // if (!saved) {
                                      // total -= item["productData!"]["sellingPrice"];
                                      // }

                                      setState(() {});

                                      updateBag(productData!["id"],
                                          productData!["qty"]);
                                    }
                                    if (productData!["qty"] == 0) {
                                      cart.remove(productData!["id"]);
                                    }
                                  },
                                  incrementFunc: () async {
                                    if (productData!["qty"] < 5) {
                                      productData!["qty"] += 1;

                                      setState(() {});
                                      updateBag(productData!["id"],
                                          productData!["qty"]);
                                    }

                                    // getData();
                                  },
                                )
                              : Expanded(
                                  child: Button(
                                      size: ButtonSize.medium,
                                      type: ButtonType.filled,
                                      label: "Add to Bag",
                                      onPress: () {
                                        productData!["qty"] = 1;
                                        cart.add(productData!["id"]);
                                        addToBag(productData!["id"]);
                                        showMessage(context,
                                            "Added ${productData!["name"]} to bag");
                                        setState(() {});
                                      })),
                        ],
                      ),
                    )
                  ],
                ),
              ),
      ),
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
                        for (var product in monthlyPicks)
                          InkWell(
                            splashColor:
                                Theme.of(context).colorScheme.surfaceContainer,
                            onTap: () async {
                              productData = product;
                              showDetail = true;
                              if (cart.contains(productData!["id"])) {
                                productData!["qty"] =
                                    await getQty(productData!["id"]);
                              }
                              if (productData!["stars"].isNotEmpty) {
                                for (var star in productData!["stars"]) {
                                  stars += star;
                                }
                                stars = stars / productData!["stars"].length;
                              }
                              setState(() {});
                              // Navigator.push(
                              //   mainContext,
                              //   MaterialPageRoute(
                              //       builder: (context) => ProductsInCategory(
                              //             categoryId: product["id"],
                              //             categoryName: product["name"],
                              //           )),
                              // );
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
                                            getUrl(Bucket.products,
                                                product["images"][0]),
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
                                            product["name"],
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
