import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0),
      child: Container(
        padding: EdgeInsets.all(5),
        child: Center(
          widthFactor: 1.0,
          heightFactor: 1.0,
          child: Text('My custom Button'),
        ),
        decoration: BoxDecoration(
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
    );
  }
}
