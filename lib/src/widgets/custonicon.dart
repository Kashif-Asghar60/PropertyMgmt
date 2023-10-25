import 'package:flutter/material.dart';

class HoverIconButton extends StatefulWidget {
  final IconData icon;
  final Color defaultColor , splashColor;
  final Color hoverColor;
  final double iconSize;
  final VoidCallback? onPressed;

  HoverIconButton({
    required this.icon,
    required this.defaultColor, required this.splashColor,
    required this.hoverColor,
    required this.iconSize,
    this.onPressed,
  });

  @override
  _HoverIconButtonState createState() => _HoverIconButtonState();
}

class _HoverIconButtonState extends State<HoverIconButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: widget.splashColor   ,
      onHover: (hover) {
        setState(() {
          isHovered = hover;
        });
      },
      onTap: widget.onPressed,
      child: Icon(
        
        widget.icon,
        color: isHovered ? widget.hoverColor : widget.defaultColor,
        size: widget.iconSize,
      ),
    );
  }
}
