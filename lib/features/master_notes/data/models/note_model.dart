import 'package:hive/hive.dart';
import '../../domain/entities/note.dart';

part 'note_model.g.dart';

@HiveType(typeId: 0)
class NoteModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late String description;

  @HiveField(3)
  late String content;

  @HiveField(4)
  late List<String> tags;

  @HiveField(5)
  late DateTime createdAt;

  @HiveField(6)
  late DateTime updatedAt;

  NoteModel({
    required this.id,
    required this.title,
    this.description = '',
    required this.content,
    this.tags = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  // Конвертация из Note entity
  factory NoteModel.fromEntity(Note note) {
    return NoteModel(
      id: note.id,
      title: note.title,
      description: note.description,
      content: note.content,
      tags: note.tags,
      createdAt: note.createdAt,
      updatedAt: note.updatedAt,
    );
  }

  // Конвертация в Note entity
  Note toEntity() {
    return Note(
      id: id,
      title: title,
      description: description,
      content: content,
      tags: tags,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
