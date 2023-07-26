import 'package:example/domain_layer/note_service.dart';
import 'package:example/screens/edit_note/edit_note_controller.dart';
import 'package:example/screens/home/home_controller.dart';
import 'package:example/screens/home/home_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:subtree/subtree.dart';

import 'screens/edit_note/edit_note_screen.dart';
import 'screens/edit_note/model.dart';

Function() _goBackRoute(BuildContext context) {
  return () => context.pop();
}

class _NoteRoute {
  static const path = 'note/:id';

  static EditNoteParams parseParams(Map<String, String> params) {
    final rawId = params['id'];

    if (rawId == null || rawId == "null") {
      return EditNoteParams(noteId: null);
    }

    return EditNoteParams(noteId: rawId);
  }

  static Function(String id) goToEdit(BuildContext context) {
    return (String id) => context.go('/note/$id');
  }

  static Function() goToAdd(BuildContext context) {
    return () => context.go('/note/null');
  }
}

class AppRoot {
  late final NoteService noteService;

  Future<void> setupServices() async {
    noteService = NoteService();
  }

  RouterConfig<Object> linkScreens() {
    final noteChangeDependency = EventNotifier();

    return GoRouter(
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) {
            final routing =
                HomeRouting(goToNoteAdd: _NoteRoute.goToAdd(context), goToNoteEdit: _NoteRoute.goToEdit(context));
            return ControlledSubtree(
              subtree: const HomeScreen(),
              controller: () => HomeController(
                  routing: routing, noteService: noteService, refreshOnNotesChange: noteChangeDependency),
            );
          },
          routes: <RouteBase>[
            GoRoute(
              path: _NoteRoute.path,
              builder: (BuildContext context, GoRouterState state) {
                final routing = EditNoteRouting(goBack: _goBackRoute(context));
                final noteId = _NoteRoute.parseParams(state.params).noteId;

                return ControlledSubtree(
                    subtree: const EditNotePage(),
                    controller: () => EditNoteController(
                        noteId: noteId,
                        routing: routing,
                        noteService: noteService,
                        produceNoteChange: noteChangeDependency),
                    deps: [noteId]);
              },
            ),
          ],
        ),
      ],
    );
  }
}
