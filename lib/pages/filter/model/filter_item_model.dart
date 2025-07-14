class FilterItem {
  final int id;
  final String name;
  bool selected;

  FilterItem({required this.id, required this.name, this.selected = false});

  factory FilterItem.fromJson(Map<String, dynamic> json) {
    return FilterItem(
      id: json['id'],
      name: json['name'],
    );
  }
}