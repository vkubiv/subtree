<a href="https://github.com/vkubiv/subtree/actions"><img src="https://github.com/vkubiv/subtree/workflows/Build/badge.svg" alt="Build Status"></a>
[![codecov](https://codecov.io/gh/vkubiv/subtree/branch/main/graph/badge.svg)](https://codecov.io/gh/vkubiv/subtree)


Subtree is a state manager for those who like BLoC but don't like BLoC verbosity.

### BLoC difference

* Subtree separates state injection from state observing mechanism.
* Providing a compact mechanism for observing state instead of verbose Builder concept.
* Events (Actions) are not separate objects, just regular function calls, which hugely reduce boilerplate.

```dart
class ExamplePageState {
  final title = ValueNotifier("...");
}

abstract class ExamplePageActions {
  void buttonClicked();
}

// .....

void build(BuildContext context) {
  final state = context.getState<ExamplePageState>(); // getting subtree state
  final actions = context.getState<ExamplePageActions>();

  // watch on state.title change with ref.watch function.
  return Obx((ref) =>
      TextButton(
          onPressed: actions.buttonClicked, child: Text(
          ref.watch(state.title)
      )));
}
```

The state is a simple class, you can put any reactive primitives into it.
`Obx` and `ref.watch` is designed to reduce the verbosity of ValueListenableBuilder. You can watch any
primitive that implements the ValueListenable interface.

But if you need you can use other reactive primitives and builders for them, like StreamBuilder.

```dart
class ExamplePageState {
  final title = BehaviorSubject<String>();
}

void build(BuildContext context) {
  final state = context.getState<ExamplePageState>();

  return StreamBuilder<String>(
      stream: state.title,
      builder: (BuildContext context, AsyncSnapshot<String> titleSnapshot) {
        ...
      });
}

```

## A trivial example of a counter

It is common practice to use a "counter" example to demonstrate state management usage.  
But it is too far from the real use case. Let's a little bit complicate it and assume the counter state is located on the backend.

```dart
// CounterAPI doing http call to backend API.
class CounterAPI {
  Future<int> getCounterValue();

  Future<int> incCounterValue();

  Future<int> decCounterValue();
}


// counter_model.dart
class CounterState {
  final counter = Rx<int>(0);
  final loaded = Rx<bool>(false);
  final blocked = Rx<bool>(false);
}

abstract class CounterActions {
  void incCounter();

  void decCounter();
}

//counter_controller.dart

class CounterController extends SubtreeController implements CounterActions {
  final state = CounterState();

  @protected
  final CounterAPI counterAPI;

  CounterController({required this.counterAPI}) {
    subtreeModel.putState(state);
    subtreeModel.putActions<CounterActions>(this);
    loadData();
  }

  void loadData() async {
    final counter = await counterAPI.getCounterValue();
    state.counter.value = counter;
    state.loaded.value = true;
  }

  // Actions implementations
  @override
  void incCounter() async {
    state.blocked.value = true;

    final newCounterValue = await counterAPI.incCounterValue();
    state.counter.value = newCounterValue;

    state.blocked.value = false;
  }

  @override
  void decCounter() async {
    // implemented in the same way as incCounter.
  }
}

// counter_screen.dart
class CounterScreen extends StatelessWidget {
  const CounterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.getState<CounterState>();
    final actions = context.getActions<CounterActions>();

    return Scaffold(
        appBar: AppBar(title: const Text('Counter')),
        body: Obx((ref) {
          if (!ref.watch(state.loaded)) {
            return const CircularProgressIndicator();
          }
          return Stack(
            children: [
              Column(
                  children: [
                    Text(ref.watch(ref.counter.value).toString()),
                    MaterialButton(
                      onPressed: actions.incCounter,
                      child: const Text('+'),
                    ),
                    MaterialButton(
                      onPressed: actions.decCounter,
                      child: const Text('-'),
                    )
                  ]
              )
            ],
            if (ref.watch(state.blocked))
              BlockingOverlay()
          );
        }));
  }
}

```

Now we need to bind all things together. Usually, this is done on the router level.

```dart
ControlledSubtree(
  subtree: const CounterScreen(),
  controller: () => CounterController(counterAPI: services.counterAPI),
);
```

Because subtree widgets and the controller not depending directly on each other,
they can be independently tested. Also, you can have different widgets for different platforms, or special mock controllers with preset data for demo mode.

```dart
ControlledSubtree(
  subtree:  isDesktop ? const CounterScreenDesktop() : const CounterScreen(),
  controller: () => isDemo ? MockCounterController() : CounterController(counterAPI: services.counterAPI),
);
```
