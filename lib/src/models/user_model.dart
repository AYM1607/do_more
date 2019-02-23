import 'summary_model.dart';

/// An app user.
///
/// Represents all of a users data.
class UserModel {
  final String id;
  final String username;
  final List<int> tasks;
  final SummaryModel summary;
  final int userId;
  final int pendingHigh;
  final int pendingMedium;
  final int pendingLow;

  UserModel({
    this.id,
    this.username,
    this.tasks,
    this.summary,
    this.userId,
    this.pendingHigh,
    this.pendingMedium,
    this.pendingLow,
  })  : assert(id != null),
        assert(username != null),
        assert(tasks != null),
        assert(summary != null),
        assert(userId != null),
        assert(pendingHigh != null),
        assert(pendingMedium != null),
        assert(pendingLow != null);

  ///Returns a [UserModel] from a map.
  UserModel.fromFirestore(Map<String, dynamic> firestoreMap, {String id})
      : id = id,
        username = firestoreMap["username"],
        tasks = firestoreMap["tasks"].cast<int>(),
        summary =
            SummaryModel.fromMap(firestoreMap["summary"].cast<String, int>()),
        userId = firestoreMap["userId"],
        pendingHigh = firestoreMap["pendingHigh"],
        pendingMedium = firestoreMap["pendingMedium"],
        pendingLow = firestoreMap["pendingLow"];
}
