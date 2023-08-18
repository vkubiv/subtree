import 'package:example/domain_layer/note_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:subtree/subtree.dart';

import 'model.dart';

class EditNoteRouting {
  final void Function() goBack;

  EditNoteRouting({required this.goBack});
}

class EditNoteController extends SubtreeController implements EditNoteActions {
  @visibleForTesting
  final state = EditNoteState();

  @protected
  final String? noteId;

  @protected
  final EditNoteRouting routing;
  @protected
  final NoteService noteService;
  @protected
  final ControllerNotifier produceNoteChange;

  EditNoteController(
      {required this.noteId, required this.noteService, required this.routing, required this.produceNoteChange}) {
    subtreeModel.putState(state);
    subtreeModel.putActions<EditNoteActions>(this);

    init();
  }

  void init() async {
    if (noteId != null) {
      final note = await noteService.getNote(noteId!);
      state.titleText.text = note.title;
      state.contentText.text = note.content;
    }

    state.loaded.value = true;
  }

  @override
  Future<void> save() async {
    final noteId = this.noteId;
    if (noteId != null) {
      final note = Note(id: noteId, title: state.titleText.text, content: state.contentText.text);
      await noteService.updateNote(note);
    } else {
      await noteService.addNote(title: state.titleText.text, content: state.contentText.text);
    }
    produceNoteChange.notify();
    routing.goBack();
  }

  @override
  void dispose() {
    super.dispose();
    state.titleText.dispose();
    state.contentText.dispose();
  }
}
