import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grokci_main/backend/server.dart';
import 'package:grokci_main/screens/notifications.dart';
import 'package:grokci_main/types.dart';
import 'package:grokci_main/widgets.dart';
import 'package:intl/intl.dart';
import 'package:accordion/accordion.dart';

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

  bool showDetail = false;
  Map productData = {};
  double stars = 0;
  // String direction = "";

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

    return Scaffold(
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
        title: Text("Products in ${widget.categoryName}".toLowerCase()),
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
          Divider(color: Theme.of(context).colorScheme.outline, height: 0.3),
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
                                                        color: Theme.of(context)
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
            )
        ],
      ),
    );
  }
}

class ProductDetails extends StatefulWidget {
  const ProductDetails(
      {super.key,
      required this.showDetail,
      required this.productData,
      required this.stars,
      required this.onClose});
  final bool showDetail;
  final Map productData;
  final double stars;
  final Function onClose;

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  List<String> cart = [];

  int imageIdx = 0;
  double stars = 0;
  String direction = "";

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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      width: width,
      height: widget.showDetail ? height : 0,
      child: (!widget.showDetail)
          ? SizedBox()
          : SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onPanUpdate: (details) {
                  print(details.delta.dy);

                  // if (details.delta.dy < 0) {
                  //   print(details.delta.dy);
                  // }
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
                              // FocusScope.of(context).unfocus();
                              if (details.delta.dy > 0) {
                                direction = "down";
                              } else {
                                direction = "";
                              }
                            },
                            onVerticalDragEnd: (details) {
                              if (direction == "down") {
                                widget.onClose();
                                //   showDetail = false;
                                //   setState(() {});
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
                                    widget.productData["images"].length - 1) {
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
                                  widget.productData["images"][imageIdx])),
                            )),
                        SizedBox(height: 10),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (var i = 0;
                                  i < widget.productData["images"].length;
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
                          widget.productData["name"],
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
                              "${stars.toInt()} stars (${widget.productData["stars"].length} ratings)",
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
                            Text(
                                "Quantity:  ${widget.productData["netContent"]}")
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              "${widget.productData["discountPercentage"].toString()}% off",
                              style: Style.title3.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              widget.productData["originalPrice"].toString(),
                              style: Style.title3Emphasized.copyWith(
                                  decoration: TextDecoration.lineThrough,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "₹ ${widget.productData["sellingPrice"]}",
                              style: Style.title3Emphasized.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                            ),
                            Expanded(child: SizedBox()),
                            Text(
                              widget.productData["priceDescription"],
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
                                    "Expiry Date: ${DateFormat('dd MMM yyyy').format(DateTime.parse(widget.productData["expiryDate"]))}",
                                    style: Style.callout.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface),
                                  )
                                ],
                              ),
                              SizedBox(height: 20),
                              if (widget.productData["about"] != null)
                                Accordion(
                                  title: "About the Product",
                                  children: [
                                    Text(
                                      widget.productData["about"],
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              if (widget.productData["ingredients"] != null)
                                Accordion(
                                  title: "Ingredients",
                                  children: [
                                    Text(
                                      widget.productData["ingredients"],
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              if (widget.productData["eanCode"] != null ||
                                  widget.productData["manufacturer"] != null)
                                Accordion(
                                  title: "Other Product Info",
                                  children: [
                                    if (widget.productData["eanCode"] != null)
                                      Text(
                                        "${widget.productData["EAN CODE: ${widget.productData["eanCode"]}"]}",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    if (widget.productData["manufacturer"] !=
                                        null)
                                      Text(
                                        "${widget.productData["Manufactured & Marketed By: ${widget.productData["manufacturer"]}"]}",
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
                          cart.contains(widget.productData["id"])
                              ? StepperWidget(
                                  quantity: widget.productData["qty"],
                                  decrementFunc: () async {
                                    if (widget.productData["qty"] > 0) {
                                      widget.productData["qty"] -= 1;
                                      // if (!saved) {
                                      // total -= item["productData!"]["sellingPrice"];
                                      // }

                                      setState(() {});

                                      updateBag(widget.productData["id"],
                                          widget.productData["qty"]);
                                    }
                                    if (widget.productData["qty"] == 0) {
                                      cart.remove(widget.productData["id"]);
                                    }
                                  },
                                  incrementFunc: () async {
                                    if (widget.productData["qty"] < 5) {
                                      widget.productData["qty"] += 1;

                                      setState(() {});
                                      updateBag(widget.productData["id"],
                                          widget.productData["qty"]);
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
                                        widget.productData["qty"] = 1;
                                        cart.add(widget.productData["id"]);
                                        addToBag(widget.productData["id"]);
                                        showMessage(context,
                                            "Added ${widget.productData["name"]} to bag");
                                        setState(() {});
                                      })),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}

// class Categories extends StatefulWidget {
//   const Categories({super.key});

//   @override
//   State<Categories> createState() => _CategoriesState();
// }

// class _CategoriesState extends State<Categories> {
//   List categories = [];

//   @override
//   void initState() {
//     getData();
//     // TODO: implement initState
//     super.initState();
//   }

//   getData() async {
//     categories = await getCategories();
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Theme.of(context).colorScheme.surface,
//         body: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   GestureDetector(
//                       onTap: () {
//                         Navigator.pop(context);
//                       },
//                       child: Icon(Icons.arrow_back, size: 22)),
//                   SizedBox(width: 15),
//                   Text(
//                     "Categories",
//                     style: Style.footnoteEmphasized.copyWith(
//                         color: Theme.of(context).colorScheme.onSurface),
//                   ),
//                   Expanded(child: SizedBox()),
//                   Icon(Icons.notifications_none, size: 22)
//                 ],
//               ),
//             ),
//             Divider(
//               color: Theme.of(context).colorScheme.outline,
//               height: 1,
//             ),
//             SizedBox(height: 10),
//             Expanded(
//               child: GridView.count(
//                 padding: EdgeInsets.symmetric(horizontal: 20),
//                 primary: false,
//                 crossAxisSpacing: 16,
//                 mainAxisSpacing: 16,
//                 crossAxisCount: 2,
//                 childAspectRatio: 2.2,
//                 children: <Widget>[
//                   for (var category in categories)
//                     Container(
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           color: Theme.of(context)
//                               .colorScheme
//                               .surfaceContainerLow),
//                       padding: const EdgeInsets.all(8),
//                       child: Row(
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(10),
//                             child: Container(
//                               color: Theme.of(context).colorScheme.surface,
//                               child: Image.network(
//                                 getUrl(Bucket.categories, category["imageId"]),
//                                 width: 65,
//                                 height: 65,
//                               ),
//                             ),
//                           ),
//                           SizedBox(width: 10),
//                           Expanded(
//                               child: Text(
//                             category["categoryName"],
//                             style: Style.footnoteEmphasized.copyWith(
//                                 color: Theme.of(context).colorScheme.onSurface),
//                           ))
//                         ],
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ProductDetails extends StatefulWidget {
//   const ProductDetails({super.key, required this.productId});
//   final String productId;

//   @override
//   State<ProductDetails> createState() => _ProductDetailsState();
// }

// class _ProductDetailsState extends State<ProductDetails> {
//   Map? productData;
//   int imageIdx = 0;
//   String direction = "";
//   double stars = 0;
//   List<String> cart = [];
//   @override
//   void initState() {
//     getData();
//     // TODO: implement initState
//     super.initState();
//   }

//   getData() async {
//     productData = await getProduct(widget.productId);
//     cart = await getCartProductIds();
//     if (cart.contains(productData!["id"])) {
//       productData!["qty"] = await getQty(productData!["id"]);
//     }
//     if (productData!["stars"].isNotEmpty) {
//       for (var star in productData!["stars"]) {
//         stars += star;
//       }
//       stars = stars / productData!["stars"].length;
//     }

//     print(productData!["stars"]);
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (productData == null) {
//       return Center(child: CircularProgressIndicator());
//     }
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Theme.of(context).colorScheme.surface,
//         appBar: AppBar(
//           leadingWidth: 30,
//           title: Text(
//             productData!["name"],
//             style: Style.body
//                 .copyWith(color: Theme.of(context).colorScheme.onSurface),
//           ),
//           actions: <Widget>[
//             IconButton(
//               icon: const Icon(Icons.notifications_none),
//               onPressed: () {
//                 Navigator.push(
//                   mainContext,
//                   MaterialPageRoute(builder: (context) => Notifications()),
//                 );
//               },
//             ),
//           ],
//         ),
//         body: Column(
//           children: [
//             Divider(color: Theme.of(context).colorScheme.outline, height: 1),
//             Expanded(
//                 child: ListView(
//               padding: EdgeInsets.symmetric(horizontal: 15),
//               children: [
//                 SizedBox(height: 10),
//                 GestureDetector(
//                     onPanEnd: (_) {
//                       if (direction == "right") {
//                         if (imageIdx > 0) {
//                           imageIdx--;
//                           setState(() {});
//                         }
//                       }

//                       // Swiping in left direction.
//                       if (direction == "left") {
//                         if (imageIdx < productData!["images"].length - 1) {
//                           imageIdx++;
//                           setState(() {});
//                         }
//                       }
//                     },
//                     onPanUpdate: (details) {
//                       // Swiping in right direction.
//                       if (details.delta.dx > 0) {
//                         direction = "right";
//                       }

//                       // Swiping in left direction.
//                       if (details.delta.dx < 0) {
//                         direction = "left";
//                       }
//                     },
//                     child: Image.network(getUrl(
//                         Bucket.products, productData!["images"][imageIdx]))),
//                 SizedBox(height: 10),
//                 Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//                   for (var i = 0; i < productData!["images"].length; i++)
//                     Container(
//                       margin: EdgeInsets.symmetric(horizontal: 2),
//                       width: 10,
//                       height: 10,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           color: (i == imageIdx)
//                               ? Theme.of(context).colorScheme.surfaceTint
//                               : Theme.of(context).colorScheme.outline),
//                     )
//                 ]),
//                 SizedBox(height: 10),
//                 Text(
//                   productData!["name"],
//                   style: Style.body
//                       .copyWith(color: Theme.of(context).colorScheme.onSurface),
//                 ),
//                 SizedBox(height: 10),
//                 Row(
//                   children: [
//                     for (var i = 0; i < stars; i++)
//                       Icon(
//                         Icons.star,
//                         color: Theme.of(context).colorScheme.primary,
//                         size: 16,
//                       ),
//                     SizedBox(width: 15),
//                     Text(
//                       "${stars.toInt()} stars (${productData!["stars"].length} ratings)",
//                       style: Style.caption1.copyWith(
//                           color:
//                               Theme.of(context).colorScheme.onSurfaceVariant),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 8),
//                 Row(
//                   children: [Text("Quantity:  ${productData!["netContent"]}")],
//                 ),
//                 SizedBox(height: 5),
//                 Row(
//                   children: [
//                     Text(
//                       "${productData!["discountPercentage"].toString()}% off",
//                       style: Style.title3.copyWith(
//                         color: Theme.of(context).colorScheme.primary,
//                       ),
//                     ),
//                     SizedBox(width: 10),
//                     Text(
//                       productData!["originalPrice"].toString(),
//                       style: Style.title3Emphasized.copyWith(
//                           decoration: TextDecoration.lineThrough,
//                           color:
//                               Theme.of(context).colorScheme.onSurfaceVariant),
//                     ),
//                     SizedBox(width: 10),
//                     Text(
//                       "₹ ${productData!["sellingPrice"]}",
//                       style: Style.title3Emphasized.copyWith(
//                           color: Theme.of(context).colorScheme.onSurface),
//                     ),
//                     Expanded(child: SizedBox()),
//                     Text(
//                       productData!["priceDescription"],
//                       style: Style.caption1.copyWith(
//                           color:
//                               Theme.of(context).colorScheme.onSurfaceVariant),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 20),
//                 Text(
//                   "Product Details",
//                   style: Style.footnoteEmphasized
//                       .copyWith(color: Theme.of(context).colorScheme.onSurface),
//                 ),
//                 SizedBox(height: 10),
//                 Container(
//                   padding: EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                       color:
//                           Theme.of(context).colorScheme.surfaceContainerHighest,
//                       borderRadius: BorderRadius.circular(14)),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(height: 10),
//                       Row(
//                         children: [
//                           Icon(Icons.access_time_filled,
//                               color: Theme.of(context).colorScheme.primary),
//                           SizedBox(width: 10),
//                           Text(
//                             "Expiry Date: ${DateFormat('dd MMM yyyy').format(DateTime.parse(productData!["expiryDate"]))}",
//                             style: Style.callout.copyWith(
//                                 color: Theme.of(context).colorScheme.onSurface),
//                           )
//                         ],
//                       ),
//                       SizedBox(height: 20),
//                       if (productData!["about"] != null)
//                         Accordion(
//                           title: "About the Product",
//                           children: [
//                             Text(
//                               productData!["about"],
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ],
//                         ),
//                       if (productData!["ingredients"] != null)
//                         Accordion(
//                           title: "Ingredients",
//                           children: [
//                             Text(
//                               productData!["ingredients"],
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ],
//                         ),
//                       if (productData!["eanCode"] != null ||
//                           productData!["manufacturer"] != null)
//                         Accordion(
//                           title: "Other Product Info",
//                           children: [
//                             if (productData!["eanCode"] != null)
//                               Text(
//                                 "${productData!["EAN CODE: ${productData!["eanCode"]}"]}",
//                                 maxLines: 2,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             if (productData!["manufacturer"] != null)
//                               Text(
//                                 "${productData!["Manufactured & Marketed By: ${productData!["manufacturer"]}"]}",
//                                 maxLines: 2,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                           ],
//                         ),
//                       SizedBox(height: 20),
//                       Row(
//                         children: [
//                           Icon(Icons.info,
//                               color: Theme.of(context).colorScheme.primary),
//                           SizedBox(width: 10),
//                           Text(
//                             "Additional details",
//                             style: Style.subHeadline.copyWith(
//                                 color: Theme.of(context).colorScheme.primary),
//                           ),
//                           Expanded(child: SizedBox()),
//                           Icon(Icons.keyboard_arrow_right_rounded,
//                               color: Theme.of(context).colorScheme.primary)
//                         ],
//                       ),
//                       SizedBox(height: 10),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 50)
//               ],
//             )),
//             Divider(
//               color: Theme.of(context).colorScheme.outline,
//               height: 1,
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//               child: Row(
//                 children: [
//                   Expanded(
//                       child: Button(
//                           size: ButtonSize.medium,
//                           type: ButtonType.tonal,
//                           label: "Buy Now",
//                           onPress: () {})),
//                   SizedBox(width: 20),
//                   cart.contains(productData!["id"])
//                       ? StepperWidget(
//                           quantity: productData!["qty"],
//                           decrementFunc: () async {
//                             if (productData!["qty"] > 0) {
//                               productData!["qty"] -= 1;
//                               // if (!saved) {
//                               // total -= item["productData!"]["sellingPrice"];
//                               // }

//                               setState(() {});

//                               updateBag(
//                                   productData!["id"], productData!["qty"]);
//                             }
//                             if (productData!["qty"] == 0) {
//                               cart.remove(productData!["id"]);
//                             }
//                           },
//                           incrementFunc: () async {
//                             if (productData!["qty"] < 5) {
//                               productData!["qty"] += 1;

//                               setState(() {});
//                               updateBag(
//                                   productData!["id"], productData!["qty"]);
//                             }
//                           },
//                         )
//                       : Expanded(
//                           child: Button(
//                               size: ButtonSize.medium,
//                               type: ButtonType.filled,
//                               label: "Add to Bag",
//                               onPress: () {
//                                 productData!["qty"] = 1;
//                                 cart.add(productData!["id"]);
//                                 addToBag(productData!["id"]);
//                                 showMessage(context,
//                                     "Added ${productData!["name"]} to bag");
//                                 setState(() {});
//                               })),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

class Accordion extends StatefulWidget {
  const Accordion({super.key, required this.title, required this.children});
  final String title;
  final List<Widget> children;
  @override
  State<Accordion> createState() => _AccordionState();
}

class _AccordionState extends State<Accordion> {
  bool open = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            open = !open;
            setState(() {});
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: Style.subHeadline
                    .copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),
              if (open)
                Icon(Icons.minimize, size: 18)
              else
                Icon(Icons.add, size: 18)
            ],
          ),
        ),
        SizedBox(height: 5),
        if (open)
          for (var child in widget.children) child,
        SizedBox(height: 10),
      ],
    );
  }
}
