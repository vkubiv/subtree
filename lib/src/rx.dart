import 'package:flutter/foundation.dart';

import 'util.dart';

class Rx<T> extends ChangeNotifier implements ValueListenable<T> {
  /// Creates a [Rx] that wraps this value.
  Rx(this._value);

  T _value;

  set value(T newValue) {
    if (_value == newValue) {
      return;
    }
    _value = newValue;
    notifyListeners();
  }

  @override
  T get value {
    return _value;
  }

  void update(void Function(T value) updateFn) {
    updateFn(_value);
    notifyListeners();
  }

  @override
  String toString() => throw AssertionError("Rx is not supposed to use directly in interpolation, use ref.watch()");
}

class RxList<T> extends ChangeNotifier implements ValueListenable<Iterable<T>> {
  /// Creates a [RxList].
  RxList(List<T>? defaultVal) {
    _value = defaultVal ?? [];
  }

  late List<T> _value;

  set value(Iterable<T> newValue) {
    if (isIterableEquals(_value, newValue)) {
      return;
    }
    _value = List.of(newValue);
    notifyListeners();
  }

  @override
  Iterable<T> get value {
    return _value;
  }

  void update(void Function(List<T> value) updateFn) {
    updateFn(_value);
    notifyListeners();
  }

  @override
  String toString() => throw AssertionError("RxList is not supposed to use directly in interpolation, use ref.watch()");
}
