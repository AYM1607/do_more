import 'package:flutter/material.dart';
import './models/task_model.dart';

// TODO: migrate to enum https://github.com/AYM1607/do_more/issues/4
Color getColorFromPriority(TaskPriority priority) {
  switch (priority) {
    case TaskPriority.low:
      return Color(0xFF06AD12);
      break;
    case TaskPriority.medium:
      return Color(0xFFF6A93B);
      break;
    case TaskPriority.high:
      return Color(0xFFF42850);
      break;
    default:
      return Colors.white;
  }
}
