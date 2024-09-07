import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grokci_main/backend/server.dart';
import 'package:grokci_main/screens/products.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import '../types.dart';

class ProfileIcon extends StatelessWidget {
  const ProfileIcon(
      {super.key,
      this.image,
      this.name,
      this.color,
      required this.size,
      this.fontSize});
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
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(size)),
        child: Center(
          child: Text(name![0].toString().toUpperCase(),
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      fontSize: fontSize,
                      color: Colors.white,
                      fontWeight: FontWeight.w500))),
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
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(widget.radius ?? 14),
            border: Border.all(
                color: widget.hasBorder
                    ? Theme.of(context).colorScheme.outlineVariant
                    : (hasError)
                        ? Theme.of(context).colorScheme.error
                        : Colors.transparent),
          ),
          child: TextField(
              readOnly: !widget.enabled,
              obscureText: widget.isPassword,
              focusNode: widget.focus,
              onSubmitted: widget.onEnter,
              cursorColor: Theme.of(context).colorScheme.onSurface,
              cursorOpacityAnimates: true,
              onChanged: (value) {
                hasError = false;
                if (widget.type == "time" &&
                    !RegExp(r'^([0-9]|0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$')
                        .hasMatch(value) &&
                    value.isNotEmpty) {
                  hasError = true;
                }
                if (widget.type == "double" &&
                    !RegExp(r'^\d*\.?\d*$').hasMatch(value) &&
                    value.isNotEmpty) {
                  hasError = true;
                }
                if (widget.type == "int" &&
                    !RegExp(r'^[0-9]+$').hasMatch(value) &&
                    value.isNotEmpty) {
                  hasError = true;
                }
                setState(() {});

                if (widget.onType != null) {
                  widget.onType!(value);
                }
              },
              controller: widget.controller,
              style: Style.body
                  .copyWith(color: Theme.of(context).colorScheme.onSurface),
              maxLines: widget.maxLines ?? 1,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: Style.body.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
                isDense: true,
                border: InputBorder.none,
              )),
        ),
        if (widget.errorText != null)
          Text(
            widget.errorText!,
            style: Style.caption1
                .copyWith(color: Theme.of(context).colorScheme.error),
          )
      ],
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
        height: 90,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          borderRadius: const BorderRadius.all(Radius.circular(50)),
        ),
        child: Stack(children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  height: 50,
                  width: 50,
                  getUrl(Bucket.categories, category["imageId"]),
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: 70,
              height: 36,
              padding: EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(6),
                  bottomRight: Radius.circular(6),
                ),
              ),
              child: Center(
                  child: Text(
                category["categoryName"],
                textAlign: TextAlign.center,
                style: Style.caption2
                    .copyWith(color: Theme.of(context).colorScheme.onSecondary),
              )),
            ),
          )
        ]),
      ),
    );
  }
}

class StepperWidget extends StatefulWidget {
  int quantity;
  void Function() incrementFunc;
  void Function() decrementFunc;
  StepperWidget(
      {super.key,
      required this.quantity,
      required this.incrementFunc,
      required this.decrementFunc});

  @override
  State<StepperWidget> createState() => _StepperWidgetState();
}

class _StepperWidgetState extends State<StepperWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(8)),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Row(
        children: [
          GestureDetector(
              onTap: widget.decrementFunc,
              child: Icon(Icons.remove,
                  size: 18, color: Theme.of(context).colorScheme.onSurface)),
          const SizedBox(width: 10),
          Text(
            widget.quantity.toString(),
            style: Style.subHeadline
                .copyWith(color: Theme.of(context).colorScheme.onSurface),
          ),
          const SizedBox(width: 10),
          GestureDetector(
              onTap: widget.incrementFunc,
              child: Icon(Icons.add,
                  size: 18, color: Theme.of(context).colorScheme.onSurface)),
        ],
      ),
    );
  }
}

// TODO : there is some tweaking that is needed to be done in the searchbar widget; in the textenabled state

class SearchBarWidget extends StatefulWidget {
  String label;
  VoidCallback? onPress;
  bool? textEnabled;
  Function(String value) onTextChanged;
  Function(String value)? onSearchPress;
  Style? style;
  SearchBarWidget(
      {super.key,
      required this.label,
      this.onPress,
      this.textEnabled = false,
      required this.onTextChanged,
      this.onSearchPress,
      this.style});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return (widget.textEnabled == false)
        ? (Material(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).colorScheme.surfaceContainer,
            clipBehavior: Clip.antiAlias,
            child: InkWell(
                onTap: widget.onPress,
                splashColor: Theme.of(context).colorScheme.surfaceContainer,
                child: Container(
                  height: 40,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                  child: Row(
                    children: [
                      Icon(
                        FeatherIcons.search,
                        size: 20,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                          child: Text(widget.label,
                              style: Style.body.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant)))
                    ],
                  ),
                ))))
        : (Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back,
                      size: 20,
                      color: Theme.of(context).colorScheme.onSurface,
                    )),
                const SizedBox(width: 10),
                Expanded(
                    child: TextField(
                        controller: controller,
                        autofocus: true,
                        cursorColor: Theme.of(context).colorScheme.primary,
                        style: Style.body.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                        onChanged: (value) => widget.onTextChanged(value),
                        decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            hintText: widget.label,
                            hintStyle: Style.body.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant),
                            border: InputBorder.none))),
                const SizedBox(width: 10),
                GestureDetector(
                    onTap: () {
                      if (widget.onSearchPress != null) {
                        widget.onSearchPress!(controller.text);
                      }
                    },
                    child: Icon(
                      FeatherIcons.search,
                      size: 20,
                      color: Theme.of(context).colorScheme.onSurface,
                    )),
              ],
            ),
          ));
  }
}

enum ButtonSize { small, medium, large }

enum ButtonType { borderless, gray, tonal, filled }

class ButtonConfig {
  static double getBorderRadius(ButtonSize size) {
    switch (size) {
      case ButtonSize.small:
        return 40;
      case ButtonSize.medium:
        return 40;
      case ButtonSize.large:
        return 12.0;
      default:
        return 0.0;
    }
  }

  static double getHeight(ButtonSize size) {
    switch (size) {
      case ButtonSize.small:
        return 28.0;
      case ButtonSize.medium:
        return 34.0;
      case ButtonSize.large:
        return 50.0;
      default:
        return 34.0; // default to medium
    }
  }

  static EdgeInsets getButtonEdgeInset(ButtonSize size) {
    switch (size) {
      case ButtonSize.small:
        return const EdgeInsets.fromLTRB(6, 4, 10, 4);
      case ButtonSize.medium:
        return const EdgeInsets.fromLTRB(10, 7, 14, 7);
      case ButtonSize.large:
        return const EdgeInsets.fromLTRB(16, 14, 20, 14);
      default:
        return const EdgeInsets.all(8);
    }
  }

  static Color getFillColor(ButtonType type, BuildContext context) {
    switch (type) {
      case ButtonType.borderless:
        return Colors.transparent;
      case ButtonType.gray:
        return Theme.of(context).colorScheme.surfaceContainer;
      case ButtonType.tonal:
        return Theme.of(context).colorScheme.secondaryContainer;
      case ButtonType.filled:
        return Theme.of(context).colorScheme.primary;
      default:
        return Colors.blue; // default fill color
    }
  }
}

class Button extends StatelessWidget {
  final ButtonSize size;
  final ButtonType type;
  final String label;
  final VoidCallback onPress;
  final bool disabled;
  final IconData? icon;
  final TextStyle? labelStyle;
  final ButtonStyle? buttonStyle;

  const Button({
    Key? key,
    required this.size,
    required this.type,
    required this.onPress,
    required this.label,
    this.disabled = false,
    this.icon,
    this.labelStyle,
    this.buttonStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ButtonConfig.getHeight(size),
      child: FilledButton(
        onPressed: disabled ? null : onPress,
        style: FilledButton.styleFrom(
          enableFeedback: true,
          backgroundColor: ButtonConfig.getFillColor(type, context),
          surfaceTintColor: type == ButtonType.filled
              ? Theme.of(context).colorScheme.inverseSurface
              : Theme.of(context).colorScheme.surfaceContainer,
          disabledBackgroundColor: type == ButtonType.borderless
              ? Colors.transparent
              : Theme.of(context).colorScheme.surfaceContainer,
          disabledForegroundColor: Theme.of(context).colorScheme.scrim,
          disabledIconColor: Theme.of(context).colorScheme.scrim,
          foregroundColor: type == ButtonType.filled
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.primary,
          iconColor: type == ButtonType.filled
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(ButtonConfig.getBorderRadius(size)),
          ),
          padding: ButtonConfig.getButtonEdgeInset(size),
        ).merge(buttonStyle),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FaIcon(
              icon,
              size: icon != null ? (size == ButtonSize.large ? 17 : 15) : 0,
            ),
            const SizedBox(
              width: 4,
            ),
            Text(
              label,
              style: (size == ButtonSize.large ? Style.body : Style.subHeadline)
                  .merge(labelStyle),
            )
          ],
        ),
      ),
    );
  }
}
