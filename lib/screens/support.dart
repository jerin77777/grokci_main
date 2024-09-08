import 'package:flutter/material.dart';
import 'package:grokci_main/screens/notifications.dart';
import 'package:grokci_main/types.dart';
import 'package:grokci_main/widgets.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

import '../backend/server.dart';

addSupport(BuildContext context) async {
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
                              collectionId: AppConfig.support,
                              documentId: Uuid().v4(),
                              data: {
                                "userId": userId,
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

class Support extends StatefulWidget {
  const Support({super.key});

  @override
  State<Support> createState() => _SupportState();
}

class _SupportState extends State<Support> {
  List<Map> support = [];
  @override
  void initState() {
    getData();
    // TODO: implement initState
    super.initState();
  }

  getData() async {
    support = await getSupport();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        leadingWidth: 30,
        title: Text(
          "Support",
          style: Style.headline
              .copyWith(color: Theme.of(context).colorScheme.onSurface),
        ),
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
          Divider(color: Theme.of(context).colorScheme.outline, height: 1),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(10),
              children: [
                Button(
                    size: ButtonSize.large,
                    type: ButtonType.gray,
                    label: "Start new conversation",
                    onPress: () {
                      addSupport(context).then((_) {
                        getData();
                      });
                    }),
                SizedBox(height: 10),
                Text("Recent chats"),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:
                          Theme.of(context).colorScheme.surfaceContainerHigh),
                  child: Column(
                    children: [
                      for (var data in support)
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Ticket Id (${data["id"]})",
                                overflow: TextOverflow.ellipsis,
                                style: Style.subHeadline.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                              ),
                              Text(data["body"]),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [

                                  Text(
                                    "Date: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(data["date"]))}",
                                    style: Style.subHeadline.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface),
                                  ),
                                  Text(
                                    "Status: ${data["status"]}",
                                    style: Style.subHeadline.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
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
    );
  }
}
