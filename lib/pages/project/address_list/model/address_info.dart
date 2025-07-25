import 'package:otm_inventory/web_services/response/module_info.dart';

class AddressInfo {
  int? id;
  String? name;
  bool? isArchived;
  bool? isDeleted;
  int? statusInt;
  String? progress;
  String? statusText;

  AddressInfo(
      {this.id,
        this.name,
        this.isArchived,
        this.isDeleted,
        this.statusInt,
        this.progress,
        this.statusText});

  AddressInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isArchived = json['is_archived'];
    isDeleted = json['is_deleted'];
    statusInt = json['status_int'];
    progress = json['progress'];
    statusText = json['status_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['is_archived'] = this.isArchived;
    data['is_deleted'] = this.isDeleted;
    data['status_int'] = this.statusInt;
    data['progress'] = this.progress;
    data['status_text'] = this.statusText;
    return data;
  }
}