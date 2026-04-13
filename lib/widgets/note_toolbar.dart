import 'package:dndigital/widgets/color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class NoteToolbar extends StatelessWidget {
  final QuillController controller;

  const NoteToolbar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 0)),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // Форматирование текста
            _buildToggleButton(PhosphorIcons.textB(), Attribute.bold),
            _buildToggleButton(PhosphorIcons.textItalic(), Attribute.italic),
            _buildToggleButton(
              PhosphorIcons.textUnderline(),
              Attribute.underline,
            ),
            _buildToggleButton(
              PhosphorIcons.textStrikethrough(),
              Attribute.strikeThrough,
            ),

            // Ссылка
            _buildLinkButton(context),
            // Заголовки (H)
            _buildHeaderButton(context),
            // Списки
            _buildToggleButton(Icons.format_list_bulleted, Attribute.ul),
            _buildToggleButton(Icons.format_list_numbered, Attribute.ol),
            _buildToggleButton(Icons.check_box, Attribute.checked),

            const SizedBox(width: 16),

            // Цитата
            _buildToggleButton(Icons.format_quote, Attribute.blockQuote),
            // Цвет текста (яркие)
            ToolbarColorPicker(
              currentColor:
                  controller
                      .getSelectionStyle()
                      .attributes[Attribute.color.key]
                      ?.value ??
                  Colors.black,
              onColorSelected: (color) {
                if (color == Colors.transparent) {
                  controller.formatSelection(Attribute.color); // убрать цвет
                } else {
                  final hex =
                      '#${color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}';
                  controller.formatSelection(ColorAttribute(hex));
                }
              },
              isBackground: false,
            ),

            // Цвет фона (тусклые)
            ToolbarColorPicker(
              currentColor:
                  controller
                      .getSelectionStyle()
                      .attributes[Attribute.background.key]
                      ?.value ??
                  Colors.transparent,
              onColorSelected: (color) {
                if (color == Colors.transparent) {
                  controller.formatSelection(
                    Attribute.background,
                  ); // убрать фон
                } else {
                  final hex =
                      '#${color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}';
                  controller.formatSelection(BackgroundAttribute(hex));
                }
              },
              isBackground: true,
            ),
          ],
        ),
      ),
    );
  }

  // Простая кнопка форматирования
  Widget _buildToggleButton(IconData iconData, Attribute attribute) {
    return QuillToolbarToggleStyleButton(
      controller: controller,
      attribute: attribute,
      options: QuillToolbarToggleStyleButtonOptions(iconData: iconData),
      baseOptions: const QuillToolbarBaseButtonOptions(
        iconSize: 20,
        iconButtonFactor: 1,
      ),
    );
  }

  Widget _buildLinkButton(BuildContext context) {
    return QuillToolbarLinkStyleButton(
      controller: controller,
      options: QuillToolbarLinkStyleButtonOptions(
        iconData: PhosphorIcons.link(), // ← сюда .data
        iconSize: 20,
        iconButtonFactor: 1,
      ),
    );
  }

  // Кнопка заголовков
  Widget _buildHeaderButton(BuildContext context) {
    return QuillToolbarCustomButton(
      controller: controller,
      options: QuillToolbarCustomButtonOptions(
        icon: Icon(PhosphorIcons.textHOne(), size: 20),
        tooltip: 'Заголовок',
        onPressed: () => _showHeaderMenu(context),
      ),
    );
  }

  // Меню заголовков
  void _showHeaderMenu(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final Offset position = button.localToGlobal(Offset.zero);

    showMenu<dynamic>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy + button.size.height + 6,
        position.dx + 220,
        position.dy + 300,
      ),
      items: [
        PopupMenuItem(value: 'h1', child: const Text('Заголовок 1')),
        PopupMenuItem(value: 'h2', child: const Text('Заголовок 2')),
        PopupMenuItem(value: 'h3', child: const Text('Заголовок 3')),
        const PopupMenuDivider(),
        PopupMenuItem(value: 'normal', child: const Text('Обычный текст')),
      ],
    ).then((value) {
      if (value == null) return;

      switch (value) {
        case 'h1':
          controller.formatSelection(Attribute.h1);
          break;
        case 'h2':
          controller.formatSelection(Attribute.h2);
          break;
        case 'h3':
          controller.formatSelection(Attribute.h3);
          break;
        case 'normal':
          controller.formatSelection(Attribute.header);
          break;
      }
    });
  }

  // Полноценный color picker
}
