import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

// Maybe name it SubtreeViewModel
abstract class ISubtreeModelContainer {
  S getState<S extends Object>();

  A getActions<A extends Object>();

  A? getTryActions<A extends Object>();
}

class SubtreeModelContainer implements ISubtreeModelContainer {
  late final GetIt _dependencyContainer;

  SubtreeModelContainer() {
    _dependencyContainer = GetIt.asNewInstance();
  }

  S putState<S extends Object>(S state) {
    _dependencyContainer.registerSingleton(state);
    return state;
  }

  void putActions<A extends Object>(A actions) {
    _dependencyContainer.registerSingleton(actions);
  }

  @override
  S getState<S extends Object>() {
    return _dependencyContainer.get<S>();
  }

  @override
  A getActions<A extends Object>() {
    return _dependencyContainer.get<A>();
  }

  @override
  A? getTryActions<A extends Object>() {
    if (!_dependencyContainer.isRegistered()) {
      return null;
    }

    return _dependencyContainer.get<A>();
  }
}

class SubtreeModelProvider extends InheritedWidget {
  const SubtreeModelProvider(this._dependenciesContainer, {super.key, required super.child});

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  static S getState<S extends Object>(BuildContext context) {
    return _guard(context)._dependenciesContainer.getState<S>();
  }

  static A getActions<A extends Object>(BuildContext context) {
    return _guard(context)._dependenciesContainer.getActions<A>();
  }

  static A? getTryActions<A extends Object>(BuildContext context) {
    return _guard(context)._dependenciesContainer.getTryActions<A>();
  }

  static SubtreeModelProvider _guard(BuildContext context) {
    final inheritElement = context.getElementForInheritedWidgetOfExactType<SubtreeModelProvider>();
    if (inheritElement == null) {
      throw Exception('No Dependency provider found in context');
    }
    return inheritElement.widget as SubtreeModelProvider;
  }

  final SubtreeModelContainer _dependenciesContainer;
}

extension SubtreeDependencyBuildContextExtensions on BuildContext {
  T getState<T extends Object>() => SubtreeModelProvider.getState<T>(this);

  T getActions<T extends Object>() => SubtreeModelProvider.getActions<T>(this);

  T? getTryActions<T extends Object>() => SubtreeModelProvider.getTryActions<T>(this);
}
