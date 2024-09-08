
// import 'package:appwrite/appwrite.dart';
// import 'package:appwrite/models.dart';
// import 'dart:ffi';
// import 'dart:io';

// import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:passage_flutter/passage_flutter_models/authenticator_attachment.dart';
// import 'package:passage_flutter/passage_flutter_models/passage_social_connection.dart';
import '../main.dart';
import '../widgets.dart';
import '../backend/server.dart';
import "../types.dart";
import 'package:permission_handler/permission_handler.dart';
import 'package:readsms/readsms.dart';
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
  String? checkOtp;
  bool otpSend = false;
  bool autoRead = false;
  bool verifyingOTP = false;
  bool buttonDisabled = true;
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
    plugin.smsStream.listen((sms) async {
      String smsOTP = sms.body.toString().split(" ")[0].trim();
      verifyingOTP = true;

      if (await Auth().verifyOTP(checkOtp, smsOTP, context) == "SUCCESS") {
        login(mainContext, phoneNumber.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    mainContext = context;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
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
                      GestureDetector(
                        onTap: () async {},
                        child: SvgPicture.asset(
                          width: 150,
                          "assets/logo.svg",
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 50),
                  Text(
                    "Login to continue",
                    style: Style.title1Emphasized.copyWith(
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    "Enter your phone number",
                    style: Style.subHeadline.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    // style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            width: 1,
                            color:
                                Theme.of(context).colorScheme.outlineVariant)),
                    child: Row(
                      children: [
                        Text(
                          "+91 ",
                          style: Style.body.copyWith(
                              color: Theme.of(context).colorScheme.onSurface),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                            child: TextField(
                          // style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                          enabled: checkOtp == null,
                          controller: phoneNumber,
                          maxLength: 10,
                          cursorColor: Theme.of(context).colorScheme.primary,
                          keyboardType: TextInputType.phone,
                          onChanged: (_) {
                            if (phoneError.isNotEmpty) {
                              phoneError = "";
                              setState(() {});
                            }
                            if (phoneNumber.text.length == 10) {
                              buttonDisabled = false;
                              setState(() {});
                            } else {
                              buttonDisabled = true;
                              setState(() {});
                            }
                          },
                          decoration: const InputDecoration(
                              border: InputBorder.none, counter: Offstage()),
                          style: Style.body.copyWith(
                              color: Theme.of(context).colorScheme.onSurface),
                        ))
                      ],
                    ),
                  ),
                  if (phoneError.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(phoneError,
                          style: Style.caption2.copyWith(
                              color: Theme.of(context).colorScheme.error)),
                    ),
                  const SizedBox(height: 40),
                  if (checkOtp != null && checkOtp != "")
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40),
                        Text(
                          "Enter otp:",
                          style: Style.subHeadline.copyWith(
                              color: Theme.of(context).colorScheme.onSurface),
                        ),
                        const SizedBox(height: 20),
                        OtpTextField(
                          numberOfFields: 4,
                          borderRadius: BorderRadius.circular(14),
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          fieldWidth: 50,
                          fieldHeight: 50,
                          borderColor:
                              Theme.of(context).colorScheme.outlineVariant,
                          focusedBorderColor:
                              Theme.of(context).colorScheme.outline,
                          borderWidth: 1,
                          textStyle: Style.body.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          cursorColor: Theme.of(context).colorScheme.onSurface,
                          filled: true,
                          fillColor:
                              Theme.of(context).colorScheme.surfaceContainer,
                          showFieldAsBox: true,
                          onSubmit: (String verificationCode) async {
                            verifyingOTP = true;
                            if (await Auth().verifyOTP(
                                    checkOtp, verificationCode, context) ==
                                "SUCCESS") {
                              login(context, phoneNumber.text);
                            }
                            ;
                          }, // end onSubmit
                        ),
                        SizedBox(height: 20)
                      ],
                    ),
                  if (checkOtp == "" && otpSend == true)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Didn't recieve the otp ? ",
                            style: GoogleFonts.beVietnamPro(fontSize: 14)),
                        GestureDetector(
                          onTap: () {
                            if (phoneNumber.text.length != 10) {
                              phoneNumber.text = "";
                            }
                            otpSend = false;
                            checkOtp = null;
                            setState(() {});
                          },
                          child: Text("Try again",
                              style: GoogleFonts.beVietnamPro(
                                  fontSize: 14,
                                  color:
                                      Theme.of(context).colorScheme.primary)),
                        ),
                      ],
                    ),
                  SizedBox(height: 40),
                ],
              )),
              RichText(
                text: TextSpan(
                  text: "By continuing, you agree to Grocki's ",
                  style: Style.footnote
                      .copyWith(color: Theme.of(context).colorScheme.onSurface),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Terms of Use',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            final Uri url = Uri.parse(
                                'https://grokci.com/policies/terms-of-service');
                            if (!await launchUrl(url)) {
                              throw Exception('Could not launch url');
                            }
                          },
                        style: Style.footnote.copyWith(
                            color: Theme.of(context).colorScheme.primary)),
                    TextSpan(text: ' & '),
                    TextSpan(
                        text: 'Privacy Policy!',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            final Uri url = Uri.parse(
                                'https://grokci.com/policies/privacy-policy');
                            if (!await launchUrl(url)) {
                              throw Exception('Could not launch url');
                            }
                          },
                        style: Style.footnote.copyWith(
                            color: Theme.of(context).colorScheme.primary)),
                  ],
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width - 20,
                child: Button(
                    disabled: buttonDisabled,
                    size: ButtonSize.large,
                    type: ButtonType.filled,
                    label: autoRead? "trying to auto-read OTP...": (verifyingOTP? "verifying OTP...": "Send otp"),
                    onPress: () async {
                      if (phoneNumber.text.length == 10) {
                        buttonDisabled = true;
                        setState(() {});
                        checkOtp =
                            await Auth().sendOtp(phoneNumber.text, context);
                        otpSend = true;
                        setState(() {});
                      } else {
                        phoneError = "Enter valid phone";
                      }
                      setState(() {});
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
  String phoneError = "";

  String language = "english";
  bool presedDone = false;
  TextEditingController userName = TextEditingController();
  TextEditingController phone = TextEditingController();
  bool otpSend = false;
  bool buttonDisabled = false;
  String? checkOtp;
  bool verified = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
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
                      "Register to continue",
                      style: Style.title1Emphasized.copyWith(
                          color: Theme.of(context).colorScheme.onSurface),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    if (widget.phoneNumber.isEmpty) ...[
                      Text("Enter your phone"),
                      SizedBox(height: 6),
                      Container(
                        height: 50,
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                                width: 1,
                                color: Theme.of(context)
                                    .colorScheme
                                    .outlineVariant)),
                        child: Row(
                          children: [
                            Text(
                              "+91 ",
                              style: Style.body.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                                child: TextField(
                              // style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                              enabled: checkOtp == null,
                              controller: phone,
                              maxLength: 10,
                              cursorColor:
                                  Theme.of(context).colorScheme.primary,
                              keyboardType: TextInputType.phone,
                              onChanged: (_) {
                                if (phoneError.isNotEmpty) {
                                  phoneError = "";
                                  setState(() {});
                                }
                                if (phone.text.length == 10) {
                                  buttonDisabled = false;
                                  setState(() {});
                                } else {
                                  buttonDisabled = true;
                                  setState(() {});
                                }
                              },
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  counter: Offstage()),
                              style: Style.body.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                            ))
                          ],
                        ),
                      ),
                      if (phoneError.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(phoneError,
                              style: Style.caption2.copyWith(
                                  color: Theme.of(context).colorScheme.error)),
                        ),
                      SizedBox(height: 10),
                    ],
                    Text("Enter your full name"),
                    SizedBox(height: 6),
                    Container(
                      height: 50,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              width: 1,
                              color: Theme.of(context)
                                  .colorScheme
                                  .outlineVariant)),
                      child: TextField(
                        // style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                        // enabled: checkOtp == null,
                        controller: userName,
                        // maxLength: 10,
                        cursorColor: Theme.of(context).colorScheme.primary,
                        keyboardType: TextInputType.text,
                        onChanged: (_) {
                          if (nameError.isNotEmpty) {
                            nameError = "";
                            setState(() {});
                          }
                          // if (phoneNumber.text.length == 10) {
                          //   buttonDisabled = false;
                          //   setState(() {});
                          // } else {
                          //   buttonDisabled = true;
                          //   setState(() {});
                          // }
                        },
                        decoration: const InputDecoration(
                            border: InputBorder.none, counter: Offstage()),
                        style: Style.body.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                    ),
                    if (nameError.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(nameError,
                            style: Style.caption2.copyWith(
                                color: Theme.of(context).colorScheme.error)),
                      ),
                    // Container(
                    //   height: 50,
                    //   padding: EdgeInsets.symmetric(
                    //     horizontal: 10,
                    //   ),
                    //   decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(10),
                    //       border: Border.all(
                    //           width: 0.5,
                    //           color: nameError.isEmpty
                    //               ? Colors.black
                    //               : Theme.of(context).colorScheme.error)),
                    //   child: TextField(
                    //     style: Style.body.copyWith(
                    //         color: Theme.of(context).colorScheme.onSurface),
                    //     controller: userName,
                    //     keyboardType: TextInputType.text,
                    //     onChanged: (_) {
                    //       if (nameError.isNotEmpty) {
                    //         nameError = "";
                    //         setState(() {});
                    //       }
                    //     },
                    //     decoration: InputDecoration(border: InputBorder.none),
                    //   ),
                    // ),
                    if (checkOtp != null && checkOtp != "")
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 40),
                          Text(
                            "Enter otp:",
                            style: Style.subHeadline.copyWith(
                                color: Theme.of(context).colorScheme.onSurface),
                          ),
                          const SizedBox(height: 20),
                          OtpTextField(
                            numberOfFields: 4,
                            borderRadius: BorderRadius.circular(14),
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            fieldWidth: 50,
                            fieldHeight: 50,
                            borderColor:
                                Theme.of(context).colorScheme.outlineVariant,
                            focusedBorderColor:
                                Theme.of(context).colorScheme.outline,
                            borderWidth: 1,
                            textStyle: Style.body.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            cursorColor:
                                Theme.of(context).colorScheme.onSurface,
                            filled: true,
                            fillColor:
                                Theme.of(context).colorScheme.surfaceContainer,
                            showFieldAsBox: true,
                            onSubmit: (String verificationCode) {
                              if (int.parse(verificationCode) == checkOtp!) {
                                verified = true;
                                setState(() {});
                                // login(context, phone.text);
                              }
                            }, // end onSubmit
                          ),
                          SizedBox(height: 20)
                        ],
                      ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              if (!verified)
                SizedBox(
                  width: MediaQuery.of(context).size.width - 20,
                  child: Button(
                      disabled: buttonDisabled,
                      size: ButtonSize.large,
                      type: ButtonType.filled,
                      label: "Send Otp",
                      onPress: () async {
                        print(phone.text.length);
                        if (phone.text.length != 10) {
                          phoneError = "Enter valid phone";
                        } else if (userName.text.isEmpty) {
                          nameError = "Enter valid name";
                        } else {
                          otpSend = true;
                          buttonDisabled = true;
                          checkOtp = await Auth().sendOtp(phone.text, context);
                          setState(() {});
                        }
                        setState(() {});
                      }),
                )
              else
                Button(
                    size: ButtonSize.large,
                    type: ButtonType.filled,
                    label: "Continue",
                    onPress: () async {
                      // RegExp numReg = RegExp(r'^-?[0-9]+$');
                      // bool error = false;

                      // if (userName.text.isEmpty) {
                      //   nameError = "required *";
                      //   error = true;
                      // }

                      // setState(() {});

                      // if (!error && !presedDone) {
                      presedDone = true;
                      createAccount(
                        context,
                        widget.phoneNumber,
                        userName.text,
                      );

                      setState(() {});
                      // }
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
                  color: Theme.of(context).colorScheme.surfaceContainer),
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
                          border: Border.all(
                              color: Theme.of(context).colorScheme.primary)),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(
                            "Camera",
                            style: GoogleFonts.beVietnamPro(
                                color: Theme.of(context).colorScheme.primary),
                          )),
                          Icon(
                            Icons.camera_alt,
                            color: Theme.of(context).colorScheme.primary,
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
                          border: Border.all(
                              color: Theme.of(context).colorScheme.primary)),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(
                            "Gallery",
                            style: GoogleFonts.beVietnamPro(
                                color: Theme.of(context).colorScheme.primary),
                          )),
                          Icon(
                            Icons.photo,
                            color: Theme.of(context).colorScheme.primary,
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
