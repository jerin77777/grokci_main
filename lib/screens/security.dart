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
  final LocalAuthentication auth = LocalAuthentication();
  bool supported = false;
  // SupportState _supportState = _SupportState.unknown;
  bool? _canCheckBiometrics;
  List<BiometricType>? _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;
  bool authenticated = false;

  bool themeEnabled = false;

  bool passageEnabled = false;

  @override
  void initState() {
    super.initState();
    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() => supported = isSupported),
        );
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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () {
                        // routerSink.add({"route": "dashboard"});

                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back, size: 22)),
                  SizedBox(width: 15),
                  Text(
                    "User Preferences",
                    style: Style.h3,
                  ),
                  Expanded(child: SizedBox()),
                  Icon(Icons.notifications_none, size: 22)
                ],
              ),
            ),
            Divider(color: Pallet.divider, height: 1),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text(
                    "Theme",
                    style: Style.h3,
                  ),
                  // SizedBox(height: 10),

                  // Text(
                  //   "Login & Security",
                  //   style: Style.h2,
                  // ),
                  // SizedBox(height: 10),
                  // Row(
                  //   children: [
                  //     Expanded(child: Text("Enable finger print")),
                  //     Switch(
                  //         value: passageEnabled,
                  //         activeColor: Colors.red,
                  //         onChanged: (bool value) async {
                  //           passageEnabled = value;
                  //           if (value) {
                  //             // await _authenticate();
                  //             // if (authenticated) {
                  //             //   sharedPreferences!.setBool("bio_metrics", true);
                  //             // }
                  //           } else {
                  //             // sharedPreferences!.setBool("bio_metrics", false);
                  //           }
                  //           setState(() {});
                  //         }),
                  //   ],
                  // ),

                  Row(
                    children: [
                      Expanded(child: Text("Enable ligh mode")),
                      Switch(
                          thumbIcon: WidgetStateProperty.resolveWith<Icon?>(
                              (Set<WidgetState> states) {
                            if (themeEnabled) {
                              return const Icon(Icons.light_mode);
                            } else {
                              return const Icon(Icons.dark_mode);
                            }
                          }),
                          value: themeEnabled,
                          activeColor: Colors.amber,
                          inactiveThumbColor: Colors.blue,
                          inactiveTrackColor: Colors.blue[100],
                          onChanged: (bool value) async {
                            themeEnabled = value;
                            if (value) {
                              Pallet.lightMode();
                            } else {
                              Pallet.darkMode();
                            }

                            setState(() {});
                          }),
                    ],
                  ),
                  // Expanded(
                  //   child: Stack(
                  //     children: [
                  //       Positioned(
                  //         bottom: 10,
                  //         right: 10,
                  //         child: SizedBox(
                  //           width: 200,
                  //           child: Image.asset("assets/finger2.gif"),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
