import 'package:flutter/widgets.dart';

import 'container.dart';

// Maybe name it SubtreeViewModel
abstract class ISubtreeModelContainer {
  S subtreeGet<S extends Object>();
}

class SubtreeModelContainer implements ISubtreeModelContainer {
  S put<S extends Object>(S state) {
    _containers.put(state);
    return state;
  }

  @override
  S subtreeGet<S extends Object>() {
    return _containers.get<S>();
  }

  final _containers = UnrestrictedContainer();
}

class SubtreeModelProvider extends InheritedWidget {
  const SubtreeModelProvider(this._dependenciesContainer, {super.key, required super.child});

  @override
  bool updateShouldNotify(covariant SubtreeModelProvider oldWidget) {
    return _dependenciesContainer != oldWidget._dependenciesContainer;
  }

  static S subtreeGet<S extends Object>(BuildContext context) {
    return _guard(context)._dependenciesContainer.subtreeGet<S>();
  }

  static SubtreeModelProvider _guard(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<SubtreeModelProvider>();
    if (widget == null) {
      throw AssertionError('''No SubtreeModelProvider provider found in context.\n'''
          '''This error usually means that the widget that is intended\n'''
          '''to be part of the subtree is not a child of ControlledSubtree widget''');
    }
    return widget;
  }

  final SubtreeModelContainer _dependenciesContainer;
}

extension SubtreeDependencyBuildContextExtensions on BuildContext {
  T subtreeGet<T extends Object>() => SubtreeModelProvider.subtreeGet<T>(this);
}
