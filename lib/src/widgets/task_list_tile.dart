import 'package:flutter/material.dart';

class TaskListTile extends StatelessWidget {
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: .9,
      child: Container(
        height: 116,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: 88,
                height: 25,
                decoration: BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(14),
                  ),
                ),
              ),
            )
          ],
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
        ),
      ),
    );
  }
}
