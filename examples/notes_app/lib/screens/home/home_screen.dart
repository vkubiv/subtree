import 'package:flutter/material.dart';
import 'model.dart';
import 'package:subtree/subtree.dart';
import 'package:subtree/state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.getState<HomeState>();
    final actions = context.getActions<HomeActions>();

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Obx((ref) {

          if (ref.watch(state.isLoadingData)) {
            return const CircularProgressIndicator();
          }

          final notes = ref.watch(state.noteItems);
          if (notes.isEmpty) {
            return const Center(child: Text('The notes list is empty.'));
          }

          return ListView(
            children: [
              for (final item in notes)
                ListTile(
                  title: Text(item.title),
                  onTap: () => actions.goToNote(item.id),
                )
            ],
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(onPressed: actions.goToAddNote, child: const Icon(Icons.add)),
    );
  }
}
