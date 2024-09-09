import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grokci_main/backend/server.dart';
import 'package:grokci_main/types.dart';
import 'package:grokci_main/widgets.dart';
import 'checkout.dart';
import 'notifications.dart';

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
    bag = getBagLocal();
    if (bag.isNotEmpty) {
      queried = true;
    }
    setState(() {});

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

    saveBag(bag);

    queried = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              // crossAxisAlignment: CrossAxisAlignment.start,
              slivers: [
                SliverAppBar.medium(
                  leading: IconButton(
                    onPressed: () {
                      routerSink.add({"route": "dashboard"});
                    },
                    icon: Icon(Icons.arrow_back),
                  ),
                  title: Text(
                    "Bag",
                    style: Style.title1Emphasized,
                  ),
                  actions: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.notifications_none),
                      onPressed: () {
                        Navigator.push(
                          mainContext,
                          MaterialPageRoute(
                              builder: (context) => Notifications()),
                        );
                      },
                    ),
                  ],
                ),
                if (!queried)
                  SliverToBoxAdapter(
                    child: Column(
                        children: [
                          const SizedBox(height: 40,),
                          Center(child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.primary,))
                        ]
                      )
                  )
                else if (bag.isEmpty && saved.isEmpty)
                  SliverToBoxAdapter(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/no_items.jpg"),
                        Text(
                          "No items found",
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant),
                        )
                      ],
                    ),
                  )
                else
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          if (bag.isNotEmpty)
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .surfaceContainerLow),
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
                  ),
              ],
            ),
          ),
          if (total != 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
                        style: Style.title3,
                      ),
                    ],
                  )),
                  Button(
                      size: ButtonSize.medium,
                      type: ButtonType.filled,
                      label: "Proceed to Buy",
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
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(item["product"]["originalPrice"].toString(),
                    style: Style.title3Emphasized.copyWith(
                        decoration: TextDecoration.lineThrough,
                        color: Theme.of(context).colorScheme.onSurfaceVariant)),
                Text(
                  "₹ ${item["product"]["sellingPrice"].toString()}",
                  style: Style.title3Emphasized
                      .copyWith(color: Theme.of(context).colorScheme.onSurface),
                ),
                StepperWidget(
                    quantity: item["qty"],
                    incrementFunc: () async {
                      if (item["qty"] < 5) {
                        item["qty"] += 1;
                        if (!saved) {
                          total += item["product"]["sellingPrice"];
                        }

                        setState(() {});
                        updateBag(item["productId"], item["qty"]);
                      }

                      // getData();
                    },
                    decrementFunc: () async {
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
                    size: ButtonSize.medium,
                    type: ButtonType.gray,
                    label: "Remove",
                    labelStyle:
                        TextStyle(color: Theme.of(context).colorScheme.error),
                    onPress: () async {
                      await updateBag(item["productId"], 0);

                      getData();
                    }),
                SizedBox(width: 10),
                Button(
                    size: ButtonSize.medium,
                    type: ButtonType.filled,
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
