import 'package:flutter/material.dart';
import './models/task_model.dart';

const kLowPriorityColor = Color(0xFF06AD12);
const kMediumPriorityColor = Color(0xFFF6A93B);
const kHighPriorityColor = Color(0xFFF42850);

Color getColorFromPriority(TaskPriority priority) {
  switch (priority) {
    case TaskPriority.low:
      return kLowPriorityColor;
      break;
    case TaskPriority.medium:
      return kMediumPriorityColor;
      break;
    case TaskPriority.high:
      return kHighPriorityColor;
      break;
    default:
      return Colors.white;
  }
}
