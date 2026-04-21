import 'package:flutter/material.dart';

// color_picker_widget.dart
class ToolbarColorPicker extends StatelessWidget {
  final Color currentColor;
  final ValueChanged<Color> onColorSelected;
  final bool
  isBackground; // true — для фона (тусклые), false — для текста (яркие)

  const ToolbarColorPicker({
    super.key,
    required this.currentColor,
    required this.onColorSelected,
    required this.isBackground,
  });

  @override
  Widget build(BuildContext context) {
    final colors = isBackground ? _mutedColors : _brightColors;

    return PopupMenuButton<Color>(
      tooltip: isBackground ? 'Цвет фона' : 'Цвет текста',
      icon: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: currentColor,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade400, width: 1),
        ),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          enabled: false,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: colors.map((color) {
              final isSelected = color == currentColor;
              return GestureDetector(
                onTap: () {
                  onColorSelected(color);
                  Navigator.pop(context);
                },
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? Colors.white : Colors.transparent,
                      width: 2,
                    ),
                    boxShadow: isSelected
                        ? [BoxShadow(color: Colors.black26, blurRadius: 4)]
                        : null,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

// Палитры
const List<Color> _brightColors = [
  Colors.red,
  Colors.orange,
  Colors.amber,
  Colors.green,
  Colors.teal,
  Colors.blue,
  Colors.indigo,
  Colors.purple,
  Colors.pink,
  Colors.white,
  Colors.black,
];

final List<Color> _mutedColors = [
  Colors.grey[800]!,
  Colors.grey[600]!,
  const Color(0xFF8B4513), // saddle brown
  const Color(0xFFCD853F),
  const Color(0xFF2E8B57), // sea green
  const Color(0xFF4682B4),
  const Color(0xFF6A5ACD),
  const Color(0xFF8B008B),
  const Color(0xFFDB7093),
  Colors.white,
  const Color(0xFF1C1C1E),
];
