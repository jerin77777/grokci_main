import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grokci_main/backend/server.dart';
import 'package:grokci_main/screens/products.dart';

import '../types.dart';

class ProfileIcon extends StatelessWidget {
  const ProfileIcon({super.key, this.image, this.name, this.color, required this.size, this.fontSize});
  final String? image;
  final String? name;
  final Color? color;
  final double size;
  final double? fontSize;
  @override
  Widget build(BuildContext context) {
    if (image == null) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(size)),
        child: Center(
          child: Text(name![0].toString().toUpperCase(),
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(fontSize: fontSize, color: Colors.white, fontWeight: FontWeight.w500))),
        ),
      );
    } else {
      return SizedBox(
        width: size,
        height: size,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(size),
          // width: size,
          // height: size,
          // decoration: BoxDecoration(color: color, borderRadius: ),
          // child: Image.network(server.getAsssetUrl(image!))
          // child: Center(
          // child: Text(name![0].toString().toUpperCase(), style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w500))),
          // ),
        ),
      );
    }
  }
}

class SmallButton extends StatelessWidget {
  const SmallButton({super.key, required this.label, required this.onPress});
  final String label;
  final Function onPress;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.all(0),
        minimumSize: Size(30, 30),
      ),
      onPressed: () {
        onPress();
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 13),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Pallet.primary),
        child: Text(
          label,
          style: TextStyle(fontSize: 13, color: Pallet.fontInner),
        ),
      ),
    );
  }
}

class TextBox extends StatefulWidget {
  const TextBox(
      {super.key,
      this.controller,
      this.maxLines,
      this.onType,
      this.onEnter,
      this.hintText,
      this.focus,
      this.radius,
      this.errorText,
      this.type,
      this.isPassword = false,
      this.hasBorder = false,
      this.enabled = true});
  final TextEditingController? controller;
  final int? maxLines;
  final Function(String)? onType;
  final Function(String)? onEnter;
  final String? hintText;
  final FocusNode? focus;
  final double? radius;
  final bool isPassword;
  final bool enabled;
  final bool hasBorder;
  final String? errorText;
  final String? type;
  @override
  State<TextBox> createState() => _TextBoxState();
}

class _TextBoxState extends State<TextBox> {
  bool hasError = false;
  @override
  void initState() {
    if (widget.errorText != null) {
      hasError = true;
      setState(() {});
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: Pallet.inner2,
            borderRadius: BorderRadius.circular(widget.radius ?? 5),
            border: Border.all(
                color: widget.hasBorder
                    ? Colors.black
                    : (hasError)
                        ? Colors.red
                        : Colors.transparent),
          ),
          child: TextField(
              readOnly: !widget.enabled,
              obscureText: widget.isPassword,
              focusNode: widget.focus,
              onSubmitted: widget.onEnter,
              onChanged: (value) {
                hasError = false;
                if (widget.type == "time" &&
                    !RegExp(r'^([0-9]|0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$').hasMatch(value) &&
                    value.isNotEmpty) {
                  hasError = true;
                }
                if (widget.type == "double" && !RegExp(r'^\d*\.?\d*$').hasMatch(value) && value.isNotEmpty) {
                  hasError = true;
                }
                if (widget.type == "int" && !RegExp(r'^[0-9]+$').hasMatch(value) && value.isNotEmpty) {
                  hasError = true;
                }
                setState(() {});

                if (widget.onType != null) {
                  widget.onType!(value);
                }
              },
              controller: widget.controller,
              style: const TextStyle(fontSize: 12),
              maxLines: widget.maxLines ?? 1,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: TextStyle(fontSize: 12, color: Pallet.font3),
                isDense: true,
                border: InputBorder.none,
              )),
        ),
        if (widget.errorText != null)
          Text(
            widget.errorText!,
            style: TextStyle(fontSize: 10, color: Colors.red),
          )
      ],
    );
  }
}

class Button extends StatefulWidget {
  const Button(
      {super.key,
      required this.label,
      this.icon,
      required this.onPress,
      this.color,
      this.fontColor,
      this.active = true,
      this.radius,
      this.padding});
  final Icon? icon;
  final String label;
  final bool active;
  final Function onPress;
  final double? radius;
  final EdgeInsets? padding;
  final Color? color;
  final Color? fontColor;
  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: widget.active ? (widget.color ?? Pallet.primary) : Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.radius ?? 10),
          ),
          minimumSize: Size(0, 0),
          padding: EdgeInsets.zero),
      onPressed: () {
        if (widget.active) {
          widget.onPress();
        }
      },
      child: Padding(
        padding: widget.padding ?? EdgeInsets.symmetric(vertical: (widget.icon == null) ? 15 : 10, horizontal: 10),
        child: Row(
          mainAxisAlignment: (widget.icon == null) ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            if (widget.icon != null) widget.icon!,
            SizedBox(width: 10),
            Text(
              widget.label,
              style: TextStyle(
                color: (widget.active) ? (widget.fontColor ?? Colors.white) : Colors.white.withOpacity(0.5),
                fontSize: 13.5,
              ),
            ),
            SizedBox(width: 10)
          ],
        ),
      ),
    );
  }
}

class Category extends StatelessWidget {
  const Category({
    super.key,
    required this.category,
  });

  final category;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProductsInCategory(
                    categoryId: category["id"],
                    categoryName: category["categoryName"],
                  )),
        );
      },
      child: Container(
        width: 70,
        decoration: BoxDecoration(
          color: Pallet.inner1,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        child: Stack(children: [
          Center(
            child: Column(
              children: [
                SizedBox(
                  height: 5,
                ),
                Image.network(
                  height: 60,
                  width: 55,
                  getUrl(Bucket.categories, category["imageId"]),
                  fit: BoxFit.contain,
                ),
                SizedBox(
                  height: 35,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: 70,
              height: 40,
              padding: EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: Pallet.secondary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Center(
                  child: Text(
                category["categoryName"],
                textAlign: TextAlign.center,
                style: TextStyle(color: Pallet.fontInner, fontSize: 12),
              )),
            ),
          )
        ]),
      ),
    );
  }
}
