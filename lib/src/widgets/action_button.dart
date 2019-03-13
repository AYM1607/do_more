import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  /// Function to be called when the button is pressed
  final VoidCallback onPressed;

  /// Background color of the button.
  final Color color;

  /// Text and icon color.
  final Color textColor;

  /// Icon to be placed before the text.
  final IconData leadingIconData;

  /// Icon to be placed after the text.
  final IconData trailingIconData;

  /// Text for the button.
  final String text;

  /// Width of the button.
  final double width;

  /// Height of the button.
  final double height;

  /// Border radius for the button.
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
        child: buildButtonBody(),
      ),
    );
  }

  /// Returns the button body.
  Widget buildButtonBody() {
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}
