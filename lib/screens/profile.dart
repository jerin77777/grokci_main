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

import 'address.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String name = "";
  getData() async {
    var doc = await db.getDocument(
        databaseId: AppConfig.database,
        collectionId: AppConfig.users,
        documentId: sharedPreferences!.get("phone").toString());
    name = doc.data["userName"];
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
      padding: const EdgeInsets.all(15),
      child: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Icon(Icons.arrow_back), Icon(Icons.notifications_none)],
          ),
          SizedBox(height: 10),
          Text(
            "Account",
            style: Style.h1,
          ),
          SizedBox(height: 10),
          Row(
            children: [
              ProfileIcon(
                size: 60,
                fontSize: 20,
                color: Colors.red,
                name: "j",
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Hi, $name", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    Text("How are you doing ?", style: TextStyle(fontSize: 14))
                  ],
                ),
              ),
              // Container(
              //   padding: EdgeInsets.all(10),
              //   decoration: BoxDecoration(color: Pallet.primary, borderRadius: BorderRadius.circular(20)),
              //   child: Center(
              //     child: Icon(
              //       Icons.edit,
              //       color: Pallet.fontInner,
              //       size: 18,
              //     ),
              //   ),
              // )
            ],
          ),
          SizedBox(height: 20),
          Text(
            "Primary options",
            style: Style.h3,
          ),
          SizedBox(height: 10),
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 8),
          //   child: Row(
          //     children: [
          //       SizedBox(
          //         width: 25,
          //         child: Center(
          //           child: FaIcon(
          //             FontAwesomeIcons.box,
          //             color: Pallet.primary,
          //             size: 22,
          //           ),
          //         ),
          //       ),
          //       SizedBox(width: 10),
          //       Expanded(
          //           child: Text(
          //         "My Orders",
          //         style: TextStyle(color: Pallet.primary, fontSize: 16),
          //       )),
          //       Icon(Icons.keyboard_arrow_right_outlined, color: Pallet.primary)
          //     ],
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 8),
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
          //       Icon(Icons.keyboard_arrow_right_outlined, color: Pallet.primary)
          //     ],
          //   ),
          // ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                mainContext,
                MaterialPageRoute(builder: (context) => Address()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 25,
                    child: Center(
                      child: FaIcon(
                        FontAwesomeIcons.locationDot,
                        color: Pallet.primary,
                        size: 22,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                      child: Text(
                    "Manage Addresses",
                    style: TextStyle(color: Pallet.primary, fontSize: 16),
                  )),
                  Icon(Icons.keyboard_arrow_right_outlined, color: Pallet.primary)
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                mainContext,
                MaterialPageRoute(builder: (context) => Support()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 25,
                    child: Center(
                      child: FaIcon(
                        FontAwesomeIcons.headset,
                        color: Pallet.primary,
                        size: 22,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                      child: Text(
                    "Support",
                    style: TextStyle(color: Pallet.primary, fontSize: 16),
                  )),
                  Icon(Icons.keyboard_arrow_right_outlined, color: Pallet.primary)
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                mainContext,
                MaterialPageRoute(builder: (context) => Support()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 25,
                    child: Center(
                      child: FaIcon(
                        FontAwesomeIcons.solidMessage,
                        color: Pallet.primary,
                        size: 22,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                      child: Text(
                    "Feed Back",
                    style: TextStyle(color: Pallet.primary, fontSize: 16),
                  )),
                  Icon(Icons.keyboard_arrow_right_outlined, color: Pallet.primary)
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                mainContext,
                MaterialPageRoute(builder: (context) => Security()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 25,
                    child: Center(
                      child: FaIcon(
                        FontAwesomeIcons.key,
                        color: Pallet.primary,
                        size: 22,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                      child: Text(
                    "Login & Security",
                    style: TextStyle(color: Pallet.primary, fontSize: 16),
                  )),
                  Icon(Icons.keyboard_arrow_right_outlined, color: Pallet.primary)
                ],
              ),
            ),
          ),

          GestureDetector(
            onTap: () {
              sharedPreferences!.remove("phone");
              Navigator.pushReplacement(
                mainContext,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 25,
                    child: Center(
                      child: FaIcon(
                        FontAwesomeIcons.rightFromBracket,
                        color: Pallet.primary,
                        size: 22,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                      child: Text(
                    "Logout",
                    style: TextStyle(color: Pallet.primary, fontSize: 16),
                  )),
                  Icon(Icons.keyboard_arrow_right_outlined, color: Pallet.primary)
                ],
              ),
            ),
          ),
          SizedBox(height: 10),

          // Text(
          //   "Extra Features",
          //   style: Style.h3,
          // ),
          // SizedBox(height: 10),
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 5),
          //   child: Row(
          //     children: [
          //       SizedBox(
          //         width: 25,
          //         child: Center(
          //           child: FaIcon(
          //             FontAwesomeIcons.solidBell,
          //             color: Pallet.primary,
          //             size: 22,
          //           ),
          //         ),
          //       ),
          //       SizedBox(width: 10),
          //       Expanded(
          //           child: Text(
          //         "Login & Security",
          //         style: TextStyle(color: Pallet.primary, fontSize: 16),
          //       )),
          //       Icon(Icons.keyboard_arrow_right_outlined, color: Pallet.primary)
          //     ],
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 5),
          //   child: Row(
          //     children: [
          //       FaIcon(
          //         FontAwesomeIcons.solidBell,
          //         color: Pallet.primary,
          //         size: 22,
          //       ),
          //       SizedBox(width: 10),
          //       Expanded(
          //           child: Text(
          //         "My Reviews",
          //         style: TextStyle(color: Pallet.primary, fontSize: 16),
          //       )),
          //       Icon(Icons.keyboard_arrow_right_outlined, color: Pallet.primary)
          //     ],
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 5),
          //   child: Row(
          //     children: [
          //       FaIcon(
          //         FontAwesomeIcons.solidCircleQuestion,
          //         color: Pallet.primary,
          //         size: 22,
          //       ),
          //       SizedBox(width: 10),
          //       Expanded(
          //           child: Text(
          //         "Frequently Asked Questions",
          //         style: TextStyle(color: Pallet.primary, fontSize: 16),
          //       )),
          //       Icon(Icons.keyboard_arrow_right_outlined, color: Pallet.primary)
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
