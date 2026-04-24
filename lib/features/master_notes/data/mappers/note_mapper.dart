import '../../domain/entities/note.dart';
import '../models/note_hive_model.dart';

class NoteMapper {
  static Note toDomainEntity(NoteHiveModel model) {
    return Note(
      id: model.id,
      title: model.title,
      description: model.description,
      content: model.content,
      tags: model.tags,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  static NoteHiveModel toHiveModel(Note entity) {
    return NoteHiveModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      content: entity.content,
      tags: entity.tags,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
