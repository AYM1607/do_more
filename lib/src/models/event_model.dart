import 'package:meta/meta.dart';

/// A user's event.
///
/// Represents all the data linked to an event.
class EventModel {
  /// The event id in the database.
  final String id;

  /// The event name.
  final String name;

  /// The amount of pending tasks linked to this event.
  final int pendigTasks;

  // TODO: Create a data model for [when]. It should support both days and times.
  /// A representation of the ocurrance of this event.
  ///
  /// This list whould contain five items each representing a day of the week.
  /// If the value for a day is true then the event happens at that day.
  final List<bool> when;

  /// The media files linked to this event.
  ///
  /// The list items are data bucket paths.
  final List<String> media;

  /// The amount of high priority pending tasks linked to this event.
  final int highPriority;

  /// The amount of medium priority pending tasks linked to this event.
  final int mediumPriority;

  /// The amount of low priority pending tasks linked to this event.
  final int lowPriority;

  EventModel({
    this.id,
    @required this.name,
    @required this.pendigTasks,
    @required this.when,
    @required this.media,
    @required this.highPriority,
    @required this.mediumPriority,
    @required this.lowPriority,
  });

  /// Creates an [EventModel] from  a firestore map.
  ///
  /// The database id for the event is not provided inside the map but should
  /// always be specified.
  EventModel.fromFirestore(Map<String, dynamic> firestoreMap,
      {@required String id})
      : id = id,
        name = firestoreMap["name"],
        pendigTasks = firestoreMap["pendingTasks"],
        when = firestoreMap["when"].cast<bool>(),
        media = firestoreMap["media"].cast<String>(),
        highPriority = firestoreMap["highPriority"],
        mediumPriority = firestoreMap["mediumPriority"],
        lowPriority = firestoreMap["lowPriority"];

  /// Returns a map that contains all the event's fields.
  ///
  /// The id field does not need to be included, it is provided separately.
  Map<String, dynamic> toFirestoreMap() {
    return <String, dynamic>{
      "name": name,
      "pendingTasks": pendigTasks,
      "when": when,
      "media": media,
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
      highPriority.hashCode ^
      mediumPriority.hashCode ^
      lowPriority.hashCode;

  //  TODO: find a way to compare the 3 commented properties.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          pendigTasks == other.pendigTasks &&
          //when == other.when &&
          //media == other.media &&
          //tasks == other.tasks &&
          highPriority == other.highPriority &&
          mediumPriority == other.mediumPriority &&
          lowPriority == other.lowPriority;
}
