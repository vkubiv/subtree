import 'package:flutter/widgets.dart';

import 'subtree_model.dart';
import 'event_notifier.dart';
import 'util.dart';

abstract class SubtreeController {
  final subtreeModel = SubtreeModelContainer();

  @mustCallSuper
  void dispose() {
    for (final sub in _subscriptions) {
      sub.cancel();
    }
  }

  void syncController(void Function() syncFunc, List<Listenable> on) {
    final sub = sync(syncFunc, on);
    _subscriptions.add(sub);
  }

  void subscribeController(void Function() syncFunc, List<Listenable> on) {
    final sub = subscribe(syncFunc, on);
    _subscriptions.add(sub);
  }

  final _subscriptions = <EventSubscription>[];
}

typedef SubtreeControllerBuilder = SubtreeController Function();

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller?.dispose();
    _controller = widget.controller();
  }

  @override
  void didUpdateWidget(covariant ControlledSubtree oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!isListsEquals(widget.deps, oldWidget.deps)) {
      _controller?.dispose();
      _controller = widget.controller();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SubtreeModelProvider(_controller!.subtreeModel, child: widget.subtree);
  }
}
