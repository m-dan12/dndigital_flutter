import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

// Перечисление для удобства работы с типами списков
enum _ListType {
  bullet, // Маркированный
  number, // Нумерованный
  check, // Чек-лист
}

class QuillToolbarListButton extends StatefulWidget {
  final QuillController controller;
  final QuillToolbarBaseButtonOptions? options;

  const QuillToolbarListButton({
    super.key,
    required this.controller,
    this.options,
  });

  @override
  State<QuillToolbarListButton> createState() => _QuillToolbarListButtonState();
}

class _QuillToolbarListButtonState extends State<QuillToolbarListButton> {
  _ListType? _currentListType;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateListType);
    _updateListType();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateListType);
    super.dispose();
  }

  void _updateListType() {
    final attrs = widget.controller.getSelectionStyle().attributes;

    // Проверяем активные атрибуты списка в порядке приоритета отображения
    if (attrs[Attribute.blockQuote.key] != null ||
        attrs[Attribute.codeBlock.key] != null ||
        attrs[Attribute.indent.key] != null) {
      // Если есть другие блочные элементы, можно решить, сбрасывать ли состояние
      // Но для простоты проверяем именно списки
    }

    if (attrs[Attribute.list.key]?.value == 'checked' ||
        attrs[Attribute.list.key]?.value == 'unchecked') {
      if (_currentListType != _ListType.check) {
        setState(() => _currentListType = _ListType.check);
      }
    } else if (attrs[Attribute.list.key]?.value == 'ordered') {
      if (_currentListType != _ListType.number) {
        setState(() => _currentListType = _ListType.number);
      }
    } else if (attrs[Attribute.list.key]?.value == 'bullet') {
      if (_currentListType != _ListType.bullet) {
        setState(() => _currentListType = _ListType.bullet);
      }
    } else {
      if (_currentListType != null) {
        setState(() => _currentListType = null);
      }
    }
  }

  IconData _getListIcon() {
    switch (_currentListType) {
      case _ListType.bullet:
        return PhosphorIcons.listBullets();
      case _ListType.number:
        return PhosphorIcons.listNumbers();
      case _ListType.check:
        return PhosphorIcons.listChecks();
      default:
        return PhosphorIcons.list(); // Дефолтная иконка "список"
    }
  }

  bool get _isListActive => _currentListType != null;

  void _onButtonPressed() {
    if (_isListActive) {
      _applyList(null); // Снять форматирование списка при повторном нажатии
    } else {
      _showListMenu();
    }
  }

  void _showListMenu() {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final Offset position = button.localToGlobal(Offset.zero);

    showMenu<_ListType>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx - 4,
        position.dy - 180, // Позиция меню над кнопкой
        position.dx + button.size.width,
        position.dy - 0,
      ),
      elevation: 8,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      constraints: const BoxConstraints(maxWidth: 48),
      items: [
        _buildMenuItem(_ListType.bullet, PhosphorIcons.listBullets()),
        _buildMenuItem(_ListType.number, PhosphorIcons.listNumbers()),
        _buildMenuItem(_ListType.check, PhosphorIcons.listChecks()),
      ],
    ).then((value) {
      if (value != null) {
        _applyList(value);
      }
    });
  }

  PopupMenuItem<_ListType> _buildMenuItem(_ListType type, IconData icon) {
    final isSelected = _currentListType == type;

    return PopupMenuItem<_ListType>(
      value: type,
      height: 48,
      child: Center(
        child: SizedBox(
          width: 48,
          height: 48,
          child: Center(
            child: Icon(
              icon,
              size: 24,
              color: isSelected ? Theme.of(context).colorScheme.primary : null,
            ),
          ),
        ),
      ),
    );
  }

  void _applyList(_ListType? type) {
    Attribute<dynamic> attr;

    switch (type) {
      case _ListType.bullet:
        // Используем конструктор ListAttribute со значением 'bullet'
        attr = const ListAttribute('bullet');
        break;
      case _ListType.number:
        // Используем конструктор ListAttribute со значением 'ordered'
        attr = const ListAttribute('ordered');
        break;
      case _ListType.check:
        // Для чек-листа используем 'unchecked' (или 'checked', если нужно сразу отмеченное)
        attr = const ListAttribute('unchecked');
        break;
      case null:
        // Снятие форматирования списка
        attr = Attribute.list;
        break;
    }

    widget.controller.formatSelection(attr);
    // setState не обязателен здесь, так как listener _updateListType вызовется после formatSelection
  }

  @override
  Widget build(BuildContext context) {
    final baseOptions = widget.options ?? const QuillToolbarBaseButtonOptions();

    return QuillToolbarCustomButton(
      controller: widget.controller,
      options: QuillToolbarCustomButtonOptions(
        icon: Icon(_getListIcon(), size: baseOptions.iconSize),
        tooltip: _isListActive ? 'Снять список' : 'Список',
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
