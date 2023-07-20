
import 'package:flutter/foundation.dart';

class EventNotifier extends ChangeNotifier {
  void notify() {
    notifyListeners();
  }
}

class EventSubscription {
  final Function() _syncFunc;
  final List<Listenable> dependsOn;

  EventSubscription(this._syncFunc, this.dependsOn);

  void cancel() {
    for (final deps in dependsOn) {
      deps.removeListener(_syncFunc);
    }
  }
}

EventSubscription sync(void Function() syncFunc, List<Listenable> on) {
  for (final deps in on) {
    deps.addListener(syncFunc);
  }
  syncFunc();

  return EventSubscription(syncFunc, on);
}

EventSubscription subscribe(void Function() syncFunc, List<Listenable> on) {
  for (final deps in on) {
    deps.addListener(syncFunc);
  }

  return EventSubscription(syncFunc, on);
}

