import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Avatar extends StatelessWidget {
  /// The url of hte image to be displayed.
  final String imageUrl;

  /// The size of the Avatar.
  final double size;

  Avatar({
    this.imageUrl,
    this.size = 60.0,
  });

  Widget build(BuildContext context) {
    return imageUrl == null
        ? Container(
            height: size,
            width: size,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(size / 2),
            ),
            child: Center(
              child: Icon(
                FontAwesomeIcons.question,
              ),
            ),
          )
        : ClipOval(
            child: Image.network(
              imageUrl,
              height: size,
              width: size,
            ),
          );
  }
}
