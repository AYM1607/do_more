import 'package:meta/meta.dart';
import 'summary_model.dart';

/// An app user.
///
/// Represents all of a users data.
class UserModel {
  /// The document id that corresponds to the user in the database.
  final String id;

  /// The users email address.
  final String username;

  /// An array of task ids.
  final List<String> tasks;

  /// An array of event names.
  final List<String> events;

  /// Added and finished tasks for the current week.
  final SummaryModel summary;

  /// Pending high priority tasks.
  final int pendingHigh;

  /// Pendign medium priority tasks.
  final int pendingMedium;

  /// Pending low priority tasks.
  final int pendingLow;

  UserModel({
    this.id,
    @required this.username,
    @required this.tasks,
    @required this.summary,
    @required this.pendingHigh,
    @required this.pendingMedium,
    @required this.pendingLow,
    @required this.events,
  });

  ///Returns a [UserModel] from a map.
  UserModel.fromFirestore(Map<String, dynamic> firestoreMap, {String id})
      : id = id,
        username = firestoreMap["username"],
        tasks = firestoreMap["tasks"].cast<String>(),
        events = firestoreMap["events"].cast<String>(),
        summary =
            SummaryModel.fromMap(firestoreMap["summary"].cast<String, int>()),
        pendingHigh = firestoreMap["pendingHigh"],
        pendingMedium = firestoreMap["pendingMedium"],
        pendingLow = firestoreMap["pendingLow"];

  Map<String, dynamic> toFirestoreMap() {
    return <String, dynamic>{
      "username": username,
      "tasks": tasks,
      "events": events,
      "summary": summary.toMap(),
      "pendingHigh": pendingHigh,
      "pendingMedium": pendingMedium,
      "pendingLow": pendingLow,
    };
  }

  @override
  int get hashCode =>
      id.hashCode ^
      username.hashCode ^
      summary.hashCode ^
      pendingHigh.hashCode ^
      pendingMedium.hashCode ^
      pendingLow.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      runtimeType == other.runtimeType &&
          other is UserModel &&
          id == other.id &&
          username == other.username &&
          summary == other.summary &&
          pendingHigh == other.pendingHigh &&
          pendingMedium == other.pendingMedium &&
          pendingLow == other.pendingLow;
}
