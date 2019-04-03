import 'package:flutter/material.dart';

/// A widget that sizes its child to a fraction of the size of the screen
class FractionallyScreenSizedBox extends StatelessWidget {
  FractionallyScreenSizedBox({
    this.child,
    this.widthFactor,
    this.heightFactor,
  });

  final Widget child;
  final double widthFactor;
  final double heightFactor;

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: widthFactor != null ? widthFactor * size.width : null,
      height: heightFactor != null ? heightFactor * size.height : null,
      child: child,
    );
  }
}
