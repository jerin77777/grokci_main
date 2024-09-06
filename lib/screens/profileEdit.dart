import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grokci_main/backend/server.dart';
import 'package:grokci_main/screens/changeMode.dart';
import 'package:grokci_main/screens/feedback.dart';
import 'package:grokci_main/screens/login.dart';
import 'package:grokci_main/screens/security.dart';
import 'package:grokci_main/types.dart';
import 'package:grokci_main/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'address.dart';
import 'notifications.dart';
import 'orders.dart';
import 'support.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String name = "";
  TextEditingController _name = TextEditingController();
  bool edit = false;
  getData() async {
    var doc = await db.getDocument(
        databaseId: AppConfig.database,
        collectionId: AppConfig.users,
        documentId: sharedPreferences!.get("phone").toString());
    name = doc.data["userName"];
    _name.text = name;
    setState(() {});
  }

  @override
  void initState() {
    getData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        leadingWidth: 30,
        title: Text(
          "Edit Profile",
          style: Style.headline
              .copyWith(color: Theme.of(context).colorScheme.onSurface),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        children: [
          Text(
            "Profile image",
          ),
          Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  ProfileIcon(
                    size: 100,
                    fontSize: 40,
                    name: "J",
                    color: Colors.red,
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Button(
                        label: "Change image",
                        size: ButtonSize.small,
                        type: ButtonType.gray,
                        onPress: () {},
                      ),
                      SizedBox(height: 10),
                      Button(
                        label: "Delete image",
                        size: ButtonSize.small,
                        type: ButtonType.gray,
                        labelStyle:
                            Style.subHeadline.copyWith(color: Colors.red),
                        onPress: () {},
                      ),
                    ],
                  )
                ],
              )),
          SizedBox(height: 10),
          Text(
            "Full name",
          ),
          SizedBox(height: 5),
          TextBox(),
          SizedBox(height: 10),
          Text(
            "Phone number",
          ),
          SizedBox(height: 5),
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                      cursorColor: Theme.of(context).colorScheme.onSurface,
                      cursorOpacityAnimates: true,
                      onChanged: (value) {},
                      style: Style.body.copyWith(
                          color: Theme.of(context).colorScheme.onSurface),
                      decoration: InputDecoration(
                        hintStyle: Style.body.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant),
                        isDense: true,
                        border: InputBorder.none,
                      )),
                ),
                Button(
                  label: "update",
                  size: ButtonSize.small,
                  type: ButtonType.gray,
                  onPress: () {},
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Email",
          ),
          SizedBox(height: 5),
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                      cursorColor: Theme.of(context).colorScheme.onSurface,
                      cursorOpacityAnimates: true,
                      onChanged: (value) {},
                      style: Style.body.copyWith(
                          color: Theme.of(context).colorScheme.onSurface),
                      decoration: InputDecoration(
                        hintStyle: Style.body.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant),
                        isDense: true,
                        border: InputBorder.none,
                      )),
                ),
                Button(
                  label: "add email",
                  size: ButtonSize.small,
                  type: ButtonType.gray,
                  onPress: () {},
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
