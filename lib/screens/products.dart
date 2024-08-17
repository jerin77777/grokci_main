import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grokci_main/backend/server.dart';
import 'package:grokci_main/screens/notifications.dart';
import 'package:grokci_main/types.dart';
import 'package:grokci_main/widgets.dart';

class ProductsInCategory extends StatefulWidget {
  const ProductsInCategory(
      {super.key, required this.categoryId, required this.categoryName});
  final String categoryId;
  final String categoryName;
  @override
  State<ProductsInCategory> createState() => _ProductsInCategoryState();
}

class _ProductsInCategoryState extends State<ProductsInCategory> {
  List products = [];
  List<String> cart = [];

  @override
  void initState() {
    getData();
    // TODO: implement initState
    super.initState();
  }

  getData() async {
    print(widget.categoryId);
    products = await getProducts(widget.categoryId);
    cart = await getCartProductIds();
    for (var product in products) {
      if (cart.contains(product["id"])) {
        product["qty"] = await getQty(product["id"]);
      }
    }
    print(cart);
    print(products[0]["id"]);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          leadingWidth: 30,
          title: Text(
            "Products in ${widget.categoryName}",
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
            if (products.isNotEmpty)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Theme.of(context).colorScheme.surfaceContainerLow),
                child: Column(
                  children: [
                    for (var product in products)
                      Material(
                          color:
                              Theme.of(context).colorScheme.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(14),
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            splashColor:
                                Theme.of(context).colorScheme.surfaceContainer,
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
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset("assets/oil.jpeg",
                                          width: 60, height: 60)),
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
                                                  style: Style.title3Emphasized
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
                                            Container(
                                              height: 32,
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .surfaceContainer,
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8, horizontal: 8),
                                              child: Row(
                                                children: [
                                                  GestureDetector(
                                                      onTap: () async {
                                                        if (product["qty"] >
                                                            0) {
                                                          product["qty"] -= 1;
                                                          // if (!saved) {
                                                          // total -= item["product"]["sellingPrice"];
                                                          // }

                                                          setState(() {});

                                                          updateBag(
                                                              product["id"],
                                                              product["qty"]);
                                                        }
                                                        if (product["qty"] ==
                                                            0) {
                                                          cart.remove(
                                                              product["id"]);
                                                        }
                                                      },
                                                      child: Icon(
                                                          FontAwesomeIcons
                                                              .minus,
                                                          size: 20,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .onSurface)),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    product["qty"].toString(),
                                                    style: Style.subHeadline
                                                        .copyWith(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .onSurface),
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
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .onSurface)),
                                                ],
                                              ),
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
              )
          ],
        ),
      ),
    );
  }
}

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  List categories = [];

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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back, size: 22)),
                  SizedBox(width: 15),
                  Text(
                    "Categories",
                    style: Style.footnoteEmphasized.copyWith(
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                  Expanded(child: SizedBox()),
                  Icon(Icons.notifications_none, size: 22)
                ],
              ),
            ),
            Divider(
              color: Theme.of(context).colorScheme.outline,
              height: 1,
            ),
            SizedBox(height: 10),
            Expanded(
              child: GridView.count(
                padding: EdgeInsets.symmetric(horizontal: 20),
                primary: false,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                crossAxisCount: 2,
                childAspectRatio: 2.2,
                children: <Widget>[
                  for (var category in categories)
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerLow),
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              color: Theme.of(context).colorScheme.surface,
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
                            style: Style.footnoteEmphasized.copyWith(
                                color: Theme.of(context).colorScheme.onSurface),
                          ))
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductDetails extends StatefulWidget {
  const ProductDetails({super.key, required this.productId});
  final String productId;

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  Map? productData;
  int imageIdx = 0;
  String direction = "";
  // double sellingPrice = 0;
  // double originalPrice = 0;
  @override
  void initState() {
    getData();
    // TODO: implement initState
    super.initState();
  }

  getData() async {
    productData = await getProduct(widget.productId);
    print(productData);
    // productData!["discount"] =
    //     productData!["originalPrice"] - productData!["sellingPrice"] / productData!["originalPrice"];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (productData == null) {
      return Center(child: CircularProgressIndicator());
    }
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          leadingWidth: 30,
          title: Text(
            productData!["name"],
            style: Style.body
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
          children: [
            // SizedBox(height: 5),
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            //   child: Row(
            //     children: [
            //       GestureDetector(
            //           onTap: () {
            //             Navigator.pop(context);
            //           },
            //           child: Icon(Icons.arrow_back, size: 22)),
            //       SizedBox(width: 15),
            //       Text(
            //         productData!["name"],
            //         style: Style.body.copyWith(
            //             color: Theme.of(context).colorScheme.onSurface),
            //       ),
            //       Expanded(child: SizedBox()),
            //       Icon(Icons.notifications_none, size: 22)
            //     ],
            //   ),
            // ),
            Divider(color: Theme.of(context).colorScheme.outline, height: 1),
            Expanded(
                child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 15),
              children: [
                SizedBox(height: 10),
                GestureDetector(
                    onPanEnd: (_) {
                      if (direction == "right") {
                        if (imageIdx > 0) {
                          imageIdx--;
                          setState(() {});
                        }
                      }

                      // Swiping in left direction.
                      if (direction == "left") {
                        if (imageIdx < productData!["images"].length - 1) {
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
                    child: Image.network(getUrl(
                        Bucket.products, productData!["images"][imageIdx]))),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  for (var i = 0; i < productData!["images"].length; i++)
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 2),
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: (i == imageIdx)
                              ? Theme.of(context).colorScheme.surfaceTint
                              : Theme.of(context).colorScheme.outline),
                    )
                ]),
                SizedBox(height: 10),
                Text(
                  productData!["name"],
                  style: Style.body
                      .copyWith(color: Theme.of(context).colorScheme.onSurface),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Theme.of(context).colorScheme.primary,
                      size: 16,
                    ),
                    Icon(
                      Icons.star,
                      color: Theme.of(context).colorScheme.primary,
                      size: 16,
                    ),
                    Icon(
                      Icons.star,
                      color: Theme.of(context).colorScheme.primary,
                      size: 16,
                    ),
                    Icon(
                      Icons.star,
                      color: Theme.of(context).colorScheme.primary,
                      size: 16,
                    ),
                    Icon(
                      Icons.star,
                      color: Theme.of(context).colorScheme.primary,
                      size: 16,
                    ),
                    SizedBox(width: 15),
                    Text(
                      "4.5 stars (1,089 ratings)",
                      style: Style.caption1.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [Text("Quantity:  ${productData!["netContent"]}")],
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
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "₹ ${productData!["sellingPrice"]}",
                      style: Style.title3Emphasized.copyWith(
                          color: Theme.of(context).colorScheme.onSurface),
                    ),
                    Expanded(child: SizedBox()),
                    Text(
                      "@₹${productData!["sellingPrice"]}/I",
                      style: Style.caption1.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  "Product Details",
                  style: Style.footnoteEmphasized
                      .copyWith(color: Theme.of(context).colorScheme.onSurface),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(14)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.access_time_filled,
                              color: Theme.of(context).colorScheme.primary),
                          SizedBox(width: 10),
                          Text(
                            "Expiry Date: 30 OCT 2024",
                            style: Style.callout.copyWith(
                                color: Theme.of(context).colorScheme.onSurface),
                          )
                        ],
                      ),
                      SizedBox(height: 20),
                      if (productData!["about"] != null) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "About the Product",
                              style: Style.subHeadline.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                            ),
                            Icon(Icons.add, size: 18)
                          ],
                        ),
                        SizedBox(height: 5),
                        Text(
                          productData!["about"],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 10),
                      ],
                      if (productData!["ingredients"] != null) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Ingredients",
                              style: Style.subHeadline.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                            ),
                            Icon(Icons.add, size: 18)
                          ],
                        ),
                        SizedBox(height: 5),
                        Text(
                          productData!["ingredients"],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 10),
                      ],
                      if (productData!["eanCode"] != null ||
                          productData!["manufacturer"] != null) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Other Product Info",
                              style: Style.subHeadline.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                            ),
                            Icon(Icons.add, size: 18)
                          ],
                        ),
                        SizedBox(height: 5),
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
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Icon(Icons.info,
                              color: Theme.of(context).colorScheme.primary),
                          SizedBox(width: 10),
                          Text(
                            "Additional details",
                            style: Style.subHeadline.copyWith(
                                color: Theme.of(context).colorScheme.primary),
                          ),
                          Expanded(child: SizedBox()),
                          Icon(Icons.keyboard_arrow_right_rounded,
                              color: Theme.of(context).colorScheme.primary)
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
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Row(
                children: [
                  Expanded(
                      child: Button(
                          size: ButtonSize.medium,
                          type: ButtonType.tonal,
                          label: "Buy Now",
                          onPress: () {})),
                  SizedBox(width: 20),
                  Expanded(
                      child: Button(
                          size: ButtonSize.medium,
                          type: ButtonType.filled,
                          label: "Add to Bag",
                          onPress: () {}))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
