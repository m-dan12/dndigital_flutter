import 'package:flutter/material.dart';

const double _kDnbIconSize = 20;
const double _kDnbCornerRadius = 4;
const EdgeInsets _kDnIconButtonPadding = EdgeInsets.all(8);
const EdgeInsets _kDnButtonPadding = EdgeInsets.symmetric(
  horizontal: 16,
  vertical: 8,
);

/// Компактная иконочная кнопка
class DnIconButton extends IconButton {
  const DnIconButton({
    super.key,
    required super.onPressed,
    required super.icon,
    super.color,
    super.tooltip,
    double? iconSize,
    super.focusNode,
    super.autofocus = false,
    super.isSelected,
    super.selectedIcon,
    super.style,
  }) : super(
         iconSize: iconSize ?? _kDnbIconSize,
         padding: _kDnIconButtonPadding,
         constraints: const BoxConstraints(),
       );
}

/// Иконка окна
class DnWindowButton extends StatefulWidget {
  const DnWindowButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.isClose = false,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final bool isClose;

  @override
  State<DnWindowButton> createState() => _DnWindowButtonState();
}

class _DnWindowButtonState extends State<DnWindowButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final defaultColor = widget.isClose ? Colors.redAccent : null;
    final hoverColor = widget.isClose ? Colors.white : null;

    return SizedBox(
      width: 46,
      height: double.infinity,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: InkWell(
          onTap: widget.onPressed,
          hoverColor: widget.isClose ? Colors.red.shade400 : null,
          child: Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              border: Border(left: BorderSide(color: Colors.black12, width: 1)),
            ),
            child: Icon(
              widget.icon,
              size: 18,
              color: _isHovered ? hoverColor : defaultColor,
            ),
          ),
        ),
      ),
    );
  }
}

/// Компактная текстовая кнопка (решение без const-конфликта)
class DnTextButton extends TextButton {
  DnTextButton({
    super.key,
    required super.onPressed,
    required super.child,
    ButtonStyle? style,
  }) : super(
         // Если передали свой стиль — используем его, иначе дефолт
         style: style ?? _defaultStyle,
       );

  // Статический стиль (не const, потому что TextButton.styleFrom не const)
  static final ButtonStyle _defaultStyle = TextButton.styleFrom(
    padding: _kDnButtonPadding,
    minimumSize: Size.zero,
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(_kDnbCornerRadius)),
    ),
  );
}

/// Компактная elevated кнопка
class DnElevatedButton extends ElevatedButton {
  DnElevatedButton({
    super.key,
    required super.onPressed,
    required super.child,
    ButtonStyle? style,
  }) : super(
         style:
             style ??
             ElevatedButton.styleFrom(
               padding: _kDnButtonPadding,
               minimumSize: Size.zero,
               tapTargetSize: MaterialTapTargetSize.shrinkWrap,
               shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.all(
                   Radius.circular(_kDnbCornerRadius),
                 ),
               ),
             ),
       );
}

/// Компактная outlined кнопка
class DnOutlinedButton extends OutlinedButton {
  DnOutlinedButton({
    super.key,
    required super.onPressed,
    required super.child,
    ButtonStyle? style,
  }) : super(
         style:
             style ??
             OutlinedButton.styleFrom(
               padding: _kDnButtonPadding,
               minimumSize: Size.zero,
               tapTargetSize: MaterialTapTargetSize.shrinkWrap,
               shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.all(
                   Radius.circular(_kDnbCornerRadius),
                 ),
               ),
             ),
       );
}
