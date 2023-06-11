import 'package:flutter/cupertino.dart';

import '../../data_store/database.dart';
import '../../domain/entities/note.dart';

/// Class for the state of Notes Page
class NotesState extends ChangeNotifier {
  /// Constructor
  NotesState() {
    _init();
  }

  /// -------------------------- VARIABLES -------------------------------------
// ---------------------------------------------------------------------------

  final _database = DatabaseHelper();

  bool _isLoading = false;

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  final _notesList = <Note>[];

  final _formKey = GlobalKey<FormState>();

  /// --------------------------- GETTERS --------------------------------------
// ---------------------------------------------------------------------------

  /// Getter for the controller of the title of the note
  TextEditingController get titleController => _titleController;

  /// Getter for the controller of the description of the note
  TextEditingController get descriptionController => _descriptionController;

  /// Getter for the list of notes
  List<Note> get notesList => _notesList;

  /// Getter for is loading to check if the screen needs to show a loading
  bool get isLoading => _isLoading;

  /// Getter for the form key of the notes form
  GlobalKey<FormState> get formKey => _formKey;

  /// --------------------------- SETTERS --------------------------------------
// ---------------------------------------------------------------------------

  /// -------------------------- FUNCTIONS -------------------------------------
// ---------------------------------------------------------------------------

  void _init() async {
    await updateList();
  }

  Future<void> insert() async {
    await _database.insert(
      _titleController.text,
      _descriptionController.text,
    );

    _titleController.clear();
    _descriptionController.clear();

    await updateList();
  }

  Future<void> update(int id) async {
    await _database.update(
      id,
      _titleController.text,
      _descriptionController.text,
    );

    await updateList();
  }

  Future<void> delete(int id) async {
    await _database.delete(id);

    await updateList();
  }

  Future<void> updateList() async {
    _isLoading = true;

    notifyListeners();
    _notesList.clear();

    final response = await _database.requestNotes();

    for (final item in response ?? []) {
      _notesList.add(
        Note(
          id: item['id'] ?? 0,
          title: item['title'] ?? 0,
          description: item['description'],
          createdAt: DateTime.parse(
            item['created_at'] ?? '',
          ),
        ),
      );
    }

    await Future.delayed(const Duration(milliseconds: 300));

    _isLoading = false;
    notifyListeners();
  }

  void clearFields() {
    _titleController.clear();
    _descriptionController.clear();
  }

}
