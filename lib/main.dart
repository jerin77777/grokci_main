import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grokci_main/screens/address.dart';
import 'package:grokci_main/screens/bag.dart';
import 'package:grokci_main/screens/dashboard.dart';
import 'package:grokci_main/screens/login.dart';
import 'package:grokci_main/screens/profile.dart';
import 'package:grokci_main/screens/search.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'backend/server.dart';
import 'types.dart';

Future<void> main() async {
//
  WidgetsFlutterBinding.ensureInitialized();
  // sharedPreferences = await SharedPreferences.getInstance();
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  Client client = Client();
  account = Account(client);
  sharedPreferences = await SharedPreferences.getInstance();
  db = Databases(client);
  storage = Storage(client);

  client
          .setEndpoint(AppConfig.endpoint) // Your Appwrite Endpoint
          .setProject(AppConfig.project) // Your project ID
          .setSelfSigned() // Use only on dev mode with a self-signed SSL cert
      ;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.beVietnamProTextTheme(TextTheme(
          displayLarge: GoogleFonts.beVietnamPro(color: Pallet.font1),
          displayMedium: GoogleFonts.beVietnamPro(color: Pallet.font1),
          bodyMedium: GoogleFonts.beVietnamPro(color: Pallet.font1),
          titleMedium: GoogleFonts.beVietnamPro(color: Pallet.font1),
        )),
        iconTheme: IconThemeData(color: Pallet.font1),
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: (sharedPreferences!.get("phone") == null) ? Login() : Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int navIdx = 0;
  @override
  Widget build(BuildContext context) {
    mainContext = context;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Pallet.background,
        bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels: true,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          backgroundColor: Pallet.background,
          landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Account',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag),
              label: 'Shopping Bag  ',
            ),
          ],
          currentIndex: navIdx,
          selectedItemColor: Pallet.primary,
          unselectedItemColor: Pallet.font3,
          onTap: (index) {
            navIdx = index;
            if (index == 0) {
              routerSink.add({"route": "dashboard"});
            } else if (index == 1) {
              routerSink.add({"route": "search"});
            } else if (index == 2) {
              routerSink.add({"route": "profile"});
            } else if (index == 3) {
              routerSink.add({"route": "bag"});
            }
            setState(() {});
          },
        ),
        body: StreamBuilder<Map>(
            initialData: const {"route": "dashboard"},
            stream: routerStream,
            builder: (context, snapshot) {
              return Navigator(
                pages: [
                  if (snapshot.data?["route"] == "dashboard")
                    MaterialPage(
                      child: Dashboard(),
                    )
                  else if (snapshot.data?["route"] == "search")
                    MaterialPage(
                      child: Search(),
                    )
                  else if (snapshot.data?["route"] == "profile")
                    MaterialPage(
                      child: Profile(),
                    )
                  else if (snapshot.data?["route"] == "bag")
                    MaterialPage(
                      child: Bag(),
                    )
                  else if (snapshot.data?["route"] == "address")
                    MaterialPage(
                      child: Address(),
                    )
                  // else if (snapshot.data?["route"] == "checkout")
                  // MaterialPage(
                  //   child: Checkout(),
                  // )
                ],
                onPopPage: (route, result) {
                  return true;
                },
              );
            }),
      ),
    );
  }
}
