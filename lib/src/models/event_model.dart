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
    this.id,
    @required this.name,
    @required this.pendigTasks,
    @required this.when,
    @required this.media,
    @required this.tasks,
    @required this.highPriority,
    @required this.mediumPriority,
    @required this.lowPriority,
  });

  EventModel.fromFirestore(Map<String, dynamic> firestoreMap, {String id})
      : id = id,
        name = firestoreMap["name"],
        pendigTasks = firestoreMap["pendingTasks"],
        when = firestoreMap["when"].cast<bool>(),
        media = firestoreMap["media"].cast<String>(),
        tasks = firestoreMap["tasks"].cast<String>(),
        highPriority = firestoreMap["highPriority"],
        mediumPriority = firestoreMap["mediumPriority"],
        lowPriority = firestoreMap["lowPriority"];

  Map<String, dynamic> toFirestoreMap() {
    return <String, dynamic>{
      "name": name,
      "pendingTasks": pendigTasks,
      "when": when,
      "media": media,
      "tasks": tasks,
      "highPriority": highPriority,
      "mediumPriority": mediumPriority,
      "lowPriority": lowPriority,
    };
  }

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      pendigTasks.hashCode ^
      when.hashCode ^
      media.hashCode ^
      tasks.hashCode ^
      highPriority.hashCode ^
      mediumPriority.hashCode ^
      lowPriority.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          pendigTasks == other.pendigTasks &&
          when == other.when &&
          media == other.media &&
          tasks == other.tasks &&
          highPriority == other.highPriority &&
          mediumPriority == other.mediumPriority &&
          lowPriority == other.lowPriority;
}
