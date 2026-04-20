import 'dart:convert';
import 'package:belcka/pages/profile/health_and_safety/health_and_safety_service/health_and_safety_service.dart';
import 'package:belcka/pages/profile/health_and_safety/health_and_safety_service/hs_resource_types_info.dart';
import 'package:belcka/pages/profile/health_and_safety/near_miss_list/model/near_miss_report_Info.dart';
import 'package:belcka/pages/profile/health_and_safety/near_miss_reporting/controller/near_miss_reporting_repository.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as multi;

class NearMissReportingController extends GetxController{
  RxBool isDeliverySelected = true.obs;
  final _api = NearMissReportingRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = true.obs,
      isSearchEnable = false.obs,
      isClearSearch = false.obs;

  final ImagePicker picker = ImagePicker();
  final healthAndSafetyService = Get.find<HealthAndSafetyService>();

  final selectedHazard = Rxn<HSResourceTypesInfo>();

  final TextEditingController descriptionController = TextEditingController();
  bool isDataUpdated = false;
  var attachmentList = <PlatformFile>[].obs;
  var deletedAttachmentIds = <String>[].obs;

  bool isEdit = false;
  NearMissReportInfo? selectedReportToEdit;

  RxString appBarTitle = "".obs;
  RxString saveButtonTitle = "".obs;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      isEdit = arguments["isEdit"];
      selectedReportToEdit = arguments["selectedReportToEdit"];

      appBarTitle.value = "edit_near_miss_reporting";
      saveButtonTitle.value = "update_report";

      selectedHazard.value = (selectedHazard.value != null)
          ? selectedHazard.value!.copyWith(
        id: selectedReportToEdit?.hazardId ?? 0,
        title: selectedReportToEdit?.hazardName ?? "",
      )
          : HSResourceTypesInfo(
        id: selectedReportToEdit?.hazardId ?? 0,
        title: selectedReportToEdit?.hazardName ?? "",
        firstName: '',
        lastName: '',
        name: '',
        userImage: '',
        userThumbImage: '',
      );

      descriptionController.text = selectedReportToEdit?.description ?? "";

      attachmentList.value = (selectedReportToEdit?.files ?? []).map((file) {

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
      appBarTitle.value = "add_near_miss_reporting";
      saveButtonTitle.value = "submit_report";
    }

  }

  void storeNearMissReport() async {
    Map<String, dynamic> map = {
      "company_id": ApiConstants.companyId,
      "hazard_id": selectedHazard.value?.id ?? 0,
      "description": descriptionController.text.trim(),
      if (isEdit)
        "remove_attachment_ids":deletedAttachmentIds.toList(),
      if (isEdit)
        "near_miss_id":selectedReportToEdit?.id ?? 0
    };

    print("request data:" + map.toString());
    // Pre-create the list of MultipartFiles
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

    // Add the list to the map
    map["files"] = fileList;

    // Create FormData from the map containing the list
    multi.FormData formData = multi.FormData.fromMap(map);

    isLoading.value = true;
    _api.storeNearMissReportsAPI(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          BaseResponse response =
          BaseResponse.fromJson(jsonDecode(responseModel.result!));
          AppUtils.showApiResponseMessage(response.Message ?? "");
          isDataUpdated = true;
          onBackPress();
        }
        else{
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

class AppFile {
  final int? id;
  final String name;
  final String? url;
  final String? thumbUrl;
  final PlatformFile? localFile; // Holds the actual file if picked locally

  AppFile({this.id, required this.name, this.url, this.thumbUrl, this.localFile});

  bool get isRemote => url != null;
}