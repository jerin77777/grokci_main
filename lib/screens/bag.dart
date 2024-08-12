import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grokci_main/backend/server.dart';
import 'package:grokci_main/types.dart';
import 'package:grokci_main/widgets.dart';
import 'checkout.dart';

class Bag extends StatefulWidget {
  const Bag({super.key});

  @override
  State<Bag> createState() => _BagState();
}

class _BagState extends State<Bag> {
  double total = 0;

  List bag = [];
  List saved = [];
  bool queried = false;
  @override
  void initState() {
    getData(saveForLater: true);
    // TODO: implement initState
    super.initState();
  }

  getData({bool? saveForLater}) async {
    total = 0;
    bag = await getBag();
    for (var item in bag) {
      Map product = await getProduct(item["productId"]);
      item["product"] = product;
      total += item["product"]["sellingPrice"] * item["qty"];
    }

    if (saveForLater == true) {
      saved = await getSaveForLater();
      for (var item in saved) {
        Map product = await getProduct(item["productId"]);
        item["product"] = product;
      }
    }

    queried = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                  onTap: () {
                    routerSink.add({"route": "dashboard"});
                  },
                  child: Icon(Icons.arrow_back, size: 22)),
              Icon(Icons.notifications_none, size: 22)
            ],
          ),
          SizedBox(height: 10),
          Text(
            "Bag",
            style: Style.title1Emphasized,
          ),
          SizedBox(height: 10),
          if (!queried)
            Expanded(
              child: Center(
                child: CircularProgressIndicator(color: Pallet.primary,),
              ),
            )
          else if (bag.isEmpty && saved.isEmpty)
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/no_items.jpg"),
                  Text(
                    "No items found",
                    style: TextStyle(color: Pallet.onSurfaceVariant),
                  )
                ],
              ),
            )
          else
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 5),
                children: [
                  if (bag.isNotEmpty)
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: Pallet.surface1),
                      child: Column(
                        children: [
                          for (var item in bag) product(item, false),
                        ],
                      ),
                    ),
                  SizedBox(height: 10),
                  if (saved.isNotEmpty)
                    Text(
                      "Saved for later",
                      style: Style.footnoteEmphasized,
                    ),
                  SizedBox(height: 10),
                  for (var item in saved) product(item, true)
                ],
              ),
            ),
          SizedBox(height: 10),
          if (total != 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total Amount:",
                        style: Style.subHeadlineEmphasized,
                      ),
                      SizedBox(height: 5),
                      Text(
                        "\₹ ${total}",
                        style:Style.title3,
                      ),
                    ],
                  )),
                  Button(
                      label: "Proceed to Buy",
                      radius: 30,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      onPress: () {
                        Navigator.push(
                          mainContext,
                          MaterialPageRoute(
                              builder: (context) => Checkout(
                                    items: bag,
                                  )),
                        ).then((_) {
                          getData();
                        });
                      })
                ],
              ),
            )
        ],
      ),
    );
  }

  product(Map item, bool saved) {
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
        const SizedBox(width: 10),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item["product"]["name"],
              style: Style.body,
            ),
            Text(
              item["product"]["about"].toString(),
              maxLines: 1,
              style: Style.ellipsisText.merge(Style.subHeadline).copyWith(
                      color: Pallet.onSurfaceVariant
              ),
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item["product"]["originalPrice"].toString(),
                  style: Style.title3Emphasized.copyWith(
                    decoration: TextDecoration.lineThrough,
                    color: Pallet.onSurfaceVariant
                  )
                ),
                Text(
                  "₹ ${item["product"]["sellingPrice"].toString()}",
                  style: Style.title3Emphasized.copyWith(
                    color: Pallet.onBackground
                  ),
                ),
                StepperWidget(quantity: item["qty"], incrementFunc: () async {
                            item["qty"] += 1;
                            if (!saved) {
                              total += item["product"]["sellingPrice"];
                            }

                            setState(() {});
                            updateBag(item["productId"], item["qty"]);

                            // getData();
                          }, decrementFunc: () async {
                            if (item["qty"] > 0) {
                              item["qty"] -= 1;
                              total -= item["product"]["sellingPrice"];

                              setState(() {});
                              updateBag(item["productId"], item["qty"]);
                            }
                            if (item["qty"] == 0) {
                              bag.remove(item);
                            }
                          }),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Button(
                    radius: 30,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    label: "Remove",
                    color: Pallet.tertiaryFill,
                    fontColor: Pallet.error,
                    onPress: () async {
                      await updateBag(item["productId"], 0);

                      getData();
                    }),
                SizedBox(width: 10),
                Button(
                    radius: 30,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    label: saved ? "Move to Bag" : "Save for later",
                    onPress: () async {
                      await saveForLater(item["productId"], !saved);
                      getData(saveForLater: saved);
                    })
              ],
            ),
          ],
        ))
      ],
    );
  }
}
