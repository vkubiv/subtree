import 'package:flutter/widgets.dart';

import 'subtree_model.dart';
import 'event_notifier.dart';

abstract class SubtreeController<Params> {
  final subtreeModel = SubtreeModelContainer();
  late Params arguments;

  void onInit();

  @mustCallSuper
  void onUpdate(Params oldArguments) {}

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

typedef SubtreeControllerBuilder<Params> = SubtreeController<Params> Function();

class ControlledSubtree<Params> extends StatefulWidget {
  final Widget subtree;
  final Params params;
  final SubtreeControllerBuilder<Params> controller;

  const ControlledSubtree({Key? key, required this.subtree, required this.controller, required this.params})
      : super(key: key);

  @override
  State<ControlledSubtree> createState() => _ControlledSubtreeState<Params>();
}

class _ControlledSubtreeState<Params> extends State<ControlledSubtree<Params>> {
  SubtreeController<Params>? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller?.dispose();

    _controller = widget.controller();

    _controller!.arguments = widget.params;
    _controller!.onInit();
  }

  @override
  void didUpdateWidget(covariant ControlledSubtree<Params> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.params != oldWidget.params) {
      _controller!.arguments = widget.params;
      _controller!.onUpdate(oldWidget.params);
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
