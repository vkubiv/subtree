import 'package:flutter/material.dart';
import 'package:subtree/subtree.dart';
import 'package:subtree/state.dart';

import 'model.dart';

class EditNotePage extends StatelessWidget {
  const EditNotePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.get<EditNoteState>();
    final actions = context.get<EditNoteActions>();

    return Scaffold(
        appBar: AppBar(title: const Text('Home')),
        body: Obx((ref) {
          if (!ref.watch(state.loaded)) {
            return const CircularProgressIndicator();
          }
          return Column(
            children: [
              TextField(controller: state.titleText, decoration: const InputDecoration(labelText: "Title")),
              TextField(
                controller: state.contentText,
                decoration: const InputDecoration(labelText: "Note:"),
                minLines: 5,
                maxLines: 10,
              ),
              MaterialButton(
                onPressed: ref.disableUntilCompleted(actions.save),
                child: const Text('Save'),
              )
            ],
          );
        }));
  }
}
