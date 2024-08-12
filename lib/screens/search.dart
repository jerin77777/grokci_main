import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grokci_main/screens/products.dart';

import '../types.dart';
import '../backend/server.dart';
import '../widgets.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<Map> categories = [];
  List<Map> products = [];
  List<String> cart = [];
  Map qtyCache = {};

  @override
  void initState() {
    getData();
    // TODO: implement initState
    super.initState();
  }

  getData() async {
    categories = await getCategories();
    cart = await getCartProductIds();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                  onTap: () {
                    routerSink.add({"route": "dashboard"});
                  },
                  child: Icon(Icons.arrow_back, size: 22)),
              Icon(Icons.notifications_none, size: 22)
            ],
          ),
          SizedBox(height: 10),
          Text(
            "Search",
            style: Style.title1Emphasized.copyWith(
              color: Pallet.onBackground,
            ),
          ),
          SizedBox(height: 10),
          SearchBarWidget(
            label: "Search for Products...",
            onTextChanged: (value) async {
              products = await searchProducts(value);
              for (var product in products) {
                if (cart.contains(product["id"])) {
                  if (qtyCache[product["id"]] != null) {
                    product["qty"] = qtyCache[product["id"]];
                  } else {
                    print("called");
                    product["qty"] = await getQty(product["id"]);
                    qtyCache[product["id"]] = product["qty"];
                  }
                }
              }
              setState(() {});
            },
          ),
          const SizedBox(height: 16),
          Text("Categories", style: Style.footnoteEmphasized),
          const SizedBox(height: 8),
          if (products.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Pallet.surface1),
              child: Column(
                children: [
                  for (var product in products)
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          mainContext,
                          MaterialPageRoute(
                              builder: (context) => ProductDetails(
                                    productId: product["id"],
                                  )),
                        );
                      },
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset("assets/oil.jpeg",
                                    width: 80, height: 80)),
                            SizedBox(width: 10),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product["name"],
                                  style: Style.body
                                      .copyWith(color: Pallet.onBackground),
                                ),
                                Text(
                                  product["about"].toString(),
                                  style: Style.subHeadline
                                      .copyWith(color: Pallet.onSurfaceVariant),
                                ),
                                SizedBox(height: 20),
                                Row(
                                  children: [
                                    if (product["originalPrice"] !=
                                        product["sellingPrice"])
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 15),
                                        child: Text(
                                          product["originalPrice"].toString(),
                                          style: Style.title3Emphasized
                                              .copyWith(
                                                  color:
                                                      Pallet.onSurfaceVariant,
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                        ),
                                      ),
                                    Text(
                                      "₹ ${product["sellingPrice"].toString()}",
                                      style: Style.title3Emphasized
                                          .copyWith(color: Pallet.onBackground),
                                    ),
                                    Expanded(child: SizedBox()),
                                    if (cart.contains(product["id"]))
                                      Container(
                                        height: 32,
                                        decoration: BoxDecoration(
                                            color: Pallet.tertiaryFill,
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 8),
                                        child: Row(
                                          children: [
                                            GestureDetector(
                                                onTap: () async {
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
                                                child: Icon(
                                                    FontAwesomeIcons.minus,
                                                    size: 20,
                                                    color:
                                                        Pallet.onBackground)),
                                            SizedBox(width: 8),
                                            Text(
                                              product["qty"].toString(),
                                              style: Style.subHeadline.copyWith(
                                                  color: Pallet.onBackground),
                                            ),
                                            SizedBox(width: 8),
                                            GestureDetector(
                                                onTap: () async {
                                                  product["qty"] += 1;
                                                  // if (!saved) {
                                                  // total += item["product"]["sellingPrice"];
                                                  // }

                                                  setState(() {});
                                                  updateBag(product["id"],
                                                      product["qty"]);

                                                  // getData();
                                                },
                                                child: Icon(
                                                    FontAwesomeIcons.plus,
                                                    size: 20,
                                                    color:
                                                        Pallet.onBackground)),
                                          ],
                                        ),
                                      )
                                    else
                                      Button(
                                          radius: 30,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 8),
                                          label: "Add to Bag",
                                          onPress: () {
                                            addToBag(product["id"]);
                                            showMessage(context,
                                                "Added ${product["name"]} to bag");
                                          })
                                  ],
                                )
                              ],
                            ))
                          ],
                        ),
                      ),
                    )
                ],
              ),
            )
          else
            Expanded(
              child: GridView.count(
                primary: false,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                crossAxisCount: 2,
                childAspectRatio: 2.2,
                children: <Widget>[
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
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: Pallet.surface1),
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Container(
                                color: Pallet.background,
                                child: Image.network(
                                  getUrl(
                                      Bucket.categories, category["imageId"]),
                                  width: 65,
                                  height: 65,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                                child: Text(
                              category["categoryName"],
                              style: Style.footnoteEmphasized
                                  .copyWith(color: Pallet.onBackground),
                            ))
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
