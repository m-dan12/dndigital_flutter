import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/note.dart';
import '../../domain/usecases/get_note_usecase.dart';
import '../../domain/usecases/save_note_usecase.dart';

class NoteEditorViewModel extends ChangeNotifier {
  final SaveNoteUseCase _saveNoteUseCase;
  final GetNoteUseCase _getNoteUseCase;

  late Note _currentNote;
  bool _isSaving = false;
  String? _errorMessage;
  Timer? _debounceTimer;

  // Callback для обновления списка заметок при сохранении
  Function(Note)? _onNoteSaved;

  NoteEditorViewModel({
    required SaveNoteUseCase saveNoteUseCase,
    required GetNoteUseCase getNoteUseCase,
  }) : _saveNoteUseCase = saveNoteUseCase,
       _getNoteUseCase = getNoteUseCase {
    _initializeNewNote();
  }

  // Getters
  Note get currentNote => _currentNote;
  bool get isSaving => _isSaving;
  String? get errorMessage => _errorMessage;

  /// Установить callback для обновления списка заметок
  void setOnNoteSavedCallback(Function(Note) callback) {
    _onNoteSaved = callback;
  }

  void _initializeNewNote() {
    _currentNote = Note(
      id: const Uuid().v4(),
      title: '',
      description: '',
      content: '[]',
      tags: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Загрузить существующую заметку.
  /// Если были несохранённые изменения — сохраняет их немедленно,
  /// прежде чем заменить _currentNote данными новой заметки.
  Future<void> loadNote(String noteId) async {
    // Проверяем наличие несохранённых изменений ДО отмены таймера
    final hasPendingChanges = _debounceTimer?.isActive ?? false;
    _debounceTimer?.cancel();

    if (hasPendingChanges) {
      // Сохраняем текущую заметку синхронно — после этого _currentNote
      // будет перезаписан данными новой заметки, и момент будет упущен.
      await _performSave();
    }

    try {
      _errorMessage = null;
      final note = await _getNoteUseCase(noteId);
      if (note != null) {
        _currentNote = note;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Ошибка загрузки заметки: $e';
      notifyListeners();
    }
  }

  /// Обновить заголовок
  void updateTitle(String title) {
    _currentNote = _currentNote.copyWith(title: title);
    notifyListeners();
    _scheduleAutoSave();
  }

  /// Обновить описание
  void updateDescription(String description) {
    _currentNote = _currentNote.copyWith(description: description);
    notifyListeners();
    _scheduleAutoSave();
  }

  /// Обновить контент (QuillDelta JSON).
  /// notifyListeners() намеренно не вызывается — контент хранится в QuillController
  /// на стороне View, а лишние перерисовки на каждое нажатие клавиши не нужны.
  void updateContent(String content) {
    _currentNote = _currentNote.copyWith(content: content);
    _scheduleAutoSave();
  }

  /// Обновить теги
  void updateTags(List<String> tags) {
    _currentNote = _currentNote.copyWith(tags: tags);
    notifyListeners();
    _scheduleAutoSave();
  }

  /// Запускает (или сбрасывает) таймер автосохранения.
  /// Сохранение произойдёт ровно через 2 секунды ПОСЛЕ последнего изменения.
  /// Индикатор "Сохранение..." появляется только в момент реальной записи.
  void _scheduleAutoSave() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(seconds: 2), _performSave);
  }

  /// Фактическое сохранение заметки на диск.
  Future<void> _performSave() async {
    if (_isSaving) return;

    _isSaving = true;
    notifyListeners(); // показываем индикатор только здесь

    try {
      await _saveNoteUseCase(_currentNote);
      _onNoteSaved?.call(_currentNote);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Ошибка сохранения: $e';
      debugPrint('Save error: $e');
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  /// Явное немедленное сохранение (отменяет отложенное).
  Future<void> saveNow() async {
    _debounceTimer?.cancel();
    await _performSave();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
