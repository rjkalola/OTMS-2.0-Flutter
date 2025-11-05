import 'package:belcka/pages/project/project_info/model/project_info.dart';

class ProjectListResponse {
  bool? isSuccess;
  String? message;
  int? id;
  String? name;
  List<ProjectInfo>? info;

  ProjectListResponse(
      {this.isSuccess, this.message, this.id, this.name, this.info});

  ProjectListResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    id = json['id'];
    name = json['name'];
    if (json['info'] != null) {
      info = <ProjectInfo>[];
      json['info'].forEach((v) {
        info!.add(new ProjectInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['message'] = this.message;
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.info != null) {
      data['info'] = this.info!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
