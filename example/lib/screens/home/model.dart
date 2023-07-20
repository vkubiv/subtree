import 'package:subtree/state.dart';

class NoteItem {
  final String id;
  final String title;

  NoteItem({required this.id, required this.title});
}

class HomeState {
  final noteItems = Rx<List<NoteItem>>([]);
}

abstract class HomeActions {
  void goToNote(String noteId);
  void goToAddNote();
}