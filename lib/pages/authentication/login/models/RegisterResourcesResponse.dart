import 'package:belcka/web_services/response/module_info.dart';

class RegisterResourcesResponse {
  bool? isSuccess;
  String? message;
  List<ModuleInfo>? timezone, currency, phoneExtension, countries;

  RegisterResourcesResponse(
      {this.isSuccess,
      this.message,
      this.timezone,
      this.currency,
      this.phoneExtension,
      this.countries});

  RegisterResourcesResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['Message'];
    if (json['timezone'] != null) {
      timezone = <ModuleInfo>[];
      json['timezone'].forEach((v) {
        timezone!.add(ModuleInfo.fromJson(v));
      });
    }
    if (json['currency'] != null) {
      currency = <ModuleInfo>[];
      json['currency'].forEach((v) {
        currency!.add(ModuleInfo.fromJson(v));
      });
    }
    if (json['phone_extension'] != null) {
      phoneExtension = <ModuleInfo>[];
      json['phone_extension'].forEach((v) {
        phoneExtension!.add(ModuleInfo.fromJson(v));
      });
    }
    if (json['countries'] != null) {
      countries = <ModuleInfo>[];
      json['countries'].forEach((v) {
        countries!.add(ModuleInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['IsSuccess'] = isSuccess;
    data['Message'] = message;
    if (timezone != null) {
      data['timezone'] = timezone!.map((v) => v.toJson()).toList();
    }
    if (currency != null) {
      data['currency'] = currency!.map((v) => v.toJson()).toList();
    }
    if (phoneExtension != null) {
      data['phone_extension'] = phoneExtension!.map((v) => v.toJson()).toList();
    }
    if (countries != null) {
      data['countries'] = countries!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
