import 'package:flutter/material.dart';

// TODO: migrate to enum https://github.com/AYM1607/do_more/issues/4
Color getColorFromPriority(int priority) {
  switch (priority) {
    case 0:
      return Color(0xFF06AD12);
      break;
    case 1:
      return Color(0xFFF6A93B);
      break;
    case 2:
      return Color(0xFFF42850);
      break;
    default:
      return Colors.white;
  }
}
