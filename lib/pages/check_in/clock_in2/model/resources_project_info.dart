import 'package:belcka/pages/check_in/clock_in2/model/resources_project_attachment_info.dart';

class ResourcesProjectInfo {
  int? id;
  String? name;
  int? statusNumber;
  String? treeKey;
  List<ResourcesProjectAttachmentInfo>? attachments;

  ResourcesProjectInfo(
      {this.id, this.name, this.statusNumber, this.treeKey, this.attachments});

  ResourcesProjectInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    statusNumber = json['status_number'];
    treeKey = json['tree_key'];
    if (json['attachments'] != null) {
      attachments = <ResourcesProjectAttachmentInfo>[];
      json['attachments'].forEach((v) {
        attachments!.add(new ResourcesProjectAttachmentInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['status_number'] = this.statusNumber;
    data['tree_key'] = this.treeKey;
    if (this.attachments != null) {
      data['attachments'] = this.attachments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
