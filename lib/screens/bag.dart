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
  List bag = [];
  List saved = [];
  double total = 0;
  @override
  void initState() {
    getData(saveForLater: true);
    // TODO: implement initState
    super.initState();
  }

  getData({bool? saveForLater}) async {
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

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Icon(Icons.arrow_back), Icon(Icons.notifications_none)],
          ),
          SizedBox(height: 10),
          Text(
            "Bag",
            style: Style.h1,
          ),
          SizedBox(height: 10),
          if (bag.isEmpty && saved.isEmpty)
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/no_items.jpg"),
                  Text(
                    "No items found",
                    style: TextStyle(color: Pallet.font3),
                  )
                ],
              ),
            )
          else
            Expanded(
              child: ListView(
                children: [
                  if (bag.isNotEmpty)
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Pallet.inner1),
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
                      style: Style.h3,
                    ),
                  SizedBox(height: 10),
                  for (var item in saved) product(item, true)
                ],
              ),
            ),
          SizedBox(height: 10),
          if (total != 0)
            Row(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total Amount:",
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "\$ ${total}",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ],
                )),
                Button(
                    label: "Proceed to Buy",
                    radius: 30,
                    onPress: () {
                      Navigator.push(
                        mainContext,
                        MaterialPageRoute(
                            builder: (context) => Checkout(
                                  items: bag,
                                )),
                      );
                      // routerSink.add({"route": "checkout"});
                      // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Checkout()));
                    })
              ],
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
              style: TextStyle(color: Pallet.font3),
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
                            await updateBag(item["productId"], (item["qty"] + 1));
                            getData();
                          },
                          child: Icon(Icons.add, size: 18, color: Pallet.font2)),
                      SizedBox(width: 10),
                      Text(item["qty"].toString()),
                      SizedBox(width: 10),
                      GestureDetector(
                          onTap: () async {
                            await updateBag(item["productId"], (item["qty"] - 1));
                            getData();
                          },
                          child: Icon(Icons.remove, size: 18, color: Pallet.font2))
                    ],
                  ),
                )
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
                    color: Pallet.inner2,
                    fontColor: Color(0xFFBA1A1A),
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
