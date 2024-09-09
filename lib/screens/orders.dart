import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grokci_main/backend/server.dart';

import '../types.dart';
import '../widgets.dart';
import 'notifications.dart';

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
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(
            title: const Text("My Orders"),
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
              Divider(
                  color: Theme.of(context).colorScheme.outline, height: 0.3),
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
                          margin: EdgeInsets.only(top: 10),
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  // width: 50,
                                  child: Image.network(
                                    getUrl(Bucket.products, order["imageId"]),
                                    width: 70,
                                    height: 70,
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
                                    Text(
                                        "Multiple Item (${order["qty"]} Items)",
                                        style: TextStyle(fontSize: 15)),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                            "Order Value: ₹${order["sellingPrice"]}")
                                        // RichText(
                                        //   text: TextSpan(
                                        //     text: "Order Value: ",
                                        //     style: TextStyle(fontSize: 14),
                                        //     children: <TextSpan>[
                                        //       TextSpan(
                                        //           text: '',
                                        //           style: ),
                                        //     ],
                                        //   ),
                                        // ),
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
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          title: const Text("Order Details"),
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
            Divider(color: Theme.of(context).colorScheme.outline, height: 0.3),
            SizedBox(height: 10),
            Expanded(
                child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 10),
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:
                          Theme.of(context).colorScheme.surfaceContainerHigh),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Order ID: ${widget.order["id"]}",
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        style: Style.callout,
                      ),
                      SizedBox(height: 5),
                      Divider(
                          color: Theme.of(context).colorScheme.outline,
                          height: 1),
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
                                  Text(
                                    product["name"],
                                    style: Style.callout,
                                  ),
                                  SizedBox(height: 15),
                                  Text(
                                    "₹ ${product["sellingPrice"]}",
                                    style: Style.calloutEmphasized,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surfaceContainer,
                                        borderRadius: BorderRadius.circular(8)),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    child: Text(
                                        "Qty: ${product["qty"].toString()}"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      SizedBox(height: 10),
                      Divider(
                          color: Theme.of(context).colorScheme.outline,
                          height: 1),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total amount Paid:",
                            style: Style.calloutEmphasized,
                          ),
                          Text(
                            "₹ ${widget.order["sellingPrice"]}",
                            style: Style.calloutEmphasized,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    FaIcon(FontAwesomeIcons.brandsFontAwesome),
                    SizedBox(width: 5),
                    Text(
                      "Download Invoice",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    Expanded(child: SizedBox()),
                    Icon(Icons.arrow_forward_ios,
                        color: Theme.of(context).colorScheme.primary)
                  ],
                ),
                SizedBox(height: 20),
                Text("pricing details"),
                SizedBox(height: 10),
                Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color:
                            Theme.of(context).colorScheme.surfaceContainerHigh),
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
                                  fontSize: 16,
                                  color:
                                      Theme.of(context).colorScheme.primary)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Delivery Charges",
                              style: TextStyle(fontSize: 16)),
                          Text("Free Delivery",
                              style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      Theme.of(context).colorScheme.primary)),
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
                    size: ButtonSize.large,
                    type: ButtonType.filled,
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
