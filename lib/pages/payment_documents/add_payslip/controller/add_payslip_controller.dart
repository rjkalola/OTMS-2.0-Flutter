import 'dart:convert';

import 'package:belcka/pages/common/listener/DialogButtonClickListener.dart';
import 'package:belcka/pages/common/listener/select_date_listener.dart';
import 'package:belcka/pages/common/model/file_info.dart';
import 'package:belcka/pages/manageattachment/controller/manage_attachment_controller.dart';
import 'package:belcka/pages/manageattachment/listener/select_attachment_listener.dart';
import 'package:belcka/pages/payment_documents/add_invoice/controller/add_invoice_repository.dart';
import 'package:belcka/pages/payment_documents/add_invoice/model/invoice_info.dart';
import 'package:belcka/pages/payment_documents/add_payslip/controller/add_payslip_repository.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/date_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:dio/dio.dart' as multi;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddPayslipController extends GetxController
    implements
        SelectDateListener,
        DialogButtonClickListener,
        SelectAttachmentListener {
  final fromDateController = TextEditingController().obs;
  final toDateController = TextEditingController().obs;

  DateTime? fromDate, toDate;

  final formKey = GlobalKey<FormState>();
  final _api = AddPayslipRepository();

  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = true.obs,
      isSaveEnable = false.obs;
  RxInt payslipId = 0.obs;
  RxString fileUrl = "".obs;

  int userId = UserUtils.getLoginUserId();
  final invoiceInfo = InvoiceInfo().obs;
  var attachment = FilesInfo().obs;

  bool fromNotification = false;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      payslipId.value = arguments[AppConstants.intentKey.ID] ?? 0;
      userId = arguments[AppConstants.intentKey.userId] ?? 0;
      fromNotification =
          arguments[AppConstants.intentKey.fromNotification] ?? false;
      // expenseInfo = arguments[AppConstants.intentKey.expenseInfo];
    }
    // getExpenseResourcesApi();
  }

  void addPayslipApi() async {
    Map<String, dynamic> map = {};
    map["user_id"] = userId;
    map["company_id"] = ApiConstants.companyId;
    map["from_date"] = StringHelper.getText(fromDateController.value);
    map["to_date"] = StringHelper.getText(toDateController.value);

    multi.FormData formData = multi.FormData.fromMap(map);
    print("reques value:" + map.toString());

    if (!StringHelper.isEmptyString(fileUrl.value) &&
        !fileUrl.value.startsWith("http")) {
      formData.files.add(
        MapEntry(
          "file_name",
          await multi.MultipartFile.fromFile(
            fileUrl.value,
          ),
        ),
      );
    }

    isLoading.value = true;
    _api.payslipsAdd(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
          AppUtils.showToastMessage(response.Message ?? "");
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

  bool valid() {
    return formKey.currentState!.validate();
  }

  void showDatePickerDialog(String dialogIdentifier, DateTime? date,
      DateTime firstDate, DateTime lastDate) {
    DateUtil.showDatePickerDialog(
        initialDate: date,
        firstDate: firstDate,
        lastDate: lastDate,
        dialogIdentifier: dialogIdentifier,
        selectDateListener: this);
  }

  @override
  void onSelectDate(DateTime date, String dialogIdentifier) {
    if (dialogIdentifier == AppConstants.dialogIdentifier.startDate) {
      fromDate = date;
      fromDateController.value.text =
          DateUtil.dateToString(date, DateUtil.DD_MM_YYYY_SLASH);
      isSaveEnable.value = true;
    } else if (dialogIdentifier == AppConstants.dialogIdentifier.endDate) {
      final fromDateOnly = getDateOnly(fromDate!);
      final toDateOnly = getDateOnly(date);
      if (!toDateOnly.isBefore(fromDateOnly)) {
        toDate = date;
        toDateController.value.text =
            DateUtil.dateToString(date, DateUtil.DD_MM_YYYY_SLASH);
        isSaveEnable.value = true;
      } else {
        AppUtils.showToastMessage('error_wrong_to_date_selection'.tr);
      }
    }
  }

  DateTime getDateOnly(DateTime inputDate) {
    return DateTime(inputDate.year, inputDate.month, inputDate.day);
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

    info = ModuleInfo();
    info.name = 'pdf'.tr;
    info.action = AppConstants.attachmentType.pdf;
    listOptions.add(info);

    ManageAttachmentController().showAttachmentOptionsDialog(
        'select_photo_from_'.tr, listOptions, this);
  }

  @override
  void onSelectAttachment(List<String> paths, String action) {
    isSaveEnable.value = true;
    if (action == AppConstants.attachmentType.camera) {
      addPhotoToList(paths[0]);
    } else if (action == AppConstants.attachmentType.pdf) {
      for (var path in paths) {
        addPhotoToList(path);
      }
    } else if (action == AppConstants.attachmentType.image) {
      addPhotoToList(paths[0]);
      // for (var path in paths) {
      //   addPhotoToList(path);
      // }
    }
  }

  addPhotoToList(String? path) {
    if (!StringHelper.isEmptyString(path)) {
      FilesInfo info = FilesInfo();
      info.imageUrl = path;
      fileUrl.value = path ?? "";
      // attachmentList.add(info);
    }
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
      Get.back();
      // deleteExpenseApi();
    }
  }

  void onBackPress() {
    if (fromNotification) {
      Get.offAllNamed(AppRoutes.dashboardScreen);
    } else {
      Get.back();
    }
  }
}
