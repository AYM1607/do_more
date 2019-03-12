import 'package:meta/meta.dart';

class TaskModel {
  final String id;
  final String text;
  final int priority;
  final String ownerUsername;
  final bool done;
  final String event;

  TaskModel({
    this.id,
    @required this.text,
    @required this.priority,
    @required this.ownerUsername,
    @required this.done,
    @required this.event,
  });

  TaskModel.fromFirestore(Map<String, dynamic> firestoreMap, {String id})
      : id = id,
        text = firestoreMap["text"],
        priority = firestoreMap["priority"],
        ownerUsername = firestoreMap["ownerUsername"],
        done = firestoreMap["done"],
        event = firestoreMap["event"];

  Map<String, dynamic> toFirestoreMap() {
    return <String, dynamic>{
      "text": text,
      "priority": priority,
      "ownerUsername": ownerUsername,
      "done": done,
      "event": event,
    };
  }

  String getPriorityText() {
    switch (priority) {
      case 0:
        return 'Low';
        break;
      case 1:
        return 'Medium';
        break;
      case 2:
        return 'High';
        break;
      default:
        return 'None';
    }
  }

  @override
  int get hashCode =>
      id.hashCode ^
      text.hashCode ^
      priority.hashCode ^
      ownerUsername.hashCode ^
      done.hashCode ^
      event.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      runtimeType == other.runtimeType &&
          other is TaskModel &&
          id == other.id &&
          text == other.text &&
          priority == other.priority &&
          ownerUsername == other.ownerUsername &&
          done == other.done &&
          event == other.event;
}
