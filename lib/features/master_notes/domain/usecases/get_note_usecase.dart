import '../../domain/entities/note.dart';
import '../../domain/repositories/note_repository.dart';

class GetNoteUseCase {
  final NoteRepository repository;

  GetNoteUseCase(this.repository);

  Future<Note?> call(String id) async {
    return repository.getNote(id);
  }
}
