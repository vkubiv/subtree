import 'package:flutter/widgets.dart';

import 'container.dart';

// Maybe name it SubtreeViewModel
abstract class ISubtreeModelContainer {
  S getState<S extends Object>();

  A getActions<A extends Object>();

  A getTransformer<A extends Object>();
}

class SubtreeModelContainer implements ISubtreeModelContainer {
  S putState<S extends Object>(S state) {
    _states.put(state);
    return state;
  }

  void putActions<A extends Object>(A actions) {
    _actions.put(actions);
  }

  T putIntoSubtree<T extends Object>(T obj) {
    _transformers.put(obj);
    return obj;
  }

  @override
  S getState<S extends Object>() {
    return _states.get<S>();
  }

  @override
  A getActions<A extends Object>() {
    return _actions.get<A>();
  }

  @override
  A getTransformer<A extends Object>() {
    return _transformers.get<A>();
  }

  final _states = UnrestrictedContainer("State");
  final _actions = UnrestrictedContainer("Actions");
  final _transformers = UnrestrictedContainer("Transformers");
}

class SubtreeModelProvider extends InheritedWidget {
  const SubtreeModelProvider(this._dependenciesContainer, {super.key, required super.child});

  @override
  bool updateShouldNotify(covariant SubtreeModelProvider oldWidget) {
    return _dependenciesContainer != oldWidget._dependenciesContainer;
  }

  static S getState<S extends Object>(BuildContext context) {
    return _guard(context)._dependenciesContainer.getState<S>();
  }

  static A getActions<A extends Object>(BuildContext context) {
    return _guard(context)._dependenciesContainer.getActions<A>();
  }

  static A fromSubtree<A extends Object>(BuildContext context) {
    return _guard(context)._dependenciesContainer.getTransformer<A>();
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
  T getState<T extends Object>() => SubtreeModelProvider.getState<T>(this);

  T getActions<T extends Object>() => SubtreeModelProvider.getActions<T>(this);

  T fromSubtree<T extends Object>() => SubtreeModelProvider.fromSubtree<T>(this);  
}
