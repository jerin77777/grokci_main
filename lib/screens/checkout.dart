import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grokci_main/backend/server.dart';
import 'package:grokci_main/screens/address.dart';
import 'package:grokci_main/screens/notifications.dart';
import 'package:grokci_main/screens/payments.dart';
import 'package:grokci_main/types.dart';
import 'package:grokci_main/widgets.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';

class Checkout extends StatefulWidget {
  const Checkout({super.key, required this.items});
  final List items;

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  Map? currentAddress;
  String name = "";
  bool queried = false;
  double total = 0;
  double totalOriginal = 0;
  int qty = 0;

  @override
  void initState() {
    getData();

    // TODO: implement initState
    super.initState();
  }

  getData() async {
    for (var item in widget.items) {
      totalOriginal += item["product"]["originalPrice"] * item["qty"];
      total += item["product"]["sellingPrice"] * item["qty"];
      qty += item["qty"] as int;
    }

    currentAddress = await getAddress();
    var doc = await db.getDocument(
        databaseId: AppConfig.database,
        collectionId: AppConfig.users,
        documentId: sharedPreferences!.get("phone").toString());

    name = doc.data["userName"];
    queried = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          title: const Text("Checkout"),
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
            const SizedBox(height: 10),
            Expanded(
                child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                Text(
                  "Delivery Information",
                  style: Style.footnoteEmphasized
                      .copyWith(color: Theme.of(context).colorScheme.onSurface),
                ),
                SizedBox(height: 10),
                if (currentAddress != null)
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    decoration: BoxDecoration(
                        color:
                            Theme.of(context).colorScheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(14)),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  "Deliver to:",
                                  style: Style.headline.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface),
                                ),
                              ),
                              Button(
                                  size: ButtonSize.small,
                                  type: ButtonType.gray,
                                  label: "Change",
                                  onPress: () {
                                    Navigator.push(
                                      mainContext,
                                      MaterialPageRoute(
                                          builder: (context) => Address()),
                                    );
                                    // Address
                                  })
                            ],
                          ),
                          const SizedBox(height: 8,),
                          Text(
                            currentAddress?["name"],
                            style: Style.callout.copyWith(
                                color: Theme.of(context).colorScheme.onSurface),
                          ),
                          Text(
                            name,
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(currentAddress?["address"],
                              style: Style.footnote.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface)),
                          SizedBox(height: 5)
                        ]),
                  )
                else if (queried)
                  Button(
                      size: ButtonSize.large,
                      type: ButtonType.gray,
                      label: "Add New Address",
                      onPress: () {
                        Navigator.push(
                          mainContext,
                          MaterialPageRoute(builder: (context) => AddAddress()),
                        ).then((_) {
                          getData();
                        });
                      }),
                SizedBox(height: 10),
                Container(
                  height: 54,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Theme.of(context).colorScheme.surfaceContainerLow,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.truckFast,
                        color: Theme.of(context).colorScheme.primary,
                        size: 16,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "Delivering within a hour",
                        style: Style.headline.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text("Items",
                    style: Style.footnoteEmphasized.copyWith(
                        color: Theme.of(context).colorScheme.onSurface)),
                const SizedBox(height: 8),
                Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color:
                            Theme.of(context).colorScheme.surfaceContainerLow),
                    child: Column(children: [
                      for (var item in widget.items) product(item)
                    ])),
                SizedBox(height: 10),
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
                      padding: EdgeInsets.all(16),
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
                            Text("₹ $totalOriginal",
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
                            Text("-₹ ${totalOriginal - total}",
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
                            Text("₹ ${total}",
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
                      label: "Proceed to Payment",
                      onPress: () {
                        Navigator.push(
                          mainContext,
                          MaterialPageRoute(
                              builder: (context) => Payments(
                                    qty: qty,
                                    total: total,
                                    totalOriginal: totalOriginal,
                                    items: widget.items,
                                  )),
                        ).then((_) {
                          Navigator.pop(context);
                        });
                        // Payments
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
              style: Style.body
                  .copyWith(color: Theme.of(context).colorScheme.onSurface),
            ),
            Text(
              item["product"]["about"].toString(),
              maxLines: 1,
              style: Style.ellipsisText.merge(Style.subHeadline).copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      decoration: TextDecoration.lineThrough),
                ),
                Text(
                  "₹ ${item["product"]["sellingPrice"].toString()}",
                  style: Style.title2Emphasized
                      .copyWith(color: Theme.of(context).colorScheme.onSurface),
                ),
                StepperWidget(
                    quantity: item["qty"],
                    incrementFunc: () async {
                      item["qty"]--;
                      setState(() {});
                    },
                    decrementFunc: () async {
                      item["qty"]++;
                      setState(() {});
                    }),
              ],
            ),
          ],
        ))
      ],
    );
  }
}

// class Payments extends StatefulWidget {
//   const Payments({super.key});

//   @override
//   State<Payments> createState() => _PaymentsState();
// }

// class _PaymentsState extends State<Payments> {
//   final _razorpay = Razorpay();

//   @override
//   void initState() {
//     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
//     // TODO: implement initState
//     super.initState();
//   }

//   void _handlePaymentSuccess(PaymentSuccessResponse response) {
//     print("ching ${response}");
//     // Do something when payment succeeds
//   }

//   void _handlePaymentError(PaymentFailureResponse response) {
//     print("chang ${response}");
//     // Do something when payment fails
//   }

//   void _handleExternalWallet(ExternalWalletResponse response) {
//     // Do something when an external wallet was selected
//   }
//   var options = {
//     'key': ' rzp_test_mKFJZWtl4Tzu0k',
//     'amount': 100,
//     'currency': 'INR',
//     'name': 'Acme Corp.',
//     'description': 'Fine T-Shirt',
//     'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'}
//   };

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           GestureDetector(
//             onTap: () {
//               _razorpay.open(options);
//             },
//             child: Container(
//               width: 200,
//               height: 200,
//               color: Colors.red,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
