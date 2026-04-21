import 'package:belcka/pages/analytics/warnings_analytics/model/warning_item_model.dart';

class WarningsScoreModel {
  final int total;
  final List<WarningItemModel> items;
  final String startDate;
  final String endDate;

  WarningsScoreModel({
    required this.total,
    required this.items,
    required this.startDate,
    required this.endDate,
  });

  factory WarningsScoreModel.fromJson(Map<String, dynamic> json) {
    final list = (json["list"] as List<dynamic>? ?? [])
        .map((e) => WarningItemModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return WarningsScoreModel(
      total: json["total"] ?? 0,
      items: list,
      startDate: json["start_date"]?.toString() ?? "",
      endDate: json["end_date"]?.toString() ?? "",
    );
  }
}
