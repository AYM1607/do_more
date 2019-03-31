import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class NewItemDialogRoute extends PopupRoute {
  final WidgetBuilder builder;

  NewItemDialogRoute({@required this.builder});
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
    final result = builder(context);
    return result;
  }

  @override
  // TODO: implement transitionDuration
  Duration get transitionDuration => Duration(milliseconds: 300);
}
