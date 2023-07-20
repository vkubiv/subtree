import 'reactive_block_ref.dart';

class ReactiveBlock implements ReactiveBlockRef {
  ReactiveBlock(this._reactiveBlockFunc) {
    _runReactiveBlock();
  }

  void _runReactiveBlock() {
    _reactiveBlockFunc(this);
  }

  @override
  T watch<T>(RxListenable<T> observable) {
    if (!_subscriptions.contains(observable)) {
      observable.addListener(_runReactiveBlock);
      _subscriptions.add(observable);
    }
    return observable.current;
  }

  void dispose() {
    for (var sub in _subscriptions) {
      sub.removeListener(_runReactiveBlock);
    }
  }

  final _subscriptions = <RxListenable>{};
  final void Function(ReactiveBlockRef ref) _reactiveBlockFunc;
}
