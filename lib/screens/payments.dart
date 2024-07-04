import 'package:flutter/material.dart';
import 'package:grokci_main/widgets.dart';

class Payments extends StatefulWidget {
  const Payments({super.key});

  @override
  State<Payments> createState() => _PaymentsState();
}

class _PaymentsState extends State<Payments> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Expanded(
              child: ListView(
            children: [
              Text("Payment options"),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Text(
                  "Payment Interface from Razorpay",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          )),
          Text("Pricing Details"),
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  children: [Text("MRP (4 Items)"), Text("\$ 884")],
                ),
                Row(
                  children: [Text("Discounts"), Text("-\$ 128")],
                ),
                Row(
                  children: [Text("Delivery Charges"), Text("FREE Delivery")],
                ),
                Divider()
              ],
            ),
          ),
          Button(label: "Continue", onPress: () {})
        ],
      ),
    );
  }
}
