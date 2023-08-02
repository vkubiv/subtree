import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:subtree/src/subtree_model.dart';

import 'reactive_block_ref.dart';
import 'rx.dart';

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

class EventListener<T extends Object> extends StatefulWidget {
  const EventListener({
    Key? key,
    required this.event,
    required this.listener,
    required this.child,
  }) : super(key: key);

  final RxEvent<T> event;
  final void Function(BuildContext context, T value) listener;
  final Widget child;

  @override
  State<EventListener> createState() => _EventListenerState<T>();
}

class _EventListenerState<T extends Object> extends State<EventListener<T>> {
  void _onEvent() {
    widget.listener(context, widget.event.value!);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _unsubscribe();
    _subscribe();
  }

  @override
  void didUpdateWidget(covariant EventListener<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.event != oldWidget.event) {
      _unsubscribe();
      _subscribe();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _subscribe() {
    final event = widget.event;
    if (!_subscriptions.contains(event)) {
      event.addListener(_onEvent);
      _subscriptions.add(event);
    }
  }

  void _unsubscribe() {
    for (var sub in _subscriptions) {
      sub.removeListener(_onEvent);
    }
    _subscriptions.clear();
  }

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  final _subscriptions = <RxEvent<T>>{};
}
