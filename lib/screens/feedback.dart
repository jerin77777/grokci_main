import 'package:flutter/material.dart';
import 'package:grokci_main/types.dart';
import 'package:grokci_main/widgets.dart';
import 'package:uuid/uuid.dart';

import '../backend/server.dart';
import 'notifications.dart';
import 'package:intl/intl.dart';

Future<void> addFeedback(BuildContext context) async {
  TextEditingController title = TextEditingController();
  TextEditingController subject = TextEditingController();
  await showDialog(
      context: context,
      builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            backgroundColor: Theme.of(context).colorScheme.surface,
            content: SizedBox(
              width: 150,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "name",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 5),
                  TextBox(
                    controller: title,
                    radius: 10,
                  ),
                  SizedBox(height: 5),
                  Text(
                    "subject",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 5),
                  TextBox(
                    controller: subject,
                    maxLines: 5,
                    radius: 10,
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Button(
                        size: ButtonSize.small,
                        type: ButtonType.gray,
                        label: "Cancel",
                        onPress: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      SizedBox(width: 10),
                      Button(
                        size: ButtonSize.small,
                        type: ButtonType.filled,
                        label: "Done",
                        onPress: () async {
                          String userId =
                              sharedPreferences!.get("phone").toString();

                          await db.createDocument(
                              databaseId: AppConfig.database,
                              collectionId: AppConfig.feedback,
                              documentId: Uuid().v4(),
                              data: {
                                "userId": userId,
                                "title": title.text,
                                "body": subject.text,
                                "status": "in-review",
                                "date": DateTime.now().toString(),
                              });
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ));
}

class FeedBack extends StatefulWidget {
  const FeedBack({super.key});

  @override
  State<FeedBack> createState() => _FeedBackState();
}

class _FeedBackState extends State<FeedBack> {
  List feedback = [];
  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    feedback = await getFeedBack();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          leadingWidth: 60,
          title: const Text("Notifications"),
        ),
        body: Column(
          children: [
            Divider(color: Theme.of(context).colorScheme.outline, height: 0.3),
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(10),
                children: [
                  Button(
                      size: ButtonSize.large,
                      type: ButtonType.gray,
                      label: "Share new feedback",
                      onPress: () {
                        addFeedback(context).then((_) {
                          getData();
                        });
                      }),
                  SizedBox(height: 10),
                  if (feedback.isNotEmpty) Text("Recent chats"),
                  SizedBox(height: 10),
                  if (feedback.isNotEmpty)
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color:
                              Theme.of(context).colorScheme.surfaceContainer),
                      child: Column(
                        children: [
                          for (var data in feedback)
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(data["title"]),
                                  Text(data["body"]),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Date: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(data["date"]))}"),
                                      Text(
                                        "Status: ${data["status"]}",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class Support extends StatefulWidget {
//   const Support({super.key});

//   @override
//   State<Support> createState() => _SupportState();
// }

// // class _SupportState extends State<Support> {
 
// // }
