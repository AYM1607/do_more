import 'package:meta/meta.dart';
import 'summary_model.dart';

/// An app user.
///
/// Represents all of a users data.
class UserModel {
  final String id;
  final String username;
  final List<String> tasks;
  final SummaryModel summary;
  final int pendingHigh;
  final int pendingMedium;
  final int pendingLow;

  UserModel({
    this.id,
    @required this.username,
    @required this.tasks,
    @required this.summary,
    @required this.pendingHigh,
    @required this.pendingMedium,
    @required this.pendingLow,
  });

  ///Returns a [UserModel] from a map.
  UserModel.fromFirestore(Map<String, dynamic> firestoreMap, {String id})
      : id = id,
        username = firestoreMap["username"],
        tasks = firestoreMap["tasks"].cast<String>(),
        summary =
            SummaryModel.fromMap(firestoreMap["summary"].cast<String, int>()),
        pendingHigh = firestoreMap["pendingHigh"],
        pendingMedium = firestoreMap["pendingMedium"],
        pendingLow = firestoreMap["pendingLow"];

  Map<String, dynamic> toFirestoreMap() {
    return <String, dynamic>{
      "username": username,
      "tasks": tasks,
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
