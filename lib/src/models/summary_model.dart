/// A summary of a user's week.
///
/// It represents how many tasks were completed and added by a user every day.
class SummaryModel {
  int completedMonday;
  int addedMonday;
  int completedTuesday;
  int addedTuesday;
  int completedWednesday;
  int addedWednesday;
  int completedThursday;
  int addedThursday;
  int completedFriday;
  int addedFriday;

  SummaryModel({
    int completedMonday,
    int addedMonday,
    int completedTuesday,
    int addedTuesday,
    int completedWednesday,
    int addedWednesday,
    int completedThursday,
    int addedThursday,
    int completedFriday,
    int addedFriday,
  })  : completedMonday = completedMonday ?? 0,
        addedMonday = addedMonday ?? 0,
        completedTuesday = completedTuesday ?? 0,
        addedTuesday = addedTuesday ?? 0,
        completedWednesday = completedWednesday ?? 0,
        addedWednesday = addedWednesday ?? 0,
        completedThursday = completedThursday ?? 0,
        addedThursday = addedThursday ?? 0,
        completedFriday = completedFriday ?? 0,
        addedFriday = addedFriday ?? 0;

  /// Returns a [SummaryModel] from a map.
  SummaryModel.fromMap(Map<String, dynamic> map) {
    completedMonday = map["completedMonday"];
    addedMonday = map["addedMonday"];
    completedTuesday = map["completedTuesday"];
    addedTuesday = map["addedTuesday"];
    completedWednesday = map["completedWednesday"];
    addedWednesday = map["addedWednesday"];
    completedThursday = map["completedThursday"];
    addedThursday = map["addedThursday"];
    completedFriday = map["completedFriday"];
    addedFriday = map["addedFriday"];
  }

  Map<String, int> toMap() {
    return <String, int>{
      "completedMonday": completedMonday,
      "addedMonday": addedMonday,
      "completedTuesday": completedTuesday,
      "addedTuesday": addedTuesday,
      "completedWednesday": completedWednesday,
      "addedWednesday": addedWednesday,
      "completedThursday": completedThursday,
      "addedThursday": addedThursday,
      "completedFriday": completedFriday,
      "addedFriday": addedFriday,
    };
  }

  @override
  int get hashCode =>
      completedMonday.hashCode ^
      addedMonday.hashCode ^
      completedTuesday.hashCode ^
      addedTuesday.hashCode ^
      completedWednesday.hashCode ^
      addedWednesday.hashCode ^
      completedThursday.hashCode ^
      addedThursday.hashCode ^
      completedFriday.hashCode ^
      addedFriday.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SummaryModel &&
          runtimeType == other.runtimeType &&
          completedMonday == other.completedMonday &&
          addedMonday == other.addedMonday &&
          completedTuesday == other.completedTuesday &&
          addedTuesday == other.addedTuesday &&
          completedWednesday == other.completedWednesday &&
          addedWednesday == other.addedWednesday &&
          completedThursday == other.completedThursday &&
          addedThursday == other.addedThursday &&
          completedFriday == other.completedFriday &&
          addedFriday == other.addedFriday;
}
