import 'package:meta/meta.dart';

class EventModel {
  final String id;
  final String name;
  final int pendigTasks;
  final List<bool> when;
  final List<String> media;
  final List<String> tasks;
  final int highPriority;
  final int mediumPriority;
  final int lowPriority;

  EventModel({
    @required this.id,
    @required this.name,
    @required this.pendigTasks,
    @required this.when,
    @required this.media,
    @required this.tasks,
    @required this.highPriority,
    @required this.mediumPriority,
    @required this.lowPriority,
  });

  EventModel.fromFirestore(Map<String, dynamic> firestoreMap, String id)
      : id = id,
        name = firestoreMap["name"],
        pendigTasks = firestoreMap["pendingTasks"],
        when = firestoreMap["when"].cast<bool>(),
        media = firestoreMap["media"].cast<String>(),
        tasks = firestoreMap["tasks"].cast<String>(),
        highPriority = firestoreMap["highPriority"],
        mediumPriority = firestoreMap["mediumPriority"],
        lowPriority = firestoreMap["lowPriority"];
}
