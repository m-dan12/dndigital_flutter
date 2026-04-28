import 'dart:convert';

import 'package:dndigital/features/master_notes/domain/entities/note.dart';
import 'package:dndigital/features/master_notes/presentation/widgets/toolbar/note_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:dndigital/core/theme/quill_text_styles.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../viewmodel/note_editor_viewmodel.dart';

class NoteEditor extends StatefulWidget {
  final String? noteId;

  const NoteEditor({super.key, this.noteId});

  @override
  State<NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  late QuillController _controller;
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isHeaderHovered = false;
  bool _showDescriptionField = false;

  /// ID последней заметки, загруженной в _controller.
  /// Используется чтобы не перезагружать контроллер без необходимости.
  String? _lastLoadedNoteId;

  /// true во время программной загрузки контента в _controller,
  /// чтобы _onContentChanged не запускал автосохранение.
  bool _isLoadingContent = false;

  @override
  void initState() {
    super.initState();
    _controller = QuillController.basic();
    _controller.addListener(_onContentChanged);

    // Загружаем существующую заметку если её ID передан
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.noteId != null && mounted) {
        context.read<NoteEditorViewModel>().loadNote(widget.noteId!);
      }
    });
  }

  void _onContentChanged() {
    // Игнорируем изменения, вызванные программной загрузкой контента
    if (_isLoadingContent) return;

    final viewModel = context.read<NoteEditorViewModel>();
    // jsonEncode возвращает валидный JSON, в отличие от .toString()
    final deltaJson = jsonEncode(_controller.document.toDelta().toJson());
    viewModel.updateContent(deltaJson);
  }

  @override
  void didUpdateWidget(NoteEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    // didUpdateWidget вызывается во время фазы build родительского виджета,
    // поэтому loadNote (который через _performSave вызывает notifyListeners)
    // нельзя запускать синхронно — это вызовет "setState during build".
    // Откладываем на postFrameCallback: к тому моменту build уже завершён.
    if (oldWidget.noteId != widget.noteId && widget.noteId != null) {
      final noteIdToLoad = widget.noteId!;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Проверяем mounted и что пользователь не переключился ещё раз
        // пока callback ждал своей очереди.
        if (mounted && noteIdToLoad == widget.noteId) {
          context.read<NoteEditorViewModel>().loadNote(noteIdToLoad);
        }
      });
    }
  }

  /// Загружает контент заметки в Quill-контроллер.
  /// Вызывается через postFrameCallback чтобы не делать setState во время build.
  void _loadContentFromNote(Note note) {
    if (_lastLoadedNoteId == note.id) return;
    _lastLoadedNoteId = note.id;

    // Сохраняем ссылку на старый контроллер — уберём его после следующего кадра,
    // когда Flutter уже переключится на новый.
    final oldController = _controller;
    oldController.removeListener(_onContentChanged);

    _isLoadingContent = true;

    QuillController newController;
    final content = note.content;

    if (content.isNotEmpty && content != '[]') {
      try {
        final jsonList = jsonDecode(content) as List;
        newController = QuillController(
          document: Document.fromJson(jsonList),
          selection: const TextSelection.collapsed(offset: 0),
        );
      } catch (e) {
        debugPrint('Error loading note content: $e');
        newController = QuillController.basic();
      }
    } else {
      newController = QuillController.basic();
    }

    newController.addListener(_onContentChanged);
    _controller = newController;

    // Удаляем старый контроллер и снимаем флаг только после следующего кадра:
    // к тому моменту QuillEditor уже использует новый контроллер.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      oldController.dispose();
      if (mounted) _isLoadingContent = false;
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_onContentChanged);
    _controller.dispose();
    _focusNode.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteEditorViewModel>(
      builder: (context, viewModel, _) {
        // Синхронизируем текстовые контроллеры с ViewModel
        if (_titleController.text != viewModel.currentNote.title) {
          _titleController.text = viewModel.currentNote.title;
        }
        if (_descriptionController.text != viewModel.currentNote.description) {
          _descriptionController.text = viewModel.currentNote.description;
        }

        // Когда ViewModel загрузила нужную заметку — переключаем Quill-контроллер.
        // Проверяем что ViewModel уже содержит именно запрошенную заметку
        // (а не промежуточное состояние с другой заметкой).
        if (widget.noteId != null &&
            viewModel.currentNote.id == widget.noteId &&
            _lastLoadedNoteId != widget.noteId) {
          final noteToLoad = viewModel.currentNote;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && noteToLoad.id == widget.noteId) {
              setState(() => _loadContentFromNote(noteToLoad));
            }
          });
        }

        return Stack(
          children: [
            // == Note ==
            Positioned.fill(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Align(
                  alignment: AlignmentGeometry.topCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 874),
                    child: Column(
                      children: [
                        // == Title ==
                        _buildTitlePane(viewModel),

                        // == Content ==
                        _buildContentPane(),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // == Toolbar ==
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: NoteToolbar(controller: _controller),
              ),
            ),

            // == Индикатор сохранения ==
            // Появляется только в момент реальной записи на диск (не во время debounce)
            if (viewModel.isSaving)
              Positioned(
                bottom: 100,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Сохранение...',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),

            // == Ошибки ==
            if (viewModel.errorMessage != null)
              Positioned(
                bottom: 100,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red[400],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    viewModel.errorMessage!,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildTitlePane(NoteEditorViewModel viewModel) => Padding(
    padding: const EdgeInsets.fromLTRB(32, 32, 32, 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Строка с кнопками (иконка / описание) — появляется при наведении
        SizedBox(
          height: 36,
          child: MouseRegion(
            onEnter: (_) => setState(() => _isHeaderHovered = true),
            onExit: (_) => setState(() => _isHeaderHovered = false),
            child: Container(
              alignment: Alignment.centerLeft,
              child: _isHeaderHovered
                  ? Row(
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            // TODO: Реализовать добавление заметке иконки
                          },
                          icon: const Icon(Icons.image_outlined, size: 18),
                          label: const Text('Добавить иконку'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black26,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                        const SizedBox(width: 16),
                        TextButton.icon(
                          onPressed: () {
                            setState(
                              () => _showDescriptionField =
                                  !_showDescriptionField,
                            );
                          },
                          icon: Icon(
                            _showDescriptionField
                                ? Icons.visibility_off
                                : Icons.visibility,
                            size: 18,
                          ),
                          label: Text(
                            _showDescriptionField
                                ? 'Скрыть описание'
                                : 'Показать описание',
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black26,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ),

        // Заголовок
        Padding(
          padding: EdgeInsetsGeometry.directional(start: 8),
          child: TextField(
            controller: _titleController,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            onChanged: (value) => viewModel.updateTitle(value),
            style: GoogleFonts.lora(
              color: Colors.black87,
              fontSize: 44.0,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
            decoration: const InputDecoration(
              hintText: 'Без названия',
              hintStyle: TextStyle(color: Colors.black26),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Описание
        Padding(
          padding: EdgeInsetsGeometry.directional(start: 8),
          child: _showDescriptionField
              ? TextField(
                  controller: _descriptionController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  onChanged: (value) => viewModel.updateDescription(value),
                  style: GoogleFonts.lora(
                    fontSize: 18,
                    height: 1.2,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Добавить описание...',
                    hintStyle: TextStyle(color: Colors.black26),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                )
              : const SizedBox(),
        ),
        if (_showDescriptionField) const SizedBox(height: 8),

        // Теги
        Row(
          children: [
            TextButton(
              onPressed: () => _showTagSelectionPopup(context),
              style: TextButton.styleFrom(
                foregroundColor: Colors.black26,
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 12,
                ),
                minimumSize: Size.zero,
              ),
              child: Text(
                'Tag 1',
                style: GoogleFonts.lora(
                  fontSize: 14,
                  height: 1.3,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );

  /// Панель с редактором содержимого заметки.
  /// Consumer убран намеренно — контент управляется через _controller напрямую,
  /// не через ViewModel, что исключает лишние перерисовки при каждом нажатии клавиши.
  Widget _buildContentPane() => GestureDetector(
    onTap: () {
      _controller.moveCursorToEnd();
      _focusNode.requestFocus();
    },
    behavior: HitTestBehavior.translucent,
    child: Container(
      color: Colors.transparent,
      constraints: const BoxConstraints(minHeight: 600),
      child: MouseRegion(
        cursor: SystemMouseCursors.text,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            QuillEditor.basic(
              controller: _controller,
              focusNode: _focusNode,
              config: QuillEditorConfig(
                padding: const EdgeInsets.fromLTRB(40, 0, 40, 40),
                scrollable: false,
                expands: false,
                customStyles: quillTextStyles,
              ),
            ),

            // Пустое пространство снизу, чтобы кликать ниже последней строки
            SizedBox(height: MediaQuery.of(context).size.height * 0.4),
          ],
        ),
      ),
    ),
  );

  void _showTagSelectionPopup(BuildContext context) {
    // TODO: Реализовать полноценный выбор тегов
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Теги'),
        content: const Text('Функция выбора тегов будет добавлена позже.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
