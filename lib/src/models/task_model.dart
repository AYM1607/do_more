import 'package:meta/meta.dart';

class TaskModel {
  final String text;
  final int priority;
  final String ownerUsername;
  final bool done;
  final String event;

  TaskModel({
    @required this.text,
    @required this.priority,
    @required this.ownerUsername,
    @required this.done,
    @required this.event,
  });

  TaskModel.fromFirestore(Map<String, dynamic> firestoreMap)
      : text = firestoreMap["text"],
        priority = firestoreMap["priority"],
        ownerUsername = firestoreMap["ownerUsername"],
        done = firestoreMap["done"],
        event = firestoreMap["event"];
}
