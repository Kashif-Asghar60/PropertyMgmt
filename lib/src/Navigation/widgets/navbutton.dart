import 'package:flutter/material.dart';

class NavButton extends StatefulWidget {
  final String text;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final bool backbuttonSize;
  final bool hideIcon;
  NavButton({
    required this.text,
    required this.icon,
    this.hideIcon = false,
    this.isSelected = false,
    this.backbuttonSize = false,
    required this.onTap,
  });

  @override
  _NavButtonState createState() => _NavButtonState();
}

class _NavButtonState extends State<NavButton> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final containerPadding = screenWidth * 1.0 / 100.0;
    final containerMargin = screenWidth * 1.0 / 100.0;
    final iconSize = screenWidth * 1.4 / 100.0;
    final textSize = screenWidth * 1.4 / 100.0;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: EdgeInsets.all(containerPadding),
        margin: EdgeInsets.fromLTRB(
          containerMargin,
          0,
          containerMargin,
          containerMargin,
        ),
        decoration: BoxDecoration(
          color: widget.isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(iconSize),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            widget.hideIcon
                ? const SizedBox()
                : Icon(
                    widget.icon,
                    size: widget.backbuttonSize ? iconSize / 1.5 : iconSize,
                    color: widget.isSelected ? Colors.black : Colors.white,
                  ),
            widget.hideIcon
                ? const SizedBox()
                : SizedBox(width: containerPadding),
            Text(
              widget.text,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: widget.backbuttonSize ? textSize / 1.5 : textSize,
                color: widget.isSelected ? Colors.black : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
