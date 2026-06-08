class InventoryResourcesResponse {
  bool? isSuccess;
  String? message;
  List<InventoryResourceItem>? suppliers;
  List<InventoryResourceItem>? categories;

  InventoryResourcesResponse({
    this.isSuccess,
    this.message,
    this.suppliers,
    this.categories,
  });

  factory InventoryResourcesResponse.fromJson(Map<String, dynamic> json) {
    return InventoryResourcesResponse(
      isSuccess: json['IsSuccess'],
      message: json['message'],
      suppliers: _parseList(json['suppliers']),
      categories: _parseList(json['categories']),
    );
  }

  static List<InventoryResourceItem>? _parseList(dynamic data) {
    if (data == null) return null;
    return (data as List)
        .map((e) => InventoryResourceItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

class InventoryResourceItem {
  int? id;
  String? name;

  InventoryResourceItem({this.id, this.name});

  factory InventoryResourceItem.fromJson(Map<String, dynamic> json) {
    return InventoryResourceItem(
      id: json['id'],
      name: json['name'],
    );
  }
}
