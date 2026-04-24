import '../../domain/entities/note.dart';
import '../../domain/repositories/note_repository.dart';

class SaveNoteUseCase {
  final NoteRepository repository;

  SaveNoteUseCase(this.repository);

  Future<void> call(Note note) async {
    // Обновляем время последнего изменения
    final updatedNote = note.copyWith(updatedAt: DateTime.now());
    await repository.saveNote(updatedNote);
  }
}
