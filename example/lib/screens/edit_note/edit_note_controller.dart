import 'package:example/domain_layer/note_service.dart';
import 'package:subtree/subtree.dart';

import 'model.dart';

class EditNoteRouting {
  final void Function() goBack;

  EditNoteRouting({required this.goBack});
}

class EditNoteController extends SubtreeController<EditNoteParams> implements EditNoteActions {
  final state = EditNoteState();
  final EditNoteRouting routing;
  final NoteService noteService;
  final EventNotifier produceNoteChange;

  EditNoteController({required this.noteService, required this.routing, required this.produceNoteChange}) {
    subtreeModel.putState(state);
    subtreeModel.putActions<EditNoteActions>(this);
  }

  @override
  void onInit() async {
    final noteId = arguments.noteId;

    if (noteId != null) {
      await noteService.getNote(noteId!);
    }

    state.loaded.value = true;
  }

  @override
  Future<void> save() async {
    final noteId = arguments.noteId;
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
    state.titleText.dispose();
    state.contentText.dispose();
  }
}
