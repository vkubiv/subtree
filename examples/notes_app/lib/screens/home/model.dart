import 'package:subtree/state.dart';

class NoteItem {
  final String id;
  final String title;

  NoteItem({required this.id, required this.title});
}

class HomeState {
  final noteItems = RxList<NoteItem>([]);
  final isLoadingData = Rx(true);
}

abstract class HomeActions {
  void goToNote(String noteId);
  void goToAddNote();
}
