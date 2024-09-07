import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grokci_main/backend/server.dart';
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

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
    tile(
        {required String name,
        required IconData icon,
        required Function onTap}) {
      return Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          splashColor: Theme.of(context).colorScheme.surfaceContainer,
          onTap: () => onTap(),
          child: Container(
            height: 44,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            child: Row(
              children: [
                SizedBox(
                  width: 24,
                  child: Center(
                    child: FaIcon(
                      icon,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                    child: Text(
                  name,
                  style: Style.subHeadline
                      .copyWith(color: Theme.of(context).colorScheme.primary),
                )),
                Icon(FontAwesomeIcons.chevronRight,
                    color: Theme.of(context).colorScheme.primary, size: 16)
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            leading: IconButton(
              onPressed: () {
                routerSink.add({"route": "dashboard"});
              },
              icon: Icon(Icons.arrow_back),
            ),
            title: Text(
              "Account",
              style: Style.title1Emphasized,
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
          SliverToBoxAdapter(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              // padding: EdgeInsets.symmetric(horizontal: 5),
              children: [
                // SizedBox(height: 10),
                // Text(
                //   "Account",
                //   style: Style.title1Emphasized.copyWith(
                //     color: Theme.of(context).colorScheme.onSurface,
                //   ),
                // ),
                SizedBox(height: 30),
                Row(
                  children: [
                    ProfileIcon(
                      size: 60,
                      fontSize: 20,
                      color: Colors.red,
                      name: name != "" ? "$name[0]" : " ",
                    ),
                    SizedBox(width: 10),
                    if (edit)
                      Expanded(
                          child: TextBox(
                        controller: _name,
                        radius: 10,
                        hasBorder: true,
                      ))
                    else
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Hi, $name",
                                style: Style.title3.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface)),
                            Text("How are you doing ?",
                                style: Style.body.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant))
                          ],
                        ),
                      ),
                    if (edit)
                      GestureDetector(
                        onTap: () {
                          edit = false;
                          String userId =
                              sharedPreferences!.get("phone").toString();

                          db.updateDocument(
                              databaseId: AppConfig.database,
                              collectionId: AppConfig.users,
                              documentId: userId,
                              data: {"userName": _name.text});

                          name = _name.text;
                          setState(() {});
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 10),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                            child: Icon(
                              FontAwesomeIcons.check,
                              color: Theme.of(context).colorScheme.onPrimary,
                              size: 14,
                            ),
                          ),
                        ),
                      ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        edit = !edit;
                        setState(() {});
                      },
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                          child: Icon(
                            (edit)
                                ? FontAwesomeIcons.xmark
                                : FontAwesomeIcons.pen,
                            color: Theme.of(context).colorScheme.onPrimary,
                            size: 14,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 25),
                      Text(
                        "Primary options",
                        style: Style.footnoteEmphasized.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                      const SizedBox(height: 8),

                      // Padding(
                      //   padding: const EdgeInsets.symmetric(vertical: 10),
                      //   child: Row(
                      //     children: [
                      //       SizedBox(
                      //         width: 25,
                      //         child: Center(
                      //           child: FaIcon(
                      //             FontAwesomeIcons.solidCreditCard,
                      //             color: Theme.of(context).colorScheme.primary,
                      //             size: 22,
                      //           ),
                      //         ),
                      //       ),
                      //       SizedBox(width: 10),
                      //       Expanded(
                      //           child: Text(
                      //         "Payment Options",
                      //         style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 16),
                      //       )),
                      //       Icon(Icons.keyboard_arrow_right_outlined, color: Theme.of(context).colorScheme.primary, size: 20)
                      //     ],
                      //   ),
                      // ),
                      tile(
                        name: "My Orders",
                        icon: FontAwesomeIcons.box,
                        onTap: () {
                          Navigator.push(
                            mainContext,
                            MaterialPageRoute(builder: (context) => Orders()),
                          );
                        },
                      ),
                      tile(
                        name: "Manage Addresses",
                        icon: FontAwesomeIcons.locationDot,
                        onTap: () {
                          Navigator.push(
                            mainContext,
                            MaterialPageRoute(builder: (context) => Address()),
                          );
                        },
                      ),
                      tile(
                        name: "Support",
                        icon: FontAwesomeIcons.headset,
                        onTap: () {
                          Navigator.push(
                            mainContext,
                            MaterialPageRoute(builder: (context) => Support()),
                          );
                        },
                      ),
                      tile(
                        name: "Feedback",
                        icon: FontAwesomeIcons.solidMessage,
                        onTap: () {
                          Navigator.push(
                            mainContext,
                            MaterialPageRoute(builder: (context) => FeedBack()),
                          );
                        },
                      ),
                      tile(
                        name: "User Preferences",
                        icon: FontAwesomeIcons.userGear,
                        onTap: () {
                          Navigator.push(
                            mainContext,
                            MaterialPageRoute(builder: (context) => Security()),
                          );
                        },
                      ),
                      tile(
                        name: "Privacy Policy",
                        icon: FontAwesomeIcons.lock,
                        onTap: () async {
                          final Uri url = Uri.parse(
                              'https://grokci.com/policies/privacy-policy');
                          if (!await launchUrl(url)) {
                            throw Exception('Could not launch url');
                          }
                        },
                      ),
                      tile(
                        name: "Terms of Services",
                        icon: FontAwesomeIcons.userLock,
                        onTap: () async {
                          final Uri url = Uri.parse(
                              'https://grokci.com/policies/terms-of-service');
                          if (!await launchUrl(url)) {
                            throw Exception('Could not launch url');
                          }
                        },
                      ),

                      tile(
                        name: "Logout",
                        icon: FontAwesomeIcons.rightFromBracket,
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.surface,
                                    title: Text(
                                        "Do you really want to log out?",
                                        style: Style.title3.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface)),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            sharedPreferences!.remove("phone");
                                            Navigator.pushReplacement(
                                              mainContext,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Login()),
                                            );
                                          },
                                          child: Text("Yes",
                                              style: Style.body.copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                              ))),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("Cancel",
                                              style: Style.body.copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .error,
                                              ))),
                                    ],
                                  ));
                        },
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                )
              ],
            ),
          ))
        ],
      ),
    );
  }
}
