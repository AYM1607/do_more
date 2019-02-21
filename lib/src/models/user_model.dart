import 'summary_model.dart';

class UserModel {
  final String username;
  final List<int> tasks;
  final SummaryModel summary;
  final int userId;
  final int pendingHigh;
  final int pendingMedium;
  final int pendingLow;

  UserModel({
    this.username,
    this.tasks,
    this.summary,
    this.userId,
    this.pendingHigh,
    this.pendingMedium,
    this.pendingLow,
  })  : assert(username != null),
        assert(tasks != null),
        assert(summary != null),
        assert(userId != null),
        assert(pendingHigh != null),
        assert(pendingMedium != null),
        assert(pendingLow != null);

  UserModel.fromFirestore(Map<String, dynamic> firestoreMap)
      : username = firestoreMap["username"],
        tasks = firestoreMap["tasks"].cast<int>(),
        summary = SummaryModel.fromMap(firestoreMap),
        userId = firestoreMap["userId"],
        pendingHigh = firestoreMap["pendingHigh"],
        pendingMedium = firestoreMap["pendingMedium"],
        pendingLow = firestoreMap["pendingLow"];
}
