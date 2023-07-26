class UnrestrictedContainer {
  UnrestrictedContainer(this._dependencyClass);

  T put<T extends Object>(T dep) {
    if (_dependencies[T] != null) {
      throw AssertionError(
          // ignore: missing_whitespace_between_adjacent_strings
          'Subtree view model already contains ${_dependencyClass.toLowerCase()} of type ${T.toString()}. '
          '\n(Did you accidentally to put it twice?');
    }

    _dependencies[T] = dep;
    return dep;
  }

  T get<T extends Object>() {
    final dep = _dependencies[T];
    if (dep == null) {
      throw AssertionError(
          // ignore: missing_whitespace_between_adjacent_strings
          '$_dependencyClass of type ${T.toString()} is not found in subtree view model. '
          '\n(Did you forget to put it in subtree controller?');
    }

    return dep as T;
  }

  final Map<Type, Object> _dependencies = {};
  final String _dependencyClass;
}
