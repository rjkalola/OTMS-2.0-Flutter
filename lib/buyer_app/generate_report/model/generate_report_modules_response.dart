import 'package:belcka/web_services/response/module_info.dart';

class GenerateReportModulesResponse {
  bool? isSuccess;
  String? message;
  List<ModuleInfo> projects = [];
  List<ModuleInfo> addresses = [];
  List<ModuleInfo> stores = [];
  List<ModuleInfo> suppliers = [];
  List<ModuleInfo> trades = [];
  List<ModuleInfo> users = [];
  List<ModuleInfo> teams = [];
  List<ModuleInfo> items = [];

  GenerateReportModulesResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'] as bool?;
    message = json['message'] as String?;
    projects = _mapNamedList(json['projects']);
    addresses = _mapNamedList(json['addresses']);
    stores = _mapNamedList(json['stores']);
    suppliers = _mapNamedList(json['suppliers']);
    trades = _mapNamedList(json['trades']);
    users = _mapNamedList(json['users']);
    teams = _mapTeamList(json['teams']);
    items = _mapNamedList(json['items']);
  }

  static List<ModuleInfo> _mapNamedList(dynamic raw) {
    if (raw is! List) return [];
    return raw
        .map((e) => ModuleInfo(
              id: e['id'] is int ? e['id'] as int : int.tryParse('${e['id']}'),
              name: e['name']?.toString(),
            ))
        .toList();
  }

  static List<ModuleInfo> _mapTeamList(dynamic raw) {
    if (raw is! List) return [];
    return raw
        .map((e) => ModuleInfo(
              id: e['id'] is int ? e['id'] as int : int.tryParse('${e['id']}'),
              name: (e['title'] ?? e['name'])?.toString(),
            ))
        .toList();
  }

  List<ModuleInfo> listForReportType(String reportTypeKey) {
    switch (reportTypeKey) {
      case 'project':
        return projects;
      case 'address':
        return addresses;
      case 'store':
        return stores;
      case 'supplier':
        return suppliers;
      case 'user':
        return users;
      case 'trade':
        return trades;
      case 'team':
        return teams;
      case 'item':
        return items;
      default:
        return [];
    }
  }
}
