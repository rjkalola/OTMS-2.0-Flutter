class HealthIssueSavedRow {
  final int heathId;
  final String name;
  final int healthIssueId;
  final bool isCheck;
  final String? comment;

  HealthIssueSavedRow({
    required this.heathId,
    required this.name,
    required this.healthIssueId,
    required this.isCheck,
    this.comment,
  });

  factory HealthIssueSavedRow.fromJson(Map<String, dynamic> json) {
    final dynamic raw = json['is_check'];
    bool check = false;
    if (raw is bool) {
      check = raw;
    } else if (raw is int) {
      check = raw == 1;
    } else if (raw is String) {
      check = raw == '1' || raw.toLowerCase() == 'true';
    }
    return HealthIssueSavedRow(
      heathId: json['heath_id'] is int
          ? json['heath_id'] as int
          : int.tryParse('${json['heath_id']}') ?? 0,
      name: json['name']?.toString() ?? '',
      healthIssueId: json['health_issue_id'] is int
          ? json['health_issue_id'] as int
          : int.tryParse('${json['health_issue_id']}') ?? 0,
      isCheck: check,
      comment: json['comment']?.toString(),
    );
  }
}
