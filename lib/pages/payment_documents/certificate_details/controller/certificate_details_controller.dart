import 'dart:convert';
import 'dart:io';

import 'package:belcka/pages/common/listener/DialogButtonClickListener.dart';
import 'package:belcka/pages/manageattachment/controller/manage_attachment_controller.dart';
import 'package:belcka/pages/manageattachment/listener/select_attachment_listener.dart';
import 'package:belcka/pages/manageattachment/view/pdf_viewer_page.dart';
import 'package:belcka/pages/payment_documents/certificate_details/controller/certificate_details_repository.dart';
import 'package:belcka/pages/payment_documents/certificate_details/model/certificate_detail_response.dart';
import 'package:belcka/pages/payment_documents/certificate_details/view/widgets/replace_certificate_bottom_sheet.dart';
import 'package:belcka/pages/payment_documents/certificates_list/model/certificate_info.dart';
import 'package:belcka/utils/AlertDialogHelper.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/data_utils.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:dio/dio.dart' as multi;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CertificateDetailsController extends GetxController
    implements DialogButtonClickListener, SelectAttachmentListener {
  static const int maxReplaceFileSizeBytes = 10 * 1024 * 1024;

  final _api = CertificateDetailsRepository();

  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isDataUpdated = false.obs;

  final certificateInfo = CertificateInfo().obs;
  int certificateId = 0;
  String iconColorHex = DataUtils.listColors.first;

  bool get isInsuranceCertificate => certificateInfo.value.isInsurance;

  final replaceFilePath = "".obs;
  final replaceSelectedFileName = "".obs;

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    if (arguments != null) {
      certificateId = arguments[AppConstants.intentKey.ID] ?? 0;
      iconColorHex = arguments[AppConstants.intentKey.certificateIconColor] ??
          DataUtils.listColors.first;
    }
    loadCertificateDetail(true);
  }

  void loadCertificateDetail(bool isProgress) {
    isLoading.value = isProgress;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    map["id"] = certificateId;

    _api.getCertificateDetail(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          CertificateDetailResponse response =
              CertificateDetailResponse.fromJson(
                  jsonDecode(responseModel.result!));
          certificateInfo.value = response.info ?? CertificateInfo();
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

  void onViewDocument() {
    final url = certificateInfo.value.fileUrl ?? "";
    if (StringHelper.isEmptyString(url)) {
      AppUtils.showToastMessage('empty_data_message'.tr);
      return;
    }
    if (url.toLowerCase().endsWith('.pdf')) {
      Get.to(() => PdfViewerPage(url: url));
    } else {
      ImageUtils.openAttachment(Get.context!, url, 'image');
    }
  }

  void onReplaceDocument() {
    removeReplaceFile();
    Get.bottomSheet(
      ReplaceCertificateBottomSheet(controller: this),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  void showReplaceAttachmentOptionsDialog() {
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
    if (!_isAllowedReplaceFile(path)) {
      AppUtils.showToastMessage('certificate_invalid_file_type'.tr);
      return;
    }
    final file = File(path);
    if (!file.existsSync()) return;
    if (file.lengthSync() > maxReplaceFileSizeBytes) {
      AppUtils.showToastMessage('certificate_file_size_exceeded'.tr);
      return;
    }
    replaceFilePath.value = path;
    replaceSelectedFileName.value = path.split('/').last;
  }

  bool _isAllowedReplaceFile(String path) {
    final lower = path.toLowerCase();
    return lower.endsWith('.pdf') ||
        lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png');
  }

  void removeReplaceFile() {
    replaceFilePath.value = "";
    replaceSelectedFileName.value = "";
  }

  void onReplaceDocumentSubmit() {
    if (StringHelper.isEmptyString(replaceFilePath.value)) {
      AppUtils.showToastMessage('please_select_attachment'.tr);
      return;
    }
    if (Get.isBottomSheetOpen ?? false) {
      Get.back();
    }
    replaceCertificateApi();
  }

  Future<void> replaceCertificateApi() async {
    isLoading.value = true;

    final map = <String, dynamic>{
      "company_id": ApiConstants.companyId,
      "id": certificateId,
    };
    final formData = multi.FormData.fromMap(map);
    formData.files.add(
      MapEntry(
        "file",
        await multi.MultipartFile.fromFile(replaceFilePath.value),
      ),
    );

    _api.replaceCertificate(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
          AppUtils.showToastMessage(response.Message ?? "");
          isDataUpdated.value = true;
          removeReplaceFile();
          loadCertificateDetail(true);
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? "");
          isLoading.value = false;
        }
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          AppUtils.showApiResponseMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage ?? "");
        }
      },
    );
  }

  void onDeleteDocument() {
    AlertDialogHelper.showAlertDialog(
      "",
      'are_you_sure_you_want_to_delete'.tr,
      'yes'.tr,
      'no'.tr,
      "",
      true,
      false,
      this,
      AppConstants.dialogIdentifier.delete,
    );
  }

  void deleteCertificateApi() {
    isLoading.value = true;
    final data = {"id": certificateId};

    _api.deleteCertificate(
      data: data,
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
        if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage ?? "");
        }
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
      Get.back();
      deleteCertificateApi();
    }
  }

  void onBackPress() {
    Get.back(result: isDataUpdated.value);
  }
}
