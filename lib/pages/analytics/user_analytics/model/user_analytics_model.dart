class UserAnalyticsModel {
  bool? isSuccess;
  String? message;
  int? userId;
  String? userName;
  String? userImage;
  String? userImageThumb;
  String? tradeName;
  int? tradeId;
  int? score;
  int? stoppedWorkAutomaticallyCount;
  int? stoppedWorkAutomaticallyTotal;
  int? lateWorkStartedCount;
  int? lateWorkStartedTotal;
  int? checkIns;
  int? leaves;
  int? outsideWorkingArea;
  int? outsideWorkingAreaTotal;
  String? worthMaterialUsed;
  String? currency;
  String? startDate;
  String? endDate;

  UserAnalyticsModel(
      {this.isSuccess,
        this.message,
        this.userId,
        this.userName,
        this.userImage,
        this.userImageThumb,
        this.tradeName,
        this.tradeId,
        this.score,
        this.stoppedWorkAutomaticallyCount,
        this.stoppedWorkAutomaticallyTotal,
        this.lateWorkStartedCount,
        this.lateWorkStartedTotal,
        this.checkIns,
        this.leaves,
        this.outsideWorkingArea,
        this.outsideWorkingAreaTotal,
        this.worthMaterialUsed,
        this.currency,
        this.startDate,
        this.endDate});

  UserAnalyticsModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    userId = json['user_id'];
    userName = json['user_name'];
    userImage = json['user_image'];
    userImageThumb = json['user_image_thumb'];
    tradeName = json['trade_name'];
    tradeId = json['trade_id'];
    score = json['score'];
    stoppedWorkAutomaticallyCount = json['stoppedWorkAutomaticallyCount'];
    stoppedWorkAutomaticallyTotal = json['stoppedWorkAutomaticallyTotal'];
    lateWorkStartedCount = json['lateWorkStartedCount'];
    lateWorkStartedTotal = json['lateWorkStartedTotal'];
    checkIns = json['checkIns'];
    leaves = json['leaves'];
    outsideWorkingArea = json['outsideWorkingArea'];
    outsideWorkingAreaTotal = json['outsideWorkingAreaTotal'];
    worthMaterialUsed = json['worthMaterialUsed'];
    currency = json['currency'];
    startDate = json['start_date'];
    endDate = json['end_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['message'] = this.message;
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['user_image'] = this.userImage;
    data['user_image_thumb'] = this.userImageThumb;
    data['trade_name'] = this.tradeName;
    data['trade_id'] = this.tradeId;
    data['score'] = this.score;
    data['stoppedWorkAutomaticallyCount'] = this.stoppedWorkAutomaticallyCount;
    data['stoppedWorkAutomaticallyTotal'] = this.stoppedWorkAutomaticallyTotal;
    data['lateWorkStartedCount'] = this.lateWorkStartedCount;
    data['lateWorkStartedTotal'] = this.lateWorkStartedTotal;
    data['checkIns'] = this.checkIns;
    data['leaves'] = this.leaves;
    data['outsideWorkingArea'] = this.outsideWorkingArea;
    data['outsideWorkingAreaTotal'] = this.outsideWorkingAreaTotal;
    data['worthMaterialUsed'] = this.worthMaterialUsed;
    data['currency'] = this.currency;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    return data;
  }
}

extension ScoreHelpers on UserAnalyticsModel {
  double get overallScorePercent => (score ?? 0) / 100;

  double get stoppedWorkPercent {
    if (stoppedWorkAutomaticallyTotal == 0) return 0;
    return (stoppedWorkAutomaticallyCount ?? 0) / (stoppedWorkAutomaticallyTotal ?? 0);
  }

  double get outsideAreaPercent {
    if (outsideWorkingAreaTotal == 0) return 0;
    return (outsideWorkingArea ?? 0) / (outsideWorkingAreaTotal ?? 0);
  }
}