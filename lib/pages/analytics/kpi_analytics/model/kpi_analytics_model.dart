class KpiAnalyticsModel {
  final int score;
  final int checkIns;
  final String startDate;
  final String endDate;

  KpiAnalyticsModel({
    required this.score,
    required this.checkIns,
    required this.startDate,
    required this.endDate,
  });

  factory KpiAnalyticsModel.fromJson(Map<String, dynamic> json) {
    return KpiAnalyticsModel(
      score: json["score"] ?? 0,
      checkIns: json["checkIns"] ?? 0,
      startDate: json["start_date"]?.toString() ?? "",
      endDate: json["end_date"]?.toString() ?? "",
    );
  }
}
