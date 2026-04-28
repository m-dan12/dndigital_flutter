import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/notes_list_viewmodel.dart';

class NotesNavigationPanel extends StatefulWidget {
  final Function(String noteId) onNoteSelected;

  const NotesNavigationPanel({Key? key, required this.onNoteSelected})
    : super(key: key);

  @override
  State<NotesNavigationPanel> createState() => _NotesNavigationPanelState();
}

class _NotesNavigationPanelState extends State<NotesNavigationPanel> {
  @override
  void initState() {
    super.initState();
    // Загружаем все заметки при открытии панели
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotesListViewModel>().loadAllNotes();
    });
  }

  /// Создать новую заметку с названием "Без названия" и открыть её
  Future<void> _createNewNote() async {
    final viewModel = context.read<NotesListViewModel>();
    final noteId = await viewModel.createNote('');

    if (noteId.isNotEmpty && mounted) {
      widget.onNoteSelected(noteId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NotesListViewModel>(
      builder: (context, viewModel, _) {
        return Column(
          children: [
            // == Header с кнопкой добавления ==
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Заметки',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _createNewNote,
                    iconSize: 20,
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1),

            // == Список заметок ==
            Expanded(
              child: viewModel.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : viewModel.allNotes.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'Нет заметок\n\nНажмите + чтобы создать',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: viewModel.allNotes.length,
                      itemBuilder: (context, index) {
                        final note = viewModel.allNotes[index];
                        final isSelected = viewModel.selectedNoteId == note.id;

                        return ListTile(
                          selected: isSelected,
                          selectedTileColor: Colors.blue[50],
                          title: Text(
                            note.title.isEmpty ? 'Без названия' : note.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              fontSize: 13,
                            ),
                          ),
                          subtitle: Text(
                            _formatDate(note.updatedAt),
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                          ),
                          trailing: PopupMenuButton(
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                child: const Text('Удалить'),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Удалить заметку?'),
                                      content: const Text(
                                        'Это действие нельзя отменить',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('Отмена'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            viewModel.deleteNote(note.id);
                                            Navigator.pop(context);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                          ),
                                          child: const Text('Удалить'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          onTap: () {
                            viewModel.selectNote(note.id);
                            widget.onNoteSelected(note.id);
                          },
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return 'Сегодня ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (dateOnly == yesterday) {
      return 'Вчера';
    } else {
      return '${date.day}.${date.month}.${date.year}';
    }
  }
}
