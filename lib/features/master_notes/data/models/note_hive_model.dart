import 'package:hive/hive.dart';

part 'note_hive_model.g.dart';

@HiveType(typeId: 0)
class NoteHiveModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String content;

  @HiveField(4)
  final List<String> tags;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  final DateTime updatedAt;

  NoteHiveModel({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
  });
}
