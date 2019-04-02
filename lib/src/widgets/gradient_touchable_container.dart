import 'package:flutter/material.dart';

//TODO: Refactor to allow expansion if no width is provided.

class GradientTouchableContainer extends StatelessWidget {
  /// The border radius of the button.
  final double radius;

  /// The Widget to be contained inside the button.
  final Widget child;

  /// Height of the button.
  final double height;

  /// Width of the button.
  final double width;

  /// Function to be called when the button is pressed.
  final VoidCallback onTap;

  final BoxShadow shadow;

  GradientTouchableContainer({
    this.radius = 4,
    @required this.child,
    this.height,
    this.width,
    this.onTap,
    this.shadow,
  });

  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: width,
          height: height,
          padding: EdgeInsets.all(5),
          child: Center(
            widthFactor: 1.0,
            heightFactor: 1.0,
            child: child,
          ),
          decoration: BoxDecoration(
            boxShadow: shadow == null ? null : [shadow],
            borderRadius: BorderRadius.circular(radius),
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [
                  0,
                  1.0
                ],
                colors: [
                  Color.fromRGBO(32, 156, 227, 1.0),
                  Color.fromRGBO(45, 83, 216, 1.0)
                ]),
          ),
        ),
      ),
    );
  }
}
