import 'package:hive_flutter/hive_flutter.dart';
import '../models/note_hive_model.dart';
import '../repositories/hive_note_repository.dart';

class HiveInitializer {
  static final _repository = HiveNoteRepository();

  static HiveNoteRepository get repository => _repository;

  static Future<void> initialize() async {
    // Регистрируем Hive адаптер для модели
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(NoteHiveModelAdapter());
    }

    // Инициализируем репозиторий
    await _repository.init();
  }
}
