import 'dart:async';

import 'package:flutter/cupertino.dart';

import '../dialogs.dart';

/// A modal dialog header component combining a top-centered drag handle bar
/// with an optional closing button positioned in the top-right corner.
class CustomDialogHeader extends StatelessWidget {
  final bool showClosingButton;

  /// An optional asynchronous callback passed to [CustomClosingButton],
  /// executed immediately before closing the modal context.
  final FutureOr<void> Function()? closingButtonFunction;


  const CustomDialogHeader({
    super.key,

    this.showClosingButton = true,

    this.closingButtonFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const CustomDragHandleBar(),
        if (showClosingButton)
          CustomClosingButton(onClose: closingButtonFunction,),
      ],
    );
  }
}
