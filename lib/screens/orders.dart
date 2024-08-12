import 'package:flutter/material.dart';
import 'package:grokci_main/backend/server.dart';

import '../types.dart';
import '../widgets.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  List orders = [];
  @override
  void initState() {
    getData();

    // TODO: implement initState
    super.initState();
  }

  getData() async {
    orders = await getOrders();
    print(orders);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Pallet.background,
          body: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
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
                      "My Orders",
                      style:
                          Style.headline.copyWith(color: Pallet.onBackground),
                    ),
                    Expanded(child: SizedBox()),
                    Icon(Icons.notifications_none, size: 22)
                  ],
                ),
              ),
              Divider(color: Pallet.outline, height: 1),
              SizedBox(height: 10),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  children: [
                    for (var order in orders)
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            mainContext,
                            MaterialPageRoute(
                                builder: (context) =>
                                    OrderDetails(order: order)),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Pallet.primaryFill,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  // width: 50,
                                  child: Image.network(
                                    getUrl(Bucket.products, order["imageId"]),
                                    width: 60,
                                    height: 60,
                                  )),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text("Status: ${order["orderStatus"]}",
                                            style: TextStyle(fontSize: 15)),
                                        Expanded(child: SizedBox()),
                                        Icon(Icons.arrow_forward_ios_sharp,
                                            size: 10)
                                      ],
                                    ),
                                    Text("Multiple Item (4 Items)",
                                        style: TextStyle(fontSize: 15)),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            text: "Order Value: ",
                                            style: TextStyle(fontSize: 14),
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: '₹ 179',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600)),
                                            ],
                                          ),
                                        ),
                                        // Text("Order Value: ₹ 179",
                                        //     style: TextStyle(fontSize: 15)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                  ],
                ),
              )
            ],
          )),
    );
  }
}

class OrderDetails extends StatefulWidget {
  const OrderDetails({super.key, required this.order});
  final Map order;
  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  List products = [];
  @override
  void initState() {
    getData();
    // TODO: implement initState
    super.initState();
  }

  getData() async {
    products = await getOrderProducts(widget.order["id"]);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Pallet.background,
        body: Column(
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
                    "Order Details",
                    style: Style.footnoteEmphasized
                        .copyWith(color: Pallet.onBackground),
                  ),
                  Expanded(child: SizedBox()),
                  Icon(Icons.notifications_none, size: 22)
                ],
              ),
            ),
            Divider(color: Pallet.outline, height: 1),
            SizedBox(height: 10),
            Expanded(
                child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 10),
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Pallet.primaryFill),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Column(
                    children: [
                      Text("Order ID: ${widget.order["id"]}",
                          maxLines: 1, overflow: TextOverflow.clip),
                      SizedBox(height: 5),
                      Divider(color: Pallet.outline, height: 1),
                      for (var product in products)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(
                                  getUrl(Bucket.products, product["images"][0]),
                                  width: 60,
                                  height: 60,
                                ),
                              ),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Order Id: ${product["name"]}"),
                                  SizedBox(height: 15),
                                  Text(
                                    "₹ ${product["sellingPrice"]}",
                                    style: TextStyle(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      SizedBox(height: 10),
                      Divider(color: Pallet.outline, height: 1),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text("Total amount Paid:"),
                          Text(
                            "₹ ${widget.order["sellingPrice"]}",
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.file_copy),
                    SizedBox(width: 5),
                    Text(
                      "Download Invoice",
                      style: TextStyle(color: Pallet.primary),
                    ),
                    Expanded(child: SizedBox()),
                    Icon(Icons.arrow_forward_ios, color: Pallet.primary)
                  ],
                ),
                SizedBox(height: 10),
                Text("pricing details"),
                SizedBox(height: 10),
                Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Pallet.primaryFill),
                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("MRP (${widget.order["qty"]} items)",
                              style: TextStyle(fontSize: 16)),
                          Text("₹ ${widget.order["sellingPrice"]}",
                              style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Discounts", style: TextStyle(fontSize: 16)),
                          Text(
                              "-₹ ${widget.order["originalPrice"] - widget.order["sellingPrice"]}",
                              style: TextStyle(
                                  fontSize: 16, color: Pallet.primary)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Delivery Charges",
                              style: TextStyle(fontSize: 16)),
                          Text("Free Delivery",
                              style: TextStyle(
                                  fontSize: 16, color: Pallet.primary)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total Amount", style: TextStyle(fontSize: 16)),
                          Text("₹ ${widget.order["sellingPrice"]}",
                              style: TextStyle(fontSize: 16)),
                        ],
                      )
                    ])),
                SizedBox(height: 15),
                Button(
                    label: "Proceed to Payment",
                    onPress: () {
                      // Navigator.push(
                      //   mainContext,
                      //   MaterialPageRoute(
                      //       builder: (context) => Payments(
                      //         qty: qty,
                      //             total: total,
                      //             totalOriginal: totalOriginal,
                      //             items: widget.items,
                      //           )),
                      // ).then((_) {
                      //   Navigator.pop(context);
                      // });
                      // Payments
                    }),
                SizedBox(height: 15)
              ],
            )),
          ],
        ),
      ),
    );
  }
}
