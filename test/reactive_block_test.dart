import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:subtree/state.dart';

void main() {
  test("subtree model container success", () {
    final valNotifier = ValueNotifier<String>("0");
    var value = "";

    final rBlock = ReactiveBlock((ref) {
      value = ref.watch(valNotifier);
    });

    expect(value, "0");

    valNotifier.value = "1";
    expect(value, "1");

    rBlock.dispose();
    valNotifier.value = "2";
    expect(value, "1");

  });
}
