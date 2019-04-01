import 'package:meta/meta.dart';

class TaskModel {
  final String id;
  final String text;
  final TaskPriority priority;
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
        priority = decodedPriority(firestoreMap["priority"]),
        ownerUsername = firestoreMap["ownerUsername"],
        done = firestoreMap["done"],
        event = firestoreMap["event"];

  Map<String, dynamic> toFirestoreMap() {
    return <String, dynamic>{
      "text": text,
      "priority": ecodedPriority(),
      "ownerUsername": ownerUsername,
      "done": done,
      "event": event,
    };
  }

  String getPriorityText() {
    switch (priority) {
      case TaskPriority.low:
        return 'Low';
        break;
      case TaskPriority.medium:
        return 'Medium';
        break;
      case TaskPriority.high:
        return 'High';
        break;
      default:
        return 'None';
    }
  }

  static TaskPriority decodedPriority(int priority) {
    switch (priority) {
      case 0:
        return TaskPriority.low;
        break;
      case 1:
        return TaskPriority.medium;
        break;
      case 2:
        return TaskPriority.high;
        break;
      default:
        return TaskPriority.none;
    }
  }

  int ecodedPriority() {
    switch (priority) {
      case TaskPriority.low:
        return 0;
        break;
      case TaskPriority.medium:
        return 1;
        break;
      case TaskPriority.high:
        return 2;
        break;
      default:
        return -1;
    }
  }

  static TaskModel sample() {
    return TaskModel(
      id: '1',
      text:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut.',
      done: false,
      ownerUsername: 'testUser',
      event: 'testEvent',
      priority: TaskPriority.medium,
    );
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

enum TaskPriority {
  high,
  medium,
  low,
  none,
}
