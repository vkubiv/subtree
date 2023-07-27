import 'package:flutter/cupertino.dart';
import 'package:subtree/state.dart';

class EditNoteParams {
  final String? noteId;

  EditNoteParams({required this.noteId});
}

class EditNoteState {
  final titleText = TextEditingController();
  final contentText = TextEditingController();
  final loaded = Rx<bool>(false);
}

abstract class EditNoteActions {
  Future<void> save();
}
