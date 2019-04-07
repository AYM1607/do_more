import 'dart:async';

import 'package:flutter/material.dart';
import './models/task_model.dart';

const kLowPriorityColor = Color(0xFF06AD12);
const kMediumPriorityColor = Color(0xFFF6A93B);
const kHighPriorityColor = Color(0xFFF42850);

const kBigTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 24,
  fontWeight: FontWeight.w600,
);
const kSmallTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 16,
  fontWeight: FontWeight.w500,
);
const kBlueGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  stops: [0, 1.0],
  colors: [Color.fromRGBO(32, 156, 227, 1.0), Color.fromRGBO(45, 83, 216, 1.0)],
);

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

class Validators {
  final validateStringNotEmpty = StreamTransformer<String, String>.fromHandlers(
    handleData: (String string, EventSink<String> sink) {
      if (string.isEmpty) {
        sink.addError('Text cannot be empty');
      } else {
        sink.add(string);
      }
    },
  );
}

/// Returns a stream transformer that sorts tasks by priority.
final StreamTransformer<List<TaskModel>, List<TaskModel>>
    kTaskListPriorityTransforemer =
    StreamTransformer.fromHandlers(handleData: (tasksList, sink) {
  tasksList.sort((a, b) => TaskModel.ecodedPriority(b.priority)
      .compareTo(TaskModel.ecodedPriority(a.priority)));
  sink.add(tasksList);
});
