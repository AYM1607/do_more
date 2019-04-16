import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import './logo.dart';
import './avatar.dart';

//TODO: Add callback for the menu button.

/// Custom app bar with avatar and menu button.
///
/// Only to be used in the home scree.
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Url for the user avatar.
  ///
  /// A placeholder is shown if null.
  final String avatarUrl;

  /// Text to be shown as a subtitle.
  final String subtitle;

  HomeAppBar({
    this.avatarUrl,
    this.subtitle = '',
  });

  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      child: SafeArea(
        top: true,
        child: Container(
          height: preferredSize.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              buildTopSection(context),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.only(left: 30),
                child: Logo(),
              ),
              Padding(
                padding: EdgeInsets.only(left: 30),
                child: Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTopSection(BuildContext context) {
    final scaffolContext = Scaffold.of(context);

    return Row(
      children: <Widget>[
        SizedBox(
          width: 20,
        ),
        IconButton(
          onPressed: () => scaffolContext.openDrawer(),
          icon: Icon(
            FontAwesomeIcons.bars,
            size: 24,
          ),
          color: Colors.white,
        ),
        Spacer(),
        Avatar(
          imageUrl: avatarUrl,
        ),
        SizedBox(
          width: 20,
        )
      ],
    );
  }

  @override
  final preferredSize = Size.fromHeight(220.0);
}
