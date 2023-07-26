import 'package:flutter/foundation.dart';

import 'reactive_block_ref.dart';

class ReactiveBlock implements ReactiveBlockRef {
  ReactiveBlock(this._reactiveBlockFunc) {
    _runReactiveBlock();
  }

  void _runReactiveBlock() {
    _reactiveBlockFunc(this);
  }

  @override
  T watch<T>(ValueListenable<T> observable) {
    if (!_subscriptions.contains(observable)) {
      observable.addListener(_runReactiveBlock);
      _subscriptions.add(observable);
    }
    return observable.value;
  }

  void dispose() {
    for (var sub in _subscriptions) {
      sub.removeListener(_runReactiveBlock);
    }
  }

  final _subscriptions = <ValueListenable>{};
  final void Function(ReactiveBlockRef ref) _reactiveBlockFunc;
}
