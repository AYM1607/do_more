import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// A custom app bar to match the DO> design rules.
///
/// This app bar is meant to be usen in screens that are not the home screen.
/// It will always contain a back button that pops the current screen.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// The title for the app bar.
  final String title;

  /// Widget to be shown on the bottom of the app bar.
  final PreferredSizeWidget bottom;

  /// The size of only the app bar part.
  final double appBarHeight;
  CustomAppBar({
    this.title = '',
    this.bottom,
  }) : appBarHeight = bottom == null ? 140.0 : 120.0;

  Size get preferredSize =>
      Size.fromHeight(appBarHeight + (bottom?.preferredSize?.height ?? 0));

  Widget build(BuildContext context) {
    Widget result = Container(
      height: preferredSize.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          IconButton(
            icon: Icon(
              FontAwesomeIcons.arrowLeft,
              color: Color.fromRGBO(112, 112, 112, 1),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
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
}
