import 'package:flutter/foundation.dart';
import '../../domain/entities/note.dart';

import '../../data/services/hive_initializer.dart';

class NotesListViewModel extends ChangeNotifier {
  List<Note> _allNotes = [];
  String _selectedNoteId = '';
  bool _isLoading = false;

  NotesListViewModel();

  // Getters
  List<Note> get allNotes => _allNotes;
  String get selectedNoteId => _selectedNoteId;
  bool get isLoading => _isLoading;

  /// Загрузить все заметки
  Future<void> loadAllNotes() async {
    try {
      _isLoading = true;
      notifyListeners();

      final repository = HiveInitializer.repository;
      _allNotes = await repository.getAllNotes();

      notifyListeners();
    } catch (e) {
      print('Ошибка загрузки заметок: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Выбрать заметку
  void selectNote(String noteId) {
    _selectedNoteId = noteId;
    notifyListeners();
  }

  /// Создать новую заметку
  Future<String> createNote(String title) async {
    try {
      final repository = HiveInitializer.repository;

      final note = Note(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title.isEmpty ? 'Без названия' : title,
        description: '',
        content: '[]',
        tags: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await repository.saveNote(note);
      _allNotes.add(note);
      _selectedNoteId = note.id;
      notifyListeners();

      return note.id;
    } catch (e) {
      print('Ошибка создания заметки: $e');
      return '';
    }
  }

  /// Удалить заметку
  Future<void> deleteNote(String noteId) async {
    try {
      final repository = HiveInitializer.repository;
      await repository.deleteNote(noteId);

      _allNotes.removeWhere((note) => note.id == noteId);
      if (_selectedNoteId == noteId) {
        _selectedNoteId = '';
      }
      notifyListeners();
    } catch (e) {
      print('Ошибка удаления заметки: $e');
    }
  }

  /// Обновить список после сохранения
  void refreshNotes(Note updatedNote) {
    final index = _allNotes.indexWhere((note) => note.id == updatedNote.id);
    if (index != -1) {
      _allNotes[index] = updatedNote;
    } else {
      _allNotes.add(updatedNote);
    }
    notifyListeners();
  }
}
