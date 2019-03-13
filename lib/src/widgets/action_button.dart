import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;
  final IconData leadingIconData;
  final IconData trailingIconData;
  final String text;
  final double width;
  final double height;
  final double radius;

  ActionButton({
    this.onPressed,
    this.color = const Color(0xFF2C2F34),
    this.textColor = Colors.white,
    this.leadingIconData,
    this.trailingIconData,
    this.width,
    this.height,
    this.radius = 6.0,
    @required this.text,
  });

  Widget build(BuildContext context) {
    final children = <Widget>[];
    if (leadingIconData != null) {
      children.addAll([
        Icon(
          leadingIconData,
          color: textColor,
          size: 16,
        ),
        SizedBox(
          width: 3,
        )
      ]);
    }
    children.add(
      Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
    if (trailingIconData != null) {
      children.addAll([
        SizedBox(
          width: 3,
        ),
        Icon(
          trailingIconData,
          color: textColor,
          size: 14,
        ),
      ]);
    }
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 25,
        minWidth: 60,
      ),
      child: Container(
        width: width,
        height: height,
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
      ),
    );
  }
}
