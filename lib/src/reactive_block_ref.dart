import 'package:flutter/foundation.dart';

abstract class ReactiveBlockRef {
  T watch<T>(ValueListenable<T> observable);
}