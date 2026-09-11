import 'package:flutter/material.dart';

extension ScrollControllerUtils on ScrollController {
  /// Whether the scroll position has passed [threshold] (default 80%) of the
  /// maximum scroll extent.
  ///
  /// Typical use case: triggering pagination / infinite scroll a bit before
  /// the user physically hits the bottom, so the next page has time to load
  /// without the user seeing an empty gap.
  ///
  /// ```dart
  /// _scrollController.addListener(() {
  ///   if (_scrollController.isAtBottom()) {
  ///     bloc.add(LoadNextPage());
  ///   }
  /// });
  /// ```
  bool isAtBottom({double threshold = 0.8}) {
    if (!hasClients) return false;
    final maxScroll = position.maxScrollExtent;
    return offset >= (maxScroll * threshold);
  }
}