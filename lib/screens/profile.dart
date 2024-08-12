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
import 'orders.dart';

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
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                  onTap: () {
                    routerSink.add({"route": "dashboard"});
                  },
                  child: Icon(Icons.arrow_back, size: 22)),
              Icon(Icons.notifications_none, size: 22)
            ],
          ),
          Expanded(
              child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 5),
            children: [
              SizedBox(height: 10),
              Text(
                "Account",
                style: Style.title1Emphasized.copyWith(
                  color: Pallet.onBackground,
                ),
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  ProfileIcon(
                    size: 60,
                    fontSize: 20,
                    color: Colors.red,
                    name: "${name[0]}",
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
                              style: Style.title3
                                  .copyWith(color: Pallet.onBackground)),
                          Text("How are you doing ?",
                              style: Style.body
                                  .copyWith(color: Pallet.onSurfaceVariant))
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
                            color: Pallet.primary,
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                          child: Icon(
                            FontAwesomeIcons.check,
                            color: Pallet.onPrimary,
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
                          color: Pallet.primary,
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: Icon(
                          (edit)
                              ? FontAwesomeIcons.xmark
                              : FontAwesomeIcons.pen,
                          color: Pallet.onPrimary,
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
                    SizedBox(height: 25),
                    Text(
                      "Primary options",
                      style: Style.footnoteEmphasized
                          .copyWith(color: Pallet.onBackground),
                    ),
                    SizedBox(height: 10),

                    // Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 10),
                    //   child: Row(
                    //     children: [
                    //       SizedBox(
                    //         width: 25,
                    //         child: Center(
                    //           child: FaIcon(
                    //             FontAwesomeIcons.solidCreditCard,
                    //             color: Pallet.primary,
                    //             size: 22,
                    //           ),
                    //         ),
                    //       ),
                    //       SizedBox(width: 10),
                    //       Expanded(
                    //           child: Text(
                    //         "Payment Options",
                    //         style: TextStyle(color: Pallet.primary, fontSize: 16),
                    //       )),
                    //       Icon(Icons.keyboard_arrow_right_outlined, color: Pallet.primary, size: 20)
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
                      name: "Feed Back",
                      icon: FontAwesomeIcons.solidMessage,
                      onTap: () {
                        Navigator.push(
                          mainContext,
                          MaterialPageRoute(builder: (context) => Support()),
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
                                  backgroundColor: Pallet.background,
                                  title: Text("Do you Really want to log out?",
                                      style: Style.title3.copyWith(
                                          color: Pallet.primary)),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          sharedPreferences!.remove("phone");
                                          Navigator.pushReplacement(
                                            mainContext,
                                            MaterialPageRoute(
                                                builder: (context) => Login()),
                                          );
                                        },
                                        child: Text("Yes",
                                            style: Style.body.copyWith(
                                              color: Pallet.primary,
                                            ))),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("Cancel",
                                            style: Style.body.copyWith(
                                              color: Pallet.error,
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
          ))
        ],
      ),
    );
  }

  tile(
      {required String name, required IconData icon, required Function onTap}) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: () => onTap(),
        child: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              SizedBox(
                width: 25,
                child: Center(
                  child: FaIcon(
                    icon,
                    color: Pallet.primary,
                    size: 22,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                  child: Text(
                name,
                style: Style.subHeadline.copyWith(color: Pallet.primary),
              )),
              Icon(FontAwesomeIcons.chevronRight,
                  color: Pallet.primary, size: 16)
            ],
          ),
        ),
      ),
    );
  }
}
