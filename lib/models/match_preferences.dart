class MatchPreferences {
  final int? maxDistance;
  final List<String>? nationalities;
  final List<String>? genders;
  final int? ageRangeMin;
  final int? ageRangeMax;
  final bool randomMatching;

  MatchPreferences({
    this.maxDistance,
    this.nationalities,
    this.genders,
    this.ageRangeMin,
    this.ageRangeMax,
    this.randomMatching = true,
  });
}