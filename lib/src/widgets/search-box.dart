import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import './gradient_touchable_container.dart';

class SearchBox extends StatelessWidget {
  final double height;

  SearchBox({@required this.height}) : assert(height >= 50);

  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Spacer(flex: 1),
        Expanded(
          flex: 8,
          child: GradientTouchableContainer(
            radius: height / 2,
            height: height,
            shadow: BoxShadow(
              color: Color(0x20FFFFFF),
              offset: Offset(0, 3),
              blurRadius: 6,
              spreadRadius: 1,
            ),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 10,
                ),
                Icon(
                  FontAwesomeIcons.sistrix,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search...',
                      hintStyle: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    cursorColor: Colors.white,
                    scrollPadding: EdgeInsets.zero,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Spacer(flex: 1),
      ],
    );
  }
}
