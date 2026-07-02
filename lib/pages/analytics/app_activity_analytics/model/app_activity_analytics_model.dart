class AppActivityAnalyticsModel {
  final bool isSuccess;
  final String message;
  final int userId;
  final String userName;
  final String userImage;
  final String userImageThumb;
  final String tradeName;
  final int tradeId;
  final double score;
  final int totalWorklogs;
  final int stoppedWorkAutomaticallyCount;
  final int lateWorkStartedCount;
  final int unauthorizedLeaveCount;
  final int outsideWorkingArea;
  final String worthMaterialUsed;
  final String currency;
  final String startDate;
  final String endDate;
  final int? activeCompanyId;

  AppActivityAnalyticsModel({
    required this.isSuccess,
    required this.message,
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.userImageThumb,
    required this.tradeName,
    required this.tradeId,
    required this.score,
    required this.totalWorklogs,
    required this.stoppedWorkAutomaticallyCount,
    required this.lateWorkStartedCount,
    required this.unauthorizedLeaveCount,
    required this.outsideWorkingArea,
    required this.worthMaterialUsed,
    required this.currency,
    required this.startDate,
    required this.endDate,
    required this.activeCompanyId,
  });

  factory AppActivityAnalyticsModel.fromJson(Map<String, dynamic> json) {
    return AppActivityAnalyticsModel(
      isSuccess: json['IsSuccess'] ?? false,
      message: json['message']?.toString() ?? '',
      userId: json['user_id'] ?? 0,
      userName: json['user_name']?.toString() ?? '',
      userImage: json['user_image']?.toString() ?? '',
      userImageThumb: json['user_image_thumb']?.toString() ?? '',
      tradeName: json['trade_name']?.toString() ?? '',
      tradeId: json['trade_id'] ?? 0,
      score: _toDouble(json['score']),
      totalWorklogs: json['total_worklogs'] ?? 0,
      stoppedWorkAutomaticallyCount:
          json['stoppedWorkAutomaticallyCount'] ?? 0,
      lateWorkStartedCount: json['lateWorkStartedCount'] ?? 0,
      unauthorizedLeaveCount: json['unauthorizedLeaveCount'] ?? 0,
      outsideWorkingArea: json['outsideWorkingArea'] ?? 0,
      worthMaterialUsed: json['worthMaterialUsed']?.toString() ?? '0.00',
      currency: json['currency']?.toString() ?? '',
      startDate: json['start_date']?.toString() ?? '',
      endDate: json['end_date']?.toString() ?? '',
      activeCompanyId: json['active_company_id'],
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }
}
