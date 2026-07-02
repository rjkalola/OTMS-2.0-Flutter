class UserAnalyticsScoreModel {
  final bool isSuccess;
  final String message;
  final int userId;
  final double score;
  final double kpiScore;
  final double appActivityScore;
  final double warningsScore;
  final int checkIns;
  final int stoppedWorkAutomaticallyCount;
  final int lateWorkStartedCount;
  final int unauthorizedLeaveCount;
  final int outsideWorkingArea;
  final int totalWarnings;
  final String startDate;
  final String endDate;
  final int activeCompanyId;

  UserAnalyticsScoreModel({
    required this.isSuccess,
    required this.message,
    required this.userId,
    required this.score,
    required this.kpiScore,
    required this.appActivityScore,
    required this.warningsScore,
    required this.checkIns,
    required this.stoppedWorkAutomaticallyCount,
    required this.lateWorkStartedCount,
    required this.unauthorizedLeaveCount,
    required this.outsideWorkingArea,
    required this.totalWarnings,
    required this.startDate,
    required this.endDate,
    required this.activeCompanyId,
  });

  factory UserAnalyticsScoreModel.fromJson(Map<String, dynamic> json) {
    return UserAnalyticsScoreModel(
      isSuccess: json['IsSuccess'] ?? false,
      message: json['message']?.toString() ?? '',
      userId: json['user_id'] ?? 0,
      score: _toDouble(json['score']),
      kpiScore: _toDouble(json['kpi_score']),
      appActivityScore: _toDouble(json['app_activity_score']),
      warningsScore: _toDouble(json['warnings_score']),
      checkIns: json['checkIns'] ?? 0,
      stoppedWorkAutomaticallyCount:
          json['stoppedWorkAutomaticallyCount'] ?? 0,
      lateWorkStartedCount: json['lateWorkStartedCount'] ?? 0,
      unauthorizedLeaveCount: json['unauthorizedLeaveCount'] ?? 0,
      outsideWorkingArea: json['outsideWorkingArea'] ?? 0,
      totalWarnings: json['totalWarnings'] ?? 0,
      startDate: json['start_date']?.toString() ?? '',
      endDate: json['end_date']?.toString() ?? '',
      activeCompanyId: json['active_company_id'] ?? 0,
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }
}

extension UserAnalyticsScoreFormatting on double {
  String get asScorePercent {
    if (this % 1 == 0) return toInt().toString();
    return toStringAsFixed(1);
  }
}
