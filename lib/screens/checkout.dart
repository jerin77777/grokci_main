import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grokci_main/backend/server.dart';
import 'package:grokci_main/screens/address.dart';
import 'package:grokci_main/screens/payments.dart';
import 'package:grokci_main/types.dart';
import 'package:grokci_main/widgets.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

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
                if (currentAddress != null)
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    decoration: BoxDecoration(
                        color: Pallet.inner1,
                        borderRadius: BorderRadius.circular(10)),
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
                                  currentAddress?["name"],
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Button(
                                  radius: 30,
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  color: Pallet.inner2,
                                  fontColor: Pallet.primary,
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
                          Text(
                            name,
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(currentAddress?["address"]),
                          SizedBox(height: 5)
                        ]),
                  )
                else if (queried)
                  Button(
                      color: Pallet.inner1,
                      fontColor: Pallet.primary,
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Pallet.inner1),
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
                  Text("pricing details", style: Style.h3),
                  SizedBox(height: 10),
                  Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Pallet.inner1),
                      child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("MRP (4 items)",
                                style: TextStyle(fontSize: 16)),
                            Text("₹ ${totalOriginal}",
                                style: TextStyle(fontSize: 16)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Discounts", style: TextStyle(fontSize: 16)),
                            Text("-₹ ${totalOriginal - total}",
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
                            Text("Total Amount",
                                style: TextStyle(fontSize: 16)),
                            Text("₹ ${total}", style: TextStyle(fontSize: 16)),
                          ],
                        )
                      ])),
                  SizedBox(height: 15),
                  Button(
                      label: "Proceed to Payment",
                      onPress: () {
                        Navigator.push(
                          mainContext,
                          MaterialPageRoute(
                              builder: (context) => Payments(
                                    total: total,
                                    totalOriginal: totalOriginal,
                                    items: widget.items,
                                  )),
                        ).then((_){
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
                  decoration: BoxDecoration(
                      color: Pallet.inner2,
                      borderRadius: BorderRadius.circular(5)),
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    children: [
                      GestureDetector(
                          onTap: () async {
                            item["qty"]++;
                            setState(() {});
                          },
                          child:
                              Icon(Icons.add, size: 18, color: Pallet.font2)),
                      SizedBox(width: 10),
                      Text(item["qty"].toString()),
                      SizedBox(width: 10),
                      GestureDetector(
                          onTap: () async {
                            item["qty"]--;
                            setState(() {});
                          },
                          child:
                              Icon(Icons.remove, size: 18, color: Pallet.font2))
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
