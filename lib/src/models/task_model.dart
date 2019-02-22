import 'package:meta/meta.dart';

class TaskModel {
  final String id;
  final String text;
  final int priority;
  final String ownerUsername;
  final bool done;
  final String event;

  TaskModel({
    @required this.id,
    @required this.text,
    @required this.priority,
    @required this.ownerUsername,
    @required this.done,
    @required this.event,
  });

  TaskModel.fromFirestore(Map<String, dynamic> firestoreMap, String id)
      : id = id,
        text = firestoreMap["text"],
        priority = firestoreMap["priority"],
        ownerUsername = firestoreMap["ownerUsername"],
        done = firestoreMap["done"],
        event = firestoreMap["event"];
}
