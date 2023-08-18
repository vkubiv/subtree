import 'package:example/domain_layer/note_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    "add then get",
    () async {
      final noteService = NoteService();
      final added = await noteService.addNote(title: "title", content: "content");
      expect(added.title, "title");
      expect(added.content, "content");

      final got = await noteService.getNote(added.id);

      expect(got.title, "title");
      expect(got.content, "content");
    },
  );

  test(
    "add then get all",
    () async {
      final noteService = NoteService();
      final added = await noteService.addNote(title: "title", content: "content");
      expect(added.title, "title");
      expect(added.content, "content");

      final got = await noteService.getAll();

      expect(got, hasLength(1));
      expect(got.first.title, "title");
      expect(got.first.content, "content");
    },
  );

  test(
    "get by invalid id",
    () async {
      final noteService = NoteService();

      try {
        await noteService.getNote("invalid");
        fail("exception not thrown");
        // ignore: empty_catches
      } on StateError catch (e) {}
    },
  );

  test(
    "add then update",
    () async {
      final noteService = NoteService();
      final added = await noteService.addNote(title: "title", content: "content");
      expect(added.title, "title");
      expect(added.content, "content");

      await noteService.updateNote(Note(id: added.id, title: "new_title", content: "new_content"));

      final got = await noteService.getNote(added.id);

      expect(got.title, "new_title");
      expect(got.content, "new_content");
    },
  );

  test(
    "update with invalid id",
    () async {
      final noteService = NoteService();

      try {
        await noteService.updateNote(Note(id: "invalid", title: "new_title", content: "new_content"));
        fail("exception not thrown");
        // ignore: empty_catches
      } on StateError catch (e) {}
    },
  );

  test(
    "add then delete",
    () async {
      final noteService = NoteService();
      final added = await noteService.addNote(title: "title", content: "content");
      expect(added.title, "title");
      expect(added.content, "content");

      await noteService.updateNote(Note(id: added.id, title: "new_title", content: "new_content"));

      await noteService.deleteNote(added.id);

      final got = await noteService.getAll();
      expect(got, hasLength(0));
    },
  );

  test(
    "delete with invalid id",
    () async {
      final noteService = NoteService();

      try {
        await noteService.deleteNote("invalid");
        fail("exception not thrown");
        // ignore: empty_catches
      } on StateError catch (e) {}
    },
  );
}
