import 'dart:convert';
import 'package:belcka/buyer_app/categories/add_category/controller/add_category_repository.dart';
import 'package:belcka/buyer_app/categories/catalogue_list/controller/buyer_catalogue_repository.dart';
import 'package:belcka/pages/common/drop_down_list_dialog.dart';
import 'package:belcka/pages/common/listener/select_item_listener.dart';
import 'package:belcka/pages/common/model/Dropdown_list_response.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as multi;

class AddCategoryController extends GetxController
    implements SelectItemListener {
  final _api = AddCategoryRepository();
  final _catalogueApi = BuyerCatalogueRepository();

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController().obs;
  final parentCategoryController = TextEditingController().obs;

  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = true.obs,
      isEnabled = true.obs,
      isSaveEnable = false.obs;

  RxString imageUrl = "".obs;
  RxInt parentCategoryId = 0.obs;
  final parentCategoriesList = <ModuleInfo>[].obs;

  @override
  void onInit() {
    super.onInit();
    getParentCategoriesApi();
  }

  void getParentCategoriesApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    _catalogueApi.buyerCatalogueList(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          DropdownListResponse response =
              DropdownListResponse.fromJson(jsonDecode(responseModel.result!));
          parentCategoriesList.value = response.info!;
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
      },
    );
  }

  void showParentCategoryDialog() {
    if (parentCategoriesList.isNotEmpty) {
      Get.bottomSheet(
          DropDownListDialog(
            title: 'parent_category'.tr,
            dialogType: AppConstants.dialogIdentifier.selectCategory,
            list: parentCategoriesList,
            listener: this,
            isCloseEnable: true,
            isSearchEnable: true,
          ),
          backgroundColor: Colors.transparent,
          isScrollControlled: true);
    } else {
      AppUtils.showToastMessage('empty_data_message'.tr);
    }
  }

  void showAttachmentOptionsDialog() {
    // ImageUtils.showAttachmentOptionsDialog(Get.context!, (path, type) {
    //   imageUrl.value = path;
    // });
  }

  bool valid() {
    return formKey.currentState!.validate();
  }

  void addCategoryApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    map["name"] = nameController.value.text;
    map["parent_id"] = parentCategoryId.value;
    map["status"] = isEnabled.value ? 1 : 0;
    map["image"] = imageUrl.value;

    multi.FormData formData = multi.FormData.fromMap(map);
    // print("reques value:" + map.toString());
    // print("mCompanyLogo.value:" + mCompanyLogo.value.toString());
    //
    // if (!StringHelper.isEmptyString(mCompanyLogo.value) &&
    //     !mCompanyLogo.startsWith("http")) {
    //   // final mimeType = lookupMimeType(file. path);
    //   formData.files.add(
    //     MapEntry("company_image",
    //         await multi.MultipartFile.fromFile(mCompanyLogo.value)),
    //   );
    // }

    _api.addCategory(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
          AppUtils.showToastMessage(response.Message ?? "");
          Get.back(result: true);
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        AppUtils.showSnackBarMessage(error.statusMessage ?? "");
      },
    );
  }

  @override
  void onSelectItem(int position, int id, String name, String action) {
    if (action == AppConstants.dialogIdentifier.selectCategory) {
      parentCategoryId.value = id;
      parentCategoryController.value.text = name;
    }
  }

  void onBackPress() {
    Get.back();
  }
}
