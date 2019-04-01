import 'package:flutter/material.dart';

class BigTextInput extends StatelessWidget {
  final double height;
  final double width;

  BigTextInput({
    this.height,
    this.width,
  });

  Widget build(BuildContext context) {
    return Material(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 100,
          minHeight: 50,
        ),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: TextField(
            maxLines: 3,
            maxLength: 220,
            maxLengthEnforced: true,
            cursorColor: Theme.of(context).cursorColor,
            textInputAction: TextInputAction.done,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0),
              counterStyle: TextStyle(color: Colors.white),
              hintText: 'Do something...',
              hintStyle: TextStyle(
                color: Theme.of(context).cursorColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
