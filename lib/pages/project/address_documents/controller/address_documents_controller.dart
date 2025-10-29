import 'dart:convert';

import 'package:belcka/pages/check_in/check_in/model/type_of_work_resources_info.dart';
import 'package:belcka/pages/project/address_documents/controller/address_documents_repository.dart';
import 'package:belcka/pages/project/address_documents/model/address_documents_response.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../web_services/api_constants.dart';

class AddressDocumentsController extends GetxController {
  final RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;
  final RxInt selectedDateFilterIndex = (1).obs;
  final _api = AddressDocumentsRepository();
  final listItems = <TypeOfWorkResourcesInfo>[].obs;
  int selectedIndex = 0, addressId = 0;
  String startDate = "", endDate = "";
  RxString title = "".obs, displayStartDate = "".obs, displayEndDate = "".obs;
  List<TypeOfWorkResourcesInfo> tempList = [];

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      addressId = arguments[AppConstants.intentKey.addressId] ?? 0;
      title.value = arguments[AppConstants.intentKey.title]??"";
    }
    getAddressDocumentsApi(true);
  }

  void getAddressDocumentsApi(bool isProgress) {
    isLoading.value = isProgress;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    map["address_id"] = addressId;
    map["start_date"] = startDate;
    map["end_date"] = endDate;
    // map["company_id"] = 14;
    // map["address_id"] = 3;

    _api.addressDocuments(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          AddressDocumentsResponse response = AddressDocumentsResponse.fromJson(
              jsonDecode(responseModel.result!));
          tempList.clear();
          tempList.addAll(response.info ?? []);
          listItems.value = tempList;
          listItems.refresh();
          // displayStartDate.value = response.weekStartDate ?? "";
          // displayEndDate.value = response.weekEndDate ?? "";
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
        }
      },
    );
  }

  typeOfWorkDetails(TypeOfWorkResourcesInfo info) async {
    print("typeOfWorkDetails");
    var arguments = {
      AppConstants.intentKey.typeOfWorkInfo: info,
      AppConstants.intentKey.checkLogId: info.checklogId ?? 0,
      AppConstants.intentKey.afterPhotosList: info.afterAttachments ?? [],
      AppConstants.intentKey.beforePhotosList: info.beforeAttachments ?? [],
      AppConstants.intentKey.isEditable: true,
    };
    var result = await Navigator.of(Get.context!)
        .pushNamed(AppRoutes.typeOfWorkDetailsScreen, arguments: arguments);

    if (result != null) {
      getAddressDocumentsApi(true);
    }
  }

  void clearFilter() {
    startDate = "";
    endDate = "";
    selectedDateFilterIndex.value = -1;
    // getAddressDocumentsApi(true);
  }
}
