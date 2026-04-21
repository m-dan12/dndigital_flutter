import 'package:dndigital/features/master_notes/presentation/widgets/toolbar/note_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:dndigital/core/theme/quill_text_styles.dart';

class NoteEditor extends StatefulWidget {
  const NoteEditor({super.key});

  @override
  State<NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  final QuillController _controller = QuillController.basic();
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isHeaderHovered = false;
  bool _showDescriptionField = false;

  void _showTagSelectionPopup(BuildContext context) {
    // Пока заглушка — сюда вставишь свой попап позже
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выбрать или создать тег'),
        content: const Text(
          'Здесь будет поиск + список тегов + кнопка "Создать"',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    _buildTitlePane(),
                    const SizedBox(height: 12),

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
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Widget _buildTitlePane() => Padding(
    padding: const EdgeInsets.all(32),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Строка с кнопками
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
                          onPressed: () {},
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
            style: const TextStyle(
              fontSize: 44,
              height: 1.2,
              fontWeight: FontWeight.w600,
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

        // Описание
        Padding(
          padding: EdgeInsetsGeometry.directional(start: 8),
          child: _showDescriptionField
              ? TextField(
                  controller: _descriptionController,
                  style: const TextStyle(
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
              : SizedBox(),
        ),
        if (_showDescriptionField) const SizedBox(height: 8),

        // Теги + кнопка "Тег"
        Row(
          children: [
            TextButton(
              onPressed: () => _showTagSelectionPopup(context),
              style: TextButton.styleFrom(
                foregroundColor: Colors.black26,
                padding: const EdgeInsets.all(8),
                minimumSize: Size.zero,
              ),
              child: const Text('Тег'),
            ),
          ],
        ),
      ],
    ),
  );

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
                padding: const EdgeInsets.fromLTRB(40, 8, 40, 40),
                scrollable: false,
                expands: false,
                customStyles: quillTextStyles,
              ),
            ),

            // Пустое пространство внизу без Expanded
            SizedBox(height: MediaQuery.of(context).size.height * 0.4),
          ],
        ),
      ),
    ),
  );
}
