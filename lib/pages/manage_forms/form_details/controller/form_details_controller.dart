import 'dart:convert';

import 'package:belcka/pages/manage_forms/form_details/controller/form_details_repository.dart';
import 'package:belcka/pages/manage_forms/form_details/model/form_entry_file.dart';
import 'package:belcka/pages/manage_forms/form_details/model/form_entry_model.dart';
import 'package:belcka/pages/manage_forms/submit_form/model/form_detail_info.dart';
import 'package:belcka/pages/manage_forms/submit_form/model/form_detail_response.dart';
import 'package:belcka/pages/manage_forms/submit_form/model/form_field_model.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:get/get.dart';

class FormDetailsController extends GetxController {
  final _api = FormDetailsRepository();

  final formInfo = FormDetailInfo().obs;
  final fields = <FormFieldModel>[].obs;
  final userEntry = Rxn<FormEntryModel>();
  final screenTitle = ''.obs;

  final isLoading = false.obs;
  final isInternetNotAvailable = false.obs;
  final isMainViewVisible = false.obs;
  final hasUserEntry = false.obs;

  int formId = 0;
  int? targetUserId;

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    if (arguments != null) {
      formId = arguments[AppConstants.intentKey.ID] ?? 0;
      targetUserId = arguments[AppConstants.intentKey.userId];
    }
    fetchFormDetail();
  }

  void fetchFormDetail() {
    if (formId == 0) {
      AppUtils.showSnackBarMessage('Invalid form');
      return;
    }

    isLoading.value = true;
    isInternetNotAvailable.value = false;

    _api.getFormDetail(
      formId: formId,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess && responseModel.result != null) {
          final response = FormDetailResponse.fromJson(
            jsonDecode(responseModel.result!) as Map<String, dynamic>,
          );
          if (response.isSuccess == true) {
            formInfo.value = response.info ?? FormDetailInfo();
            fields.assignAll(response.info?.fields ?? []);
            screenTitle.value = response.info?.name ?? '';
            _resolveUserEntry(response.info?.formEntry);
            isMainViewVisible.value = true;
          } else {
            AppUtils.showSnackBarMessage(response.message ?? '');
          }
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? '');
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
        } else if ((error.statusMessage ?? '').isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage ?? '');
        }
      },
    );
  }

  void _resolveUserEntry(List<dynamic>? entries) {
    final matchUserId = targetUserId ?? UserUtils.getLoginUserId();
    FormEntryModel? matched;

    for (final item in entries ?? const []) {
      if (item is! Map) continue;
      final entry = FormEntryModel.fromJson(Map<String, dynamic>.from(item));
      if (entry.submittedById == matchUserId) {
        matched = entry;
        break;
      }
    }

    userEntry.value = matched;
    hasUserEntry.value = matched != null;
  }

  dynamic rawValue(String? fieldId) => userEntry.value?.valueFor(fieldId);

  String? textValue(String? fieldId) => userEntry.value?.textValueFor(fieldId);

  List<FormEntryFile> filesFor(String? fieldId) =>
      userEntry.value?.filesFor(fieldId) ?? const [];

  FormEntryFile? singleFileFor(String? fieldId) =>
      userEntry.value?.singleFileFor(fieldId);

  int? selectedIndex(String? fieldId) {
    final value = textValue(fieldId);
    if (value == null) return null;
    return int.tryParse(value);
  }

  bool boolValue(String? fieldId) {
    final value = (textValue(fieldId) ?? '').toLowerCase();
    return value == 'true' || value == '1' || value == 'yes';
  }

  int ratingValue(String? fieldId) {
    return int.tryParse(textValue(fieldId) ?? '') ?? 0;
  }

  double? sliderValue(String? fieldId) {
    return double.tryParse(textValue(fieldId) ?? '');
  }

  Map<String, dynamic>? locationValue(String? fieldId) {
    final value = rawValue(fieldId);
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);

    final text = textValue(fieldId);
    if (text == null) return null;

    try {
      final decoded = jsonDecode(text);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    } catch (_) {}

    return null;
  }

  List<String> selectedOptions(String? fieldId) {
    final value = rawValue(fieldId);
    if (value is List) {
      return value.map((item) => item.toString()).toList();
    }
    final text = textValue(fieldId);
    if (text == null) return const [];
    return [text];
  }
}
