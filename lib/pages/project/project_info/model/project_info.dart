import 'package:otm_inventory/web_services/response/module_info.dart';

class ProjectInfo {
  int? id;
  String? name;
  String? address;
  String? budget;
  String? code;
  String? description;
  bool? isArchive;
  bool? status;
  List<ModuleInfo>? shifts;
  List<ModuleInfo>? teams;
  int? addresses;
  int? trades;
  String? currency;

  ProjectInfo(
      {this.id,
        this.name,
        this.address,
        this.budget,
        this.code,
        this.description,
        this.isArchive,
        this.status,
        this.shifts,
        this.teams,
        this.addresses,
        this.trades,
        this.currency});

  ProjectInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    budget = json['budget'];
    code = json['code'];
    description = json['description'];
    isArchive = json['is_archive'];
    status = json['status'];
    addresses = json['addresses'];
    trades = json['trades'];
    currency = json['currency'];

    if (json['shifts'] != null) {
      shifts = <ModuleInfo>[];
      json['shifts'].forEach((v) {
        shifts!.add(new ModuleInfo.fromJson(v));
      });
    }
    if (json['teams'] != null) {
      teams = <ModuleInfo>[];
      json['teams'].forEach((v) {
        teams!.add(new ModuleInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['address'] = this.address;
    data['budget'] = this.budget;
    data['code'] = this.code;
    data['description'] = this.description;
    data['is_archive'] = this.isArchive;
    data['status'] = this.status;
    data['addresses'] = this.addresses;
    data['trades'] = this.trades;
    data['currency'] = this.currency;

    if (this.shifts != null) {
      data['shifts'] = this.shifts!.map((v) => v.toJson()).toList();
    }
    if (this.teams != null) {
      data['teams'] = this.teams!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
