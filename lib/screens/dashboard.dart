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
    categories = await getCategories(limit: 5);
    setState(() {});
  }

  @override
  void initState() {
    getData();
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
                              builder: (context) =>
                                  MonthlyPicks(monthlyPicks: monthlyPicks),
                            ),
                          );
                          // Navigator.push(
                          //     mainContext,
                          //     MaterialPageRoute(
                          //         builder: (context) => ProductsInCategory(
                          //               categoryId: category["id"],
                          //               categoryName:
                          //                   category["categoryName"],
                          //             )),
                          //   );
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

class MonthlyPicks extends StatefulWidget {
  const MonthlyPicks({super.key, required this.monthlyPicks});
  final List monthlyPicks;
  @override
  State<MonthlyPicks> createState() => _MonthlyPicksState();
}

class _MonthlyPicksState extends State<MonthlyPicks> {
  List products = [];
  List<String> cart = [];
  String selectedCategory = "";

  bool showDetail = false;
  Map productData = {};
  double stars = 0;

  @override
  void initState() {
    if (widget.monthlyPicks.isNotEmpty) {
      selectedCategory = widget.monthlyPicks.first["id"];
      getData();
    }

    super.initState();
  }

  getData() async {
    products = await getProducts(selectedCategory);
    print(products);
    cart = await getCartProductIds();
    for (var product in products) {
      if (cart.contains(product["id"])) {
        product["qty"] = await getQty(product["id"]);
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        bottomSheet: ProductDetails(
          showDetail: showDetail,
          productData: productData,
          stars: stars,
          onClose: () {
            showDetail = false;
            setState(() {});
          },
        ),
        appBar: AppBar(
          leadingWidth: 30,
          title: Text(
            "Monthly Picks",
            style: Style.headline
                .copyWith(color: Theme.of(context).colorScheme.onSurface),
          ),
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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(color: Theme.of(context).colorScheme.outline, height: 1),
            SizedBox(height: 10),
            SizedBox(
              height: 30,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (var category in widget.monthlyPicks)
                    GestureDetector(
                      onTap: () {
                        selectedCategory = category["id"];
                        setState(() {});
                        getData();
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceContainerHigh),
                            color: (category["id"] == selectedCategory)
                                ? Theme.of(context)
                                    .colorScheme
                                    .surfaceContainerHigh
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20)),
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (category["id"] == selectedCategory)
                              Icon(Icons.check, size: 14)
                            else
                              Icon(Icons.add, size: 14),
                            SizedBox(width: 5),
                            Text(category["categoryName"]),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (products.isNotEmpty)
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Theme.of(context).colorScheme.surfaceContainerLow),
                  child: Column(
                    children: [
                      for (var product in products)
                        Material(
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerLow,
                            borderRadius: BorderRadius.circular(14),
                            clipBehavior: Clip.antiAlias,
                            child: InkWell(
                              splashColor: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainer,
                              onTap: () async {
                                showDetail = true;
                                productData = product;

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
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                            getUrl(Bucket.products,
                                                product["images"][0]),
                                            width: 60,
                                            height: 60)),
                                    SizedBox(width: 10),
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product["name"],
                                          style: Style.body.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface),
                                        ),
                                        Text(
                                          product["about"].toString(),
                                          maxLines: 1,
                                          style: Style.ellipsisText
                                              .merge(Style.subHeadline)
                                              .copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurfaceVariant),
                                        ),
                                        SizedBox(height: 20),
                                        Row(
                                          children: [
                                            if (product["originalPrice"] !=
                                                product["sellingPrice"])
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 15),
                                                child: Text(
                                                    product["originalPrice"]
                                                        .toString(),
                                                    style: Style
                                                        .title3Emphasized
                                                        .copyWith(
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .onSurfaceVariant)),
                                              ),
                                            Text(
                                              "₹ ${product["sellingPrice"].toString()}",
                                              style: Style.title3Emphasized
                                                  .copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSurface),
                                            ),
                                            Expanded(child: SizedBox()),
                                            if (cart.contains(product["id"]))
                                              StepperWidget(
                                                quantity: product["qty"],
                                                decrementFunc: () async {
                                                  if (product["qty"] > 0) {
                                                    product["qty"] -= 1;
                                                    // if (!saved) {
                                                    // total -= item["product"]["sellingPrice"];
                                                    // }

                                                    setState(() {});

                                                    updateBag(product["id"],
                                                        product["qty"]);
                                                  }
                                                  if (product["qty"] == 0) {
                                                    cart.remove(product["id"]);
                                                  }
                                                },
                                                incrementFunc: () async {
                                                  if (product!["qty"] < 5) {
                                                    product["qty"] += 1;

                                                    setState(() {});
                                                    updateBag(product["id"],
                                                        product["qty"]);
                                                  }

                                                  // getData();
                                                },
                                              )
                                            else
                                              Button(
                                                  size: ButtonSize.medium,
                                                  type: ButtonType.filled,
                                                  label: "Add to Bag",
                                                  onPress: () {
                                                    product["qty"] = 1;
                                                    cart.add(product["id"]);
                                                    addToBag(product["id"]);
                                                    showMessage(context,
                                                        "Added ${product["name"]} to bag");
                                                    setState(() {});
                                                  })
                                          ],
                                        )
                                      ],
                                    ))
                                  ],
                                ),
                              ),
                            ))
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
