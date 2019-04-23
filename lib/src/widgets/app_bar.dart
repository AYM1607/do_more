import 'package:flutter/material.dart' hide AppBar;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// A custom app bar to match the DO> design rules.
///
/// This app bar is meant to be usen in screens that are not the home screen.
/// It will always contain a back button that pops the current screen.
class AppBar extends StatelessWidget implements PreferredSizeWidget {
  /// The title for the app bar.
  final String title;

  /// Widget to be shown on the bottom of the app bar.
  final PreferredSizeWidget bottom;

  /// The size of only the app bar part.
  ///
  /// It will vary depending on the existance of the bottom widget.
  final double _appBarHeight;

  /// Whether to show a back button or a menu button.
  final bool hasDrawer;
  AppBar({
    this.title = '',
    this.bottom,
    this.hasDrawer = false,
  }) : _appBarHeight = bottom == null ? 140.0 : 120.0;

  /// The preferred size of the app bar.
  ///
  /// Consider the size of the bottom widget if there is one.
  Size get preferredSize =>
      Size.fromHeight(_appBarHeight + (bottom?.preferredSize?.height ?? 0));

  Widget build(BuildContext context) {
    Widget result = Container(
      height: preferredSize.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          buildButton(context),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );

    if (bottom != null) {
      result = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 140.0),
              child: result,
            ),
          ),
          bottom,
        ],
      );
    }
    return Material(
      elevation: 10.0,
      child: Container(
        color: Theme.of(context).canvasColor,
        child: SafeArea(
          child: result,
        ),
      ),
    );
  }

  Widget buildButton(BuildContext context) {
    return IconButton(
      icon: hasDrawer
          ? Icon(
              FontAwesomeIcons.bars,
            )
          : Icon(
              FontAwesomeIcons.arrowLeft,
              color: Color.fromRGBO(112, 112, 112, 1),
            ),
      onPressed: hasDrawer
          ? () => Scaffold.of(context).openDrawer()
          : () => Navigator.of(context).pop(),
    );
  }
}
