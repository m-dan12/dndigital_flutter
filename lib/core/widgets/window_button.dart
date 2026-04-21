import 'package:flutter/material.dart';

class WindowButton extends StatefulWidget {
  const WindowButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.isClose = false,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final bool isClose;

  @override
  State<WindowButton> createState() => _WindowButtonState();
}

class _WindowButtonState extends State<WindowButton> {
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
