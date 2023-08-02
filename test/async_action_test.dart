import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:subtree/state.dart';
import 'package:subtree/subtree.dart';

abstract class TestActions {
  Future<void> asyncOperation();
}

class TestingWidget extends StatelessWidget {
  const TestingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final actions = context.getActions<TestActions>();
    return Obx((ref) =>
        TextButton(onPressed: ref.disableUntilCompleted(actions.asyncOperation), child: const Text("Test text")));
  }
}

class TestController extends SubtreeController implements TestActions {
  TestController() {
    subtreeModel.putActions<TestActions>(this);
  }

  @override
  Future<void> asyncOperation() {
    return asyncOperationCompleter.future;
  }

  final asyncOperationCompleter = Completer<void>();
}

void main() {
  testWidgets('Subtree async action', (WidgetTester tester) async {
    final controller = TestController();

    await tester
        .pumpWidget(MaterialApp(home: ControlledSubtree(subtree: const TestingWidget(), controller: (context) => controller)));

    final btn = find.byWidgetPredicate((widget) => widget is TextButton);
    expect(tester.widget<TextButton>(btn).enabled, true);

    await tester.tap(btn);
    await tester.pump();
    expect(tester.widget<TextButton>(btn).enabled, false);

    controller.asyncOperationCompleter.complete();
    await tester.pump();
    expect(tester.widget<TextButton>(btn).enabled, true);
  });
}
