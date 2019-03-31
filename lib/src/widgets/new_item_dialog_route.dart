import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import './new_item_dialog_button.dart';

/// A transparent screen that lets you choose between creating a new task or
/// add a new picture.
class NewItemDialogRoute extends PopupRoute {
  @override
  // TODO: implement barrierColor
  Color get barrierColor => Color.fromRGBO(255, 255, 255, 0.5);

  @override
  // TODO: implement barrierDismissible
  bool get barrierDismissible => true;

  @override
  // TODO: implement barrierLabel
  String get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return _builder(context);
  }

  Widget _builder(BuildContext context) {
    // Needs to be wrapped in a material widget so all the widgets have a
    // [Theme] widget as a parent.
    return Center(
      child: Material(
        type: MaterialType.transparency,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            NewItemDialogButton(
              label: 'Task',
            ),
            SizedBox(
              width: 20,
            ),
            NewItemDialogButton(
              label: 'Media',
            ),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement transitionDuration
  Duration get transitionDuration => Duration(milliseconds: 300);
}
