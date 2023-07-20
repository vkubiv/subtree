import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';

import 'reactive_block_ref.dart';

class Rx<T> extends ChangeNotifier implements RxListenable<T> {
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
  T get current {
    return _value;
  }

  void update(void Function(T value) updateFn) {
    updateFn(current);
    notifyListeners();
  }

  @override
  String toString() => throw Exception("Rx is not supposed to use directly in interpolation, use ref.watch()");
}

class RxList<T> extends ChangeNotifier implements RxListenable<Iterable<T>> {
  /// Creates a [RxList].
  RxList();

  List<T> _value = [];

  set value(Iterable<T> newValue) {
    if (const IterableEquality().equals(_value, newValue)) {
      return;
    }
    _value = List.of(newValue);
    notifyListeners();
  }

  @override
  Iterable<T> get current {
    return _value;
  }

  void update(void Function(List<T> value) updateFn) {
    updateFn(_value);
    notifyListeners();
  }

  @override
  String toString() => throw Exception("RxList is not supposed to use directly in interpolation, use ref.watch()");
}
