import 'package:belcka/web_services/response/module_info.dart';

class InventoryResourcesResponse {
  bool? isSuccess;
  String? message;
  List<InventoryResourceItem>? suppliers;
  List<InventoryResourceItem>? categories;
  List<ModuleInfo>? users;
  List<ModuleInfo>? projects;
  List<ModuleInfo>? addresses;

  InventoryResourcesResponse({
    this.isSuccess,
    this.message,
    this.suppliers,
    this.categories,
    this.users,
    this.projects,
    this.addresses,
  });

  factory InventoryResourcesResponse.fromJson(Map<String, dynamic> json) {
    return InventoryResourcesResponse(
      isSuccess: json['IsSuccess'],
      message: json['message'],
      suppliers: _parseResourceList(json['suppliers']),
      categories: _parseResourceList(json['categories']),
      users: _parseModuleList(json['users']),
      projects: _parseModuleList(json['projects']),
      addresses: _parseModuleList(json['addresses']),
    );
  }

  static List<InventoryResourceItem>? _parseResourceList(dynamic data) {
    if (data == null) return null;
    return (data as List)
        .map((e) => InventoryResourceItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static List<ModuleInfo>? _parseModuleList(dynamic data) {
    if (data == null) return null;
    return (data as List)
        .map((e) => ModuleInfo.fromJson(e as Map<String, dynamic>))
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
