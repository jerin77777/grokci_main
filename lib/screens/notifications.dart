import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../backend/server.dart';
import '../types.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  List<Map> notifications = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  getData() async {
    notifications = await getNotifications();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          title: const Text("Notifications"),
          // actions: <Widget>[
          //   IconButton(
          //     icon: const Icon(Icons.notifications_none),
          //     onPressed: () {
          //       Navigator.push(
          //         mainContext,
          //         MaterialPageRoute(builder: (context) => Notifications()),
          //       );
          //     },
          //   ),
          // ],
        ),
        body: Column(
          children: [
            Divider(color: Theme.of(context).colorScheme.outline, height: 0.3),
            if (notifications.isNotEmpty)
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  children: [
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Mark all as read",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Text("Recent notifications"),
                    SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHigh),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Column(
                        children: [
                          for (var notification in notifications)
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SvgPicture.asset(
                                    width: 60,
                                    "assets/logo_icon.svg",
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Notification Title",
                                          style: Style.headline.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface)),
                                      Text(
                                        "Subject of the chat here",
                                        style: Style.footnote.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface),
                                      ),
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
