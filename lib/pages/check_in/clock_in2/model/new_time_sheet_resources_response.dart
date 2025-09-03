import 'package:belcka/pages/check_in/clock_in2/model/resources_project_address_info.dart';
import 'package:belcka/pages/check_in/clock_in2/model/resources_project_info.dart';
import 'package:belcka/pages/check_in/clock_in2/model/resources_shift_info.dart';

class NewTimeSheetResourcesResponse {
  bool? isSuccess;
  String? message;
  String? currencyName;
  List<ResourcesProjectInfo>? projects;
  List<ResourcesShiftInfo>? shifts;
  List<ResourcesProjectAddressInfo>? projectAddresses;

  NewTimeSheetResourcesResponse(
      {this.isSuccess,
      this.message,
      this.currencyName,
      this.projects,
      this.shifts,
      this.projectAddresses});

  NewTimeSheetResourcesResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['Message'];
    currencyName = json['currency_name'];
    if (json['projects'] != null) {
      projects = <ResourcesProjectInfo>[];
      json['projects'].forEach((v) {
        projects!.add(new ResourcesProjectInfo.fromJson(v));
      });
    }
    if (json['shifts'] != null) {
      shifts = <ResourcesShiftInfo>[];
      json['shifts'].forEach((v) {
        shifts!.add(new ResourcesShiftInfo.fromJson(v));
      });
    }
    if (json['project_addresses'] != null) {
      projectAddresses = <ResourcesProjectAddressInfo>[];
      json['project_addresses'].forEach((v) {
        projectAddresses!.add(new ResourcesProjectAddressInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['Message'] = this.message;
    data['currency_name'] = this.currencyName;
    if (this.projects != null) {
      data['projects'] = this.projects!.map((v) => v.toJson()).toList();
    }
    if (this.shifts != null) {
      data['shifts'] = this.shifts!.map((v) => v.toJson()).toList();
    }
    if (this.projectAddresses != null) {
      data['project_addresses'] =
          this.projectAddresses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
