import 'package:flutter/material.dart';
import 'package:memento/theme.dart';

import 'back_button_widget.dart';
import 'title_widget.dart';

/// A wrapper around [SliverAppBar] providing standardized styling, title behavior,
/// flexible background support, and platform-adaptive navigation integration.
class CustomSliverAppBar extends StatelessWidget {
  // ------------------------------------------------------------
  // 1. TITLE & TEXT
  // ------------------------------------------------------------
  final String title;
  final Color? titleColor;

  // ------------------------------------------------------------
  // 2. ACTIONS & BOTTOM
  // ------------------------------------------------------------
  final List<Widget>? actions;
  final Widget? widget; // bottom area
  final Size? preferredSize;

  // ------------------------------------------------------------
  // 3. NAVIGATION (BACK BUTTON)
  // ------------------------------------------------------------
  final bool showBackButton;
  final bool isBackButtonInsideContainer;
  final VoidCallback? onBackPressed;

  // ------------------------------------------------------------
  // 4. LAYOUT & BEHAVIOR
  // ------------------------------------------------------------
  final double? expandedHeight;
  final double elevation;
  final bool floating;
  final bool pinned;
  final bool stretch;

  // ------------------------------------------------------------
  // 5. COLORS & AESTHETICS
  // ------------------------------------------------------------
  final Color? backgroundColor;
  final Color? surfaceTintColor;

  // ------------------------------------------------------------
  // 6. FLEXIBLE SPACE
  // ------------------------------------------------------------
  final Widget? flexibleBackground;

  const CustomSliverAppBar({
    super.key,

    // 1. TITLE
    required this.title,
    this.titleColor,

    // 2. ACTIONS / BOTTOM
    this.actions,
    this.widget,
    this.preferredSize,

    // 3. NAVIGATION
    this.showBackButton = true,
    this.isBackButtonInsideContainer = false,
    this.onBackPressed,

    // 4. LAYOUT
    this.expandedHeight,
    this.elevation = 0,
    this.floating = true,
    this.pinned = false,
    this.stretch = true,

    // 5. COLORS
    this.backgroundColor,
    this.surfaceTintColor,

    // 6. FLEXIBLE SPACE
    this.flexibleBackground,
  });

  @override
  Widget build(BuildContext context) {
    final Color effectiveTitleColor = titleColor ?? AppThemes.secondaryColor;
    final Color effectiveBackgroundColor = backgroundColor ?? AppThemes.primaryColor;
    final Color effectiveSurfaceTintColor = surfaceTintColor ?? AppThemes.primaryColor;

    final double? effectiveExpandedHeight = expandedHeight ??
        (flexibleBackground != null
            ? MediaQuery.of(context).size.height / 3
            : null);

    return SliverAppBar(
      actions: actions,
      surfaceTintColor: effectiveSurfaceTintColor,
      backgroundColor: effectiveBackgroundColor,
      elevation: elevation,
      stretch: stretch,
      pinned: pinned,
      floating: floating,
      expandedHeight: effectiveExpandedHeight,
      bottom: PreferredSize(
          preferredSize: preferredSize
              ?? (widget != null
                  ? const Size.fromHeight(50.0)
                  : const Size.fromHeight(0.0)),
          child: widget ?? const SizedBox(height: 1,)),
      title: TitleWidget(
          title: title,
          titleColor: effectiveTitleColor,
      ),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.blurBackground,
          StretchMode.zoomBackground,
        ],
        background: flexibleBackground,
      ),
      leading: BackButtonWidget(
        showBackButton: showBackButton,
      ),
    );
  }
}