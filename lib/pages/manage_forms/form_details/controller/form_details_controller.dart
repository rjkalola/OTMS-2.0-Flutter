import 'dart:convert';

import 'package:belcka/pages/manage_forms/form_details/controller/form_details_repository.dart';
import 'package:belcka/pages/manage_forms/form_details/model/form_detail_info.dart';
import 'package:belcka/pages/manage_forms/form_details/model/form_detail_response.dart';
import 'package:belcka/pages/manage_forms/form_details/model/form_field_model.dart';
import 'package:belcka/pages/manage_forms/form_details/model/form_field_type.dart';
import 'package:belcka/pages/common/listener/SelectPhoneExtensionListener.dart';
import 'package:belcka/pages/common/listener/select_date_listener.dart';
import 'package:belcka/pages/common/listener/select_time_listener.dart';
import 'package:belcka/pages/common/phone_extension_list_dialog.dart';
import 'package:belcka/pages/manage_forms/form_details/model/form_date_value.dart';
import 'package:belcka/pages/manage_forms/form_details/model/form_location_value.dart';
import 'package:belcka/pages/manage_forms/form_details/model/form_phone_value.dart';
import 'package:belcka/pages/manage_forms/form_details/utils/form_condition_evaluator.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/date_utils.dart';
import 'package:belcka/utils/data_utils.dart';
import 'package:belcka/utils/location_service_new.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:get/get.dart';

class FormDetailsController extends GetxController
    implements
        SelectPhoneExtensionListener,
        SelectDateListener,
        SelectTimeListener {
  final _api = FormDetailsRepository();
  final _locationService = LocationServiceNew();

  final formInfo = FormDetailInfo().obs;
  final fields = <FormFieldModel>[].obs;
  final screenTitle = ''.obs;

  final isLoading = false.obs;
  final isInternetNotAvailable = false.obs;
  final isMainViewVisible = false.obs;

  final singleSelections = <String, String>{}.obs;
  final multipleSelections = <String, RxSet<String>>{}.obs;
  final textValues = <String, String>{}.obs;
  final locationValues = <String, FormLocationValue>{}.obs;
  final locationLoading = <String, bool>{}.obs;
  final taskChecked = <String, bool>{}.obs;
  final ratingValues = <String, int>{}.obs;
  final phoneValues = <String, FormPhoneValue>{}.obs;
  final dateValues = <String, FormDateValue>{}.obs;
  final sliderValues = <String, double?>{}.obs;
  final showValidationErrors = false.obs;

  String? _activePhoneFieldId;
  final invalidFieldIds = <String>{}.obs;
  final _emailValidator = EmailValidator(errorText: '');

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
    textValues.clear();
    locationValues.clear();
    locationLoading.clear();
    taskChecked.clear();
    ratingValues.clear();
    phoneValues.clear();
    dateValues.clear();
    sliderValues.clear();
    _registerFieldState(fields);
  }

  void _registerFieldState(List<FormFieldModel> fieldList) {
    for (final field in fieldList) {
      if (field.normalizedType == FormFieldType.group) {
        _registerFieldState(field.fields ?? []);
        continue;
      }

      final fieldId = field.id;
      if (StringHelper.isEmptyString(fieldId)) continue;

      if (field.normalizedType == FormFieldType.dropdown) {
        if (field.multipleSelection == true) {
          multipleSelections[fieldId!] = <String>{}.obs;
        } else {
          singleSelections[fieldId!] = '';
        }
        continue;
      }

      if (field.normalizedType == FormFieldType.openEnded ||
          field.normalizedType == FormFieldType.email) {
        textValues[fieldId!] = '';
        continue;
      }

      if (field.normalizedType == FormFieldType.location) {
        locationValues[fieldId!] = FormLocationValue();
        continue;
      }

      if (field.normalizedType == FormFieldType.task) {
        taskChecked[fieldId!] = false;
        continue;
      }

      if (field.normalizedType == FormFieldType.rating) {
        ratingValues[fieldId!] = 0;
        continue;
      }

      if (field.normalizedType == FormFieldType.phone) {
        phoneValues[fieldId!] = FormPhoneValue();
        continue;
      }

      if (field.normalizedType == FormFieldType.yesNo) {
        singleSelections[fieldId!] = '';
        continue;
      }

      if (field.normalizedType == FormFieldType.date) {
        dateValues[fieldId!] = FormDateValue();
        continue;
      }

      if (field.normalizedType == FormFieldType.numbersSlider) {
        sliderValues[fieldId!] = null;
      }
    }
  }

  String? getSingleSelection(String fieldId) {
    final value = singleSelections[fieldId];
    if (StringHelper.isEmptyString(value)) return null;
    return value;
  }

  String getTextValue(String fieldId) => textValues[fieldId] ?? '';

  void setTextValue(String fieldId, String value) {
    textValues[fieldId] = value;
    textValues.refresh();
    if (!StringHelper.isEmptyString(value.trim())) {
      _clearFieldError(fieldId);
    }
  }

  void setEmailValue(String fieldId, String value) {
    textValues[fieldId] = value;
    textValues.refresh();
    final trimmed = value.trim();
    final field = findFieldById(fieldId);
    if (trimmed.isEmpty) {
      if (field != null && !field.isRequired) {
        _clearFieldError(fieldId);
      }
    } else if (isValidEmail(trimmed)) {
      _clearFieldError(fieldId);
    }
    _clearErrorsForHiddenFields();
  }

  bool isValidEmail(String value) => _emailValidator(value) == null;

  String getEmailFieldErrorMessage(FormFieldModel field) {
    final fieldId = field.id ?? '';
    final value = getTextValue(fieldId).trim();
    if (value.isEmpty) {
      return 'this_field_is_required'.tr;
    }
    return 'enter_valid_email_address'.tr;
  }

  FormLocationValue? getLocationValue(String fieldId) => locationValues[fieldId];

  String getManualLocationInput(String fieldId) {
    return locationValues[fieldId]?.manualInput ?? '';
  }

  void setManualLocationInput(String fieldId, String value) {
    final current = locationValues[fieldId] ?? FormLocationValue();
    current.manualInput = value;
    locationValues[fieldId] = current;
    locationValues.refresh();
    if (FormLocationValue.parseManualInput(value) != null) {
      _clearFieldError(fieldId);
    }
  }

  bool isLocationLoading(String fieldId) => locationLoading[fieldId] ?? false;

  Future<void> fetchCurrentLocation(String fieldId) async {
    if (locationLoading[fieldId] == true) return;

    locationLoading[fieldId] = true;
    locationLoading.refresh();

    try {
      final isEnabled = await _locationService.checkLocationService();
      if (!isEnabled) return;

      final position = await LocationServiceNew.getCurrentLocation();
      if (position == null) return;

      final current = locationValues[fieldId] ?? FormLocationValue();
      current.latitude = position.latitude;
      current.longitude = position.longitude;
      current.accuracyMeters = position.accuracy;
      locationValues[fieldId] = current;
      locationValues.refresh();
      _clearFieldError(fieldId);
      _clearErrorsForHiddenFields();
    } finally {
      locationLoading[fieldId] = false;
      locationLoading.refresh();
    }
  }

  bool isTaskChecked(String fieldId) => taskChecked[fieldId] ?? false;

  int getRating(String fieldId) => ratingValues[fieldId] ?? 0;

  void setRating(String fieldId, int value) {
    ratingValues[fieldId] = value;
    ratingValues.refresh();
    if (value > 0) {
      _clearFieldError(fieldId);
    }
    _clearErrorsForHiddenFields();
  }

  bool hasRating(String fieldId) => getRating(fieldId) > 0;

  FormPhoneValue? getPhoneValue(String fieldId) => phoneValues[fieldId];

  String getPhoneNumber(String fieldId) => phoneValues[fieldId]?.phone ?? '';

  void setPhoneNumber(String fieldId, String value) {
    final current = phoneValues[fieldId] ?? FormPhoneValue();
    current.phone = value;
    phoneValues[fieldId] = current;
    phoneValues.refresh();
    if (!StringHelper.isEmptyString(value.trim())) {
      _clearFieldError(fieldId);
    }
  }

  bool hasPhoneValue(String fieldId) {
    final value = phoneValues[fieldId];
    return value != null && !value.isEmpty;
  }

  FormDateValue? getDateValue(String fieldId) => dateValues[fieldId];

  bool hasDateValue(String fieldId) {
    final field = findFieldById(fieldId);
    if (field == null) return false;
    final value = dateValues[fieldId];
    if (value == null) return false;
    return value.isComplete(
      includeDate: field.includesDate,
      includeTime: field.includesTime,
    );
  }

  double getSliderValue(String fieldId, FormFieldModel field) {
    return sliderValues[fieldId] ?? field.sliderMin;
  }

  void setSliderValue(String fieldId, double value) {
    sliderValues[fieldId] = value;
    sliderValues.refresh();
    _clearFieldError(fieldId);
    _clearErrorsForHiddenFields();
  }

  bool hasSliderValue(String fieldId) => sliderValues[fieldId] != null;

  void showFormDatePicker(String fieldId) {
    final value = dateValues[fieldId] ?? FormDateValue();
    DateUtil.showDatePickerDialog(
      initialDate: value.date ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      dialogIdentifier: fieldId,
      selectDateListener: this,
    );
  }

  void showFormTimePicker(String fieldId) {
    final value = dateValues[fieldId] ?? FormDateValue();
    DateUtil.showTimePickerDialog(
      initialTime: value.time ?? DateTime.now(),
      dialogIdentifier: fieldId,
      selectTimeListener: this,
    );
  }

  @override
  void onSelectDate(DateTime date, String dialogIdentifier) {
    final current = dateValues[dialogIdentifier] ?? FormDateValue();
    current.date = date;
    dateValues[dialogIdentifier] = current;
    dateValues.refresh();
    if (hasDateValue(dialogIdentifier)) {
      _clearFieldError(dialogIdentifier);
    }
    _clearErrorsForHiddenFields();
  }

  @override
  void onSelectTime(DateTime time, String dialogIdentifier) {
    final current = dateValues[dialogIdentifier] ?? FormDateValue();
    current.time = time;
    dateValues[dialogIdentifier] = current;
    dateValues.refresh();
    if (hasDateValue(dialogIdentifier)) {
      _clearFieldError(dialogIdentifier);
    }
    _clearErrorsForHiddenFields();
  }

  void showPhoneExtensionDialog(String fieldId) {
    _activePhoneFieldId = fieldId;
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
    int id,
    String extension,
    String flag,
    String country,
  ) {
    final fieldId = _activePhoneFieldId;
    if (StringHelper.isEmptyString(fieldId)) return;

    final current = phoneValues[fieldId!] ?? FormPhoneValue();
    current.extensionId = id;
    current.extension = extension;
    current.flag = flag;
    phoneValues[fieldId] = current;
    phoneValues.refresh();
    _activePhoneFieldId = null;
  }

  void setTaskChecked(String fieldId, bool? value) {
    taskChecked[fieldId] = value ?? false;
    taskChecked.refresh();
    if (taskChecked[fieldId] == true) {
      _clearFieldError(fieldId);
    }
    _clearErrorsForHiddenFields();
  }

  bool hasLocationValue(FormFieldModel field) {
    final fieldId = field.id ?? '';
    if (StringHelper.isEmptyString(fieldId)) return false;

    final value = locationValues[fieldId];
    if (value == null) return false;

    if (field.isManualLocation) {
      return value.hasManualCoordinates();
    }
    return value.hasCurrentCoordinates;
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
      getTextValue: getTextValue,
      hasLocationValue: (fieldId) {
        final field = findFieldById(fieldId);
        return field != null && hasLocationValue(field);
      },
      isTaskChecked: isTaskChecked,
      hasRating: hasRating,
      hasPhoneValue: hasPhoneValue,
      hasDateValue: hasDateValue,
      hasSliderValue: hasSliderValue,
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
      textValues[fieldId];
      locationValues[fieldId];
      taskChecked[fieldId];
      ratingValues[fieldId];
      phoneValues[fieldId];
      dateValues[fieldId];
      sliderValues[fieldId];
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

  bool _isOpenEndedFieldInvalid(FormFieldModel field) {
    final fieldId = field.id ?? '';
    if (StringHelper.isEmptyString(fieldId)) return false;
    return StringHelper.isEmptyString(getTextValue(fieldId).trim());
  }

  bool _isEmailFieldInvalid(FormFieldModel field) {
    final fieldId = field.id ?? '';
    if (StringHelper.isEmptyString(fieldId)) return false;
    final value = getTextValue(fieldId).trim();
    if (value.isEmpty) return field.isRequired;
    return !isValidEmail(value);
  }

  bool _isLocationFieldInvalid(FormFieldModel field) {
    return !hasLocationValue(field);
  }

  bool _isTaskFieldInvalid(FormFieldModel field) {
    final fieldId = field.id ?? '';
    if (StringHelper.isEmptyString(fieldId)) return false;
    return !isTaskChecked(fieldId);
  }

  bool _isRatingFieldInvalid(FormFieldModel field) {
    final fieldId = field.id ?? '';
    if (StringHelper.isEmptyString(fieldId)) return false;
    return !hasRating(fieldId);
  }

  bool _isPhoneFieldInvalid(FormFieldModel field) {
    final fieldId = field.id ?? '';
    if (StringHelper.isEmptyString(fieldId)) return false;
    return !hasPhoneValue(fieldId);
  }

  bool _isDateFieldInvalid(FormFieldModel field) {
    final fieldId = field.id ?? '';
    if (StringHelper.isEmptyString(fieldId)) return false;
    return !hasDateValue(fieldId);
  }

  bool _isNumbersSliderFieldInvalid(FormFieldModel field) {
    final fieldId = field.id ?? '';
    if (StringHelper.isEmptyString(fieldId)) return false;
    return !hasSliderValue(fieldId);
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

      final fieldId = field.id ?? '';
      if (StringHelper.isEmptyString(fieldId)) continue;

      if (field.normalizedType == FormFieldType.email &&
          _isEmailFieldInvalid(field)) {
        invalidFieldIds.add(fieldId);
        isValid = false;
        continue;
      }

      if (!field.isRequired) continue;

      if (field.normalizedType == FormFieldType.dropdown &&
          _isDropdownFieldInvalid(field)) {
        invalidFieldIds.add(fieldId);
        isValid = false;
      } else if (field.normalizedType == FormFieldType.openEnded &&
          _isOpenEndedFieldInvalid(field)) {
        invalidFieldIds.add(fieldId);
        isValid = false;
      } else if (field.normalizedType == FormFieldType.location &&
          _isLocationFieldInvalid(field)) {
        invalidFieldIds.add(fieldId);
        isValid = false;
      } else if (field.normalizedType == FormFieldType.task &&
          _isTaskFieldInvalid(field)) {
        invalidFieldIds.add(fieldId);
        isValid = false;
      } else if (field.normalizedType == FormFieldType.rating &&
          _isRatingFieldInvalid(field)) {
        invalidFieldIds.add(fieldId);
        isValid = false;
      } else if (field.normalizedType == FormFieldType.phone &&
          _isPhoneFieldInvalid(field)) {
        invalidFieldIds.add(fieldId);
        isValid = false;
      } else if (field.normalizedType == FormFieldType.yesNo &&
          _isDropdownFieldInvalid(field)) {
        invalidFieldIds.add(fieldId);
        isValid = false;
      } else if (field.normalizedType == FormFieldType.date &&
          _isDateFieldInvalid(field)) {
        invalidFieldIds.add(fieldId);
        isValid = false;
      } else if (field.normalizedType == FormFieldType.numbersSlider &&
          _isNumbersSliderFieldInvalid(field)) {
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
