/// A summary of a user's week.
///
/// It represents how many tasks were completed and added by a user every day.
class SummaryModel {
  /// Amount of tasks completed on Monday.
  int completedMonday;

  /// Amount od tasks added on Monday.
  int addedMonday;

  /// Amount of tasks completed on Tuesday.
  int completedTuesday;

  /// Amount od tasks added on Tuesday.
  int addedTuesday;

  /// Amount of tasks completed on Wednesday.
  int completedWednesday;

  /// Amount od tasks added on Wednesday.
  int addedWednesday;

  /// Amount of tasks completed on Thursday.
  int completedThursday;

  /// Amount od tasks added on Thursday.
  int addedThursday;

  /// Amount of tasks completed on Friday.
  int completedFriday;

  /// Amount od tasks added on Friday.
  int addedFriday;

  SummaryModel({
    this.completedMonday = 0,
    this.addedMonday = 0,
    this.completedTuesday = 0,
    this.addedTuesday = 0,
    this.completedWednesday = 0,
    this.addedWednesday = 0,
    this.completedThursday = 0,
    this.addedThursday = 0,
    this.completedFriday = 0,
    this.addedFriday = 0,
  });

  /// Creates a [SummaryModel] from a map.
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

  /// Returns a map representation of the model.
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
