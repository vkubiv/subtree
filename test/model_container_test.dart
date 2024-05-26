import 'package:flutter_test/flutter_test.dart';
import 'package:subtree/state.dart';
import 'package:mocktail/mocktail.dart';
import 'package:subtree/subtree.dart';

class TestState {
  final val1 = Rx<String>("");
}

abstract class TestActions {
  void doAction();
}

class NumberFormatter {
  String fancyFormat(int value) => "__${value}__";
}

class MockTestActions extends Mock implements TestActions {}

void main() {
  test("subtree model container success", () {
    final subtreeModel = SubtreeModelContainer();
    final testState = TestState();
    final actions = MockTestActions();

    testState.val1.value = "10";

    subtreeModel.put(testState);
    subtreeModel.put<TestActions>(actions);
    subtreeModel.put(NumberFormatter());

    expect(subtreeModel.get<TestState>().val1.value, "10");

    subtreeModel.get<TestActions>().doAction();
    verify(() => actions.doAction()).called(1);

    expect(subtreeModel.get<NumberFormatter>().fancyFormat(10), "__10__");
  });

  test("subtree model container double put", () {
    final subtreeModel = SubtreeModelContainer();
    final testState = TestState();
    final actions = MockTestActions();

    testState.val1.value = "10";

    subtreeModel.put(testState);
    subtreeModel.put<TestActions>(actions);
    subtreeModel.put(NumberFormatter());

    expect(
        () => subtreeModel.put(testState),
        throwsA(predicate((e) =>
            e is AssertionError &&
            e.message ==
                "Subtree view model already contains TestState type. \n(Did you accidentally to put it twice?")));
    expect(
        () => subtreeModel.put<TestActions>(actions),
        throwsA(predicate((e) =>
            e is AssertionError &&
            e.message ==
                "Subtree view model already contains TestActions type. \n(Did you accidentally to put it twice?")));
    expect(
        () => subtreeModel.put(NumberFormatter()),
        throwsA(predicate((e) =>
            e is AssertionError &&
            e.message ==
                "Subtree view model already contains NumberFormatter type. \n(Did you accidentally to put it twice?")));
  });

  test("subtree model container forgot put", () {
    final subtreeModel = SubtreeModelContainer();

    expect(
        () => subtreeModel.get<TestState>(),
        throwsA(predicate((e) =>
            e is AssertionError &&
            e.message ==
                "Type TestState is not found in subtree view model. \n(Did you forget to put it in subtree controller?")));
    expect(
        () => subtreeModel.get<TestActions>(),
        throwsA(predicate((e) =>
            e is AssertionError &&
            e.message ==
                "Type TestActions is not found in subtree view model. \n(Did you forget to put it in subtree controller?")));
    expect(
        () => subtreeModel.get<NumberFormatter>(),
        throwsA(predicate((e) =>
            e is AssertionError &&
            e.message ==
                "Type NumberFormatter is not found in subtree view model. \n(Did you forget to put it in subtree controller?")));
  });
}
