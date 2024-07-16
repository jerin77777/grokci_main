import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grokci_main/backend/server.dart';
import 'package:grokci_main/types.dart';
import 'package:grokci_main/widgets.dart';

class Checkout extends StatefulWidget {
  const Checkout({super.key, required this.items});
  final List items;

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
                backgroundColor: Pallet.background,

        body: Column(
          children: [
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                    "Checkout",
                    style: Style.h3,
                  ),
                  Expanded(child: SizedBox()),
                  Icon(Icons.notifications_none, size: 22),
                ],
              ),
            ),
            Divider(color: Pallet.divider),
            SizedBox(height: 10),
            Expanded(
                child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              children: [
                Text(
                  "Delivery Information",
                  style: Style.h3,
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  decoration: BoxDecoration(color: Pallet.inner1, borderRadius: BorderRadius.circular(10)),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    // SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            "Deliver To:",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Button(
                            radius: 30,
                            padding: EdgeInsets.symmetric(vertical: 5),
                            color: Pallet.inner2,
                            fontColor: Pallet.primary,
                            label: "Change",
                            onPress: () {})
                      ],
                    ),
                    Text(
                      "Manish Kumar",
                      style: TextStyle(fontSize: 16),
                    ),
                    Text("X1, 201\nTiruvanthapuram City,\nValay Singh Yadhav Path,\nKhagul Path, 801503\n1234567890"),
                    SizedBox(height: 5)
                  ]),
                ),
                SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Pallet.inner1,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.delivery_dining,
                        color: Pallet.primary,
                      ),
                      SizedBox(width: 15),
                      Text(
                        "Delivery within a hour",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Text("Items", style: Style.h3),
                SizedBox(height: 10),
                Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Pallet.inner1),
                    child: Column(children: [for (var item in widget.items) product(item)])),
              ],
            ))
          ],
        ),
      ),
    );
  }

  product(Map item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              getUrl(Bucket.products, item["product"]["images"][0]),
              width: 80,
              height: 80,
            )),
        SizedBox(width: 10),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item["product"]["name"],
              style: TextStyle(fontSize: 16),
            ),
            Text(
              item["product"]["about"].toString(),
              maxLines: 1,
              style: Style.ellipsisText,
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item["product"]["originalPrice"].toString(),
                  style: TextStyle(
                      color: Pallet.font3,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.lineThrough),
                ),
                Text(
                  "₹ ${item["product"]["sellingPrice"].toString()}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                Container(
                  decoration: BoxDecoration(color: Pallet.inner2, borderRadius: BorderRadius.circular(5)),
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    children: [
                      GestureDetector(
                          onTap: () async {
                            item["qty"]++;
                            setState(() {});
                          },
                          child: Icon(Icons.add, size: 18, color: Pallet.font2)),
                      SizedBox(width: 10),
                      Text(item["qty"].toString()),
                      SizedBox(width: 10),
                      GestureDetector(
                          onTap: () async {
                            item["qty"]--;
                            setState(() {});
                          },
                          child: Icon(Icons.remove, size: 18, color: Pallet.font2))
                    ],
                  ),
                )
              ],
            ),
          ],
        ))
      ],
    );
  }
}
