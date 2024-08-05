import 'package:flutter/material.dart';
import 'package:grokci_main/types.dart';
import 'package:grokci_main/widgets.dart';

class Support extends StatefulWidget {
  const Support({super.key});

  @override
  State<Support> createState() => _SupportState();
}

class _SupportState extends State<Support> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Pallet.background,
        body: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.arrow_back),
                  SizedBox(width: 15),
                  Text(
                    "Support",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  Expanded(child: SizedBox()),
                  Icon(Icons.notifications_none)
                ],
              ),
              Expanded(
                  child: ListView(
                children: [
                  Button(label: "Start new conversation", onPress: () {}),
                  Text("Recent chats"),
                  Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Pallet.tertiaryFill),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Column(
                      children: [
                        Text("Ticket Id"),
                        Text("Subject of the chat here"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Date: 21/05/2024"),
                            Text(
                              "Status: in-review",
                              style: TextStyle(color: Pallet.onSurfaceVariant),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
