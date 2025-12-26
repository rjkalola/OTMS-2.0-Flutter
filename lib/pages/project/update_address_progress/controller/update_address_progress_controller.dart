import 'dart:convert';
import 'package:belcka/pages/project/address_list/model/address_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/project/address_details/model/address_details_response.dart';
import 'package:belcka/pages/project/update_address_progress/controller/update_address_progress_repository.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/response_model.dart';

class UpdateAddressProgressController extends GetxController {
  final siteAddressController = TextEditingController().obs;
  final formKey = GlobalKey<FormState>();
  final _api = UpdateAddressProgressRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isSaveEnable = false.obs;

  AddressInfo? addressDetailsInfo;

  UpdateAddressProgressController({required this.addressDetailsInfo});

  final Map<String, int> status = {
    "In Progress": 3,
    "Completed": 4,
    "To Do": 13
  };

  String selectedStatus = "To Do";
  int? selectedStatusValue = 13;
  double progress = 0;
  RxBool isUpdating = false.obs;

  @override
  void onInit() {
    super.onInit();
    isMainViewVisible.value = true;
  }

  void updateAddressProgressApi() async {
    //Get.back(result: false);
    Map<String, dynamic> map = {};
    map["id"] = addressDetailsInfo?.id ?? 0;
    map["progress"] = progress.toInt();
    //map["status"] = determineStatusFromProgress(progress);

    isLoading.value = true;
    _api.updateAddressProgress(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
          AppUtils.showApiResponseMessage(response.Message ?? "");
          Get.back(result: true);
        } else {
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
    if (selectedStatusValue == 4 && progress < 100) {
      // Show confirmation dialog
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('warning'.tr),
          content: Text(
            "${'update_progress_warning_text_one'.tr} 100% ${'update_progress_warning_text_two'.tr}. ${'update_progress_warning_text_three'.tr}?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("yes".tr),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                isUpdating.value = true;
                updateAddressProgressApi();
              },
              child: Text("no".tr),
            ),
          ],
        ),
      );
    } else {
      isUpdating.value = true;
      updateAddressProgressApi();
    }
  }

  int determineStatusFromProgress(double progress) {
    if (progress == 0) {
      return 13;
    } else if (progress == 100) {
      return 4;
    } else {
      return 3;
    }
  }
  String determineStatusTextFromProgress(double progress) {
    if (progress == 0) {
      return 'To Do';
    } else if (progress == 100) {
      return 'Completed';
    } else {
      return 'In Progress';
    }
  }
  Color getStatusColor(double progress) {
    if (progress == 0) {
      return Colors.grey;
    } else if (progress == 100) {
      return Colors.green;
    } else {
      return Colors.orange;
    }
  }
}
