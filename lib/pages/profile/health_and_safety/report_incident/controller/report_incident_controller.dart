import 'dart:convert';
import 'package:belcka/pages/profile/health_and_safety/health_and_safety_service/health_and_safety_service.dart';
import 'package:belcka/pages/profile/health_and_safety/health_and_safety_service/hs_resource_types_info.dart';
import 'package:belcka/pages/profile/health_and_safety/report_incident/controller/report_incident_repository.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:dio/dio.dart' as multi;

class ReportIncidentController extends GetxController{
  RxBool isDeliverySelected = true.obs;
  final _api = ReportIncidentRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isSearchEnable = false.obs,
      isClearSearch = false.obs;

  final ImagePicker picker = ImagePicker();

  final healthAndSafetyService = Get.find<HealthAndSafetyService>();

  HSResourceTypesInfo? selectedIncidentType;
  HSResourceTypesInfo? selectedThreatLevel;
  HSResourceTypesInfo? selectedUser;

  final TextEditingController descriptionController = TextEditingController();
  bool isDataUpdated = false;
  var attachmentList = <PlatformFile>[].obs;

  @override
  void onInit() {
    super.onInit();

  }
  void storeReportIncident() async {
    Map<String, dynamic> map = {
      "company_id": ApiConstants.companyId,
      "incident_type_id": selectedIncidentType?.id ?? 0,
      "threat_level_id": selectedThreatLevel?.id ?? 0,
      "notify_to": selectedUser?.id ?? 0,
      "description": descriptionController.text.trim(),
    };

    // Pre-create the list of MultipartFiles
    List<multi.MultipartFile> fileList = [];
    for (var file in attachmentList) {
      if (file.path != null) {
        fileList.add(await multi.MultipartFile.fromFile(
          file.path!,
          filename: file.name,
        ));
      }
    }

    // Add the list to the map
    map["files"] = fileList;

    // Create FormData from the map containing the list
    multi.FormData formData = multi.FormData.fromMap(map);

    isLoading.value = true;
    _api.storeReportIncidentsAPI(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          BaseResponse response =
          BaseResponse.fromJson(jsonDecode(responseModel.result!));
          AppUtils.showApiResponseMessage(response.Message ?? "");
          Get.back(result: true);
        }
        else{
          AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
        }
        isDataUpdated = true;
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          AppUtils.showApiResponseMessage('no_internet'.tr);
        }
      },
    );
  }

  Future<void> moveToScreen(String rout, dynamic arguments) async {
    var result = await Get.toNamed(rout, arguments: arguments);
    if (result != null && result) {

    }
  }
  void onBackPress() {
    Get.back(result: true);
  }
}