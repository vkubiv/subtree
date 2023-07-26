bool isListsEquals<E>(List<E>? list1, List<E>? list2) {
  if (identical(list1, list2)) return true;
  if (list1 == null || list2 == null) return false;
  var length = list1.length;
  if (length != list2.length) return false;
  for (var i = 0; i < length; i++) {
    if (list1[i] != list2[i]) return false;
  }
  return true;
}

bool isIterableEquals<E>(Iterable<E>? elements1, Iterable<E>? elements2) {
  if (identical(elements1, elements2)) return true;
  if (elements1 == null || elements2 == null) return false;
  var it1 = elements1.iterator;
  var it2 = elements2.iterator;
  while (true) {
    var hasNext = it1.moveNext();
    if (hasNext != it2.moveNext()) return false;
    if (!hasNext) return true;
    if (it1.current != it2.current) return false;
  }
}
