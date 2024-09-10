import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../backend/server.dart';
import '../widgets.dart';
import '../types.dart';
import 'notifications.dart';
import 'dart:math' as math;

class Payments extends StatefulWidget {
  const Payments(
      {super.key,
      required this.qty,
      required this.total,
      required this.totalOriginal,
      required this.items});

  final int qty;
  final double total;
  final double totalOriginal;
  final List items;
  @override
  State<Payments> createState() => _PaymentsState();
}

class _PaymentsState extends State<Payments> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          title: const Text("Payment Methods"),
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
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       GestureDetector(
            //           onTap: () {
            //             Navigator.pop(context);
            //           },
            //           child: Icon(Icons.arrow_back, size: 22)),
            //       SizedBox(width: 15),
            //       Text(
            //         "Payment Methods",
            //         style: Style.footnoteEmphasized.copyWith(
            //           color: Theme.of(context).colorScheme.onSurface
            //         ),
            //       ),
            //       Expanded(child: SizedBox()),
            //       Icon(Icons.notifications_none, size: 22)
            //     ],
            //   ),
            // ),
            Divider(color: Theme.of(context).colorScheme.outline, height: 0.3),
            SizedBox(height: 10),
            Expanded(
                child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 10),
              children: [
                SizedBox(height: 10),
                Text(
                  "Payment options",
                ),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Theme.of(context).colorScheme.surfaceContainerLow),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Text(
                    "Payment Interface from Razorpay",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Theme.of(context).colorScheme.surfaceContainerLow),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Text(
                    "Payment on Delivery",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Pricing Details",
                      style: Style.footnoteEmphasized.copyWith(
                          color: Theme.of(context).colorScheme.onSurface)),
                  SizedBox(height: 10),
                  Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerLow),
                      child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("MRP (4 items)",
                                style: Style.body.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface)),
                            Text("₹ ${widget.totalOriginal}",
                                style: Style.body.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Discounts",
                                style: Style.body.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface)),
                            Text("-₹ ${widget.totalOriginal - widget.total}",
                                style: Style.body.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Delivery Charges",
                                style: Style.body.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface)),
                            Text("Free Delivery",
                                style: Style.body.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Total Amount",
                                style: Style.body.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface)),
                            Text("₹ ${widget.total}",
                                style: Style.body.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface)),
                          ],
                        )
                      ])),
                  SizedBox(height: 15),
                  Button(
                      size: ButtonSize.large,
                      type: ButtonType.filled,
                      label: "Continue",
                      onPress: () async {
                        String userId =
                            sharedPreferences!.get("phone").toString();
                        double weight = 0;
                        for (var item in widget.items) {
                          weight += item["product"]["weight"];
                        }
                        String phoneNumber =
                            sharedPreferences!.get("phone").toString();

                        var doc = await db.getDocument(
                            databaseId: AppConfig.database,
                            collectionId: AppConfig.users,
                            documentId: phoneNumber);

                        Map address = await getAddress();
                        Map warehouse = await getWareHouse();

                        var order = await db.createDocument(
                            databaseId: AppConfig.database,
                            collectionId: AppConfig.orders,
                            documentId: Uuid().v4(),
                            data: {
                              "userId": userId,
                              "userName": doc.data["userName"],
                              "phoneNumber": phoneNumber,
                              "deliveryAddress": address["address"],
                              "originalPrice": widget.totalOriginal,
                              "sellingPrice": widget.total,
                              "orderStatus": "pending",
                              "orderTime": DateTime.now().toString(),
                              "paymentType": "COD",
                              "lat": address["lat"],
                              "lng": address["lng"],
                              "distance": getDistance(
                                  address["lat"],
                                  address["lng"],
                                  warehouse["latitude"],
                                  warehouse["longitude"]),
                              "weight": weight.toInt(),
                              "qty": widget.qty,
                              "imageId": widget.items[0]["product"]["images"][0]
                            });

                        for (var item in widget.items) {
                          await db.createDocument(
                              databaseId: AppConfig.database,
                              collectionId: AppConfig.orderProductMap,
                              documentId: Uuid().v4(),
                              data: {
                                "orderId": order.$id,
                                "productId": item["productId"],
                                "name": item["product"]["name"],
                                "images": item["product"]["images"],
                                "sellingPrice": item["product"]["sellingPrice"],
                                "originalPrice": item["product"]
                                    ["originalPrice"],
                                "qty": item["qty"],
                              });
                        }
                        await clearBag();

                        Navigator.pop(context);
                      }),
                  SizedBox(height: 15),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  int getDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371; // Radius of the Earth in kilometers
    final lat1Rad = lat1 * math.pi / 180;
    final lon1Rad = lon1 * math.pi / 180;
    final lat2Rad = lat2 * math.pi / 180;
    final lon2Rad = lon2 * math.pi / 180;

    final dLat = lat2Rad - lat1Rad;
    final dLon = lon2Rad - lon1Rad;

    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1Rad) *
            math.cos(lat2Rad) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    final distance = R * c; // Distance in kilometers
    return distance.toInt();
  }
}
