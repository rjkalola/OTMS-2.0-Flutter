class ScoreSettingsModel {
  final int id;
  final int companyId;
  final List<ScoreRangeModel> ranges;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  ScoreSettingsModel({
    required this.id,
    required this.companyId,
    required this.ranges,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory ScoreSettingsModel.fromJson(Map<String, dynamic> json) {
    final rangesJson = json['ranges'] as List<dynamic>? ?? [];
    return ScoreSettingsModel(
      id: json['id'] ?? 0,
      companyId: json['company_id'] ?? 0,
      ranges: rangesJson
          .map((e) => ScoreRangeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      deletedAt: json['deleted_at']?.toString(),
    );
  }
}

class ScoreRangeModel {
  final String key;
  final String color;
  final String label;
  final int maxScore;
  final int minScore;

  ScoreRangeModel({
    required this.key,
    required this.color,
    required this.label,
    required this.maxScore,
    required this.minScore,
  });

  factory ScoreRangeModel.fromJson(Map<String, dynamic> json) {
    return ScoreRangeModel(
      key: json['key']?.toString() ?? '',
      color: json['color']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
      maxScore: json['max_score'] ?? 0,
      minScore: json['min_score'] ?? 0,
    );
  }

  String get rangeText => '$label $minScore-$maxScore';
}
