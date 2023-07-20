import 'package:flutter/foundation.dart';

abstract class RxListenable<T> extends Listenable {
  T get current;
}

abstract class ReactiveBlockRef {
  T watch<T>(RxListenable<T> observable);
}