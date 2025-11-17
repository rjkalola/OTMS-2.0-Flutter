import 'package:belcka/web_services/response/module_info.dart';

class ExpenseResourcesResponse {
  bool? isSuccess;
  String? message;
  List<ModuleInfo>? addresses;
  List<ModuleInfo>? projects;
  List<ModuleInfo>? categories;

  ExpenseResourcesResponse(
      {this.isSuccess,
      this.message,
      this.addresses,
      this.projects,
      this.categories});

  ExpenseResourcesResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    if (json['addresses'] != null) {
      addresses = <ModuleInfo>[];
      json['addresses'].forEach((v) {
        addresses!.add(new ModuleInfo.fromJson(v));
      });
    }
    if (json['projects'] != null) {
      projects = <ModuleInfo>[];
      json['projects'].forEach((v) {
        projects!.add(new ModuleInfo.fromJson(v));
      });
    }
    if (json['categories'] != null) {
      categories = <ModuleInfo>[];
      json['categories'].forEach((v) {
        categories!.add(new ModuleInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['message'] = this.message;
    if (this.addresses != null) {
      data['addresses'] = this.addresses!.map((v) => v.toJson()).toList();
    }
    if (this.projects != null) {
      data['projects'] = this.projects!.map((v) => v.toJson()).toList();
    }
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
