import 'package:flutter/material.dart';
import 'model.dart';
import 'package:subtree/subtree.dart';
import 'package:subtree/state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.subtreeGet<HomeState>();
    final actions = context.subtreeGet<HomeActions>();

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Obx((ref) => ListView(
              children: [
                for (final item in ref.watch(state.noteItems))
                  ListTile(
                    title: Text(item.title),
                    onTap: () => actions.goToNote(item.id),
                  )
              ],
            )),
      ),
      floatingActionButton: FloatingActionButton(onPressed: actions.goToAddNote, child: const Icon(Icons.add)),
    );
  }
}
