import 'dart:convert';
import 'package:belcka/pages/profile/health_and_safety/health_and_safety_service/health_and_safety_service.dart';
import 'package:belcka/pages/profile/health_and_safety/health_and_safety_service/hs_resource_types_info.dart';
import 'package:belcka/pages/profile/health_and_safety/report_incident/controller/report_incident_repository.dart';
import 'package:belcka/pages/profile/health_and_safety/report_incidents_list/model/incident_report_info.dart';
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
  final _api = ReportIncidentRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isSearchEnable = false.obs,
      isClearSearch = false.obs;

  final ImagePicker picker = ImagePicker();

  final healthAndSafetyService = Get.find<HealthAndSafetyService>();

  final selectedIncidentType = Rxn<HSResourceTypesInfo>();
  final selectedThreatLevel = Rxn<HSResourceTypesInfo>();
  final selectedUser = Rxn<HSResourceTypesInfo>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  bool isDataUpdated = false;
  var attachmentList = <PlatformFile>[].obs;
  var deletedAttachmentIds = <String>[].obs;

  bool isEdit = false;
  IncidentReportInfo? selectedIncidentToEdit;

  RxString appBarTitle = "".obs;
  RxString saveButtonTitle = "".obs;

  @override
  void onInit() {
    super.onInit();

    var arguments = Get.arguments;
    if (arguments != null) {
      isEdit = arguments["isEdit"];
      selectedIncidentToEdit = arguments["selectedIncidentToEdit"];

      appBarTitle.value = "edit_report_incident";
      saveButtonTitle.value = "update_incident";

      titleController.text = selectedIncidentToEdit?.title ?? "";

      //Incident type
      selectedIncidentType.value = (selectedIncidentType.value != null)
          ? selectedIncidentType.value!.copyWith(
        id: selectedIncidentToEdit?.incidentTypeId ?? 0,
        title: selectedIncidentToEdit?.incidentType ?? "",
      )
          : HSResourceTypesInfo(
        id: selectedIncidentToEdit?.incidentTypeId ?? 0,
        title: selectedIncidentToEdit?.incidentType ?? "",
        firstName: '',
        lastName: '',
        name: '',
        userImage: '',
        userThumbImage: '',
      );

      //Threat Level
      selectedThreatLevel.value = (selectedThreatLevel.value != null)
          ? selectedThreatLevel.value!.copyWith(
        id: selectedIncidentToEdit?.threatLevelId ?? 0,
        title: selectedIncidentToEdit?.threatLevel ?? "",
      )
          : HSResourceTypesInfo(
        id: selectedIncidentToEdit?.threatLevelId ?? 0,
        title: selectedIncidentToEdit?.threatLevel ?? "",
        firstName: '',
        lastName: '',
        name: '',
        userImage: '',
        userThumbImage: '',
      );

      //Notify to
      selectedUser.value = (selectedUser.value != null)
          ? selectedUser.value!.copyWith(
        id: selectedIncidentToEdit?.notifyTo ?? 0,
        title: selectedIncidentToEdit?.notifyToName ?? "",
      )
          : HSResourceTypesInfo(
        id: selectedIncidentToEdit?.notifyTo ?? 0,
        title: selectedIncidentToEdit?.notifyToName ?? "",
        firstName: '',
        lastName: '',
        name: '',
        userImage: '',
        userThumbImage: '',
      );

      attachmentList.value = (selectedIncidentToEdit?.files ?? []).map((file) {

        String fileNameFromUrl = Uri.parse(file.imageUrl ?? '').pathSegments.last;

        return PlatformFile(
            identifier:"${file.id}",
            name:fileNameFromUrl,
            size: 0,
            path: file.imageUrl
        );
      }).toList();

    }
    else{
      appBarTitle.value = "add_report_incident";
      saveButtonTitle.value = "report_incident";
    }

  }
  void storeReportIncident() async {
    Map<String, dynamic> map = {
      "company_id": ApiConstants.companyId,
      'title': titleController.text.trim(),
      "incident_type_id": selectedIncidentType.value?.id ?? 0,
      "threat_level_id": selectedThreatLevel.value?.id ?? 0,
      "notify_to": selectedUser.value?.id ?? 0,
      if (isEdit)
        "remove_attachment_ids":deletedAttachmentIds.toList(),
      if (isEdit)
        "report_incident_id":selectedIncidentToEdit?.id ?? 0
    };

    List<multi.MultipartFile> fileList = [];
    for (var file in attachmentList) {
      if ((int.tryParse(file.identifier ?? "") ?? 0) > 0){

      }
      else{
        if (file.path != null) {
          fileList.add(await multi.MultipartFile.fromFile(
            file.path!,
            filename: file.name,
          ));
        }
      }
    }

    print("request data:" + map.toString());

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
          isDataUpdated = true;
          onBackPress();
        }
        else {
          AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
        }
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
    Get.back(result: isDataUpdated);
  }
}