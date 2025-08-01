import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/project/address_details/model/address_details_info.dart';
import 'package:otm_inventory/pages/project/update_address_progress/controller/update_address_progress_repository.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/web_services/api_constants.dart';
import 'package:otm_inventory/web_services/response/base_response.dart';
import 'package:otm_inventory/web_services/response/response_model.dart';

class UpdateAddressProgressController extends GetxController{
  final siteAddressController = TextEditingController().obs;
  final formKey = GlobalKey<FormState>();
  final _api = UpdateAddressProgressRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isSaveEnable = false.obs;

  AddressDetailsInfo? addressDetailsInfo;

  UpdateAddressProgressController({required this.addressDetailsInfo});

  final Map<String, int> status = {
    "In Progress": 3,
    "Completed": 4,
    "Pending": 13
  };

  String selectedStatus = "Pending";
  int? selectedStatusValue = 13;
  double progress = 0;

  @override
  void onInit() {
    super.onInit();
    isMainViewVisible.value = true;
  }
  void updateAddressProgressApi() async {
    Get.back(result: true);
    Map<String, dynamic> map = {};
    map["id"] = addressDetailsInfo?.id ?? 0;
    map["progress"] = progress;
    map["status"] = determineStatusFromProgress(progress);

    isLoading.value = true;
    _api.updateAddressProgress(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          BaseResponse response =
          BaseResponse.fromJson(jsonDecode(responseModel.result!));
          AppUtils.showApiResponseMessage(response.Message ?? "");

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
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showApiResponseMessage(error.statusMessage);
        }
      },
    );
  }
  void onSavePressed(BuildContext context) {
    if (selectedStatus == "Completed" && progress < 100) {
      // Show confirmation dialog
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Warning"),
          content: Text(
            "You have to mark progress 100% to complete the task. Do you want to modify the progress?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                updateAddressProgressApi();
              },
              child: Text("No"),
            ),
          ],
        ),
      );
    }
    else{
      updateAddressProgressApi();
    }
  }
  int determineStatusFromProgress(double progress) {
    if (progress == 0) {
      return 13;
    }
    else if (progress == 100) {
      return 4;
    }
    else{
      return 3;
    }
  }
}