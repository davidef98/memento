import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../theme.dart';
import '../../utilities/utilities.dart';

/// A platform-adaptive button component that displays a dynamic visual widget (such as an SVG icon)
/// centered above a text label.
///
/// Uses [CupertinoButton] on iOS and [TextButton] with Material styling on Android and other platforms.
class SvgButton extends StatelessWidget {
  /// The visual widget displayed at the top center of the button (typically an SVG or Image asset).
  final Widget icon;

  /// Callback function executed when the button is pressed.
  final VoidCallback onPressed;

  /// The text label displayed below the icon.
  final String text;

  /// Optional text color for the button label. Defaults to [AppThemes.secondaryColor] if null.
  final Color? textColor;

  /// Optional custom text style for the label. If null, falls back to [UnifiedTextStyles.bodyText16].
  final TextStyle? textStyle;

  const SvgButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.text,
    this.textStyle,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool isIOS = context.isIOS;
    final Color effectiveTextColor = textColor ?? AppThemes.secondaryColor;

    /// The structured layout containing the icon and label aligned vertically.
    final Widget buttonContent = IntrinsicHeight(
      child: IntrinsicWidth(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: icon),
            const SizedBox(height: 8),
            Text(
              text,
              textAlign: TextAlign.center,
              style: textStyle ??
                  UnifiedTextStyles.bodyText16.copyWith(
                    fontWeight: FontWeight.w600,
                    color: effectiveTextColor,
                  ),
            ),
          ],
        ),
      ),
    );

    /// iOS platform-adaptive Cupertino rendering.
    return isIOS ? CupertinoButton(
      onPressed: onPressed,
      padding: const EdgeInsets.all(16.0),
      child: buttonContent,
      /// Android platform-adaptive Material rendering.
    ) : TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(
          AppThemes.primaryColor,
        ),
        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.all(16.0),
        ),
      ),
      child: buttonContent,
    );
  }
}

/// Usage
/*
SvgButton(
  icon: SvgPicture.asset('assets/google_icon.svg', width: 24, height: 24),
  onPressed: () => context.read<SignUpCubit>().logInWithGoogle(),
),
 */