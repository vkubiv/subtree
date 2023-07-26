import 'package:flutter_test/flutter_test.dart';
import 'package:subtree/state.dart';

class ComplexObject {
  String innerValue;

  ComplexObject(this.innerValue);
}

void main() {
  test("Rx success", () {
    final rx = Rx<String>('0');

    expect(rx.value, '0');
    rx.value = '1';
    expect(rx.value, '1');

    int listenerCalledCount = 0;
    void listener() {
      listenerCalledCount++;
    }

    rx.addListener(listener);
    rx.value = '2';
    expect(rx.value, '2');
    expect(listenerCalledCount, 1);

    rx.removeListener(listener);
    rx.value = '4';
    expect(rx.value, '4');
    expect(listenerCalledCount, 1);

    expect(
        () => rx.toString(),
        throwsA(predicate((e) =>
            e is AssertionError &&
            e.message == "Rx is not supposed to use directly in interpolation, use ref.watch()")));
  });

  test("Rx update success", () {
    final rx = Rx<ComplexObject>(ComplexObject('0'));

    expect(rx.value.innerValue, '0');
    rx.value = ComplexObject('1');
    expect(rx.value.innerValue, '1');

    int listenerCalledCount = 0;
    void listener() {
      listenerCalledCount++;
    }

    rx.addListener(listener);
    rx.update((obj) {
      obj.innerValue = '2';
    });

    expect(rx.value.innerValue, '2');
    expect(listenerCalledCount, 1);
  });

  test("RxList success", () {
    final rx = RxList<String>(['0']);

    expect(rx.value, ['0']);

    int listenerCalledCount = 0;
    void listener() {
      listenerCalledCount++;
    }

    rx.addListener(listener);
    rx.value = ['1'];
    expect(rx.value, ['1']);
    expect(listenerCalledCount, 1);

    rx.value = ['1'];
    expect(rx.value, ['1']);
    expect(listenerCalledCount, 1);

    rx.update((obj) {
      obj[0] = '2';
    });
    expect(rx.value, ['2']);
    expect(listenerCalledCount, 2);

    expect(
        () => rx.toString(),
        throwsA(predicate((e) =>
            e is AssertionError &&
            e.message == "RxList is not supposed to use directly in interpolation, use ref.watch()")));
  });
}
