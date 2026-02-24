import 'package:belcka/pages/project/project_info/model/geofence_info.dart';
import 'package:belcka/web_services/response/module_info.dart';

class ProjectInfo {
  int? id;
  int? companyId;
  String? name;
  String? address;
  String? budget;
  String? code;
  String? description;
  bool? isArchive;
  bool? status;
  List<ModuleInfo>? shifts;
  List<ModuleInfo>? teams;
  List<GeofenceInfo>? geoFences;
  int? addresses;
  int? trades;
  String? currency;
  int? completeAddress;
  int? checkIns;
  bool? isActive;

  ProjectInfo(
      {this.id,
      this.companyId,
      this.name,
      this.address,
      this.budget,
      this.code,
      this.description,
      this.isArchive,
      this.status,
      this.shifts,
      this.teams,
      this.geoFences,
      this.addresses,
      this.trades,
      this.currency,
      this.checkIns,
      this.completeAddress,
      this.isActive});

  ProjectInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
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
    checkIns = json['check_ins'];
    completeAddress = json['complete_address'];
    isActive = json['is_active'];

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
    if (json['geofences'] != null) {
      geoFences = <GeofenceInfo>[];
      json['geofences'].forEach((v) {
        geoFences!.add(new GeofenceInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['company_id'] = this.companyId;
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
    data['check_ins'] = this.checkIns;
    data['complete_address'] = this.completeAddress;
    data['is_active'] = this.isActive;

    if (this.shifts != null) {
      data['shifts'] = this.shifts!.map((v) => v.toJson()).toList();
    }
    if (this.teams != null) {
      data['teams'] = this.teams!.map((v) => v.toJson()).toList();
    }
    if (this.geoFences != null) {
      data['geofences'] = this.geoFences!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
