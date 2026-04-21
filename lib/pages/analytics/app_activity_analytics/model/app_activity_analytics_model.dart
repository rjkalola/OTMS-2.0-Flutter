class AppActivityAnalyticsModel {
  final int userId;
  final int score;
  final int totalWorklogs;
  final int stoppedWorkAutomaticallyCount;
  final int lateWorkStartedCount;
  final int unauthorizedLeaveCount;
  final int outsideWorkingArea;
  final String startDate;
  final String endDate;

  AppActivityAnalyticsModel({
    required this.userId,
    required this.score,
    required this.totalWorklogs,
    required this.stoppedWorkAutomaticallyCount,
    required this.lateWorkStartedCount,
    required this.unauthorizedLeaveCount,
    required this.outsideWorkingArea,
    required this.startDate,
    required this.endDate,
  });

  factory AppActivityAnalyticsModel.fromJson(Map<String, dynamic> json) {
    return AppActivityAnalyticsModel(
      userId: json["user_id"] ?? 0,
      score: json["score"] ?? 0,
      totalWorklogs: json["total_worklogs"] ?? 0,
      stoppedWorkAutomaticallyCount: json["stoppedWorkAutomaticallyCount"] ?? 0,
      lateWorkStartedCount: json["lateWorkStartedCount"] ?? 0,
      unauthorizedLeaveCount: json["unauthorizedLeaveCount"] ?? 0,
      outsideWorkingArea: json["outsideWorkingArea"] ?? 0,
      startDate: json["start_date"]?.toString() ?? "",
      endDate: json["end_date"]?.toString() ?? "",
    );
  }
}
