import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memento/theme.dart';
import 'package:memento/utilities/utilities.dart';


/// Callback invoked when a search action is triggered with the specified [query].
typedef CustomSearchCallback = FutureOr<void> Function(String query);

/// Callback invoked when the search field is cleared.
typedef ClearCallback = void Function();

/// Callback used to validate the search [query] before execution.
/// Returns an error message string if invalid, or `null` if valid.
typedef ValidateCallback = String? Function(String query);

/// A customizable, platform-adaptive search bar widget supporting both iOS
/// and Android native styling.
///
/// Features built-in back navigation, query validation, clear action handling,
/// and trailing actions customization.
class CustomSearchBar extends StatefulWidget {
  // Callback triggered when the user submits a valid search query.
  final CustomSearchCallback onSearch;

  /// Callback triggered when the clear action is tapped or text is emptied.
  final ClearCallback onClear;

  /// Validation logic executed before [onSearch] is invoked.
  final ValidateCallback validator;

  /// Controls the text input field.
  final TextEditingController controller;

  /// Focus node for controlling input focus states.
  final FocusNode focusNode;

  /// The context passed to internal dialog or navigation utilities.
  final BuildContext innerContext;

  ///Back button layout
  final EdgeInsetsGeometry backButtonPadding;
  final IconData iOSBackButtonIconData;
  final IconData androidBackButtonIconData;
  final Color? backButtonColor;
  final double backButtonSize;

  ///Bar layout
  final Color? cursorColor;
  final Color? backgroundColor;
  final double androidBarElevation;
  final double spaceAtBarRight;
  final List<Widget>? actions;

  ///Placeholder TextParameters
  final String placeholderContent;
  final TextStyle? placeholderTextStyle;

  ///TextStyle Parameters
  final TextStyle? textStyle;

  ///Prefix Icon Parameters
  final Color? prefixIconColor;
  final double prefixIconSize;
  final IconData iOSPrefixIconData;
  final IconData androidPrefixIconData;

  ///Suffix Icon Parameters
  final Color? activeSuffixIconColor;
  final Color? inactiveSuffixIconColor;
  final double suffixIconSize;
  final IconData iOSSuffixIconData;
  final IconData androidSuffixIconData;

  const CustomSearchBar({
    super.key,

    required this.onSearch,
    required this.onClear,
    required this.validator,

    required this.controller,
    required this.focusNode,
    required this.innerContext,

    ///Back button
    this.backButtonPadding = const EdgeInsets.symmetric(horizontal: 4),
    this.iOSBackButtonIconData = CupertinoIcons.back,
    this.androidBackButtonIconData = Icons.arrow_back,
    this.backButtonColor,
    this.backButtonSize = 28,

    ///Bar layout
    this.cursorColor ,
    this.backgroundColor,
    this.androidBarElevation = 0,
    this.spaceAtBarRight = 4,
    this.actions,

    ///Placeholder TextParameters
    required this.placeholderContent,
    this.placeholderTextStyle,

    ///TextStyle Parameters
    this.textStyle,

    ///Prefix Icon Parameters
    this.prefixIconColor,
    this.prefixIconSize = 20, //o 14, guardala
    this.iOSPrefixIconData = CupertinoIcons.search,
    this.androidPrefixIconData = Icons.search,

    ///Suffix Icon Parameters
    this.activeSuffixIconColor,
    this.inactiveSuffixIconColor,
    this.suffixIconSize = 20, //o 14
    this.iOSSuffixIconData = CupertinoIcons.clear_circled_solid,
    this.androidSuffixIconData = Icons.cancel,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  /// Evaluates input text changes to toggle searching states and invoke [widget.onClear].
  void _onTextChanged() {
    setState(() {
      _isSearching = widget.controller.text.isNotEmpty;
    });

    if (widget.controller.text.isEmpty) {
      widget.onClear();
    }
  }

  /// Validates input text and executes search callback or displays an error dialog.
  Future<void> _invokeSearch() async {
    final validationResult = widget.validator(widget.controller.text);
    if (validationResult == null) {
      await widget.onSearch(widget.controller.text);
    } else {
      DialogUtilities.showErrorBottomSheet(context, validationResult);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isIOS = context.isIOS;
    final Color effectiveBackButtonColor = widget.backButtonColor ?? AppThemes.secondaryColor;
    final Color effectiveBackgroundColor = widget.backgroundColor ?? AppThemes.textFields;
    final Color effectiveCursorColor = widget.cursorColor ?? AppThemes.secondaryColor;
    final Color effectivePrefixIconColor = widget.prefixIconColor ?? AppThemes.secondaryColor;
    final Color effectiveActiveSuffixIconColor = widget.activeSuffixIconColor ?? AppThemes.secondaryColor;
    final Color effectiveInactiveSuffixIconColor = widget.inactiveSuffixIconColor ?? AppThemes.transparent;

    final TextStyle effectiveTextStyle = widget.textStyle ?? UnifiedTextStyles.bodyText16.copyWith(fontWeight: FontWeight.w500);
    final TextStyle effectivePlaceholderTextStyle = widget.placeholderTextStyle ?? UnifiedTextStyles.bodyText16.copyWith(fontWeight: FontWeight.w500);

    final IconData backIconData = isIOS ? widget.iOSBackButtonIconData : widget.androidBackButtonIconData;
    final IconData prefixIconData = isIOS ? widget.iOSPrefixIconData : widget.androidPrefixIconData;
    final Icon prefixIcon = Icon(
      prefixIconData,
      color: effectivePrefixIconColor,
      size: widget.prefixIconSize,
    );

    final IconData suffixIconData = isIOS ? widget.iOSSuffixIconData : widget.androidSuffixIconData;
    final Icon suffixIcon = Icon(
      suffixIconData,
      color: _isSearching ? effectiveActiveSuffixIconColor : effectiveInactiveSuffixIconColor,
      size: widget.suffixIconSize,
    );

    return Row(
      children: [
        Padding(
          padding: widget.backButtonPadding,
          child: IconButton(
            color: effectiveBackButtonColor,
            iconSize: widget.backButtonSize,
            icon: Icon(
                backIconData
            ),
            onPressed: () {
              widget.onClear();
              GoRouter.of(context).pop();
            },
          ),
        ),
        isIOS ? Expanded(
          child: CupertinoSearchTextField(
            cursorColor: effectiveCursorColor,
            controller: widget.controller,
            focusNode: widget.focusNode,
            placeholder: widget.placeholderContent,
            placeholderStyle: effectivePlaceholderTextStyle,
            style: effectiveTextStyle,
            prefixIcon: prefixIcon,
            backgroundColor: effectiveBackgroundColor,
            onSubmitted: (_) {
              _invokeSearch();
            },
            onTap: () {
              setState(() {
                _isSearching = true;
              });
            },
            suffixIcon: suffixIcon,
            onSuffixTap: _isSearching ? widget.onClear : null,
          ),
        ) : Expanded(
            child: SearchBar(
              onSubmitted: (_) {
                _invokeSearch();
              },
              elevation: WidgetStatePropertyAll(widget.androidBarElevation),
              controller: widget.controller,
              focusNode: widget.focusNode,
              hintText: widget.placeholderContent,
              hintStyle: WidgetStateProperty.all(effectivePlaceholderTextStyle),
              textStyle: WidgetStateProperty.all(effectiveTextStyle),
              backgroundColor: WidgetStateProperty.all(effectiveBackgroundColor),
              leading: prefixIcon,
              trailing: [
                IconButton(
                  icon: Icon(
                    suffixIconData,
                    color: _isSearching
                        ? effectiveActiveSuffixIconColor
                        : effectiveInactiveSuffixIconColor,
                    size: widget.suffixIconSize,
                  ),
                  onPressed: _isSearching ? widget.onClear : null,
                )
              ],
              onTap: () {
                setState(() {
                  _isSearching = true;
                });
              },
            )
        ),
        SizedBox(
            width: widget.spaceAtBarRight
        ),
        ...?widget.actions,
      ],
    );
  }
}

