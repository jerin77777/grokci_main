import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  @override
  void initState() {
    getData();
    // TODO: implement initState
    super.initState();
  }

  getData() async {
    categories = await getCategories();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
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
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(color: Pallet.inner1, borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                Icon(Icons.search),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    style: TextStyle(color: Pallet.fontInner),
                    onChanged: (value) async {
                      products = await searchProducts(value);
                      setState(() {});
                    },
                    decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        hintText: "Search for Products...",
                        border: InputBorder.none),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 10),
          Text("Categories", style: Style.h3),
          SizedBox(height: 10),
          if (products.isNotEmpty)
            Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Pallet.inner1),
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
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset("assets/oil.jpeg", width: 80, height: 80)),
                            SizedBox(width: 10),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product["name"],
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  product["about"].toString(),
                                  style: TextStyle(color: Pallet.font2),
                                ),
                                SizedBox(height: 20),
                                Row(
                                  children: [
                                    if (product["originalPrice"] != product["sellingPrice"])
                                      Padding(
                                        padding: const EdgeInsets.only(right: 15),
                                        child: Text(
                                          product["originalPrice"].toString(),
                                          style: TextStyle(
                                              color: Pallet.font2,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              decoration: TextDecoration.lineThrough),
                                        ),
                                      ),
                                    Text(
                                      "₹ ${product["sellingPrice"].toString()}",
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                    ),
                                    Expanded(child: SizedBox()),
                                    Button(
                                        radius: 30,
                                        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                                        label: "Add to Bag",
                                        onPress: () {
                                          addToBag(product["id"]);
                                          showMessage(context, "Added ${product["name"]} to bag");
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
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
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
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Pallet.inner1),
                        padding: const EdgeInsets.all(8),
                        child: Row(
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
                                child: Text(
                              category["categoryName"],
                              style: TextStyle(fontWeight: FontWeight.w500),
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
