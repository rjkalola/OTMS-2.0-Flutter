import 'dart:convert';

import 'package:belcka/pages/manage_forms/form_details/controller/form_details_repository.dart';
import 'package:belcka/pages/manage_forms/form_details/model/form_detail_info.dart';
import 'package:belcka/pages/manage_forms/form_details/model/form_detail_response.dart';
import 'package:belcka/pages/manage_forms/form_details/model/form_field_model.dart';
import 'package:belcka/pages/manage_forms/form_details/model/form_field_type.dart';
import 'package:belcka/pages/manage_forms/form_details/utils/form_condition_evaluator.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:get/get.dart';

class FormDetailsController extends GetxController {
  final _api = FormDetailsRepository();

  final formInfo = FormDetailInfo().obs;
  final fields = <FormFieldModel>[].obs;
  final screenTitle = ''.obs;

  final isLoading = false.obs;
  final isInternetNotAvailable = false.obs;
  final isMainViewVisible = false.obs;

  final singleSelections = <String, String>{}.obs;
  final multipleSelections = <String, RxSet<String>>{}.obs;
  final showValidationErrors = false.obs;
  final invalidFieldIds = <String>{}.obs;

  int formId = 0;

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    if (arguments != null) {
      formId = arguments[AppConstants.intentKey.ID] ?? 0;
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
            _initFieldSelections();
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
        } else if (!StringHelper.isEmptyString(error.statusMessage)) {
          AppUtils.showSnackBarMessage(error.statusMessage ?? '');
        }
      },
    );
  }

  void _initFieldSelections() {
    singleSelections.clear();
    multipleSelections.clear();
    _registerFieldSelections(fields);
  }

  void _registerFieldSelections(List<FormFieldModel> fieldList) {
    for (final field in fieldList) {
      if (field.normalizedType == FormFieldType.group) {
        _registerFieldSelections(field.fields ?? []);
        continue;
      }

      if (field.normalizedType != FormFieldType.dropdown) continue;

      final fieldId = field.id;
      if (StringHelper.isEmptyString(fieldId)) continue;

      if (field.multipleSelection == true) {
        multipleSelections[fieldId!] = <String>{}.obs;
      } else {
        singleSelections[fieldId!] = '';
      }
    }
  }

  String? getSingleSelection(String fieldId) {
    final value = singleSelections[fieldId];
    if (StringHelper.isEmptyString(value)) return null;
    return value;
  }

  bool isFieldInvalid(String fieldId) => invalidFieldIds.contains(fieldId);

  void _clearFieldError(String fieldId) {
    if (invalidFieldIds.remove(fieldId)) {
      invalidFieldIds.refresh();
      if (invalidFieldIds.isEmpty) {
        showValidationErrors.value = false;
      }
    }
  }

  bool isFieldVisible(FormFieldModel field) {
    _observeConditionSourceFields(field);

    return FormConditionEvaluator.isFieldVisible(
      field: field,
      allFields: fields,
      getSingleSelection: getSingleSelection,
      getMultipleSelection: (id) => multipleSelections[id]?.toSet(),
    );
  }

  void _observeConditionSourceFields(FormFieldModel field) {
    if (field.showOnlyIf != true) return;

    final sourceFieldIds = <String>{};
    for (final condition in field.conditions ?? []) {
      if (!StringHelper.isEmptyString(condition.fieldId)) {
        sourceFieldIds.add(condition.fieldId!);
      }
    }
    if (!StringHelper.isEmptyString(field.conditionFieldId)) {
      sourceFieldIds.add(field.conditionFieldId!);
    }

    if (sourceFieldIds.isEmpty) {
      singleSelections.length;
      multipleSelections.length;
      return;
    }

    for (final fieldId in sourceFieldIds) {
      singleSelections[fieldId];
      final selected = multipleSelections[fieldId];
      selected?.length;
      selected?.toList();
    }
  }

  FormFieldModel? findFieldById(String fieldId) {
    return FormConditionEvaluator.findFieldById(fieldId, fields);
  }

  void setSingleSelection(String fieldId, String? value) {
    if (value == null) return;
    singleSelections[fieldId] = value;
    singleSelections.refresh();
    _clearFieldError(fieldId);
    _clearErrorsForHiddenFields();
  }

  bool isMultipleSelected(String fieldId, String option) {
    return multipleSelections[fieldId]?.contains(option) ?? false;
  }

  void toggleMultipleSelection(String fieldId, String option) {
    final selected = multipleSelections[fieldId];
    if (selected == null) return;

    if (selected.contains(option)) {
      selected.remove(option);
    } else {
      selected.add(option);
    }
    multipleSelections.refresh();
    if (selected.isNotEmpty) {
      _clearFieldError(fieldId);
    }
    _clearErrorsForHiddenFields();
  }

  void _clearErrorsForHiddenFields() {
    final hiddenInvalidIds = invalidFieldIds
        .where((id) {
          final field = findFieldById(id);
          return field != null && !isFieldVisible(field);
        })
        .toList();

    if (hiddenInvalidIds.isEmpty) return;

    for (final id in hiddenInvalidIds) {
      invalidFieldIds.remove(id);
    }
    invalidFieldIds.refresh();

    if (invalidFieldIds.isEmpty) {
      showValidationErrors.value = false;
    }
  }

  bool _isDropdownFieldInvalid(FormFieldModel field) {
    final fieldId = field.id ?? '';
    if (StringHelper.isEmptyString(fieldId)) return false;

    if (field.multipleSelection == true) {
      final selected = multipleSelections[fieldId];
      return selected == null || selected.isEmpty;
    }
    return StringHelper.isEmptyString(getSingleSelection(fieldId));
  }

  bool validateForm() {
    invalidFieldIds.clear();
    final isValid = _validateFieldList(fields);

    if (!isValid) {
      showValidationErrors.value = true;
      invalidFieldIds.refresh();
    } else {
      showValidationErrors.value = false;
    }

    return isValid;
  }

  bool _validateFieldList(List<FormFieldModel> fieldList) {
    var isValid = true;

    for (final field in fieldList) {
      if (field.normalizedType == FormFieldType.group) {
        if (!_validateFieldList(field.fields ?? [])) {
          isValid = false;
        }
        continue;
      }

      if (!isFieldVisible(field)) continue;

      if (!field.isRequired) continue;

      final fieldId = field.id ?? '';
      if (StringHelper.isEmptyString(fieldId)) continue;

      if (field.normalizedType == FormFieldType.dropdown &&
          _isDropdownFieldInvalid(field)) {
        invalidFieldIds.add(fieldId);
        isValid = false;
      }
    }

    return isValid;
  }

  void onSendPressed() {
    if (!validateForm()) return;
    // Submission API will be wired in a later phase.
    AppUtils.showSnackBarMessage('send'.tr);
  }
}
