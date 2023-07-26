
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:subtree/src/subtree_model.dart';

import 'reactive_block_ref.dart';


abstract class ReactiveBlockRefExt extends ReactiveBlockRef {
  @override
  T watch<T>(ValueListenable<T> observable);

  Future<void> Function()? disableUntilCompleted(Future<void> Function() action);
}

abstract class ObxWidget extends StatefulWidget {
  const ObxWidget({super.key});

  @override
  State<StatefulWidget> createState() => _ObxState();

  Widget build(BuildContext context, ReactiveBlockRefExt ref);
}

class _ObxState extends State<ObxWidget> implements ReactiveBlockRefExt {
  @override
  Widget build(BuildContext context) {
    return widget.build(context, this);
  }

  void _updateTree() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  T watch<T>(ValueListenable<T> observable) {
    if (!_subscriptions.contains(observable)) {
      observable.addListener(_updateTree);
      _subscriptions.add(observable);
    }
    return observable.value;
  }

  @override
  Future<void> Function()? disableUntilCompleted(Future<void> Function() action) {
    if (_runningActions.contains(action)) {
      return null;
    }
    return () async {
      _runningActions.add(action);
      _updateTree();
      try {
        await action();
      } finally {
        _runningActions.remove(action);
        _updateTree();
      }
    };
  }

  @override
  void dispose() {
    for (var sub in _subscriptions) {
      sub.removeListener(_updateTree);
    }

    super.dispose();
  }

  final _subscriptions = <ValueListenable>{};
  final _runningActions = <Function>{};
}


class Obx extends ObxWidget {
  final Widget Function(ReactiveBlockRefExt ref) _builder;

  const Obx(this._builder, {super.key});

  @override
  Widget build(BuildContext context, ReactiveBlockRefExt ref) => _builder(ref);
}

class StateObx<State extends Object> extends ObxWidget {
  final Widget Function(State state, ReactiveBlockRef ref) _builder;

  const StateObx(this._builder, {super.key});

  @override
  Widget build(BuildContext context, ReactiveBlockRefExt ref) => _builder(context.getState<State>(), ref);
}