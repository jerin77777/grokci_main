import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:grokci_main/theme_provider.dart';
import 'package:grokci_main/types.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';

import '../backend/server.dart';

class Security extends StatefulWidget {
  Security({super.key});

  @override
  State<Security> createState() => _SecurityState();
  ThemeMode themeMode = ThemeMode.light;
}

class _SecurityState extends State<Security> {

  static String getThemeMode(ThemeMode theme) {
    switch (theme) {
      case ThemeMode.system:
        return "System Default";
      case ThemeMode.light:
        return "Light";
      case ThemeMode.dark:
        return "Dark";
      default:
        return "Select theme";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          title: const Text("User Preferences"),
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
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       GestureDetector(
            //           onTap: () {
            //             // routerSink.add({"route": "dashboard"});

            //             Navigator.pop(context);
            //           },
            //           child: Icon(Icons.arrow_back, size: 22)),
            //       SizedBox(width: 15),
            //       Text(
            //         "User Preferences",
            //         style: Style.headline.copyWith(
            //             color: Theme.of(context).colorScheme.onSurface),
            //       ),
            //       Expanded(child: SizedBox()),
            //       Icon(Icons.notifications_none, size: 22)
            //     ],
            //   ),
            // ),
            Divider(color: Theme.of(context).colorScheme.outline, height: 0.3),
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
                          
                          DropdownMenu(
                              onSelected: (thememode) {
                                if (thememode != null) {
                                  Provider.of<ThemeProvider>(context,
                                          listen: false)
                                      .themeMode = thememode;
                                  // print(thememode);
                                }
                              },
                              width: 190,
                              hintText: getThemeMode(Provider.of<ThemeProvider>(context).themeMode),
                              textStyle: Style.subHeadline,
                              inputDecorationTheme: InputDecorationTheme(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                constraints: BoxConstraints.expand(height: 50),
                                filled: true,
                                fillColor: Theme.of(context).colorScheme.surfaceContainerHigh,
                                outlineBorder: const BorderSide(
                                  width: 0,
                                  color: Colors.transparent,
                                )
                              ),
                              dropdownMenuEntries: <DropdownMenuEntry<
                                  ThemeMode>>[
                                DropdownMenuEntry(
                                    value: ThemeMode.system,
                                    label: "System Default",
                                    labelWidget: Text("System Default", style: Style.subHeadline,)),
                                DropdownMenuEntry(
                                    value: ThemeMode.light, label: 'Light',
                                    labelWidget: Text("Light", style: Style.subHeadline,)),
                                DropdownMenuEntry(
                                    value: ThemeMode.dark, label: 'Dark',
                                    labelWidget: Text("Dark", style: Style.subHeadline,))
                              ])
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
