import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memento/utilities/scroll_controller_utils.dart';

void main() {
  group('ScrollControllerUtils.isAtBottom', () {
    late ScrollController controller;

    Future<void> pumpScrollable(
        WidgetTester tester, {
          required ScrollController controller,
          double contentHeight = 1000,
          double viewportHeight = 200,
        }) {
      return tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(size: Size(400, viewportHeight)),
            child: SingleChildScrollView(
              controller: controller,
              child: SizedBox(height: contentHeight),
            ),
          ),
        ),
      );
    }

    setUp(() {
      controller = ScrollController();
    });

    tearDown(() {
      controller.dispose();
    });

    testWidgets('returns false when controller has no clients', (tester) async {
      expect(controller.isAtBottom(), isFalse);
    });

    testWidgets('returns false when scroll is below the default threshold', (tester) async {
      await pumpScrollable(tester, controller: controller);
      controller.jumpTo(0);

      expect(controller.isAtBottom(), isFalse);
    });

    testWidgets('returns true when scroll reaches the default threshold', (tester) async {
      await pumpScrollable(tester, controller: controller);
      final maxScroll = controller.position.maxScrollExtent;
      controller.jumpTo(maxScroll * 0.8);

      expect(controller.isAtBottom(), isTrue);
    });

    testWidgets('respects a custom threshold', (tester) async {
      await pumpScrollable(tester, controller: controller);
      final maxScroll = controller.position.maxScrollExtent;
      controller.jumpTo(maxScroll * 0.5);

      expect(controller.isAtBottom(threshold: 0.4), isTrue);
      expect(controller.isAtBottom(threshold: 0.6), isFalse);
    });

    testWidgets('returns true at the very bottom regardless of threshold', (tester) async {
      await pumpScrollable(tester, controller: controller);
      final maxScroll = controller.position.maxScrollExtent;
      controller.jumpTo(maxScroll);

      expect(controller.isAtBottom(), isTrue);
    });
  });
}