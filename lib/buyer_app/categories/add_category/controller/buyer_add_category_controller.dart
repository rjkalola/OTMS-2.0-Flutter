import 'dart:convert';

import 'package:belcka/buyer_app/categories/add_category/controller/buyer_add_category_repository.dart';
import 'package:belcka/buyer_app/categories/catalogue_list/controller/buyer_catalogue_repository.dart';
import 'package:belcka/buyer_app/categories/catalogue_list/model/category_info.dart';
import 'package:belcka/pages/common/drop_down_list_dialog.dart';
import 'package:belcka/pages/common/listener/DialogButtonClickListener.dart';
import 'package:belcka/pages/common/listener/select_item_listener.dart';
import 'package:belcka/pages/common/model/Dropdown_list_response.dart';
import 'package:belcka/pages/common/model/file_info.dart';
import 'package:belcka/pages/manageattachment/controller/manage_attachment_controller.dart';
import 'package:belcka/pages/manageattachment/listener/select_attachment_listener.dart';
import 'package:belcka/utils/AlertDialogHelper.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:dio/dio.dart' as multi;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuyerAddCategoryController extends GetxController
    implements
        SelectItemListener,
        SelectAttachmentListener,
        DialogButtonClickListener {
  final _api = BuyerAddCategoryRepository();
  final _catalogueApi = BuyerCatalogueRepository();

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController().obs;
  final parentCategoryController = TextEditingController().obs;

  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isSaveEnable = false.obs,
      status = true.obs;
  RxString imageUrl = "".obs;
  RxInt parentCategoryId = 0.obs;
  final parentCategoriesList = <ModuleInfo>[].obs;
  CategoryInfo? itemDetails;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      itemDetails = arguments[AppConstants.intentKey.itemDetails];
      if (itemDetails != null) {
        nameController.value.text = itemDetails!.name ?? "";
        parentCategoryId.value = itemDetails!.parentCategoryId ?? 0;
        status.value = itemDetails!.status ?? false;
        imageUrl.value = itemDetails!.imageUrl ?? "";
      }
    }
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
          isMainViewVisible.value = true;
          for (ModuleInfo info in response.info!) {
            if (info.id == parentCategoryId.value) {
              parentCategoryController.value.text = info.name ?? "";
              break;
            }
          }
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

  void deleteCategoryApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["category_ids"] = (itemDetails?.id ?? 0).toString();
    _api.deleteCategory(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
          AppUtils.showApiResponseMessage(response.Message ?? "");
          Get.back(result: true);
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
      },
    );
  }

  showDeleteDialog() async {
    AlertDialogHelper.showAlertDialog(
        "",
        'are_you_sure_you_want_to_delete'.tr,
        'yes'.tr,
        'no'.tr,
        "",
        true,
        false,
        this,
        AppConstants.dialogIdentifier.delete);
  }

  @override
  void onNegativeButtonClicked(String dialogIdentifier) {
    Get.back();
  }

  @override
  void onOtherButtonClicked(String dialogIdentifier) {}

  @override
  void onPositiveButtonClicked(String dialogIdentifier) {
    if (dialogIdentifier == AppConstants.dialogIdentifier.delete) {
      deleteCategoryApi();
      Get.back();
    }
  }

  showAttachmentOptionsDialog() async {
    var listOptions = <ModuleInfo>[].obs;
    ModuleInfo? info;

    info = ModuleInfo();
    info.name = 'camera'.tr;
    info.action = AppConstants.attachmentType.camera;
    listOptions.add(info);

    info = ModuleInfo();
    info.name = 'gallery'.tr;
    info.action = AppConstants.attachmentType.image;
    listOptions.add(info);

    ManageAttachmentController().showAttachmentOptionsDialog(
        'select_photo_from_'.tr, listOptions, this);
  }

  @override
  void onSelectAttachment(List<String> paths, String action) {
    if (action == AppConstants.attachmentType.camera) {
      addPhotoToList(paths[0]);
    } else if (action == AppConstants.attachmentType.image) {
      addPhotoToList(paths[0]);
    }
  }

  addPhotoToList(String? path) {
    if (!StringHelper.isEmptyString(path)) {
      isSaveEnable.value = true;
      FilesInfo info = FilesInfo();
      info.imageUrl = path;
      imageUrl.value = path ?? "";
      // attachmentList.add(info);
    }
  }

  bool valid() {
    return formKey.currentState!.validate();
  }

  void addCategoryApi() async {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["id"] = itemDetails?.id ?? 0;
    map["company_id"] = ApiConstants.companyId;
    map["name"] = StringHelper.getText(nameController.value);
    map["parent_category_id"] = parentCategoryId.value;
    map["status"] = status.value;

    print("map:" + map.toString());

    multi.FormData formData = multi.FormData.fromMap(map);

    if (imageUrl.value.isNotEmpty && !imageUrl.value.startsWith("http")) {
      formData.files.add(
        MapEntry(
          "image",
          await multi.MultipartFile.fromFile(imageUrl.value,
              filename: imageUrl.value.split('/').last),
        ),
      );
    }

    isLoading.value = true;

    _api.addCategoryUpdate(
      url: itemDetails != null
          ? ApiConstants.updateCategory
          : ApiConstants.addCategory,
      formData: formData,
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
        }
      },
    );
  }

  @override
  void onSelectItem(int position, int id, String name, String action) {
    if (action == AppConstants.dialogIdentifier.selectCategory) {
      parentCategoryId.value = id;
      parentCategoryController.value.text = name;
      isSaveEnable.value = true;
    }
  }

  void onBackPress() {
    Get.back();
  }
}
