class WarningItemModel {
  final int id;
  final String title;
  final String incidentType;
  final String date;

  WarningItemModel({
    required this.id,
    required this.title,
    required this.incidentType,
    required this.date,
  });

  factory WarningItemModel.fromJson(Map<String, dynamic> json) {
    return WarningItemModel(
      id: json["id"] ?? 0,
      title: json["title"]?.toString() ?? "",
      incidentType: json["incident_type"]?.toString() ?? "",
      date: json["date"]?.toString() ?? "",
    );
  }
}
