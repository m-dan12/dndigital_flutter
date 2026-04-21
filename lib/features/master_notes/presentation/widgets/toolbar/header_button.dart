import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class QuillToolbarHeaderButton extends StatefulWidget {
  final QuillController controller;
  final QuillToolbarBaseButtonOptions? options;

  const QuillToolbarHeaderButton({
    super.key,
    required this.controller,
    this.options,
  });

  @override
  State<QuillToolbarHeaderButton> createState() =>
      _QuillToolbarHeaderButtonState();
}

class _QuillToolbarHeaderButtonState extends State<QuillToolbarHeaderButton> {
  int? _currentHeaderLevel;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateHeaderLevel);
    _updateHeaderLevel();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateHeaderLevel);
    super.dispose();
  }

  void _updateHeaderLevel() {
    final attrs = widget.controller.getSelectionStyle().attributes;
    final level = attrs[Attribute.header.key]?.value as int?;
    if (level != _currentHeaderLevel) {
      setState(() => _currentHeaderLevel = level);
    }
  }

  IconData _getHeaderIcon() {
    switch (_currentHeaderLevel) {
      case 1:
        return PhosphorIcons.textHOne();
      case 2:
        return PhosphorIcons.textHTwo();
      case 3:
        return PhosphorIcons.textHThree();
      case 4:
        return PhosphorIcons.textHFour();
      default:
        return PhosphorIcons.textH();
    }
  }

  bool get _isHeaderActive => _currentHeaderLevel != null;

  void _onButtonPressed() {
    if (_isHeaderActive) {
      _applyHeader(null); // снять заголовок при повторном нажатии
    } else {
      _showHeaderMenu();
    }
  }

  void _showHeaderMenu() {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final Offset position = button.localToGlobal(Offset.zero);

    showMenu<int>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx - 4,
        position.dy - 224, // сильно вверх — над тулбаром
        position.dx + button.size.width,
        position.dy - 0,
      ),
      elevation: 8,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      constraints: const BoxConstraints(maxWidth: 48),
      items: [
        _buildMenuItem(1, PhosphorIcons.textHOne()),
        _buildMenuItem(2, PhosphorIcons.textHTwo()),
        _buildMenuItem(3, PhosphorIcons.textHThree()),
        _buildMenuItem(4, PhosphorIcons.textHFour()),
      ],
    ).then((value) {
      if (value != null) {
        _applyHeader(value);
      }
    });
  }

  PopupMenuItem<int> _buildMenuItem(int level, IconData icon) {
    return PopupMenuItem<int>(
      value: level,
      height: 48,
      child: Center(
        child: SizedBox(
          width: 48,
          height: 48,
          child: Center(child: Icon(icon, size: 24)),
        ),
      ),
    );
  }

  void _applyHeader(int? level) {
    final Attribute<dynamic> attr = level == null
        ? Attribute.header
        : HeaderAttribute(level: level);

    widget.controller.formatSelection(attr);
    setState(() => _currentHeaderLevel = level);
  }

  @override
  Widget build(BuildContext context) {
    final baseOptions = widget.options ?? const QuillToolbarBaseButtonOptions();

    return QuillToolbarCustomButton(
      controller: widget.controller,
      options: QuillToolbarCustomButtonOptions(
        icon: Icon(_getHeaderIcon(), size: baseOptions.iconSize),
        tooltip: _isHeaderActive ? 'Снять заголовок' : 'Заголовок',
        onPressed: _onButtonPressed,
        iconTheme: QuillIconTheme(
          iconButtonSelectedData: IconButtonData(
            color: Theme.of(context).colorScheme.primary,
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(
                Theme.of(context).colorScheme.primaryContainer,
              ),
            ),
          ),
          iconButtonUnselectedData: const IconButtonData(),
        ),
      ),
    );
  }
}
