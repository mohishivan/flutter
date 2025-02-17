
class MindFulModel {
  final String mood;
  final DateTime time;
  final String percentage;

  const MindFulModel(
      this.mood,
      this.time,
      this.percentage,
      );

  Map<String, dynamic> toJson() => {
    "mood": mood,
    "time": time,
    "percentage": percentage,
  };
}