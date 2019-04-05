import 'package:flutter/material.dart';

/// A widget that sizes its child to a fraction of the size of the screen
class FractionallyScreenSizedBox extends StatelessWidget {
  /// The child to be rendered inside the box.
  final Widget child;

  /// The fraction of the screen width the child will use.
  final double widthFactor;

  /// The fraction of the screen height the child will use.
  final double heightFactor;

  FractionallyScreenSizedBox({
    this.child,
    this.widthFactor,
    this.heightFactor,
  });

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: widthFactor != null ? widthFactor * size.width : null,
      height: heightFactor != null ? heightFactor * size.height : null,
      child: child,
    );
  }
}
