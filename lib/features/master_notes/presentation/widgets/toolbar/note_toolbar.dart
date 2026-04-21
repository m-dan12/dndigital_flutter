import 'package:dndigital/features/master_notes/presentation/widgets/toolbar/header_button.dart';
import 'package:dndigital/features/master_notes/presentation/widgets/toolbar/list_button.dart';
import 'package:dndigital/features/master_notes/presentation/widgets/toolbar/color_picker.dart';
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
            // _buildHeaderButton(context),
            QuillToolbarHeaderButton(controller: controller),
            // Списки
            QuillToolbarListButton(controller: controller),

            // Цитата
            _buildToggleButton(PhosphorIcons.quotes(), Attribute.blockQuote),
            // Цвет текста (яркие)
            ToolbarColorPicker(
              currentColor: _getColorFromAttribute(
                controller
                    .getSelectionStyle()
                    .attributes[Attribute.color.key]
                    ?.value,
                defaultColor: Colors.black,
              ),
              onColorSelected: (color) {
                if (color == Colors.transparent) {
                  controller.formatSelection(
                    const ColorAttribute(null),
                  ); // убрать цвет
                } else {
                  final hex =
                      '#${color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}';
                  controller.formatSelection(ColorAttribute(hex));
                }
              },
              isBackground: false,
            ),
            // Цвет фона (тусклые цвета)
            ToolbarColorPicker(
              currentColor: _getColorFromAttribute(
                controller
                    .getSelectionStyle()
                    .attributes[Attribute.background.key]
                    ?.value,
                defaultColor: Colors.transparent,
              ),
              onColorSelected: (color) {
                if (color == Colors.transparent) {
                  controller.formatSelection(
                    const BackgroundAttribute(null),
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

  Color _getColorFromAttribute(dynamic value, {required Color defaultColor}) {
    if (value is! String || value.isEmpty) {
      return defaultColor;
    }
    try {
      // value приходит как "#rrggbb" или "#rrggbbaa"
      final hex = value.replaceFirst(
        '#',
        '0xFF',
      ); // если без альфы — делаем непрозрачным
      if (value.length == 7) {
        // #rrggbb
        return Color(int.parse(hex));
      } else if (value.length == 9) {
        // #rrggbbaa
        return Color(int.parse('0x${value.substring(1)}'));
      }
      return defaultColor;
    } catch (e) {
      return defaultColor;
    }
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
}
