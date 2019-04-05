import 'package:meta/meta.dart';

/// A user's task.
///
/// Represents a task linked to a user.
class TaskModel {
  /// The task id in the database.
  final String id;

  /// The task's text.
  final String text;

  /// The priority of this task.
  final TaskPriority priority;

  /// The username of the user that owns this task.
  ///
  /// It represents an email.
  final String ownerUsername;

  /// Wether a task has been marked as done or not.
  final bool done;

  /// The name of the event that contains this task.
  final String event;

  /// Creates a task model.
  TaskModel({
    this.id,
    @required this.text,
    @required this.priority,
    @required this.ownerUsername,
    @required this.done,
    @required this.event,
  });

  /// Creates a task model from a map.
  ///
  /// The database id for the event is not provided inside the map but should
  /// always be specified.
  TaskModel.fromFirestore(Map<String, dynamic> firestoreMap,
      {@required String id})
      : id = id,
        text = firestoreMap["text"],
        priority = decodedPriority(firestoreMap["priority"]),
        ownerUsername = firestoreMap["ownerUsername"],
        done = firestoreMap["done"],
        event = firestoreMap["event"];

  /// Returns a map representation of the task.
  ///
  /// Encodes properties where required.
  Map<String, dynamic> toFirestoreMap() {
    return <String, dynamic>{
      "text": text,
      "priority": ecodedPriority(priority),
      "ownerUsername": ownerUsername,
      "done": done,
      "event": event,
    };
  }

  /// Returns a text representation of the task priority.
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

  /// Returns a [TaskPriority] from an integer.
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

  /// Returns an int from a [TaskPriority].
  static int ecodedPriority(TaskPriority priority) {
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

  /// Returns a sample [TaskModel] with mock data.
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

/// A representation of the priority of a task.
enum TaskPriority {
  high,
  medium,
  low,
  none,
}
