import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grokci_main/backend/server.dart';
import 'package:grokci_main/types.dart';
import 'package:grokci_main/widgets.dart';

class ProductsInCategory extends StatefulWidget {
  const ProductsInCategory({super.key, required this.categoryId, required this.categoryName});
  final String categoryId;
  final String categoryName;
  @override
  State<ProductsInCategory> createState() => _ProductsInCategoryState();
}

class _ProductsInCategoryState extends State<ProductsInCategory> {
  List products = [];

  @override
  void initState() {
    getData();
    // TODO: implement initState
    super.initState();
  }

  getData() async {
    products = await getProducts(widget.categoryId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SizedBox(height: 10),
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
                    "Products in ${widget.categoryName}",
                    style: Style.h3,
                  ),
                  Expanded(child: SizedBox()),
                  Icon(Icons.notifications_none, size: 22)
                ],
              ),
            ),
            Divider(color: Colors.grey[300], height: 1),
            SizedBox(height: 10),
            if (products.isNotEmpty)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
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
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    product["about"].toString(),
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: Pallet.font2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
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
                    style: Style.h3,
                  ),
                  Expanded(child: SizedBox()),
                  Icon(Icons.notifications_none, size: 22)
                ],
              ),
            ),
            Divider(
              color: Colors.grey[300],
              height: 1,
            ),
            SizedBox(height: 10),
            Expanded(
              child: GridView.count(
                padding: EdgeInsets.symmetric(horizontal: 10),
                primary: false,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 2,
                childAspectRatio: 2.2,
                children: <Widget>[
                  for (var category in categories)
                    Container(
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
        body: Column(
          children: [
            // SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back, size: 22)),
                  SizedBox(width: 15),
                  Text(
                    productData!["name"],
                    style: Style.h3,
                  ),
                  Expanded(child: SizedBox()),
                  Icon(Icons.notifications_none, size: 22)
                ],
              ),
            ),
            Divider(color: Colors.grey[300], height: 1),
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
                    child: Image.network(getUrl(Bucket.products, productData!["images"][imageIdx]))),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  for (var i = 0; i < productData!["images"].length; i++)
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 2),
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: (i == imageIdx) ? Colors.grey : Colors.grey[300]),
                    )
                ]),
                SizedBox(height: 10),
                Text(
                  productData!["name"],
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Pallet.primary,
                      size: 16,
                    ),
                    Icon(
                      Icons.star,
                      color: Pallet.primary,
                      size: 16,
                    ),
                    Icon(
                      Icons.star,
                      color: Pallet.primary,
                      size: 16,
                    ),
                    Icon(
                      Icons.star,
                      color: Pallet.primary,
                      size: 16,
                    ),
                    Icon(
                      Icons.star,
                      color: Pallet.primary,
                      size: 16,
                    ),
                    SizedBox(width: 15),
                    Text(
                      "4.5 stars (1,089 ratings)",
                      style: TextStyle(color: Pallet.font2),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [Text("Qunatity:  ${productData!["netContent"]}")],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      "${productData!["discountPercentage"].toString()}% off",
                      style: TextStyle(fontSize: 20, color: Pallet.primary),
                    ),
                    SizedBox(width: 10),
                    Text(
                      productData!["originalPrice"].toString(),
                      style: TextStyle(
                          fontSize: 20,
                          decoration: TextDecoration.lineThrough,
                          color: Pallet.font2,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "₹ ${productData!["sellingPrice"]}",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    Expanded(child: SizedBox()),
                    Text(
                      "@₹${productData!["sellingPrice"]}/I",
                      style: TextStyle(color: Pallet.font2),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  "Product Details",
                  style: Style.h3,
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Pallet.inner1, borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.access_time_filled, color: Pallet.primary),
                          SizedBox(width: 10),
                          Text(
                            "Expiry Date: 30 OCT 2024",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                              style: TextStyle(fontSize: 16),
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
                              style: TextStyle(fontSize: 16),
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
                      if (productData!["eanCode"] != null || productData!["manufacturer"] != null) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Other Product Info",
                              style: TextStyle(fontSize: 16),
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
                          Icon(Icons.info, color: Pallet.primary),
                          SizedBox(width: 10),
                          Text(
                            "Additional details",
                            style: TextStyle(color: Pallet.primary, fontSize: 16),
                          ),
                          Expanded(child: SizedBox()),
                          Icon(Icons.keyboard_arrow_right_rounded, color: Pallet.primary)
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
              color: Colors.grey[300],
              height: 1,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Row(
                children: [
                  Expanded(
                      child: Button(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          radius: 30,
                          color: Pallet.inner2,
                          fontColor: Pallet.primary,
                          label: "Buy Now",
                          onPress: () {})),
                  SizedBox(width: 20),
                  Expanded(
                      child: Button(
                          padding: EdgeInsets.symmetric(vertical: 10), radius: 30, label: "Add to Bag", onPress: () {}))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
