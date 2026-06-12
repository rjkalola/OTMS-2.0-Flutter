import 'package:belcka/pages/manage_forms/form_details/model/form_field_condition.dart';
import 'package:belcka/pages/manage_forms/form_details/model/form_field_model.dart';
import 'package:belcka/pages/manage_forms/form_details/model/form_field_type.dart';
import 'package:belcka/utils/string_helper.dart';

class FormConditionEvaluator {
  const FormConditionEvaluator._();
 
  static bool isFieldVisible({
    required FormFieldModel field,
    required List<FormFieldModel> allFields,
    required String? Function(String fieldId) getSingleSelection,
    required Set<String>? Function(String fieldId) getMultipleSelection,
    String Function(String fieldId)? getTextValue,
    bool Function(String fieldId)? hasLocationValue,
    bool Function(String fieldId)? isTaskChecked,
    bool Function(String fieldId)? hasRating,
    bool Function(String fieldId)? hasPhoneValue,
    bool Function(String fieldId)? hasDateValue,
    bool Function(String fieldId)? hasSliderValue,
    String Function(String fieldId)? getFormulaValue,
    bool Function(String fieldId)? hasSignatureValue,
    bool Function(String fieldId)? hasImageUploadValue,
    bool Function(String fieldId)? hasVideoUploadValue,
    bool Function(String fieldId)? hasScannerUploadValue,
    bool Function(String fieldId)? hasFileUploadValue,
    bool Function(String fieldId)? hasAudioRecordingValue,
  }) {
    if (field.showOnlyIf != true) return true;

    final conditions = field.conditions;
    if (conditions != null && conditions.isNotEmpty) {
      return _evaluateConditions(
        conditions: conditions,
        conditionValue: field.conditionValue,
        allFields: allFields,
        getSingleSelection: getSingleSelection,
        getMultipleSelection: getMultipleSelection,
        getTextValue: getTextValue,
        hasLocationValue: hasLocationValue,
        isTaskChecked: isTaskChecked,
        hasRating: hasRating,
        hasPhoneValue: hasPhoneValue,
        hasDateValue: hasDateValue,
        hasSliderValue: hasSliderValue,
        getFormulaValue: getFormulaValue,
        hasSignatureValue: hasSignatureValue,
        hasImageUploadValue: hasImageUploadValue,
        hasVideoUploadValue: hasVideoUploadValue,
        hasScannerUploadValue: hasScannerUploadValue,
        hasFileUploadValue: hasFileUploadValue,
        hasAudioRecordingValue: hasAudioRecordingValue,
      );
    }

    if (!StringHelper.isEmptyString(field.conditionFieldId)) {
      return _evaluateOperator(
        sourceFieldId: field.conditionFieldId!,
        operator: field.conditionOperator ?? '',
        conditionValue: field.conditionValue,
        allFields: allFields,
        getSingleSelection: getSingleSelection,
        getMultipleSelection: getMultipleSelection,
        getTextValue: getTextValue,
        hasLocationValue: hasLocationValue,
        isTaskChecked: isTaskChecked,
        hasRating: hasRating,
        hasPhoneValue: hasPhoneValue,
        hasDateValue: hasDateValue,
        hasSliderValue: hasSliderValue,
        getFormulaValue: getFormulaValue,
        hasSignatureValue: hasSignatureValue,
        hasImageUploadValue: hasImageUploadValue,
        hasVideoUploadValue: hasVideoUploadValue,
        hasScannerUploadValue: hasScannerUploadValue,
        hasFileUploadValue: hasFileUploadValue,
        hasAudioRecordingValue: hasAudioRecordingValue,
      );
    }

    return true;
  }

  static FormFieldModel? findFieldById(
    String fieldId,
    List<FormFieldModel> fieldList,
  ) {
    for (final field in fieldList) {
      if (field.id == fieldId) return field;
      if (field.fields != null && field.fields!.isNotEmpty) {
        final nested = findFieldById(fieldId, field.fields!);
        if (nested != null) return nested;
      }
    }
    return null;
  }

  static bool _evaluateConditions({
    required List<FormFieldCondition> conditions,
    required String? conditionValue,
    required List<FormFieldModel> allFields,
    required String? Function(String fieldId) getSingleSelection,
    required Set<String>? Function(String fieldId) getMultipleSelection,
    String Function(String fieldId)? getTextValue,
    bool Function(String fieldId)? hasLocationValue,
    bool Function(String fieldId)? isTaskChecked,
    bool Function(String fieldId)? hasRating,
    bool Function(String fieldId)? hasPhoneValue,
    bool Function(String fieldId)? hasDateValue,
    bool Function(String fieldId)? hasSliderValue,
    String Function(String fieldId)? getFormulaValue,
    bool Function(String fieldId)? hasSignatureValue,
    bool Function(String fieldId)? hasImageUploadValue,
    bool Function(String fieldId)? hasVideoUploadValue,
    bool Function(String fieldId)? hasScannerUploadValue,
    bool Function(String fieldId)? hasFileUploadValue,
    bool Function(String fieldId)? hasAudioRecordingValue,
  }) {
    bool? result;

    for (final condition in conditions) {
      final conditionResult = _evaluateOperator(
        sourceFieldId: condition.fieldId ?? '',
        operator: condition.operator ?? '',
        conditionValue: conditionValue,
        allFields: allFields,
        getSingleSelection: getSingleSelection,
        getMultipleSelection: getMultipleSelection,
        getTextValue: getTextValue,
        hasLocationValue: hasLocationValue,
        isTaskChecked: isTaskChecked,
        hasRating: hasRating,
        hasPhoneValue: hasPhoneValue,
        hasDateValue: hasDateValue,
        hasSliderValue: hasSliderValue,
        getFormulaValue: getFormulaValue,
        hasSignatureValue: hasSignatureValue,
        hasImageUploadValue: hasImageUploadValue,
        hasVideoUploadValue: hasVideoUploadValue,
        hasScannerUploadValue: hasScannerUploadValue,
        hasFileUploadValue: hasFileUploadValue,
        hasAudioRecordingValue: hasAudioRecordingValue,
      );

      final joinWith = (condition.joinWith ?? 'if').toLowerCase();
      if (result == null || joinWith == 'if') {
        result = conditionResult;
      } else if (joinWith == 'or') {
        result = result || conditionResult;
      } else {
        result = result && conditionResult;
      }
    }

    return result ?? true;
  }

  static bool _evaluateOperator({
    required String sourceFieldId,
    required String operator,
    required String? conditionValue,
    required List<FormFieldModel> allFields,
    required String? Function(String fieldId) getSingleSelection,
    required Set<String>? Function(String fieldId) getMultipleSelection,
    String Function(String fieldId)? getTextValue,
    bool Function(String fieldId)? hasLocationValue,
    bool Function(String fieldId)? isTaskChecked,
    bool Function(String fieldId)? hasRating,
    bool Function(String fieldId)? hasPhoneValue,
    bool Function(String fieldId)? hasDateValue,
    bool Function(String fieldId)? hasSliderValue,
    String Function(String fieldId)? getFormulaValue,
    bool Function(String fieldId)? hasSignatureValue,
    bool Function(String fieldId)? hasImageUploadValue,
    bool Function(String fieldId)? hasVideoUploadValue,
    bool Function(String fieldId)? hasScannerUploadValue,
    bool Function(String fieldId)? hasFileUploadValue,
    bool Function(String fieldId)? hasAudioRecordingValue,
  }) {
    if (StringHelper.isEmptyString(sourceFieldId)) return false;

    final sourceField = findFieldById(sourceFieldId, allFields);
    if (sourceField == null) return false;

    final isEmpty = _isFieldValueEmpty(
      fieldId: sourceFieldId,
      field: sourceField,
      getSingleSelection: getSingleSelection,
      getMultipleSelection: getMultipleSelection,
      getTextValue: getTextValue,
      hasLocationValue: hasLocationValue,
      isTaskChecked: isTaskChecked,
      hasRating: hasRating,
      hasPhoneValue: hasPhoneValue,
      hasDateValue: hasDateValue,
      hasSliderValue: hasSliderValue,
      getFormulaValue: getFormulaValue,
      hasSignatureValue: hasSignatureValue,
      hasImageUploadValue: hasImageUploadValue,
      hasVideoUploadValue: hasVideoUploadValue,
      hasScannerUploadValue: hasScannerUploadValue,
      hasFileUploadValue: hasFileUploadValue,
      hasAudioRecordingValue: hasAudioRecordingValue,
    );

    switch (operator.toLowerCase().replaceAll(' ', '_')) {
      case 'not_empty':
        return !isEmpty;
      case 'empty':
        return isEmpty;
      case 'equals':
      case 'equal':
        if (isEmpty) return false;
        return _fieldValue(
              fieldId: sourceFieldId,
              field: sourceField,
              getSingleSelection: getSingleSelection,
              getMultipleSelection: getMultipleSelection,
              getTextValue: getTextValue,
              hasLocationValue: hasLocationValue,
              isTaskChecked: isTaskChecked,
              hasRating: hasRating,
              hasPhoneValue: hasPhoneValue,
              hasDateValue: hasDateValue,
              hasSliderValue: hasSliderValue,
              getFormulaValue: getFormulaValue,
              hasSignatureValue: hasSignatureValue,
              hasImageUploadValue: hasImageUploadValue,
              hasVideoUploadValue: hasVideoUploadValue,
              hasScannerUploadValue: hasScannerUploadValue,
              hasFileUploadValue: hasFileUploadValue,
              hasAudioRecordingValue: hasAudioRecordingValue,
            ) ==
            (conditionValue ?? '');
      default:
        return true;
    }
  }

  static bool _isFieldValueEmpty({
    required String fieldId,
    required FormFieldModel field,
    required String? Function(String fieldId) getSingleSelection,
    required Set<String>? Function(String fieldId) getMultipleSelection,
    String Function(String fieldId)? getTextValue,
    bool Function(String fieldId)? hasLocationValue,
    bool Function(String fieldId)? isTaskChecked,
    bool Function(String fieldId)? hasRating,
    bool Function(String fieldId)? hasPhoneValue,
    bool Function(String fieldId)? hasDateValue,
    bool Function(String fieldId)? hasSliderValue,
    String Function(String fieldId)? getFormulaValue,
    bool Function(String fieldId)? hasSignatureValue,
    bool Function(String fieldId)? hasImageUploadValue,
    bool Function(String fieldId)? hasVideoUploadValue,
    bool Function(String fieldId)? hasScannerUploadValue,
    bool Function(String fieldId)? hasFileUploadValue,
    bool Function(String fieldId)? hasAudioRecordingValue,
  }) {
    if (field.normalizedType == FormFieldType.openEnded ||
        field.normalizedType == FormFieldType.email ||
        field.normalizedType == FormFieldType.number) {
      return StringHelper.isEmptyString(
        (getTextValue?.call(fieldId) ?? '').trim(),
      );
    }

    if (field.normalizedType == FormFieldType.formula) {
      return StringHelper.isEmptyString(
        (getFormulaValue?.call(fieldId) ?? '').trim(),
      );
    }

    if (field.normalizedType == FormFieldType.signature) {
      return !(hasSignatureValue?.call(fieldId) ?? false);
    }

    if (field.normalizedType == FormFieldType.imageUpload) {
      return !(hasImageUploadValue?.call(fieldId) ?? false);
    }

    if (field.normalizedType == FormFieldType.videoUpload) {
      return !(hasVideoUploadValue?.call(fieldId) ?? false);
    }

    if (field.normalizedType == FormFieldType.scanner) {
      return !(hasScannerUploadValue?.call(fieldId) ?? false);
    }

    if (field.normalizedType == FormFieldType.fileUpload) {
      return !(hasFileUploadValue?.call(fieldId) ?? false);
    }

    if (field.normalizedType == FormFieldType.audioRecording) {
      return !(hasAudioRecordingValue?.call(fieldId) ?? false);
    }

    if (field.normalizedType == FormFieldType.location) {
      return !(hasLocationValue?.call(fieldId) ?? false);
    }

    if (field.normalizedType == FormFieldType.task) {
      return !(isTaskChecked?.call(fieldId) ?? false);
    }

    if (field.normalizedType == FormFieldType.rating) {
      return !(hasRating?.call(fieldId) ?? false);
    }

    if (field.normalizedType == FormFieldType.phone) {
      return !(hasPhoneValue?.call(fieldId) ?? false);
    }

    if (field.normalizedType == FormFieldType.date) {
      return !(hasDateValue?.call(fieldId) ?? false);
    }

    if (field.normalizedType == FormFieldType.numbersSlider) {
      return !(hasSliderValue?.call(fieldId) ?? false);
    }

    if (field.multipleSelection == true) {
      final selected = getMultipleSelection(fieldId);
      return selected == null || selected.isEmpty;
    }
    return StringHelper.isEmptyString(getSingleSelection(fieldId));
  }

  static String _fieldValue({
    required String fieldId,
    required FormFieldModel field,
    required String? Function(String fieldId) getSingleSelection,
    required Set<String>? Function(String fieldId) getMultipleSelection,
    String Function(String fieldId)? getTextValue,
    bool Function(String fieldId)? hasLocationValue,
    bool Function(String fieldId)? isTaskChecked,
    bool Function(String fieldId)? hasRating,
    bool Function(String fieldId)? hasPhoneValue,
    bool Function(String fieldId)? hasDateValue,
    bool Function(String fieldId)? hasSliderValue,
    String Function(String fieldId)? getFormulaValue,
    bool Function(String fieldId)? hasSignatureValue,
    bool Function(String fieldId)? hasImageUploadValue,
    bool Function(String fieldId)? hasVideoUploadValue,
    bool Function(String fieldId)? hasScannerUploadValue,
    bool Function(String fieldId)? hasFileUploadValue,
    bool Function(String fieldId)? hasAudioRecordingValue,
  }) {
    if (field.normalizedType == FormFieldType.openEnded ||
        field.normalizedType == FormFieldType.email ||
        field.normalizedType == FormFieldType.number) {
      return getTextValue?.call(fieldId) ?? '';
    }

    if (field.normalizedType == FormFieldType.formula) {
      return getFormulaValue?.call(fieldId) ?? '';
    }

    if (field.normalizedType == FormFieldType.signature) {
      return (hasSignatureValue?.call(fieldId) ?? false) ? 'signed' : '';
    }

    if (field.normalizedType == FormFieldType.imageUpload) {
      return (hasImageUploadValue?.call(fieldId) ?? false) ? 'uploaded' : '';
    }

    if (field.normalizedType == FormFieldType.videoUpload) {
      return (hasVideoUploadValue?.call(fieldId) ?? false) ? 'uploaded' : '';
    }

    if (field.normalizedType == FormFieldType.scanner) {
      return (hasScannerUploadValue?.call(fieldId) ?? false) ? 'scanned' : '';
    }

    if (field.normalizedType == FormFieldType.fileUpload) {
      return (hasFileUploadValue?.call(fieldId) ?? false) ? 'uploaded' : '';
    }

    if (field.normalizedType == FormFieldType.audioRecording) {
      return (hasAudioRecordingValue?.call(fieldId) ?? false) ? 'recorded' : '';
    }

    if (field.normalizedType == FormFieldType.location) {
      return (hasLocationValue?.call(fieldId) ?? false) ? 'filled' : '';
    }

    if (field.normalizedType == FormFieldType.task) {
      return (isTaskChecked?.call(fieldId) ?? false) ? 'checked' : '';
    }

    if (field.normalizedType == FormFieldType.rating) {
      return (hasRating?.call(fieldId) ?? false) ? 'rated' : '';
    }

    if (field.normalizedType == FormFieldType.phone) {
      return (hasPhoneValue?.call(fieldId) ?? false) ? 'filled' : '';
    }

    if (field.normalizedType == FormFieldType.date) {
      return (hasDateValue?.call(fieldId) ?? false) ? 'filled' : '';
    }

    if (field.normalizedType == FormFieldType.numbersSlider) {
      return (hasSliderValue?.call(fieldId) ?? false) ? 'filled' : '';
    }

    if (field.multipleSelection == true) {
      final selected = getMultipleSelection(fieldId);
      return selected?.join(', ') ?? '';
    }
    return getSingleSelection(fieldId) ?? '';
  }
}
