import 'package:flutter/foundation.dart';

class ControllerNotifier extends ChangeNotifier {
  void notify() {
    notifyListeners();
  }
}

class ControllerSubscription {
  final Function() _syncFunc;
  final List<Listenable> dependsOn;

  ControllerSubscription(this._syncFunc, this.dependsOn);

  void cancel() {
    for (final deps in dependsOn) {
      deps.removeListener(_syncFunc);
    }
  }
}
