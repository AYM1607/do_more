import 'package:flutter/material.dart';

mixin Tile {
  BoxDecoration tileDecoration(Color color) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(8),
        bottomRight: Radius.circular(8),
      ),
    );
  }
}
