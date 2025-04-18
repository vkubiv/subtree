import 'dart:async';

import 'package:flutter/widgets.dart';

import 'subtree_model.dart';
import 'controller_notifier.dart';
import 'util.dart';

abstract class BaseController {
  @mustCallSuper
  void dispose() {
    for (final sub in _subscriptions) {
      sub.cancel();
    }
  }

  FutureOr<void> sync(FutureOr<void> Function() syncFunc, List<Listenable> on) async {
    final sub = await _sync(syncFunc, on);
    _subscriptions.add(sub);
  }

  void subscribe(void Function() syncFunc, List<Listenable> on) {
    final sub = _subscribe(syncFunc, on);
    _subscriptions.add(sub);
  }

  final _subscriptions = <ControllerSubscription>[];
}

abstract class SubtreeController extends BaseController {
  final subtree = SubtreeModelContainer();
}

typedef SubtreeControllerBuilder = SubtreeController Function(BuildContext context);

class ControlledSubtree extends StatefulWidget {
  final Widget subtree;
  final List<Object?> deps;
  final SubtreeControllerBuilder controller;

  const ControlledSubtree({Key? key, required this.subtree, required this.controller, this.deps = const []})
      : super(key: key);

  @override
  State<ControlledSubtree> createState() => _ControlledSubtreeState();
}

class _ControlledSubtreeState extends State<ControlledSubtree> {
  SubtreeController? _controller;
  late UniqueKey _rootKey;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller?.dispose();
    _rootKey = UniqueKey();
    _controller = widget.controller(context);
  }

  @override
  void didUpdateWidget(covariant ControlledSubtree oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!isListsEquals(widget.deps, oldWidget.deps)) {
      _controller?.dispose();
      _rootKey = UniqueKey();
      _controller = widget.controller(context);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SubtreeModelProvider(_controller!.subtree, key: _rootKey, child: widget.subtree);
  }
}

FutureOr<ControllerSubscription> _sync(FutureOr<void> Function() syncFunc, List<Listenable> on) async {
  for (final deps in on) {
    deps.addListener(syncFunc);
  }
  await syncFunc();

  return ControllerSubscription(syncFunc, on);
}

ControllerSubscription _subscribe(void Function() syncFunc, List<Listenable> on) {
  for (final deps in on) {
    deps.addListener(syncFunc);
  }

  return ControllerSubscription(syncFunc, on);
}
