import 'dart:math';

import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final double radius;
  final Widget child;
  final double height;
  final double width;
  final onTap;
  GradientButton({
    this.radius = 4,
    @required this.child,
    this.height,
    this.width,
    this.onTap,
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
