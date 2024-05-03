import 'package:example/screens/home/home_screen.dart';
import 'package:example/screens/home/model.dart';
import 'package:flutter/material.dart';
import 'package:subtree/subtree.dart';

void main() async {
  final subtreeModel = SubtreeModelContainer();
  final stubState = HomeState();
  stubState.noteItems.value = [NoteItem(id: "1", title: "title")];
  final actions = _HomeStubActions();
  subtreeModel.put(stubState);
  subtreeModel.put<HomeActions>(actions);

  runApp(StubRootWidget(
    testingWidget: SubtreeModelProvider(subtreeModel, child: const HomeScreen()),
  ));
}

class StubRootWidget extends StatelessWidget {
  final Widget testingWidget;

  const StubRootWidget({super.key, required this.testingWidget});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stub',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: testingWidget,
    );
  }
}

class _HomeStubActions implements HomeActions {
  @override
  void goToAddNote() {}

  @override
  void goToNote(String noteId) {}
}
