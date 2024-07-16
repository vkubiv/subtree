# 0.5.2
Ease type restriction on EventListener generic parameter T

# 0.5.1
Now sync function returns FutureOr<void> so a caller can await for an inner function to finish

### Example:
```dart
    await sync(() async {
      final someData = await api.loadData();
      ...
    }, []);
```

# 0.5.0

BREAKING CHANGE:
change `subtreeGet` to `get` and `subtreeModel` to `subtree`

# 0.4.0

Make RxList truly immutable

# 0.3.0

Combine all get put function into simple subtreeGet and put functions.

# 0.2.0

Change subtreeGet to more universal subtreeGet, now it should be used instead subtreeState and subtreeAction
Change putTransformer to more universal put now it should be used instead putState and putAction

# 0.1.0

Initial Version of the library.

