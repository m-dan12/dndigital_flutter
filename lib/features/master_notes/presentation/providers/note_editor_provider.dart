import 'package:provider/provider.dart';
import '../../data/services/hive_initializer.dart';
import '../../domain/usecases/get_note_usecase.dart';
import '../../domain/usecases/save_note_usecase.dart';
import '../viewmodel/note_editor_viewmodel.dart';
import '../viewmodel/notes_list_viewmodel.dart';

class NoteEditorProvider {
  static ChangeNotifierProvider<NoteEditorViewModel> create() {
    return ChangeNotifierProvider(
      create: (context) {
        final repository = HiveInitializer.repository;
        final saveNoteUseCase = SaveNoteUseCase(repository);
        final getNoteUseCase = GetNoteUseCase(repository);

        return NoteEditorViewModel(
          saveNoteUseCase: saveNoteUseCase,
          getNoteUseCase: getNoteUseCase,
        );
      },
    );
  }

  static ChangeNotifierProvider<NotesListViewModel> createListViewModel() {
    return ChangeNotifierProvider(create: (context) => NotesListViewModel());
  }
}
