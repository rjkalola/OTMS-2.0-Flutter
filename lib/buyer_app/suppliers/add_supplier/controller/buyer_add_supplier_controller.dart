import 'dart:convert';

import 'package:belcka/buyer_app/suppliers/add_supplier/controller/buyer_add_supplier_repository.dart';
import 'package:belcka/buyer_app/suppliers/supplier_list/models/supplier_info.dart';
import 'package:belcka/pages/common/listener/DialogButtonClickListener.dart';
import 'package:belcka/pages/common/listener/SelectPhoneExtensionListener.dart';
import 'package:belcka/pages/common/model/file_info.dart';
import 'package:belcka/pages/common/phone_extension_list_dialog.dart';
import 'package:belcka/pages/manageattachment/controller/manage_attachment_controller.dart';
import 'package:belcka/pages/manageattachment/listener/select_attachment_listener.dart';
import 'package:belcka/utils/AlertDialogHelper.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/data_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:dio/dio.dart' as multi;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuyerAddSupplierController extends GetxController
    implements
        DialogButtonClickListener,
        SelectPhoneExtensionListener,
        SelectAttachmentListener {
  final _api = BuyerAddSupplierRepository();

  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController().obs;
  final emailController = TextEditingController().obs;
  final companyNameController = TextEditingController().obs;
  final accountNumberController = TextEditingController().obs;
  final contactPersonNameController = TextEditingController().obs;
  final contactPersonEmailController = TextEditingController().obs;
  final contactPersonPhoneController = TextEditingController().obs;
  final streetController = TextEditingController().obs;
  final locationController = TextEditingController().obs;
  final townController = TextEditingController().obs;
  final postcodeController = TextEditingController().obs;
  final phoneController = TextEditingController().obs;

  final phoneExtension = AppConstants.defaultPhoneExtension.obs;
  final phoneFlag = AppConstants.defaultFlagUrl.obs;

  final contactPersonExtension = AppConstants.defaultPhoneExtension.obs;
  final contactPersonFlag = AppConstants.defaultFlagUrl.obs;

  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = true.obs,
      isSaveEnable = false.obs,
      status = true.obs;

  RxString imageUrl = "".obs;

  SupplierInfo? itemDetails;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      itemDetails = arguments[AppConstants.intentKey.itemDetails];
      if (itemDetails != null) {
        nameController.value.text = itemDetails!.name ?? "";
        emailController.value.text = itemDetails!.email ?? "";
        companyNameController.value.text = itemDetails!.companyName ?? "";
        accountNumberController.value.text = itemDetails!.accountNumber ?? "";
        contactPersonNameController.value.text =
            itemDetails!.contactPersonName ?? "";
        contactPersonEmailController.value.text =
            itemDetails!.contactPersonEmail ?? "";
        contactPersonPhoneController.value.text =
            itemDetails!.contactPersonPhone ?? "";
        streetController.value.text = itemDetails!.street ?? "";
        locationController.value.text = itemDetails!.location ?? "";
        townController.value.text = itemDetails!.town ?? "";
        postcodeController.value.text = itemDetails!.postcode ?? "";
        phoneController.value.text = itemDetails!.phone ?? "";

        phoneExtension.value = itemDetails!.extension ?? phoneExtension.value;
        phoneFlag.value =
            AppUtils.getFlagByExtension(itemDetails!.extension ?? "");

        contactPersonExtension.value =
            itemDetails!.contactPersonExtension ?? contactPersonExtension.value;
        contactPersonFlag.value = AppUtils.getFlagByExtension(
            itemDetails!.contactPersonExtension ?? "");

        status.value = itemDetails!.status ?? false;
        imageUrl.value = itemDetails!.imageUrl ?? "";
      }
    }
  }

  void showDeleteDialog() async {
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

  void deleteSupplierApi() {
    if (itemDetails == null) {
      return;
    }
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["supplier_ids"] = (itemDetails?.id ?? 0).toString();
    _api.deleteSupplier(
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

  @override
  void onNegativeButtonClicked(String dialogIdentifier) {
    Get.back();
  }

  @override
  void onOtherButtonClicked(String dialogIdentifier) {}

  @override
  void onPositiveButtonClicked(String dialogIdentifier) {
    if (dialogIdentifier == AppConstants.dialogIdentifier.delete) {
      deleteSupplierApi();
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

  void addOrUpdateSupplierApi() async {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["id"] = itemDetails?.id ?? 0;
    map["company_id"] = ApiConstants.companyId;
    map["name"] = StringHelper.getText(nameController.value);
    map["email"] = StringHelper.getText(emailController.value);
    map["company_name"] = StringHelper.getText(companyNameController.value);
    map["account_number"] = StringHelper.getText(accountNumberController.value);
    map["street"] = StringHelper.getText(streetController.value);
    map["location"] = StringHelper.getText(locationController.value);
    map["town"] = StringHelper.getText(townController.value);
    map["postcode"] = StringHelper.getText(postcodeController.value);
    map["phone"] = StringHelper.getText(phoneController.value);
    map["extension"] = phoneExtension.value;
    map["status"] = status.value;
    map["contact_person_email"] =
        StringHelper.getText(contactPersonEmailController.value);
    map["contact_person_name"] =
        StringHelper.getText(contactPersonNameController.value);
    map["contact_person_extension"] = contactPersonExtension.value;
    map["contact_person_phone"] =
        StringHelper.getText(contactPersonPhoneController.value);

    multi.FormData formData = multi.FormData.fromMap(map);

    if (imageUrl.value.isNotEmpty && !imageUrl.value.startsWith("http")) {
      formData.files.add(
        MapEntry(
          "supplier_image",
          await multi.MultipartFile.fromFile(imageUrl.value,
              filename: imageUrl.value.split('/').last),
        ),
      );
    }

    _api.addOrUpdateSupplier(
      url: itemDetails != null
          ? ApiConstants.updateSupplier
          : ApiConstants.createSupplier,
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

  void showPhoneExtensionDialog({required bool isContactPerson}) {
    Get.bottomSheet(
        PhoneExtensionListDialog(
            title: 'select_country_code'.tr,
            list: DataUtils.getPhoneExtensionList(),
            listener: _PhoneExtensionProxyListener(this, isContactPerson)),
        backgroundColor: Colors.transparent,
        isScrollControlled: true);
  }

  @override
  void onSelectPhoneExtension(
      int id, String extension, String flag, String country) {}

  void onSelectPhoneExtensionInternal(
      int id, String extension, String flag, String country,
      {required bool isContactPerson}) {
    if (isContactPerson) {
      contactPersonFlag.value = flag;
      contactPersonExtension.value = extension;
    } else {
      phoneFlag.value = flag;
      phoneExtension.value = extension;
    }
    isSaveEnable.value = true;
  }

  void onBackPress() {
    Get.back();
  }
}

class _PhoneExtensionProxyListener extends SelectPhoneExtensionListener {
  final BuyerAddSupplierController controller;
  final bool isContactPerson;

  _PhoneExtensionProxyListener(this.controller, this.isContactPerson);

  @override
  void onSelectPhoneExtension(
      int id, String extension, String flag, String country) {
    controller.onSelectPhoneExtensionInternal(
      id,
      extension,
      flag,
      country,
      isContactPerson: isContactPerson,
    );
  }
}
