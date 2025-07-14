import 'package:otm_inventory/pages/filter/model/filter_item_model.dart';

class FilterSection {
  final String key;
  final String name;
  List<FilterItem> data;

  FilterSection({required this.key, required this.name, required this.data});

  factory FilterSection.fromJson(Map<String, dynamic> json) {
    return FilterSection(
      key: json['key'],
      name: json['name'],
      data: (json['data'] as List).map((e) => FilterItem.fromJson(e)).toList(),
    );
  }
}