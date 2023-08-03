import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:subtree/state.dart';
import 'package:subtree/subtree.dart';

class TestState {
  final testVal = Rx<String>("0");
}

abstract class TestActions {
  void clickButton();
}

class Formatter {
  String fancyFormat(String value) => "__${value}__";
}

class TestingWidget extends StatelessWidget {
  const TestingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final actions = context.getActions<TestActions>();
    final state = context.getState<TestState>();
    final formatter = context.getTransformer<Formatter>();
    return TextButton(
        onPressed: actions.clickButton, child: Obx((ref) => Text(formatter.fancyFormat(ref.watch(state.testVal)))));
  }
}

class TestingWidgetStateObx extends StatelessWidget {
  const TestingWidgetStateObx({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formatter = context.getTransformer<Formatter>();
    return StateObx<TestState>((state, ref) => Text(formatter.fancyFormat(ref.watch(state.testVal))));
  }
}

class TestController extends SubtreeController implements TestActions {
  bool buttonClicked = false;
  final state = TestState();

  TestController() {
    subtreeModel.putState(state);
    subtreeModel.putActions<TestActions>(this);
    subtreeModel.putTransformer(Formatter());
  }

  void updateState() {
    state.testVal.value = "100";
  }

  @override
  void clickButton() {
    buttonClicked = true;
  }
}

class TestControllerWithArgs extends SubtreeController implements TestActions {
  bool buttonClicked = false;
  final state = TestState();

  TestControllerWithArgs(String arg) {
    subtreeModel.putState(state);
    subtreeModel.putActions<TestActions>(this);
    subtreeModel.putTransformer(Formatter());

    state.testVal.value = arg;
  }

  @override
  void clickButton() {
    buttonClicked = true;
  }
}

void main() {
  testWidgets('Subtree success test', (WidgetTester tester) async {
    final controller = TestController();

    await tester.pumpWidget(MaterialApp(
        home: ControlledSubtree(
      subtree: const TestingWidget(),
      controller: (context) => controller,
    )));

    expect(controller.buttonClicked, false);

    final btn = find.byWidgetPredicate((widget) => widget is TextButton);
    await tester.tap(btn);

    expect(controller.buttonClicked, true);

    expect(find.text("__0__"), findsOneWidget);

    controller.updateState();
    await tester.pump();

    expect(find.text("__100__"), findsOneWidget);
  });

  testWidgets('Subtree failure, missed subtree provider', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: TestingWidget()));
    expect(
        tester.takeException(),
        predicate((e) =>
            e is AssertionError && e.message.toString().contains("No SubtreeModelProvider provider found in context")));
  });

  testWidgets('Subtree switch args', (WidgetTester tester) async {
    final idSwitcher = ValueNotifier<String>("1");

    await tester.pumpWidget(MaterialApp(
        home: ValueListenableBuilder<String>(
            valueListenable: idSwitcher,
            builder: (context, id, child) => ControlledSubtree(
                  subtree: const TestingWidgetStateObx(),
                  controller: (context) => TestControllerWithArgs(id),
                  deps: [id],
                ))));

    expect(find.text("__1__"), findsOneWidget);

    idSwitcher.value = "100";

    await tester.pump();

    expect(find.text("__100__"), findsOneWidget);
  });

  testWidgets('Subtree on parent widget rebuild', (WidgetTester tester) async {
    final idSwitcher = ValueNotifier<String>("1");

    await tester.pumpWidget(MaterialApp(
        home: ValueListenableBuilder<String>(
            valueListenable: idSwitcher,
            builder: (context, id, child) => ControlledSubtree(
                  subtree: const TestingWidgetStateObx(),
                  controller: (context) => TestControllerWithArgs(id),
                  deps: const [],
                ))));

    expect(find.text("__1__"), findsOneWidget);

    idSwitcher.value = "100";

    await tester.pump();

    expect(find.text("__1__"), findsOneWidget);
  });
}
