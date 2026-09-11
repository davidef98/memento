import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../theme.dart';
import '../../utilities/utilities.dart';

/// A customizable, platform-adaptive elevated button component.
///
/// Automatically manages an async loading state, showing a platform-appropriate
/// spinner ([CupertinoActivityIndicator] on iOS, [CircularProgressIndicator] on Android)
/// while [function] executes.
class CustomElevatedButton extends StatefulWidget {
  /// The callback function executed when the button is tapped.
  ///
  /// Supports asynchronous operations and automatically displays a loading indicator
  /// until execution completes.
  final FutureOr<void> Function() function;

  ///Text Layout
  final String message;
  final double? fontSize;
  final FontWeight fontWeight;
  final Color? textColor;

  ///Button Layout
  final double? buttonWidth;
  final EdgeInsetsGeometry internalPadding;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final BorderRadiusGeometry? iOSBorderRadiusGeometry;
  final BorderRadiusGeometry? androidBorderRadiusGeometry;
  final Color? spinnerColor;

  const CustomElevatedButton({
    super.key,

    ///Button Function
    required this.function,

    ///Text Layout
    required this.message,
    this.fontSize,
    this.fontWeight = FontWeight.w500,
    this.textColor,

    ///Button Layout
    this.buttonWidth,
    this.internalPadding = const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1,
    this.iOSBorderRadiusGeometry,
    this.androidBorderRadiusGeometry,
    this.spinnerColor,
  });

  @override
  State<CustomElevatedButton> createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton> {
  /// Internal state flag indicating whether the async action is currently executing.
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final bool isIOS = context.isIOS;
    final double effectiveButtonWidth = widget.buttonWidth ?? MediaQuery.of(context).size.width * 0.9;
    final double effectiveFontSize = widget.fontSize ?? MediaQuery.of(context).size.width * 0.04;
    final BorderRadiusGeometry effectiveIOSBorderRadiusGeometry = widget.iOSBorderRadiusGeometry ?? BorderRadius.circular(10);
    final BorderRadiusGeometry effectiveAndroidBorderRadiusGeometry = widget.androidBorderRadiusGeometry ?? BorderRadius.circular(16);

    final Color effectiveTextColor = widget.textColor ?? AppThemes.primaryColor;
    final Color effectiveBackgroundColor = widget.backgroundColor ??  AppThemes.secondaryColor;
    final Color effectiveBorderColor = widget.borderColor ?? AppThemes.secondaryColor;
    final Color effectiveSpinnerColor = widget.spinnerColor ?? AppThemes.primaryColor;

    if (isIOS) {
      /// iOS platform-adaptive Cupertino rendering
      return SizedBox(
        width: effectiveButtonWidth,
        child: Container(
          decoration: BoxDecoration(
            color: effectiveBackgroundColor,
            border: Border.all(
              color: effectiveBorderColor,
              width: widget.borderWidth!,
            ),
            borderRadius: effectiveIOSBorderRadiusGeometry,
          ),
          child: CupertinoButton(
            onPressed: () async {
              setState(() {
                loading = true;
              });
              await widget.function();
              setState(() {
                loading = false;
              });
            },
            color: effectiveBackgroundColor,
            padding: widget.internalPadding,
            child: loading
                ? CupertinoActivityIndicator(color: effectiveSpinnerColor)
                : Text(widget.message,
                style: GoogleFonts.urbanist(
                    fontSize: effectiveFontSize,
                    fontWeight: widget.fontWeight,
                    color: effectiveTextColor
                )
            ),
          ),
        ),
      );
    } else {
      /// Android platform-adaptive Material rendering
      return SizedBox(
        width: effectiveButtonWidth,
        child: Container(
          decoration: BoxDecoration(
            color: effectiveBackgroundColor,
            border: Border.all(
              color: effectiveBorderColor,
              width: widget.borderWidth!,
            ),
            borderRadius: effectiveIOSBorderRadiusGeometry,
          ),
          child: ElevatedButton(
            onPressed: () async {
              setState(() {
                loading = true;
              });
              await widget.function();
              setState(() {
                loading = false;
              });
            },
            style: ButtonStyle(
              elevation: WidgetStateProperty.all(0),
              side: WidgetStateProperty.all(BorderSide(color: effectiveBackgroundColor, width: widget.borderWidth!)),
              shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: effectiveAndroidBorderRadiusGeometry)),
              fixedSize: WidgetStateProperty.all(Size.fromWidth(MediaQuery.of(context).size.width * 0.9)),
              padding: WidgetStateProperty.all(widget.internalPadding),
              backgroundColor: WidgetStateProperty.all(effectiveBackgroundColor),
            ),
            child: loading
                ? CircularProgressIndicator(color: effectiveSpinnerColor,)
                : Text(
                widget.message,
                style: GoogleFonts.urbanist(
                    fontSize: effectiveFontSize,
                    fontWeight: widget.fontWeight,
                    color: effectiveTextColor
                )
            ),
          ),
        ),
      );
    }
  }
}
