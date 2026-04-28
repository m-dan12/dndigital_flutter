/// Примеры использования функции сохранения заметок

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dndigital/features/master_notes/presentation/view/note_editor_view.dart';
import 'package:dndigital/features/master_notes/presentation/viewmodel/note_editor_viewmodel.dart';
import 'package:dndigital/features/master_notes/domain/repositories/note_repository.dart';

// ============================================================================
// Пример 1: Создание новой заметки
// ============================================================================

void navigateToNewNote(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const NoteEditor()),
  );
}

// ============================================================================
// Пример 2: Открытие существующей заметки
// ============================================================================

void navigateToExistingNote(BuildContext context, String noteId) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => NoteEditor(noteId: noteId)),
  );
}

// ============================================================================
// Пример 3: Получение текущей заметки из ViewModel
// ============================================================================

void showCurrentNoteInfo(BuildContext context) {
  final viewModel = context.read<NoteEditorViewModel>();

  final note = viewModel.currentNote;
  print('ID: ${note.id}');
  print('Title: ${note.title}');
  print('Content: ${note.content}');
  print('Tags: ${note.tags}');
}

// ============================================================================
// Пример 4: Явное сохранение
// ============================================================================

void saveNoteManually(BuildContext context) async {
  final viewModel = context.read<NoteEditorViewModel>();

  try {
    await viewModel.saveNow();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Заметка сохранена!')));
  } catch (e) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Ошибка: $e')));
  }
}

// ============================================================================
// Пример 5: Загрузка заметки по ID
// ============================================================================

void loadSpecificNote(BuildContext context, String noteId) async {
  final viewModel = context.read<NoteEditorViewModel>();

  try {
    await viewModel.loadNote(noteId);
    print('Заметка загружена успешно');
  } catch (e) {
    print('Ошибка загрузки: $e');
  }
}

// ============================================================================
// Пример 6: Слушание изменений в ViewModel
// ============================================================================

class NoteStatusListener extends StatelessWidget {
  const NoteStatusListener({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteEditorViewModel>(
      builder: (context, viewModel, _) {
        return Column(
          children: [
            if (viewModel.isSaving) const LinearProgressIndicator(),
            if (viewModel.errorMessage != null)
              Container(
                color: Colors.red[100],
                padding: const EdgeInsets.all(16),
                child: Text(
                  viewModel.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            Text('ID: ${viewModel.currentNote.id}'),
            Text('Название: ${viewModel.currentNote.title}'),
            Text('Обновлено: ${viewModel.currentNote.updatedAt}'),
          ],
        );
      },
    );
  }
}

// ============================================================================
// Пример 7: Использование в приватном чате
// ============================================================================

class NoteEditorWithBottomButtons extends StatelessWidget {
  final String? noteId;

  const NoteEditorWithBottomButtons({Key? key, this.noteId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NoteEditor(noteId: noteId),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Закрыть'),
            ),
            ElevatedButton(
              onPressed: () {
                final viewModel = context.read<NoteEditorViewModel>();
                viewModel.saveNow();
              },
              child: const Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// Пример 8: Получение списка всех заметок
// ============================================================================

void getAllNotes(NoteRepository repository) async {
  try {
    final notes = await repository.getAllNotes();
    for (final note in notes) {
      print('Note: ${note.title} (ID: ${note.id})');
    }
  } catch (e) {
    print('Ошибка получения списка: $e');
  }
}
