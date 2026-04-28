// main_view.dart
import 'package:dndigital/features/master_notes/presentation/view/note_editor_view.dart';
<<<<<<< HEAD
import 'package:dndigital/features/master_notes/presentation/widgets/notes_navigation_panel.dart';
import 'package:dndigital/features/master_notes/presentation/viewmodel/note_editor_viewmodel.dart';
import 'package:dndigital/features/master_notes/presentation/viewmodel/notes_list_viewmodel.dart';
=======
>>>>>>> origin/main
import 'package:flutter/material.dart';
import 'package:flutter_resizable_container/flutter_resizable_container.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
<<<<<<< HEAD
import '../utils/providers/layout_controller_provider.dart';
import '../theme/button_styles.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  String? _selectedNoteId;

  @override
  Widget build(BuildContext context) {
    final model = context.watch<LayoutControllerProvider>();
=======
import '../../features/master_notes/presentation/viewmodel/resizable_controller_view_model.dart';
import '../theme/button_styles.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<ResizableControllerViewModel>();
>>>>>>> origin/main

    return Row(
      children: [
        Container(
          width: 52,
          decoration: BoxDecoration(
            border: Border(right: BorderSide(color: Colors.black12, width: 1)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 8),
              IconButton(
                icon: Icon(PhosphorIcons.bookBookmark()),
                onPressed: () {},
                constraints: const BoxConstraints(),
                style: BtnStyle.mainMenu,
              ),
              const SizedBox(height: 8),
              IconButton(
                icon: Icon(PhosphorIcons.usersThree()),
                onPressed: () {},
                constraints: const BoxConstraints(),
                style: BtnStyle.mainMenu,
              ),
              const SizedBox(height: 8),
              IconButton(
                icon: Icon(PhosphorIcons.castleTurret()),
                onPressed: () {},
                constraints: const BoxConstraints(),
                style: BtnStyle.mainMenu,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(height: 8),
                    IconButton(
                      icon: Icon(PhosphorIcons.moon()),
                      onPressed: () {},
                      style: BtnStyle.mainMenu,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(height: 8),
                    IconButton(
                      icon: Icon(PhosphorIcons.gearSix()),
                      onPressed: () {},
                      style: BtnStyle.mainMenu,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ResizableContainer(
<<<<<<< HEAD
            cascadeNegativeDelta: true,
            controller: model.controller,
            direction: Axis.horizontal,
            children: [
              // Панель навигации с заметками
              ResizableChild(
                size: const ResizableSize.pixels(334, min: 184),
                divider: model.leftDivider,
                child: NotesNavigationPanel(
                  onNoteSelected: (noteId) {
                    setState(() {
                      _selectedNoteId = noteId;
                    });
                  },
                ),
              ),
              // Редактор заметок
              ResizableChild(
                divider: model.rightDivider,
                child: Consumer2<NoteEditorViewModel, NotesListViewModel>(
                  builder: (context, noteEditor, notesList, _) {
                    // Установка callback для синхронизации
                    noteEditor.setOnNoteSavedCallback((note) {
                      notesList.refreshNotes(note);
                    });
                    return NoteEditor(noteId: _selectedNoteId);
                  },
                ),
              ),
              // Правая панель
              ResizableChild(
                size: const ResizableSize.pixels(334, min: 322),
=======
            controller: model.controller,
            direction: Axis.horizontal,
            children: [
              // Панель навигации
              ResizableChild(
                size: const ResizableSize.pixels(334),
                divider: model.leftDivider,
                child: Container(),
              ),
              ResizableChild(divider: model.rightDivider, child: NoteEditor()),
              ResizableChild(
                size: const ResizableSize.pixels(334),
>>>>>>> origin/main
                child: Container(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
