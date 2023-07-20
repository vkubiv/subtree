import 'package:example/domain_layer/note_service.dart';
import 'package:flutter/foundation.dart';
import 'package:subtree/subtree.dart';

import 'model.dart';

class HomeRouting {
  final Function(String id) goToNoteEdit;
  final Function() goToNoteAdd;

  HomeRouting({required this.goToNoteEdit, required this.goToNoteAdd});
}

class HomeController extends SubtreeController<void> implements HomeActions {
  final HomeState state = HomeState();

  final NoteService noteService;
  final HomeRouting routing;
  final Listenable dependsOnNotesChange;


  HomeController(
      {required this.routing, required this.noteService, required this.dependsOnNotesChange}) {
    subtreeModel.putState(state);
    subtreeModel.putActions<HomeActions>(this);
  }

  @override
  void onInit() {
    syncController(() async {
      state.noteItems.value = (await noteService.getAll()).map((n) => NoteItem(id: n.id, title: n.title)).toList();
    }, [dependsOnNotesChange]);
  }

  @override
  void goToNote(String noteId) {
    routing.goToNoteEdit(noteId);
  }

  @override
  void goToAddNote() {
    routing.goToNoteAdd();
  }

  @override
  void dispose() {}


}
