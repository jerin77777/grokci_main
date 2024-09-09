import 'dart:async';
import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:grokci_main/globals.dart';
import 'package:grokci_main/screens/address.dart';
import 'package:grokci_main/screens/bag.dart';
import 'package:grokci_main/screens/dashboard.dart';
import 'package:grokci_main/screens/login.dart';
import 'package:grokci_main/screens/profile.dart';
import 'package:grokci_main/screens/search.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:win32/win32.dart';

import 'backend/server.dart';
import 'types.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
ThemeMode themeMode = ThemeMode.system;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Client client = Client();
  account = Account(client);
  sharedPreferences = await SharedPreferences.getInstance();
  db = Databases(client);
  storage = Storage(client);
  
  setKeys();

  // changes status and system navigation color based on theme

  if (getThemeType() == null) {
    saveThemeType("System Default");
  } else if (getThemeType() == "System Default") {
    // default
    SchedulerBinding.instance.platformDispatcher.onPlatformBrightnessChanged =
        () async {
      Brightness _brightness =
          SchedulerBinding.instance.platformDispatcher.platformBrightness;

      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: _brightness == Brightness.dark
            ? darkMode.colorScheme.surface
            : lightMode.colorScheme.surface,
        systemNavigationBarColor: _brightness == Brightness.dark
            ? darkMode.colorScheme.surface
            : lightMode.colorScheme.surface,
        statusBarIconBrightness:
            _brightness == Brightness.dark ? Brightness.light : Brightness.dark,
        systemNavigationBarIconBrightness:
            _brightness == Brightness.dark ? Brightness.light : Brightness.dark,
        statusBarBrightness: _brightness,
      ));
    };
  } else if (getThemeType() == "Light") {
    themeMode = ThemeMode.light;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: lightMode.colorScheme.surface,
      systemNavigationBarColor: lightMode.colorScheme.surface,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));
  } else if (getThemeType() == "Dark") {
    themeMode = ThemeMode.dark;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: darkMode.colorScheme.surface,
      systemNavigationBarColor: darkMode.colorScheme.surface,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ));
  }

  client
          .setEndpoint(AppConfig.endpoint) // Your Appwrite Endpoint
          .setProject(AppConfig.project) // Your project ID
          .setSelfSigned() // Use only on dev mode with a self-signed SSL cert
      ;
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: themeStream,
        builder: (context, snapshot) {
          return MaterialApp(
              navigatorObservers: [routeObserver],
              theme: lightMode.copyWith(
                appBarTheme: AppBarTheme(
                  systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarColor: Theme.of(context).colorScheme.surface,
                    systemNavigationBarColor:
                        Theme.of(context).colorScheme.surface,
                    systemStatusBarContrastEnforced: true,
                    systemNavigationBarContrastEnforced: true,
                  ),
                ),
                inputDecorationTheme: InputDecorationTheme(
                  hintStyle: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant), // Placeholder text color
                ),
              ),
              themeMode: themeMode,
              debugShowCheckedModeBanner: false,
              darkTheme: darkMode,
              title: 'Grokci',
              home: SplashScreen()

              // (sharedPreferences!.get("phone") == null) ? Login() : Home(),
              );
        });
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
        Duration(seconds: 2),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => (sharedPreferences!.get("phone") == null)
                    ? Login()
                    : Home())));
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SvgPicture.asset(
            width: 200,
            "assets/logo.svg",
          ),
        ),
      ),
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
  void initState() {
    routerStream.listen((route) {
      if (route["route"] == "dashboard") {
        navIdx = 0;
      }
      setState(() {});
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    mainContext = context;

    return WillPopScope(
      // Prevent back navigation by returning `false`.
      onWillPop: () async {
        return false; // Return `true` to allow back navigation, `false` to block it.
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          bottomNavigationBar: Container(
              foregroundDecoration: BoxDecoration(
                border: Border(
                    top: BorderSide(
                  color: Theme.of(context).colorScheme.outline,
                  width: 0.3,
                )),
              ),
              child: NavigationBar(
                destinations: const <NavigationDestination>[
                  NavigationDestination(
                    icon: Icon(
                      FontAwesomeIcons.house,
                      size: 18,
                    ),
                    label: 'Home',
                  ),
                  NavigationDestination(
                    icon: Icon(
                      FeatherIcons.search,
                      size: 20,
                    ),
                    label: 'Search',
                  ),
                  NavigationDestination(
                    icon: Icon(
                      FontAwesomeIcons.solidUser,
                      size: 20,
                    ),
                    label: 'Account',
                  ),
                  NavigationDestination(
                    icon: Icon(
                      Icons.shopping_bag,
                      size: 22,
                    ),
                    label: 'Shopping Bag',
                  ),
                ],
                selectedIndex: navIdx,
                onDestinationSelected: (index) {
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
              )),
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
                  // onDidRemovePage: (_){
                  //   return false;
                  // },
                  onPopPage: (route, result) {
                    return true;
                  },
                );
              }),
        ),
      ),
    );
  }
}
