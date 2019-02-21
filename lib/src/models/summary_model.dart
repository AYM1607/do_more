class SummaryModel {
  final int completedMonday;
  final int addedMonday;
  final int completedTuesday;
  final int addedTuesday;
  final int completedWednesday;
  final int addedWednesday;
  final int completedThursday;
  final int addedThursday;
  final int completedFriday;
  final int addedFriday;

  SummaryModel({
    this.completedMonday,
    this.addedMonday,
    this.completedTuesday,
    this.addedTuesday,
    this.completedWednesday,
    this.addedWednesday,
    this.completedThursday,
    this.addedThursday,
    this.completedFriday,
    this.addedFriday,
  });

  SummaryModel.fromMap(Map<String, dynamic> map)
      : completedMonday = map["completedMonday"],
        addedMonday = map["addedMonday"],
        completedTuesday = map["completedTuesday"],
        addedTuesday = map["addedTuesday"],
        completedWednesday = map["completedWednesday"],
        addedWednesday = map["addedWednesday"],
        completedThursday = map["completedThursday"],
        addedThursday = map["addedThursday"],
        completedFriday = map["completedFriday"],
        addedFriday = map["addedFriday"];
}
