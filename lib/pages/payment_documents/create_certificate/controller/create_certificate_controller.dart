import 'dart:convert';
import 'dart:io';

import 'package:belcka/pages/common/drop_down_list_dialog.dart';
import 'package:belcka/pages/common/listener/select_date_listener.dart';
import 'package:belcka/pages/common/listener/select_item_listener.dart';
import 'package:belcka/pages/manageattachment/controller/manage_attachment_controller.dart';
import 'package:belcka/pages/manageattachment/listener/select_attachment_listener.dart';
import 'package:belcka/pages/payment_documents/create_certificate/controller/create_certificate_repository.dart';
import 'package:belcka/pages/payment_documents/create_certificate/model/certificate_courses_response.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/date_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:dio/dio.dart' as multi;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateCertificateController extends GetxController
    implements SelectDateListener, SelectItemListener, SelectAttachmentListener {
  static const int maxDocumentNumberLength = 30;
  static const int maxFileSizeBytes = 10 * 1024 * 1024;

  final documentTypeController = TextEditingController().obs;
  final expiryDateController = TextEditingController().obs;
  final documentNumberController = TextEditingController().obs;

  final formKey = GlobalKey<FormState>();
  final _api = CreateCertificateRepository();

  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;

  RxString filePath = "".obs;
  RxString selectedFileName = "".obs;

  final coursesList = <ModuleInfo>[].obs;
  int courseId = 0;
  DateTime? expiryDate;

  @override
  void onInit() {
    super.onInit();
    loadCourses(true);
  }

  void loadCourses(bool isProgress) {
    isLoading.value = isProgress;

    _api.getCourses(
      queryParameters: {},
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          CertificateCoursesResponse response =
              CertificateCoursesResponse.fromJson(
                  jsonDecode(responseModel.result!));
          coursesList
            ..clear()
            ..addAll(response.info ?? []);
          isMainViewVisible.value = true;
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage ?? "");
        }
      },
    );
  }

  void createCertificateApi() async {
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    map["course_id"] = courseId;
    map["document_number"] =
        StringHelper.getText(documentNumberController.value);
    map["expiry_date"] = StringHelper.getText(expiryDateController.value);

    multi.FormData formData = multi.FormData.fromMap(map);

    if (!StringHelper.isEmptyString(filePath.value) &&
        !filePath.value.startsWith("http")) {
      formData.files.add(
        MapEntry(
          "file",
          await multi.MultipartFile.fromFile(filePath.value),
        ),
      );
    }

    isLoading.value = true;
    _api.createCertificate(
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

  bool valid() => formKey.currentState!.validate();

  void showDocumentTypeDialog() {
    if (coursesList.isNotEmpty) {
      showDropDownDialog(
        AppConstants.dialogIdentifier.selectCourse,
        'document_type'.tr,
        coursesList,
        this,
      );
    } else {
      AppUtils.showToastMessage('empty_data_message'.tr);
    }
  }

  void showDropDownDialog(String dialogType, String title,
      List<ModuleInfo> list, SelectItemListener listener) {
    Get.bottomSheet(
      DropDownListDialog(
        title: title,
        dialogType: dialogType,
        list: list,
        listener: listener,
        isCloseEnable: true,
        isSearchEnable: true,
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  @override
  void onSelectItem(int position, int id, String name, String action) {
    if (action == AppConstants.dialogIdentifier.selectCourse) {
      documentTypeController.value.text = name;
      courseId = id;
    }
  }

  void showExpiryDatePicker() {
    DateUtil.showDatePickerDialog(
      initialDate: expiryDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      dialogIdentifier: AppConstants.dialogIdentifier.selectDate,
      selectDateListener: this,
    );
  }

  @override
  void onSelectDate(DateTime date, String dialogIdentifier) {
    if (dialogIdentifier == AppConstants.dialogIdentifier.selectDate) {
      expiryDate = date;
      expiryDateController.value.text =
          DateUtil.dateToString(date, DateUtil.DD_MM_YYYY_SLASH);
    }
  }

  void showAttachmentOptionsDialog() {
    final listOptions = <ModuleInfo>[
      ModuleInfo(
        name: 'camera'.tr,
        action: AppConstants.attachmentType.camera,
      ),
      ModuleInfo(
        name: 'gallery'.tr,
        action: AppConstants.attachmentType.image,
      ),
      ModuleInfo(
        name: 'pdf'.tr,
        action: AppConstants.attachmentType.pdf,
      ),
    ];

    ManageAttachmentController().showAttachmentOptionsDialog(
      'upload_file'.tr,
      listOptions,
      this,
    );
  }

  @override
  void onSelectAttachment(List<String> paths, String action) {
    if (paths.isEmpty) return;
    final path = paths.first;
    if (!_isAllowedFile(path)) {
      AppUtils.showToastMessage('certificate_invalid_file_type'.tr);
      return;
    }
    final file = File(path);
    if (!file.existsSync()) return;
    if (file.lengthSync() > maxFileSizeBytes) {
      AppUtils.showToastMessage('certificate_file_size_exceeded'.tr);
      return;
    }
    filePath.value = path;
    selectedFileName.value = path.split('/').last;
  }

  bool _isAllowedFile(String path) {
    final lower = path.toLowerCase();
    return lower.endsWith('.pdf') ||
        lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png');
  }

  void removeFile() {
    filePath.value = "";
    selectedFileName.value = "";
  }

  void onSavePressed() {
    if (!valid()) return;
    if (courseId == 0) {
      AppUtils.showToastMessage('please_select_document_type'.tr);
      return;
    }
    if (StringHelper.isEmptyString(filePath.value)) {
      AppUtils.showToastMessage('please_select_attachment'.tr);
      return;
    }
    createCertificateApi();
  }

  void onBackPress() => Get.back();
}
