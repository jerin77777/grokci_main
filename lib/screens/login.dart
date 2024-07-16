// import 'package:appwrite/appwrite.dart';
// import 'package:appwrite/models.dart';
import 'dart:ffi';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../widgets.dart';
import '../backend/server.dart';
import '../types.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:readsms/readsms.dart';
import 'package:path/path.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final plugin = Readsms();
  TextEditingController phoneNumber = TextEditingController();
  String phoneError = "";
  int? checkOtp;
  bool otpSend = false;
  bool otpVerified = false;

  @override
  void initState() {
    checkingPermisssionAndAutofill();

    super.initState();
  }

  checkingPermisssionAndAutofill() async {
    bool granted = await Permission.sms.isGranted;
    if (!granted) {
      await Permission.sms.request();
    }
    granted = await Permission.sms.isGranted;
    plugin.read();

    print("listening"); // if (granted) {
    plugin.smsStream.listen((sms) {
      if (int.parse(sms.body.toString().split(":")[1].trim()) == checkOtp) {
        login(mainContext, phoneNumber.text);
      }
    });
    // }
  }

  @override
  Widget build(BuildContext context) {
    mainContext = context;
    return Scaffold(
              backgroundColor: Pallet.background,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: ListView(
                children: [
                  SizedBox(height: 60),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        width: 150,
                        "assets/logo.svg",
                      ),
                    ],
                  ),
                  SizedBox(height: 50),
                  Text(
                    "To get the best of us, please Log in",
                    style:
                        GoogleFonts.beVietnamPro(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Enter your phone number to continue",
                    // style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 10),
                  if (phoneError.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Text(phoneError,
                          style: GoogleFonts.beVietnamPro(
                              color: Colors.red, fontSize: 12)),
                    ),
                  Container(
                    height: 50,
                    // padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 0.5)),
                    child: Row(
                      children: [
                        SizedBox(width: 10),
                        Text("+91 "),
                        Expanded(
                            child: TextField(
                          enabled: checkOtp == null,
                          controller: phoneNumber,
                          keyboardType: TextInputType.phone,
                          onChanged: (_) {
                            if (phoneError.isNotEmpty) {
                              phoneError = "";
                              setState(() {});
                            }
                          },
                          decoration: InputDecoration(border: InputBorder.none),
                        ))
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  if (checkOtp != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Enter otp:"),
                        SizedBox(height: 20),
                        OtpTextField(
                          numberOfFields: 4,
                          fieldWidth: 80,

                          borderColor: Color(0xFF512DA8),
                          showFieldAsBox: true,
                          onSubmit: (String verificationCode) {
                            if (int.parse(verificationCode) == checkOtp!) {
                              login(context, phoneNumber.text);
                            }
                          }, // end onSubmit
                        ),
                        SizedBox(height: 20)
                      ],
                    )
                ],
              )),
              RichText(
                text: TextSpan(
                  text: "By continuing, you agree to Grocki's ",
                  style: GoogleFonts.beVietnamPro(
                      fontSize: 14, color: Pallet.font1),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Terms of Use',
                        style: GoogleFonts.beVietnamPro(color: Pallet.primary)),
                    TextSpan(text: ' & '),
                    TextSpan(
                        text: 'Privacy Policy!',
                        style: GoogleFonts.beVietnamPro(color: Pallet.primary)),
                  ],
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width - 20,
                child: Button(
                    active: !otpSend,
                    label: "Send Otp",
                    onPress: () async {
                      bool error = false;
                      RegExp numReg = RegExp(r'^-?[0-9]+$');
                      if (phoneNumber.text.length != 10 ||
                          !numReg.hasMatch(phoneNumber.text)) {
                        phoneError = "invalid number";
                        error = true;
                      }
                      setState(() {});
                      if (!error) {
                        otpSend = true;
                        checkOtp = await sendOtp(phoneNumber.text);
                        setState(() {});
                      }
                    }),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class SignUp extends StatefulWidget {
  const SignUp({super.key, required this.phoneNumber});
  final String phoneNumber;
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // error texts
  String nameError = "";

  String language = "english";
  bool presedDone = false;
  TextEditingController userName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
              backgroundColor: Pallet.background,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    SizedBox(height: 60),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          width: 150,
                          "assets/logo.svg",
                        ),
                      ],
                    ),
                    SizedBox(height: 50),
                    Text(
                      "We need some more information about you",
                      style:
                          GoogleFonts.beVietnamPro(fontWeight: FontWeight.w600),
                    ),
                    // SizedBox(height: 10),
                    Text("Enter your user name"),
                    SizedBox(height: 6),
                    if (nameError.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Text(nameError,
                            style: GoogleFonts.beVietnamPro(
                                color: Colors.red, fontSize: 12)),
                      ),
                    Container(
                      height: 50,
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              width: 0.5,
                              color: nameError.isEmpty
                                  ? Colors.black
                                  : Colors.red)),
                      child: TextField(
                        controller: userName,
                        keyboardType: TextInputType.text,
                        onChanged: (_) {
                          if (nameError.isNotEmpty) {
                            nameError = "";
                            setState(() {});
                          }
                        },
                        decoration: InputDecoration(border: InputBorder.none),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text("select language"),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                            child: InkWell(
                          onTap: () {
                            language = "english";
                            setState(() {});
                          },
                          child: Container(
                            height: 150,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: language == "english"
                                    ? Color(0xFF5BFFA1)
                                    : Color(0xFFC2FFD1)),
                            child: Center(
                              child: Text(
                                "English",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        )),
                        SizedBox(width: 10),
                        Expanded(
                            child: InkWell(
                          onTap: () {
                            language = "hindi";
                            setState(() {});
                          },
                          child: Container(
                            height: 150,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: language == "hindi"
                                    ? Color(0xFF5BFFA1)
                                    : Color(0xFFC2FFD1)),
                            child: Center(
                              child: Text(
                                "हिंदी",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ))
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 20),
              Button(
                  label: "Done",
                  onPress: () {
                    RegExp numReg = RegExp(r'^-?[0-9]+$');
                    bool error = false;

                    if (userName.text.isEmpty) {
                      nameError = "required *";
                      error = true;
                    }

                    setState(() {});

                    if (!error && !presedDone) {
                      presedDone = true;
                      createAccount(
                          context, widget.phoneNumber, userName.text, language);

                      setState(() {});
                    }
                  }),
              presedDone
                  ? LoadingAnimationWidget.fallingDot(
                      color: Colors.white, size: 200)
                  : Container(),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

Future<ImageSource?> selectPickerType(BuildContext context) async {
  ImageSource? selected;
  await showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
          contentPadding: EdgeInsets.zero,
          // shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
          backgroundColor: Colors.transparent,
          content: Center(
            child: Container(
              padding: EdgeInsets.all(10),
              width: 150,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Pallet.inner1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      selected = ImageSource.camera;
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Pallet.primary)),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(
                            "Camera",
                            style:
                                GoogleFonts.beVietnamPro(color: Pallet.primary),
                          )),
                          Icon(
                            Icons.camera_alt,
                            color: Pallet.primary,
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      selected = ImageSource.gallery;
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Pallet.primary)),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(
                            "Gallery",
                            style:
                                GoogleFonts.beVietnamPro(color: Pallet.primary),
                          )),
                          Icon(
                            Icons.photo,
                            color: Pallet.primary,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ));
    },
  );
  return selected;
}
