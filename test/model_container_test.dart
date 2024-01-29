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

    subtreeModel.putState(testState);
    subtreeModel.putActions<TestActions>(actions);
    subtreeModel.putIntoSubtree(NumberFormatter());

    expect(subtreeModel.getState<TestState>().val1.value, "10");

    subtreeModel.getActions<TestActions>().doAction();
    verify(() => actions.doAction()).called(1);

    expect(subtreeModel.getTransformer<NumberFormatter>().fancyFormat(10), "__10__");
  });

  test("subtree model container double put", () {
    final subtreeModel = SubtreeModelContainer();
    final testState = TestState();
    final actions = MockTestActions();

    testState.val1.value = "10";

    subtreeModel.putState(testState);
    subtreeModel.putActions<TestActions>(actions);
    subtreeModel.putIntoSubtree(NumberFormatter());

    expect(
        () => subtreeModel.putState(testState),
        throwsA(predicate((e) =>
            e is AssertionError &&
            e.message ==
                "Subtree view model already contains state of type TestState. \n(Did you accidentally to put it twice?")));
    expect(
        () => subtreeModel.putActions<TestActions>(actions),
        throwsA(predicate((e) =>
            e is AssertionError &&
            e.message ==
                "Subtree view model already contains actions of type TestActions. \n(Did you accidentally to put it twice?")));
    expect(
        () => subtreeModel.putIntoSubtree(NumberFormatter()),
        throwsA(predicate((e) =>
            e is AssertionError &&
            e.message ==
                "Subtree view model already contains transformers of type NumberFormatter. \n(Did you accidentally to put it twice?")));
  });

  test("subtree model container forgot put", () {
    final subtreeModel = SubtreeModelContainer();

    expect(
        () => subtreeModel.getState<TestState>(),
        throwsA(predicate((e) =>
            e is AssertionError &&
            e.message ==
                "State of type TestState is not found in subtree view model. \n(Did you forget to put it in subtree controller?")));
    expect(
        () => subtreeModel.getActions<TestActions>(),
        throwsA(predicate((e) =>
            e is AssertionError &&
            e.message ==
                "Actions of type TestActions is not found in subtree view model. \n(Did you forget to put it in subtree controller?")));
    expect(
        () => subtreeModel.getTransformer<NumberFormatter>(),
        throwsA(predicate((e) =>
            e is AssertionError &&
            e.message ==
                "Transformers of type NumberFormatter is not found in subtree view model. \n(Did you forget to put it in subtree controller?")));
  });
}
