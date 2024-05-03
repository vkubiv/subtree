import 'package:flutter/material.dart';
import 'package:subtree/state.dart';
import 'package:subtree/subtree.dart';

// It is common practice to use a "counter" example to demonstrate state management usage.
// But it is too far from the real use case. Let's a little bit complicate it and assume
// the counter state is located on the backend.

abstract class CounterAPI {
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

  CounterController({required this.counterAPI}) {
    subtreeModel.put(state);
    subtreeModel.put<CounterActions>(this);
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
    state.blocked.value = true;

    final newCounterValue = await counterAPI.decCounterValue();
    state.counter.value = newCounterValue;

    state.blocked.value = false;
  }

  @protected
  final CounterAPI counterAPI;
}

// counter_screen.dart
class CounterScreen extends StatelessWidget {
  const CounterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.subtreeGet<CounterState>();
    final actions = context.subtreeGet<CounterActions>();

    return Scaffold(
        appBar: AppBar(title: const Text('Counter')),
        body: Obx((ref) {
          if (!ref.watch(state.loaded)) {
            return const Center(child: CircularProgressIndicator());
          }
          return Stack(children: [
            Center(
              child: Column(children: [
                Text('Counter: ${ref.watch(state.counter)}'),
                MaterialButton(
                  onPressed: actions.incCounter,
                  child: const Text('+'),
                ),
                MaterialButton(
                  onPressed: actions.decCounter,
                  child: const Text('-'),
                )
              ]),
            ),
            if (ref.watch(state.blocked))
              ...[const Opacity(
                opacity: 0.2,
                child: ModalBarrier(dismissible: false, color: Colors.black),
              ),
              const Center(child: CircularProgressIndicator())
              ]
          ]);
        }));
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ControlledSubtree(
          subtree: const CounterScreen(), controller: (_) => CounterController(counterAPI: CounterAPIMock())),
    );
  }
}

class CounterAPIMock implements CounterAPI {
  int _counter = 0;

  @override
  Future<int> decCounterValue() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    _counter--;
    return _counter;
  }

  @override
  Future<int> incCounterValue() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    _counter++;
    return _counter;
  }

  @override
  Future<int> getCounterValue() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    return _counter;
  }
}
