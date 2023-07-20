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
    return _notes.where((note) => note.id == id).single;
  }

  Future<void> updateNote(Note updated) async {
    // simulating network call
    await Future.delayed(const Duration(milliseconds: 10));

    final index = _notes.indexWhere((n) => n.id == updated.id);

    _notes[index] = updated;
  }

  Future<void> deleteNote(String id) async {
    // simulating network call
    await Future.delayed(const Duration(milliseconds: 10));

    _notes.removeWhere((n) => n.id == id);
  }

  Future<void> addNote({required String title, required String content}) async {
    // simulating network call
    await Future.delayed(const Duration(milliseconds: 1000));
    _notes.add(Note(id: const Uuid().v4(), title: title, content: content));
  }

  Future<List<Note>> getAll() async {
    // simulating network call
    await Future.delayed(const Duration(milliseconds: 10));
    return _notes;
  }

  final _notes = <Note>[];
}
