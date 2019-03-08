import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Logo extends StatelessWidget {
  final Color color;

  const Logo({this.color = Colors.white});

  Widget build(BuildContext context) {
    return Container(
      width: 158,
      child: Stack(
        children: <Widget>[
          Text(
            'DO',
            style: TextStyle(
              fontFamily: 'IBM Plex Sans',
              fontSize: 80.0,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          Positioned(
            child: Icon(
              FontAwesomeIcons.angleRight,
              size: 90.0,
              color: color,
            ),
            left: 90,
            top: 5,
          ),
        ],
      ),
    );
  }
}
