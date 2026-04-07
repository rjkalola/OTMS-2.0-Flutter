class HealthIssueApiItem {
  final int id;
  final String name;

  HealthIssueApiItem({required this.id, required this.name});

  factory HealthIssueApiItem.fromJson(Map<String, dynamic> json) {
    return HealthIssueApiItem(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}') ?? 0,
      name: json['name']?.toString() ?? '',
    );
  }
}
