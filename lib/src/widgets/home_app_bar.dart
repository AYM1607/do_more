import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import './logo.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String avatarUrl;
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
              buildTopSection(),
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

  Widget buildTopSection() {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 20,
        ),
        Icon(
          FontAwesomeIcons.bars,
          color: Colors.white,
          size: 24,
        ),
        Spacer(),
        maybeBuildAvatar(),
        SizedBox(
          width: 20,
        )
      ],
    );
  }

  Widget maybeBuildAvatar() {
    return avatarUrl == null
        ? Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: Icon(
                FontAwesomeIcons.question,
              ),
            ),
          )
        : ClipOval(
            child: Image.network(
              avatarUrl,
              height: 60,
              width: 60,
            ),
          );
  }

  @override
  final preferredSize = Size.fromHeight(220.0);
}
