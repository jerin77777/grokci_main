import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:grokci_main/types.dart';
import 'package:local_auth/local_auth.dart';

import '../backend/server.dart';

class Security extends StatefulWidget {
  const Security({super.key});

  @override
  State<Security> createState() => _SecurityState();
}

class _SecurityState extends State<Security> {
  @override
  void initState() {
    type = getThemeType();
    super.initState();
  }

  String type = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          leadingWidth: 30,
          title: Text(
            "User Preferences",
            style: Style.headline
                .copyWith(color: Theme.of(context).colorScheme.onSurface),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.notifications_none),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(color: Theme.of(context).colorScheme.outline, height: 1),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    "Theme",
                    style: Style.footnoteEmphasized.copyWith(
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                  const SizedBox(height: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Theme mode",
                            style: Style.body.copyWith(
                                color: Theme.of(context).colorScheme.onSurface),
                          ),
                          MenuAnchor(
                            menuChildren: [
                              MenuItemButton(
                                onPressed: () {
                                  type = "System Default";
                                  saveThemeType(type);
                                  setState(() {});
                                },
                                child: Text('System Default'),
                              ),
                              MenuItemButton(
                                onPressed: () {
                                  type = "Light";
                                  saveThemeType(type);
                                  setState(() {});
                                },
                                child: Text('Light'),
                              ),
                              MenuItemButton(
                                onPressed: () {
                                  type = "Dark";
                                  saveThemeType(type);
                                  setState(() {});
                                },
                                child: Text('Dark'),
                              ),
                            ],
                            builder: (BuildContext context,
                                MenuController controller, Widget? child) {
                              return ElevatedButton(
                                onPressed: () {
                                  controller.open();
                                  print("object");
                                },
                                child: Text(type),
                              );
                            },
                          ),
                          // PopupMenuButton<String>(
                          //   onSelected: (value) {
                          //     // Handle the value selected from the menu
                          //     print('Selected: $value');
                          //   },
                          //   itemBuilder: (BuildContext context) {
                          //     return [
                          //       PopupMenuItem<String>(
                          //         value: 'System Default',
                          //         child: Text('System Default'),
                          //       ),
                          //       PopupMenuItem<String>(
                          //         value: 'Light',
                          //         child: Text('Light'),
                          //       ),
                          //       PopupMenuItem<String>(
                          //         value: 'Dark',
                          //         child: Text('Dark'),
                          //       ),
                          //     ];
                          //   },
                          //   child: ElevatedButton(
                          //     onPressed: () {
                          //       // This button will trigger the menu
                          //     },
                          //     child: Text('Default'),
                          //   ),
                          // )
                          // Expanded(
                          //   child: MenuAnchor(menuChildren: [
                          //       (
                          //         onPressed: () {},
                          //         child: Text(
                          //           "System default",
                          //           style: Style.body.copyWith(
                          //               color: Theme.of(context)
                          //                   .colorScheme
                          //                   .onSurface),
                          //         )),
                          //     MenuItemButton(
                          //         onPressed: () {},
                          //         child: Text(
                          //           "Light",
                          //           style: Style.body.copyWith(
                          //               color: Theme.of(context)
                          //                   .colorScheme
                          //                   .onSurface),
                          //         )),
                          //     MenuItemButton(
                          //         onPressed: () {},
                          //         child: Text(
                          //           "Dark",
                          //           style: Style.body.copyWith(
                          //               color: Theme.of(context)
                          //                   .colorScheme
                          //                   .onSurface),
                          //         )),
                          //   ]),
                          // )
                        ],
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
