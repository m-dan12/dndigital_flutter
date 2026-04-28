import 'package:hive/hive.dart';
import '../../domain/entities/note.dart';
import '../../domain/repositories/note_repository.dart';
import '../mappers/note_mapper.dart';
import '../models/note_hive_model.dart';

class HiveNoteRepository implements NoteRepository {
  static const String _boxName = 'notes';
  late Box<NoteHiveModel> _box;

  Future<void> init() async {
    _box = await Hive.openBox<NoteHiveModel>(_boxName);
  }

  @override
  Future<void> saveNote(Note note) async {
    final hiveModel = NoteMapper.toHiveModel(note);
    await _box.put(note.id, hiveModel);
  }

  @override
  Future<Note?> getNote(String id) async {
    final hiveModel = _box.get(id);
    return hiveModel != null ? NoteMapper.toDomainEntity(hiveModel) : null;
  }

  @override
  Future<List<Note>> getAllNotes() async {
    final notes = _box.values
        .map((model) => NoteMapper.toDomainEntity(model))
        .toList();
    return notes;
  }

  @override
  Future<void> deleteNote(String id) async {
    await _box.delete(id);
  }

  @override
  Future<void> updateNote(Note note) async {
    final hiveModel = NoteMapper.toHiveModel(note);
    await _box.put(note.id, hiveModel);
  }
}
