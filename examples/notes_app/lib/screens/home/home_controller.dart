import 'package:example/domain_layer/note_service.dart';
import 'package:flutter/foundation.dart';
import 'package:subtree/subtree.dart';

import 'model.dart';

class HomeRouting {
  final Function(String id) goToNoteEdit;
  final Function() goToNoteAdd;

  HomeRouting({required this.goToNoteEdit, required this.goToNoteAdd});
}

class HomeController extends SubtreeController implements HomeActions {
  @visibleForTesting
  final HomeState state = HomeState();

  @protected
  final HomeRouting routing;

  HomeController({required this.routing, required this.noteService, required this.refreshOnNotesChange}) {
    subtreeModel.putState(state);
    subtreeModel.putActions<HomeActions>(this);
    _init();
  }

  void _init() async {
    state.isLoadingData.value = true;
    await noteService.loadNotes();

    sync(() async {
      state.noteItems.value = noteService.getStoredNotes().map((n) => NoteItem(id: n.id, title: n.title)).toList();
    }, [refreshOnNotesChange]);

    state.isLoadingData.value = false;
  }

  // Actions
  @override
  void goToNote(String noteId) {
    routing.goToNoteEdit(noteId);
  }

  @override
  void goToAddNote() {
    routing.goToNoteAdd();
  }

  @protected
  final NoteService noteService;
  @protected
  final Listenable refreshOnNotesChange;
}
