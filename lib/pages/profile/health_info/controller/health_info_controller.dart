import 'dart:convert';

import 'package:belcka/pages/common/listener/SelectPhoneExtensionListener.dart';
import 'package:belcka/pages/common/phone_extension_list_dialog.dart';
import 'package:belcka/pages/profile/health_info/controller/health_info_repository.dart';
import 'package:belcka/pages/profile/health_info/model/health_issue_api_item.dart';
import 'package:belcka/pages/profile/health_info/model/health_issue_form_item.dart';
import 'package:belcka/pages/profile/health_info/model/health_issue_saved_row.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/data_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HealthInfoController extends GetxController
    implements SelectPhoneExtensionListener {
  final _api = HealthInfoRepository();

  final formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController().obs;
  final lastNameController = TextEditingController().obs;
  final emailController = TextEditingController().obs;
  final postCodeController = TextEditingController().obs;
  final addressController = TextEditingController().obs;
  final phoneController = TextEditingController().obs;

  final heightController = TextEditingController().obs;
  final weightController = TextEditingController().obs;

  final phoneExtension = AppConstants.defaultPhoneExtension.obs;
  final phoneFlag = AppConstants.defaultFlagUrl.obs;

  RxBool isLoading = false.obs;
  RxBool isInternetNotAvailable = false.obs;
  RxBool isMainViewVisible = false.obs;

  int userId = 0;
  int? emergencyId;
  int? userOtherInfoId;

  final issueItems = <HealthIssueFormItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null) {
      final dynamic raw =
          args[AppConstants.intentKey.userId] ?? args['user_id'];
      if (raw != null) {
        userId = raw is int ? raw : int.tryParse('$raw') ?? 0;
      }
    }
    if (userId == 0) {
      userId = UserUtils.getLoginUserId();
    }
    fetchHealthData();
  }

  bool get hasExistingRecord =>
      (emergencyId != null && emergencyId! > 0) ||
      (userOtherInfoId != null && userOtherInfoId! > 0);

  void retryFetch() {
    isInternetNotAvailable.value = false;
    fetchHealthData();
  }

  void fetchHealthData() {
    isLoading.value = true;
    isMainViewVisible.value = false;
    _api.getHealthInfo(
      queryParameters: {'user_id': userId},
      onSuccess: (ResponseModel responseModel) {
        if (!responseModel.isSuccess) {
          AppUtils.showApiResponseMessage(responseModel.statusMessage ?? '');
          isLoading.value = false;
          isMainViewVisible.value = true;
          return;
        }
        try {
          final map = jsonDecode(responseModel.result!) as Map<String, dynamic>;
          if (map['IsSuccess'] != true) {
            AppUtils.showApiResponseMessage(map['message']?.toString() ?? '');
            isLoading.value = false;
            isMainViewVisible.value = true;
            return;
          }
          final dynamic info = map['info'];
          if (_shouldLoadIssueCatalog(info)) {
            if (info is Map && info.isNotEmpty) {
              _applyEmergencyFieldsFromMap(Map<String, dynamic>.from(info));
            }
            _loadIssuesCatalogAfterEmptyInfo();
          } else {
            _applySavedInfo(Map<String, dynamic>.from(info as Map));
            isLoading.value = false;
            isMainViewVisible.value = true;
          }
        } catch (_) {
          _loadIssuesCatalogAfterEmptyInfo();
        }
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
        } else if (error.statusMessage != null &&
            error.statusMessage!.isNotEmpty) {
          AppUtils.showApiResponseMessage(error.statusMessage!);
        }
      },
    );
  }

  bool _shouldLoadIssueCatalog(dynamic info) {
    if (info == null) return true;
    if (info is! Map) return true;
    if (info.isEmpty) return true;
    final rawList = info['health_info'];
    if (rawList is List && rawList.isNotEmpty) {
      return false;
    }
    return true;
  }

  void _applyEmergencyFieldsFromMap(Map<String, dynamic> info) {
    emergencyId = int.tryParse('${info['emergency_id'] ?? 0}');
    if (emergencyId == 0) emergencyId = null;

    userOtherInfoId = int.tryParse('${info['user_other_info_id'] ?? 0}');
    if (userOtherInfoId == 0) userOtherInfoId = null;

    firstNameController.value.text = info['first_name']?.toString() ?? '';
    lastNameController.value.text = info['last_name']?.toString() ?? '';
    emailController.value.text = info['email']?.toString() ?? '';
    postCodeController.value.text = info['post_code']?.toString() ?? '';
    addressController.value.text = info['address']?.toString() ?? '';
    phoneController.value.text = info['phone']?.toString() ?? '';

    final ext = info['extention']?.toString() ?? info['extension']?.toString();
    if (ext != null && ext.isNotEmpty) {
      phoneExtension.value = ext;
    }
    phoneFlag.value = AppUtils.getFlagByExtension(phoneExtension.value);

    heightController.value.text = info['height']?.toString() ?? '';
    weightController.value.text = info['weight']?.toString() ?? '';
  }

  void _loadIssuesCatalogAfterEmptyInfo() {
    _api.getHealthIssues(
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          try {
            final map =
                jsonDecode(responseModel.result!) as Map<String, dynamic>;
            if (map['IsSuccess'] != true) {
              AppUtils.showApiResponseMessage(map['message']?.toString() ?? '');
              isLoading.value = false;
              isMainViewVisible.value = true;
              return;
            }
            final list = map['info'] as List<dynamic>? ?? [];
            _disposeIssueItems();
            issueItems.clear();
            for (final raw in list) {
              final item = HealthIssueApiItem.fromJson(
                  Map<String, dynamic>.from(raw as Map));
              issueItems.add(HealthIssueFormItem(
                healthIssueId: item.id,
                name: item.name,
              ));
            }
            issueItems.refresh();
          } catch (e) {
            AppUtils.showApiResponseMessage(e.toString());
          }
        } else {
          AppUtils.showApiResponseMessage(responseModel.statusMessage ?? '');
        }
        isLoading.value = false;
        isMainViewVisible.value = true;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        isMainViewVisible.value = true;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
        } else if (error.statusMessage != null &&
            error.statusMessage!.isNotEmpty) {
          AppUtils.showApiResponseMessage(error.statusMessage!);
        }
      },
    );
  }

  void _applySavedInfo(Map<String, dynamic> info) {
    _applyEmergencyFieldsFromMap(info);

    _disposeIssueItems();
    issueItems.clear();
    final rawList = info['health_info'];
    if (rawList is List && rawList.isNotEmpty) {
      for (final raw in rawList) {
        final row =
            HealthIssueSavedRow.fromJson(Map<String, dynamic>.from(raw as Map));
        issueItems.add(HealthIssueFormItem(
          healthIssueId: row.healthIssueId,
          name: row.name,
          heathId: row.heathId,
          initialYes: row.isCheck,
          comment: row.comment,
        ));
      }
    }
    issueItems.refresh();
  }

  void _disposeIssueItems() {
    for (final i in issueItems) {
      i.dispose();
    }
  }

  @override
  void onClose() {
    firstNameController.value.dispose();
    lastNameController.value.dispose();
    emailController.value.dispose();
    postCodeController.value.dispose();
    addressController.value.dispose();
    phoneController.value.dispose();
    heightController.value.dispose();
    weightController.value.dispose();
    _disposeIssueItems();
    super.onClose();
  }

  void showPhoneExtensionDialog() {
    Get.bottomSheet(
      PhoneExtensionListDialog(
        title: 'select_country_code'.tr,
        list: DataUtils.getPhoneExtensionList(),
        listener: this,
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  @override
  void onSelectPhoneExtension(
      int id, String extension, String flag, String country) {
    phoneFlag.value = flag;
    phoneExtension.value = extension;
  }

  void setIssueYesNo(HealthIssueFormItem item, bool? value) {
    item.isYes.value = value ?? false;
    if (value != true) {
      item.commentController.clear();
    }
    issueItems.refresh();
  }

  bool valid() {
    return formKey.currentState?.validate() ?? false;
  }

  Map<String, dynamic> _buildPayload() {
    final issues = <Map<String, dynamic>>[];
    for (final item in issueItems) {
      final isCheck = item.isYes.value ? 1 : 0;
      final m = <String, dynamic>{
        'health_issue_id': item.healthIssueId,
        'is_check': isCheck,
      };
      final hid = item.heathId;
      if (hid != null && hid > 0) {
        m['heath_id'] = hid;
      }
      if (item.isYes.value) {
        m['comment'] = item.commentController.text.trim();
      }
      issues.add(m);
    }

    final phone = StringHelper.getText(phoneController.value);
    final emergencyContact = <String, dynamic>{
      'first_name': StringHelper.getText(firstNameController.value),
      'last_name': StringHelper.getText(lastNameController.value),
      'email': StringHelper.getText(emailController.value),
      'post_code': StringHelper.getText(postCodeController.value),
      'address': StringHelper.getText(addressController.value),
      'phone': phone,
    };
    emergencyContact['extension'] = phoneExtension.value;
    if (hasExistingRecord && emergencyId != null && emergencyId! > 0) {
      emergencyContact['emergency_id'] = emergencyId;
    }

    final healthInfo = <String, dynamic>{
      'height': heightController.value.text.trim(),
      'weight': weightController.value.text.trim(),
      'health_issues': issues,
    };
    if (hasExistingRecord && userOtherInfoId != null && userOtherInfoId! > 0) {
      healthInfo['user_other_info_id'] = userOtherInfoId;
    }

    return <String, dynamic>{
      'user_id': userId,
      'emergency_contact': emergencyContact,
      'health_info': healthInfo,
    };
  }

  void onSave() {
    if (!valid()) return;

    isLoading.value = true;
    final payload = jsonEncode(_buildPayload());
    void onDone(ResponseModel responseModel) {
      isLoading.value = false;
      if (responseModel.isSuccess) {
        final map = jsonDecode(responseModel.result!) as Map<String, dynamic>;
        if (map['IsSuccess'] != true) {
          AppUtils.showApiResponseMessage(map['message']?.toString() ?? '');
          return;
        }
        final response = BaseResponse.fromJson(map);
        AppUtils.showApiResponseMessage(response.Message ?? '');
        Get.back(result: true);
      } else {
        AppUtils.showApiResponseMessage(responseModel.statusMessage ?? '');
      }
    }

    void onErr(ResponseModel error) {
      isLoading.value = false;
      if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
        AppUtils.showApiResponseMessage('no_internet'.tr);
      } else if (error.statusMessage != null &&
          error.statusMessage!.isNotEmpty) {
        AppUtils.showApiResponseMessage(error.statusMessage!);
      }
    }

    if (hasExistingRecord) {
      _api.updateHealthInfo(data: payload, onSuccess: onDone, onError: onErr);
    } else {
      _api.storeHealthInfo(data: payload, onSuccess: onDone, onError: onErr);
    }
  }
}
