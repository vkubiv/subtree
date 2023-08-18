import 'package:uuid/uuid.dart';

class Note {
  final String id;
  final String title;
  final String content;

  Note({required this.id, required this.title, required this.content});
}

class NoteService {
  Future<Note> getNote(String id) async {
    // simulating network call
    await Future.delayed(const Duration(milliseconds: 10));

    final index = _notes.indexWhere((n) => n.id == id);
    if (index == -1) {
      throw StateError('Invalid note id "$id"');
    }

    return _notes[index];
  }

  Future<void> updateNote(Note updated) async {
    // simulating network call
    await Future.delayed(const Duration(milliseconds: 1000));

    final index = _notes.indexWhere((n) => n.id == updated.id);
    if (index == -1) {
      throw StateError('Invalid note id "${updated.id}"');
    }

    _notes[index] = updated;
  }

  Future<void> deleteNote(String id) async {
    // simulating network call
    await Future.delayed(const Duration(milliseconds: 10));

    // checking if note exists
    await getNote(id);

    _notes.removeWhere((n) => n.id == id);
  }

  Future<Note> addNote({required String title, required String content}) async {
    // simulating network call
    await Future.delayed(const Duration(milliseconds: 1000));
    _notes.add(Note(id: const Uuid().v4(), title: title, content: content));
    return _notes.last;
  }

  Future<void> loadNotes() async {
    // simulating network call
    await Future.delayed(const Duration(milliseconds: 1000));
  }

  List<Note> getStoredNotes() {
    return _notes;
  }

  final _notes = <Note>[];
}
