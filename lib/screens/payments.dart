import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../backend/server.dart';
import '../widgets.dart';
import '../types.dart';

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
                    "Payment Methods",
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
                SizedBox(height: 10),
                Text(
                  "Payment options",
                ),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Pallet.surface1),
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
                      color: Pallet.surface1),
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
                      style: Style.footnoteEmphasized
                          .copyWith(color: Pallet.onBackground)),
                  SizedBox(height: 10),
                  Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Pallet.surface1),
                      child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("MRP (4 items)",
                                style: Style.body
                                    .copyWith(color: Pallet.onBackground)),
                            Text("₹ ${widget.totalOriginal}",
                                style: Style.body
                                    .copyWith(color: Pallet.onBackground)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Discounts",
                                style: Style.body
                                    .copyWith(color: Pallet.onBackground)),
                            Text("-₹ ${widget.totalOriginal - widget.total}",
                                style:
                                    Style.body.copyWith(color: Pallet.primary)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Delivery Charges",
                                style: Style.body
                                    .copyWith(color: Pallet.onBackground)),
                            Text("Free Delivery",
                                style:
                                    Style.body.copyWith(color: Pallet.primary)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Total Amount",
                                style: Style.body
                                    .copyWith(color: Pallet.onBackground)),
                            Text("₹ ${widget.total}",
                                style: Style.body
                                    .copyWith(color: Pallet.onBackground)),
                          ],
                        )
                      ])),
                  SizedBox(height: 15),
                  Button(
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
}
