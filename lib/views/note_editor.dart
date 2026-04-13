import 'package:dndigital/widgets/buttons.dart';
import 'package:dndigital/widgets/note_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

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
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 874),
        child: Column(
          children: [
            // === Зона заголовка ===
            Padding(
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
                                    onPressed: () {
                                      // TODO: добавить иконку
                                    },
                                    icon: const Icon(
                                      Icons.image_outlined,
                                      size: 18,
                                    ),
                                    label: const Text('Добавить иконку'),
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.black26,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
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
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
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
                      DnTextButton(
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
            ),

            const SizedBox(height: 12),

            // === Основной редактор ===
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 140),
                      physics: const BouncingScrollPhysics(),
                      child: GestureDetector(
                        onTap: () {
                          _controller.moveCursorToEnd();
                          _focusNode.requestFocus();
                        },
                        child: MouseRegion(
                          cursor: SystemMouseCursors.text,
                          child: QuillEditor.basic(
                            controller: _controller,
                            focusNode: _focusNode,
                            config: const QuillEditorConfig(
                              padding: EdgeInsets.fromLTRB(40, 8, 40, 40),
                              scrollable: false,
                              expands: false,
                              customStyles: DefaultStyles(
                                paragraph: DefaultTextBlockStyle(
                                  TextStyle(
                                    color: Colors.black87,
                                    fontSize: 18.0,
                                    fontFamily: 'Cormorant',
                                    height: 1.5,
                                  ),
                                  HorizontalSpacing(0, 0),
                                  VerticalSpacing(0, 0),
                                  VerticalSpacing(0, 0),
                                  null,
                                ),
                                h1: DefaultTextBlockStyle(
                                  TextStyle(
                                    color: Colors.black87,
                                    fontSize: 32,
                                    height: 2,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Cormorant',
                                  ),
                                  HorizontalSpacing(0, 0),
                                  VerticalSpacing(0, 0),
                                  VerticalSpacing(0, 0),
                                  null,
                                ),
                                h2: DefaultTextBlockStyle(
                                  TextStyle(
                                    color: Colors.black87,
                                    fontSize: 28,
                                    height: 2,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Cormorant',
                                  ),
                                  HorizontalSpacing(0, 0),
                                  VerticalSpacing(0, 0),
                                  VerticalSpacing(0, 0),
                                  null,
                                ),
                                h3: DefaultTextBlockStyle(
                                  TextStyle(
                                    color: Colors.black87,
                                    fontSize: 24,
                                    height: 2,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Cormorant',
                                  ),
                                  HorizontalSpacing(0, 0),
                                  VerticalSpacing(0, 0),
                                  VerticalSpacing(0, 0),
                                  null,
                                ),
                                h4: DefaultTextBlockStyle(
                                  TextStyle(
                                    color: Colors.black87,
                                    fontSize: 20,
                                    height: 2,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Cormorant',
                                  ),
                                  HorizontalSpacing(0, 0),
                                  VerticalSpacing(0, 0),
                                  VerticalSpacing(0, 0),
                                  null,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: NoteToolbar(controller: _controller),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
