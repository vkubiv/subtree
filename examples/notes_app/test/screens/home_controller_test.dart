import 'dart:async';

import 'package:example/domain_layer/note_service.dart';
import 'package:example/screens/home/home_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:subtree/subtree.dart';

class GoToNoteEdit extends Mock {
  void call(String id);
}

class GoToNoteAdd extends Mock {
  void call();
}

class NoteServiceMock extends Mock implements NoteService {}

void main() {
  late GoToNoteEdit goToNoteEdit;
  late GoToNoteAdd goToNoteAdd;
  late NoteServiceMock noteService;

  late ControllerNotifier noteChangeDependency;

  setUp(() {
    goToNoteEdit = GoToNoteEdit();
    goToNoteAdd = GoToNoteAdd();

    noteService = NoteServiceMock();

    noteChangeDependency = ControllerNotifier();
  });

  test('initialized successfully', () async {
    when(() => noteService.getAll()).thenAnswer((_) async {
      return [Note(id: "id", title: "title", content: "content")];
    });

    final controller = HomeController(
        routing: HomeRouting(goToNoteEdit: goToNoteEdit, goToNoteAdd: goToNoteAdd),
        noteService: noteService,
        refreshOnNotesChange: noteChangeDependency);

    expect(controller.state.noteItems.value, hasLength(0));
    await Future(() {});

    expect(controller.state.noteItems.value, hasLength(1));
  });

  test('list changed', () async {
    when(() => noteService.getAll()).thenAnswer((_) async {
      return [Note(id: "id", title: "title", content: "content")];
    });

    final controller = HomeController(
        routing: HomeRouting(goToNoteEdit: goToNoteEdit, goToNoteAdd: goToNoteAdd),
        noteService: noteService,
        refreshOnNotesChange: noteChangeDependency);

    expect(controller.state.noteItems.value, hasLength(0));
    await Future(() {});

    final notes = controller.state.noteItems;
    expect(notes.value, hasLength(1));
    expect(notes.value.first.title, "title");

    when(() => noteService.getAll()).thenAnswer((_) async {
      return [Note(id: "id", title: "title1", content: "content1")];
    });

    noteChangeDependency.notify();
    await Future(() {});

    expect(notes.value, hasLength(1));
    expect(notes.value.first.title, "title1");
  });

  test('goToAddNote called', () async {
    when(() => noteService.getAll()).thenAnswer((_) async {
      return [Note(id: "id", title: "title", content: "content")];
    });

    final controller = HomeController(
        routing: HomeRouting(goToNoteEdit: goToNoteEdit, goToNoteAdd: goToNoteAdd),
        noteService: noteService,
        refreshOnNotesChange: noteChangeDependency);

    controller.goToAddNote();
    verify(() => goToNoteAdd()).called(1);
  });

  test('goToNoteEdit called', () async {
    when(() => noteService.getAll()).thenAnswer((_) async {
      return [Note(id: "id", title: "title", content: "content")];
    });

    final controller = HomeController(
        routing: HomeRouting(goToNoteEdit: goToNoteEdit, goToNoteAdd: goToNoteAdd),
        noteService: noteService,
        refreshOnNotesChange: noteChangeDependency);

    controller.goToNote("id");
    verify(() => goToNoteEdit("id")).called(1);
  });
}
