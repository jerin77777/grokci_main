import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
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

import 'backend/server.dart';
import 'types.dart';

Future<void> main() async {
//
  WidgetsFlutterBinding.ensureInitialized();
  // sharedPreferences = await SharedPreferences.getInstance();

  Client client = Client();
  account = Account(client);
  sharedPreferences = await SharedPreferences.getInstance();
  db = Databases(client);
  storage = Storage(client);

  var brightness =
      SchedulerBinding.instance.platformDispatcher.platformBrightness;

  if (brightness == Brightness.light) {
    Pallet.lightMode();
  } else {
    Pallet.darkMode();
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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Pallet.background,
        systemNavigationBarColor: Pallet.background,
        systemNavigationBarIconBrightness: Pallet.systemBrightness,
        statusBarIconBrightness: Pallet.systemBrightness,
        statusBarBrightness: Brightness.light));
    return StreamBuilder<Object>(
      stream:
          themeStream, // Ensure this is properly initialized and emitting ThemeData objects

      builder: (context, snapshot) {
        // Check if snapshot has data and is not null
        
        return MaterialApp(
          theme: ThemeData(
            bottomSheetTheme:
                BottomSheetThemeData(backgroundColor: Colors.transparent),
            appBarTheme: AppBarTheme(
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Pallet.background,
                systemNavigationBarColor: Pallet.background,
                systemStatusBarContrastEnforced: true,
                systemNavigationBarContrastEnforced: true,
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              hintStyle: TextStyle(
                  color: Pallet.onSurfaceVariant), // Placeholder text color
            ),
            textTheme: GoogleFonts.beVietnamProTextTheme(TextTheme(
              displayLarge:
                  GoogleFonts.beVietnamPro(color: Pallet.onBackground),
              displayMedium:
                  GoogleFonts.beVietnamPro(color: Pallet.onBackground),
              bodyMedium: GoogleFonts.beVietnamPro(color: Pallet.onBackground),
              titleMedium: GoogleFonts.beVietnamPro(color: Pallet.onBackground),
            )),
            iconTheme: IconThemeData(color: Pallet.onBackground),
            primarySwatch: Colors.blue,
          ),
          debugShowCheckedModeBanner: false,
          title: 'Grokci',
          home: (sharedPreferences?.getString("phone") == null)
              ? Login()
              : sharedPreferences?.getBool("bio_metrics") == true
                  ? Biometric()
                  : Home(),
        );
      },
    );

  }
}

class Biometric extends StatefulWidget {
  const Biometric({super.key});

  @override
  State<Biometric> createState() => _BiometricState();
}

class _BiometricState extends State<Biometric> {
  final LocalAuthentication auth = LocalAuthentication();
  bool supported = false;
  // SupportState _supportState = _SupportState.unknown;
  bool? _canCheckBiometrics;
  List<BiometricType>? _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;
  bool authenticated = false;

  @override
  void initState() {
    super.initState();
    auth.isDeviceSupported().then(
      (bool isSupported) {
        setState(() => supported = isSupported);
        login();
      },
    );
  }

  login() async {
    await _authenticate();
    if (authenticated) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    }
  }

  Future<void> _checkBiometrics() async {
    late bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      print(e);
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> _getAvailableBiometrics() async {
    late List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
      print(availableBiometrics);
    } on PlatformException catch (e) {
      availableBiometrics = <BiometricType>[];
      print(e);
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }

  Future<void> _authenticate() async {
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason: 'Let OS determine authentication method',
        options: const AuthenticationOptions(
          stickyAuth: true,
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }

    setState(
        () => _authorized = authenticated ? 'Authorized' : 'Not Authorized');
  }

  Future<void> _cancelAuthentication() async {
    await auth.stopAuthentication();
    setState(() => _isAuthenticating = false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Pallet.background,
        body: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Biometric Login",
                style: Style.title1.copyWith(color: Pallet.onBackground),
              ),
              Expanded(
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: SizedBox(
                        width: 200,
                        child: Image.asset("assets/finger2.gif"),
                      ),
                    ),
                  ],
                ),
              )
            ],
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

    return SafeArea(
      child: Scaffold(
        backgroundColor: Pallet.background,
        bottomNavigationBar: Platform.isIOS
            ? CupertinoTabBar(
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
              )
            : BottomNavigationBar(
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
                unselectedItemColor: Pallet.onSurfaceVariant,
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
