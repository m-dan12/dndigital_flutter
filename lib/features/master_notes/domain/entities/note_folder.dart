class NoteFolder {
  final String id;
  final String name;
  final String? parentId;
  final List<String> noteIds; // ID заметок в папке
  final DateTime createdAt;

  NoteFolder({
    required this.id,
    required this.name,
    this.parentId,
    this.noteIds = const [],
    required this.createdAt,
  });

  NoteFolder copyWith({
    String? id,
    String? name,
    String? parentId,
    List<String>? noteIds,
    DateTime? createdAt,
  }) {
    return NoteFolder(
      id: id ?? this.id,
      name: name ?? this.name,
      parentId: parentId ?? this.parentId,
      noteIds: noteIds ?? this.noteIds,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
