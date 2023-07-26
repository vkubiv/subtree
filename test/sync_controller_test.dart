import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:subtree/state.dart';
import 'package:subtree/subtree.dart';

class TestState {
  final testVal = Rx<String>("0");
}

class TestingWidget extends StatelessWidget {
  const TestingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.getState<TestState>();

    return Obx((ref) => Text(ref.watch(state.testVal)));
  }
}

class ValueProvider {
  String value;

  ValueProvider(this.value);
}

class TestController extends SubtreeController {
  final state = TestState();

  TestController({required Listenable refreshOnChange, required ValueProvider valueProvider}) {
    subtreeModel.putState(state);

    syncController(() {
      state.testVal.value = valueProvider.value;
    }, [refreshOnChange]);
  }
}

void main() {
  testWidgets('Sync controller success', (WidgetTester tester) async {
    final changeNotifier = EventNotifier();
    final valueProvider = ValueProvider("1");

    await tester.pumpWidget(MaterialApp(
        home: ControlledSubtree(
            subtree: const TestingWidget(),
            controller: () => TestController(refreshOnChange: changeNotifier, valueProvider: valueProvider))));

    expect(find.text("0"), findsNothing);
    expect(find.text("1"), findsOneWidget);

    valueProvider.value = "2";
    changeNotifier.notify();
    await tester.pump();

    expect(find.text("1"), findsNothing);
    expect(find.text("2"), findsOneWidget);
  });
}
