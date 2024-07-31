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
                    style: Style.headline.copyWith(
                      color: Pallet.onBackground
                    ),
                  ),
                  Expanded(child: SizedBox()),
                  Icon(Icons.notifications_none, size: 22),
                ],
              ),
            ),
            Divider(color: Pallet.outline),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                Text(
                  "Delivery Information",
                  style: Style.footnoteEmphasized.copyWith(
                    color: Pallet.onBackground
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  decoration: BoxDecoration(color: Pallet.surface1, borderRadius: BorderRadius.circular(14)),
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
                            style: Style.headline.copyWith(
                              color: Pallet.onBackground
                            ),
                          ),
                        ),
                        Button(
                            radius: 30,
                            padding: EdgeInsets.symmetric(vertical: 5),
                            color: Pallet.tertiaryFill,
                            fontColor: Pallet.primary,
                            label: "Change",
                            onPress: () {})
                      ],
                    ),
                    Text(
                      "Manish Kumar",
                      style: Style.callout.copyWith(
                        color: Pallet.onBackground
                      ),
                    ),
                    Text("X1, 201\nTiruvanthapuram City,\nValay Singh Yadhav Path,\nKhagul Path, 801503\n1234567890",
                    style: Style.footnote.copyWith(
                      color: Pallet.onBackground
                    ),
                    ),
                    const SizedBox(height: 5)
                  ]),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  height: 54,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Pallet.surface1,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.delivery_dining,
                        color: Pallet.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Delivery within a hour",
                        style: Style.headline.copyWith(
                          color: Pallet.onBackground
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text("Items", style: Style.footnoteEmphasized.copyWith(
                  color: Pallet.onBackground
                )),
                const SizedBox(height: 8),
                Container(
                    padding: const EdgeInsets.only(left: 16, right: 14, bottom: 11, top: 11,),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: Pallet.surface1),
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
            borderRadius: BorderRadius.circular(11),
            child: Image.network(
              getUrl(Bucket.products, item["product"]["images"][0]),
              width: 65,
              height: 65,
            )),
        const SizedBox(width: 10),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item["product"]["name"],
              style: Style.body.copyWith(
                color: Pallet.onBackground
              ),
            ),
            Text(
              item["product"]["about"].toString(),
              maxLines: 1,
              style: Style.ellipsisText.merge(Style.subHeadline).copyWith(
                color: Pallet.onSurfaceVariant,
              ),
            ),
            const SizedBox(
              height: 7,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item["product"]["originalPrice"].toString(),
                  style: Style.title3Emphasized.copyWith(
                      color: Pallet.onSurfaceVariant,
                      decoration: TextDecoration.lineThrough),
                ),
                Text(
                  "₹ ${item["product"]["sellingPrice"].toString()}",
                  style: Style.title2Emphasized.copyWith(
                    color: Pallet.onBackground
                  ),
                ),
                Container(
                  decoration: BoxDecoration(color: Pallet.tertiaryFill, borderRadius: BorderRadius.circular(5)),
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    children: [
                      GestureDetector(
                          onTap: () async {
                            item["qty"]++;
                            setState(() {});
                          },
                          child: Icon(Icons.add, size: 18, color: Pallet.onBackground)),
                      SizedBox(width: 10),
                      Text(item["qty"].toString()),
                      SizedBox(width: 10),
                      GestureDetector(
                          onTap: () async {
                            item["qty"]--;
                            setState(() {});
                          },
                          child: Icon(Icons.remove, size: 18, color: Pallet.onBackground))
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
