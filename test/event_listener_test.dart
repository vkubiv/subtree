import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:subtree/state.dart';

void main() {
  testWidgets('EventListener', (WidgetTester tester) async {
    final rxEvent = RxEvent<int>();

    int? eventResult;
    int calledTimes = 0;

    await tester.pumpWidget(MaterialApp(
        home: EventListener(
            event: rxEvent,
            listener: (context, int value) {
              eventResult = value;
              calledTimes++;
            },
            child: const Placeholder())));

    expect(eventResult, null);
    expect(calledTimes, 0);

    rxEvent.emit(1);
    await tester.pump();

    expect(eventResult, 1);
    expect(calledTimes, 1);

    rxEvent.emit(1);
    await tester.pump();

    expect(eventResult, 1);
    expect(calledTimes, 2);
  });

  testWidgets('On tree event source change', (WidgetTester tester) async {
    final eventSwitcher = ValueNotifier<int>(0);

    final rxEvents = [RxEvent<int>(), RxEvent<int>()];

    int? eventResult;
    int calledTimes = 0;

    await tester.pumpWidget(MaterialApp(
        home: ValueListenableBuilder<int>(
            valueListenable: eventSwitcher,
            builder: (context, ind, child) => EventListener(
                event: rxEvents[ind],
                listener: (context, int value) {
                  eventResult = value;
                  calledTimes++;
                },
                child: const Placeholder()))));

    expect(eventResult, null);
    expect(calledTimes, 0);

    rxEvents[0].emit(1);
    rxEvents[1].emit(2);
    await tester.pump();

    expect(eventResult, 1);
    expect(calledTimes, 1);

    eventSwitcher.value = 1;
    await tester.pump();

    rxEvents[1].emit(4);
    rxEvents[0].emit(5);
    await tester.pump();

    expect(eventResult, 4);
    expect(calledTimes, 2);
  });
}
