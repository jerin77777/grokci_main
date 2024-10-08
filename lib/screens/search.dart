import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grokci_main/main.dart';
import 'package:grokci_main/screens/products.dart';

import '../types.dart';
import '../backend/server.dart';
import '../widgets.dart';
import 'notifications.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  // Called when the top route has been popped off, and the current route shows up.
  void didPopNext() {
    setState(() {});
  }

  List<Map> categories = [];
  Map qtyCache = {};

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
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            leading: IconButton(
              onPressed: () {
                routerSink.add({"route": "dashboard"});
              },
              icon: Icon(Icons.arrow_back),
            ),
            title: Text(
              "Search",
              style: Style.title1Emphasized,
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
          // SizedBox(height: 10),
          // Text(
          //   "Search",
          //   style: Style.title1Emphasized.copyWith(
          //     color: Theme.of(context).colorScheme.onSurface,
          //   ),
          // ),
          // SizedBox(height: 10),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SearchBarWidget(
                    label: "Search for products...",
                    onPress: () {
                      // SearchView
                      print("hii");
                      Navigator.push(
                        mainContext,
                        MaterialPageRoute(builder: (context) => SearchView()),
                      );
                    },
                    onTextChanged: (value) async {
                      // products = await searchProducts(value);
                      // for (var product in products) {
                      //   if (cart.contains(product["id"])) {
                      //     if (qtyCache[product["id"]] != null) {
                      //       product["qty"] = qtyCache[product["id"]];
                      //     } else {
                      //       print("called");
                      //       product["qty"] = await getQty(product["id"]);
                      //       qtyCache[product["id"]] = product["qty"];
                      //     }
                      //   }
                      // }
                      // setState(() {});
                    },
                  ),
                  const SizedBox(height: 16),
                  Text("Categories", style: Style.footnoteEmphasized),
                  const SizedBox(height: 8),

                  // else
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
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
                            width: (width - 57) / 2,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceContainerLow),
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Container(
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                    child: Image.network(
                                      getUrl(Bucket.categories,
                                          category["imageId"]),
                                      width: 65,
                                      height: 65,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                    child: Text(
                                  category["categoryName"],
                                  style: Style.footnoteEmphasized.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface),
                                ))
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> with RouteAware {
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  // Called when the top route has been popped off, and the current route shows up.
  void didPopNext() {
    super.didPopNext();
    getData();
  }

  List<Map> products = [];
  List<String> cart = [];

  Map qtyCache = {};

  Map productData = {};
  double stars = 0;

  @override
  void initState() {
    getData();
    // TODO: implement initState
    super.initState();
  }

  getData() async {
    cart = await getCartProductIds();
    setState(() {});
  }

  bool searching = false;
  bool showDetail = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      bottomSheet: ProductDetails(
        showDetail: showDetail,
        productData: productData,
        stars: stars,
        onClose: () {
          showDetail = false;
          setState(() {});
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: [
            SearchBarWidget(
              textEnabled: true,
              label: "Search for Products...",
              onSearchPress: (value) async {
                searching = true;
                setState(() {});

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
                searching = false;
                setState(() {});
              },
              onTextChanged: (value) async {
                searching = true;
                setState(() {});

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

                searching = false;
                setState(() {});
              },
            ),
            if (searching)
              Expanded(
                child: Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              )
            else
              Container(
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Theme.of(context).colorScheme.surfaceContainerLow),
                child: Column(
                  children: [
                    for (var product in products)
                      InkWell(
                        onTap: () async {
                          showDetail = true;
                          productData = product;
                          FocusScope.of(context).unfocus();
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
                          //       builder: (context) => ProductDetails(
                          //             productId: product["id"],
                          //           )),
                          // );
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                      getUrl(Bucket.products,
                                          product["images"][0]),
                                      width: 80,
                                      height: 80)),
                              SizedBox(width: 10),
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                    style: Style.subHeadline.copyWith(
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
                                          padding:
                                              const EdgeInsets.only(right: 15),
                                          child: Text(
                                            product["originalPrice"].toString(),
                                            style: Style.title3Emphasized
                                                .copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurfaceVariant,
                                                    decoration: TextDecoration
                                                        .lineThrough),
                                          ),
                                        ),
                                      Text(
                                        "₹ ${product["sellingPrice"].toString()}",
                                        style: Style.title3Emphasized.copyWith(
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
                                              setState(() {});
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
          ],
        ),
      ),
    ));
  }
}
