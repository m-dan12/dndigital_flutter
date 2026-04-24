class Note {
  final String id;
  final String title;
  final String description;
  final String content; // QuillDelta JSON
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;

  Note({
    required this.id,
    required this.title,
    this.description = '',
    required this.content,
    this.tags = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  // Копирование с изменениями
  Note copyWith({
    String? id,
    String? title,
    String? description,
    String? content,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      content: content ?? this.content,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
