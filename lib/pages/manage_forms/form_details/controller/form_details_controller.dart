import 'dart:convert';
import 'dart:io';

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
import 'package:belcka/pages/manage_forms/form_details/model/form_signature_value.dart';
import 'package:belcka/pages/manage_forms/form_details/model/form_audio_recording_value.dart';
import 'package:belcka/pages/manage_forms/form_details/model/form_uploaded_file.dart';
import 'package:belcka/pages/manage_forms/form_details/utils/form_condition_evaluator.dart';
import 'package:belcka/pages/manage_forms/form_details/utils/form_formula_evaluator.dart';
import 'package:belcka/pages/manage_forms/form_details/utils/form_signature_exporter.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/date_utils.dart';
import 'package:belcka/utils/data_utils.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/location_service_new.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:belcka/res/colors.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:dio/dio.dart' as multi;
import 'package:get/get.dart';

class FormDetailsController extends GetxController
    implements
        SelectPhoneExtensionListener,
        SelectDateListener,
        SelectTimeListener {
  final _api = FormDetailsRepository();
  final _locationService = LocationServiceNew();
  final _imagePicker = ImagePicker();

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
  final signatureValues = <String, FormSignatureValue>{}.obs;
  final imageUploadValues = <String, RxList<String>>{}.obs;
  final videoUploadValues = <String, RxList<String>>{}.obs;
  final scannerUploadValues = <String, RxList<String>>{}.obs;
  final fileUploadValues = <String, RxList<FormUploadedFile>>{}.obs;
  final audioRecordingValues = <String, FormAudioRecordingValue?>{}.obs;
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
    signatureValues.clear();
    imageUploadValues.clear();
    videoUploadValues.clear();
    scannerUploadValues.clear();
    fileUploadValues.clear();
    audioRecordingValues.clear();
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

      if (field.normalizedType == FormFieldType.dropdown ||
          field.normalizedType == FormFieldType.imageSelection) {
        if (field.multipleSelection == true) {
          multipleSelections[fieldId!] = <String>{}.obs;
        } else {
          singleSelections[fieldId!] = '';
        }
        continue;
      }

      if (field.normalizedType == FormFieldType.openEnded ||
          field.normalizedType == FormFieldType.email ||
          field.normalizedType == FormFieldType.number) {
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
        continue;
      }

      if (field.normalizedType == FormFieldType.signature) {
        signatureValues[fieldId!] = FormSignatureValue();
        continue;
      }

      if (field.normalizedType == FormFieldType.imageUpload) {
        imageUploadValues[fieldId!] = <String>[].obs;
        continue;
      }

      if (field.normalizedType == FormFieldType.videoUpload) {
        videoUploadValues[fieldId!] = <String>[].obs;
        continue;
      }

      if (field.normalizedType == FormFieldType.scanner) {
        scannerUploadValues[fieldId!] = <String>[].obs;
        continue;
      }

      if (field.normalizedType == FormFieldType.fileUpload) {
        fileUploadValues[fieldId!] = <FormUploadedFile>[].obs;
        continue;
      }

      if (field.normalizedType == FormFieldType.audioRecording) {
        audioRecordingValues[fieldId!] = null;
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

  void setNumberValue(String fieldId, String value) {
    textValues[fieldId] = value;
    textValues.refresh();
    if (hasNumberValue(fieldId)) {
      _clearFieldError(fieldId);
    } else {
      final field = findFieldById(fieldId);
      if (field != null && !field.isRequired && value.trim().isEmpty) {
        _clearFieldError(fieldId);
      }
    }
    _clearErrorsForHiddenFields();
  }

  bool hasNumberValue(String fieldId) {
    final value = getTextValue(fieldId).trim();
    if (value.isEmpty) return false;
    return num.tryParse(value) != null;
  }

  String getFormulaDisplayValue(FormFieldModel field) {
    final result = _evaluateFormulaField(field, {});
    return FormFormulaEvaluator.formatResult(result);
  }

  double? getFormulaNumericValue(FormFieldModel field) {
    return _evaluateFormulaField(field, {});
  }

  double? _evaluateFormulaField(
    FormFieldModel field,
    Set<String> visiting,
  ) {
    final fieldId = field.id ?? '';
    if (StringHelper.isEmptyString(fieldId)) return null;
    if (visiting.contains(fieldId)) return null;

    final expression = field.formulaExpression?.trim() ?? '';
    if (StringHelper.isEmptyString(expression)) return null;

    visiting.add(fieldId);
    final result = FormFormulaEvaluator.evaluate(
      expression: expression,
      allFields: fields,
      getFieldNumericValue: (sourceField, nestedVisiting) {
        return _getFormulaSourceNumericValue(
          sourceField,
          {...visiting, ...nestedVisiting},
        );
      },
    );
    visiting.remove(fieldId);
    return result;
  }

  double? _getFormulaSourceNumericValue(
    FormFieldModel field,
    Set<String> visiting,
  ) {
    final fieldId = field.id ?? '';
    if (StringHelper.isEmptyString(fieldId)) return 0;

    if (field.normalizedType == FormFieldType.number) {
      final value = getTextValue(fieldId).trim();
      if (value.isEmpty) return 0;
      return num.tryParse(value)?.toDouble();
    }

    if (field.normalizedType == FormFieldType.numbersSlider) {
      return sliderValues[fieldId];
    }

    if (field.normalizedType == FormFieldType.formula) {
      return _evaluateFormulaField(field, visiting);
    }

    return 0;
  }

  FormLocationValue? getLocationValue(String fieldId) =>
      locationValues[fieldId];

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

  FormSignatureValue getSignatureValue(String fieldId) {
    return signatureValues[fieldId] ?? FormSignatureValue();
  }

  void setSignatureValue(String fieldId, FormSignatureValue value) {
    signatureValues[fieldId] = value;
    signatureValues.refresh();
    if (value.isNotEmpty) {
      _clearFieldError(fieldId);
    }
    _clearErrorsForHiddenFields();
  }

  void clearSignature(String fieldId) {
    signatureValues[fieldId] = FormSignatureValue();
    signatureValues.refresh();
    _clearErrorsForHiddenFields();
  }

  bool hasSignatureValue(String fieldId) {
    return getSignatureValue(fieldId).isNotEmpty;
  }

  List<String> getImageUploadPaths(String fieldId) {
    return imageUploadValues[fieldId]?.toList() ?? [];
  }

  void addImageUploadPaths(
    String fieldId,
    List<String> paths, {
    required bool allowMultiple,
  }) {
    final images = imageUploadValues[fieldId];
    if (images == null || paths.isEmpty) return;

    if (allowMultiple) {
      images.addAll(paths);
    } else {
      images
        ..clear()
        ..add(paths.first);
    }
    images.refresh();
    _clearFieldError(fieldId);
    _clearErrorsForHiddenFields();
  }

  void removeImageUploadAt(String fieldId, int index) {
    final images = imageUploadValues[fieldId];
    if (images == null || index < 0 || index >= images.length) return;
    images.removeAt(index);
    images.refresh();
    _clearErrorsForHiddenFields();
  }

  bool hasImageUploadValue(String fieldId) {
    return getImageUploadPaths(fieldId).isNotEmpty;
  }

  List<String> getVideoUploadPaths(String fieldId) {
    return videoUploadValues[fieldId]?.toList() ?? [];
  }

  void addVideoUploadPaths(
    String fieldId,
    List<String> paths, {
    required bool allowMultiple,
  }) {
    final videos = videoUploadValues[fieldId];
    if (videos == null || paths.isEmpty) return;

    if (allowMultiple) {
      videos.addAll(paths);
    } else {
      videos
        ..clear()
        ..add(paths.first);
    }
    videos.refresh();
    _clearFieldError(fieldId);
    _clearErrorsForHiddenFields();
  }

  void removeVideoUploadAt(String fieldId, int index) {
    final videos = videoUploadValues[fieldId];
    if (videos == null || index < 0 || index >= videos.length) return;
    videos.removeAt(index);
    videos.refresh();
    _clearErrorsForHiddenFields();
  }

  bool hasVideoUploadValue(String fieldId) {
    return getVideoUploadPaths(fieldId).isNotEmpty;
  }

  List<String> getScannerUploadPaths(String fieldId) {
    return scannerUploadValues[fieldId]?.toList() ?? [];
  }

  void addScannerUploadPaths(
    String fieldId,
    List<String> paths, {
    required bool allowMultiple,
  }) {
    final scans = scannerUploadValues[fieldId];
    if (scans == null || paths.isEmpty) return;

    if (allowMultiple) {
      scans.addAll(paths);
    } else {
      scans
        ..clear()
        ..add(paths.first);
    }
    scans.refresh();
    _clearFieldError(fieldId);
    _clearErrorsForHiddenFields();
  }

  void removeScannerUploadAt(String fieldId, int index) {
    final scans = scannerUploadValues[fieldId];
    if (scans == null || index < 0 || index >= scans.length) return;
    scans.removeAt(index);
    scans.refresh();
    _clearErrorsForHiddenFields();
  }

  bool hasScannerUploadValue(String fieldId) {
    return getScannerUploadPaths(fieldId).isNotEmpty;
  }

  List<FormUploadedFile> getFileUploads(String fieldId) {
    return fileUploadValues[fieldId]?.toList() ?? [];
  }

  void addFileUploads(
    String fieldId,
    List<FormUploadedFile> files, {
    required bool allowMultiple,
  }) {
    final uploads = fileUploadValues[fieldId];
    if (uploads == null || files.isEmpty) return;

    if (allowMultiple) {
      uploads.addAll(files);
    } else {
      uploads
        ..clear()
        ..add(files.first);
    }
    uploads.refresh();
    _clearFieldError(fieldId);
    _clearErrorsForHiddenFields();
  }

  void removeFileUploadAt(String fieldId, int index) {
    final uploads = fileUploadValues[fieldId];
    if (uploads == null || index < 0 || index >= uploads.length) return;
    uploads.removeAt(index);
    uploads.refresh();
    _clearErrorsForHiddenFields();
  }

  bool hasFileUploadValue(String fieldId) {
    return getFileUploads(fieldId).isNotEmpty;
  }

  FormAudioRecordingValue? getAudioRecording(String fieldId) {
    return audioRecordingValues[fieldId];
  }

  void setAudioRecording(String fieldId, FormAudioRecordingValue value) {
    audioRecordingValues[fieldId] = value;
    audioRecordingValues.refresh();
    _clearFieldError(fieldId);
    _clearErrorsForHiddenFields();
  }

  void clearAudioRecording(String fieldId) {
    audioRecordingValues[fieldId] = null;
    audioRecordingValues.refresh();
    _clearErrorsForHiddenFields();
  }

  bool hasAudioRecordingValue(String fieldId) {
    return getAudioRecording(fieldId) != null;
  }

  Future<void> pickFileUpload({
    required FormFieldModel field,
  }) async {
    final fieldId = field.id ?? '';
    if (StringHelper.isEmptyString(fieldId)) return;

    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: field.allowsMultipleUploadsEnabled,
        type: FileType.any,
      );
      if (result == null) return;

      final files = result.files
          .where((file) => !StringHelper.isEmptyString(file.path))
          .map(
            (file) => FormUploadedFile(
              path: file.path!,
              name: file.name,
            ),
          )
          .toList();
      if (files.isEmpty) return;

      addFileUploads(
        fieldId,
        files,
        allowMultiple: field.allowsMultipleUploadsEnabled,
      );
    } catch (_) {
      // Picker failed (e.g. permission denied).
    }
  }

  Future<void> pickImageUpload({
    required BuildContext context,
    required FormFieldModel field,
  }) async {
    final fieldId = field.id ?? '';
    if (StringHelper.isEmptyString(fieldId)) return;

    final source = field.normalizedImageSource;
    if (source == 'both') {
      await _showImageSourceSheet(context: context, field: field);
      return;
    }

    final imageSource =
        source == 'camera' ? ImageSource.camera : ImageSource.gallery;
    await _pickImages(
      fieldId: fieldId,
      field: field,
      source: imageSource,
    );
  }

  Future<void> _showImageSourceSheet({
    required BuildContext context,
    required FormFieldModel field,
  }) async {
    final selectedSource = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: Text('camera'.tr),
                onTap: () => Navigator.pop(sheetContext, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: Text('gallery'.tr),
                onTap: () => Navigator.pop(sheetContext, ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );

    if (selectedSource == null) return;

    final fieldId = field.id ?? '';
    await _pickImages(
      fieldId: fieldId,
      field: field,
      source: selectedSource,
    );
  }

  Future<void> _pickImages({
    required String fieldId,
    required FormFieldModel field,
    required ImageSource source,
  }) async {
    try {
      final allowMultiple = field.allowsMultipleImageUploads;
      final paths = <String>[];

      if (source == ImageSource.camera) {
        final pickedFile = await _imagePicker.pickImage(source: source);
        if (pickedFile == null) return;
        final path = await _compressImagePath(pickedFile.path);
        if (!StringHelper.isEmptyString(path)) {
          paths.add(path!);
        }
      } else if (allowMultiple) {
        final pickedFiles = await _imagePicker.pickMultiImage();
        if (pickedFiles.isEmpty) return;
        for (final pickedFile in pickedFiles) {
          final path = await _compressImagePath(pickedFile.path);
          if (!StringHelper.isEmptyString(path)) {
            paths.add(path!);
          }
        }
      } else {
        final pickedFile = await _imagePicker.pickImage(source: source);
        if (pickedFile == null) return;
        final path = await _compressImagePath(pickedFile.path);
        if (!StringHelper.isEmptyString(path)) {
          paths.add(path!);
        }
      }

      if (paths.isEmpty) return;
      addImageUploadPaths(
        fieldId,
        paths,
        allowMultiple: allowMultiple,
      );
    } catch (_) {
      // Picker failed (e.g. permission denied).
    }
  }

  Future<String?> _compressImagePath(String path) async {
    final compressed = await ImageUtils.compressImage(File(path));
    return compressed?.path ?? path;
  }

  Future<void> pickVideoUpload({
    required BuildContext context,
    required FormFieldModel field,
  }) async {
    final fieldId = field.id ?? '';
    if (StringHelper.isEmptyString(fieldId)) return;

    final source = field.normalizedVideoSource;
    if (source == 'both') {
      await _showVideoSourceSheet(context: context, field: field);
      return;
    }

    final imageSource =
        source == 'camera' ? ImageSource.camera : ImageSource.gallery;
    await _pickVideos(
      fieldId: fieldId,
      field: field,
      source: imageSource,
    );
  }

  Future<void> _showVideoSourceSheet({
    required BuildContext context,
    required FormFieldModel field,
  }) async {
    final selectedSource = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.videocam_outlined),
                title: Text('camera'.tr),
                onTap: () => Navigator.pop(sheetContext, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.video_library_outlined),
                title: Text('gallery'.tr),
                onTap: () => Navigator.pop(sheetContext, ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );

    if (selectedSource == null) return;

    final fieldId = field.id ?? '';
    await _pickVideos(
      fieldId: fieldId,
      field: field,
      source: selectedSource,
    );
  }

  Future<void> _pickVideos({
    required String fieldId,
    required FormFieldModel field,
    required ImageSource source,
  }) async {
    try {
      final pickedFile = await _imagePicker.pickVideo(source: source);
      if (pickedFile == null) return;

      final path = await _compressVideoPath(pickedFile.path);
      if (StringHelper.isEmptyString(path)) return;

      addVideoUploadPaths(
        fieldId,
        [path!],
        allowMultiple: field.allowsMultipleVideoUploads,
      );
    } catch (_) {
      // Picker failed (e.g. permission denied).
    }
  }

  Future<String?> _compressVideoPath(String path) async {
    final compressed = await ImageUtils.compressVideo(File(path));
    return compressed?.path ?? path;
  }

  Future<void> scanDocument({
    required BuildContext context,
    required FormFieldModel field,
  }) async {
    final fieldId = field.id ?? '';
    if (StringHelper.isEmptyString(fieldId)) return;

    final source = field.normalizedScannerSource;
    if (source == 'both') {
      await _showScannerSourceSheet(context: context, field: field);
      return;
    }

    if (source == 'gallery') {
      await _scanFromGallery(fieldId: fieldId, field: field);
    } else {
      await _scanFromCamera(fieldId: fieldId, field: field);
    }
  }

  Future<void> _showScannerSourceSheet({
    required BuildContext context,
    required FormFieldModel field,
  }) async {
    final selectedSource = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.document_scanner_outlined),
                title: Text('camera'.tr),
                onTap: () => Navigator.pop(sheetContext, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: Text('gallery'.tr),
                onTap: () => Navigator.pop(sheetContext, ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );

    if (selectedSource == null) return;

    final fieldId = field.id ?? '';
    if (selectedSource == ImageSource.camera) {
      await _scanFromCamera(fieldId: fieldId, field: field);
    } else {
      await _scanFromGallery(fieldId: fieldId, field: field);
    }
  }

  Future<void> _scanFromCamera({
    required String fieldId,
    required FormFieldModel field,
  }) async {
    try {
      final pictures = await CunningDocumentScanner.getPictures(
        noOfPages: field.allowsMultipleScannerUploads ? 100 : 1,
        isGalleryImportAllowed: false,
      );
      if (pictures == null || pictures.isEmpty) return;

      final paths = <String>[];
      for (final picture in pictures) {
        final path = await _compressImagePath(picture);
        if (!StringHelper.isEmptyString(path)) {
          paths.add(path!);
        }
      }
      if (paths.isEmpty) return;

      addScannerUploadPaths(
        fieldId,
        paths,
        allowMultiple: field.allowsMultipleScannerUploads,
      );
    } on Exception {
      AppUtils.showSnackBarMessage('camera_permission_required'.tr);
    } catch (_) {
      AppUtils.showSnackBarMessage('scan_failed'.tr);
    }
  }

  Future<void> _scanFromGallery({
    required String fieldId,
    required FormFieldModel field,
  }) async {
    try {
      final allowMultiple = field.allowsMultipleScannerUploads;
      final paths = <String>[];

      if (allowMultiple) {
        final pickedFiles = await _imagePicker.pickMultiImage();
        if (pickedFiles.isEmpty) return;

        for (final pickedFile in pickedFiles) {
          final path = await _cropScannedImage(pickedFile.path);
          if (!StringHelper.isEmptyString(path)) {
            paths.add(path!);
          }
        }
      } else {
        final pickedFile = await _imagePicker.pickImage(
          source: ImageSource.gallery,
        );
        if (pickedFile == null) return;

        final path = await _cropScannedImage(pickedFile.path);
        if (!StringHelper.isEmptyString(path)) {
          paths.add(path!);
        }
      }

      if (paths.isEmpty) return;
      addScannerUploadPaths(
        fieldId,
        paths,
        allowMultiple: allowMultiple,
      );
    } catch (_) {
      AppUtils.showSnackBarMessage('scan_failed'.tr);
    }
  }

  Future<String?> _cropScannedImage(String path) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'scan'.tr,
          toolbarColor: backgroundColor_(Get.context!),
          toolbarWidgetColor: primaryTextColor_(Get.context!),
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'scan'.tr,
          aspectRatioLockEnabled: false,
        ),
      ],
    );
    if (croppedFile == null) return null;
    final croppedPath = croppedFile.path;
    if (StringHelper.isEmptyString(croppedPath)) return null;
    return _compressImagePath(croppedPath);
  }

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
      hasSignatureValue: hasSignatureValue,
      hasImageUploadValue: hasImageUploadValue,
      hasVideoUploadValue: hasVideoUploadValue,
      hasScannerUploadValue: hasScannerUploadValue,
      hasFileUploadValue: hasFileUploadValue,
      hasAudioRecordingValue: hasAudioRecordingValue,
      getFormulaValue: (fieldId) {
        final sourceField = findFieldById(fieldId);
        if (sourceField == null) return '';
        return getFormulaDisplayValue(sourceField);
      },
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
      signatureValues[fieldId];
      imageUploadValues[fieldId]?.length;
      videoUploadValues[fieldId]?.length;
      scannerUploadValues[fieldId]?.length;
      fileUploadValues[fieldId]?.length;
      audioRecordingValues[fieldId];
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
    final hiddenInvalidIds = invalidFieldIds.where((id) {
      final field = findFieldById(id);
      return field != null && !isFieldVisible(field);
    }).toList();

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

  bool _isNumberFieldInvalid(FormFieldModel field) {
    final fieldId = field.id ?? '';
    if (StringHelper.isEmptyString(fieldId)) return false;
    final value = getTextValue(fieldId).trim();
    if (value.isEmpty) return field.isRequired;
    return num.tryParse(value) == null;
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

  bool _isSignatureFieldInvalid(FormFieldModel field) {
    final fieldId = field.id ?? '';
    if (StringHelper.isEmptyString(fieldId)) return false;
    return !hasSignatureValue(fieldId);
  }

  bool _isImageUploadFieldInvalid(FormFieldModel field) {
    final fieldId = field.id ?? '';
    if (StringHelper.isEmptyString(fieldId)) return false;
    return !hasImageUploadValue(fieldId);
  }

  bool _isVideoUploadFieldInvalid(FormFieldModel field) {
    final fieldId = field.id ?? '';
    if (StringHelper.isEmptyString(fieldId)) return false;
    return !hasVideoUploadValue(fieldId);
  }

  bool _isScannerFieldInvalid(FormFieldModel field) {
    final fieldId = field.id ?? '';
    if (StringHelper.isEmptyString(fieldId)) return false;
    return !hasScannerUploadValue(fieldId);
  }

  bool _isFileUploadFieldInvalid(FormFieldModel field) {
    final fieldId = field.id ?? '';
    if (StringHelper.isEmptyString(fieldId)) return false;
    return !hasFileUploadValue(fieldId);
  }

  bool _isAudioRecordingFieldInvalid(FormFieldModel field) {
    final fieldId = field.id ?? '';
    if (StringHelper.isEmptyString(fieldId)) return false;
    return !hasAudioRecordingValue(fieldId);
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

      if (field.normalizedType == FormFieldType.number &&
          _isNumberFieldInvalid(field)) {
        invalidFieldIds.add(fieldId);
        isValid = false;
        continue;
      }

      if (!field.isRequired) continue;

      if (field.normalizedType == FormFieldType.dropdown &&
          _isDropdownFieldInvalid(field)) {
        invalidFieldIds.add(fieldId);
        isValid = false;
      } else if (field.normalizedType == FormFieldType.imageSelection &&
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
      } else if (field.normalizedType == FormFieldType.signature &&
          _isSignatureFieldInvalid(field)) {
        invalidFieldIds.add(fieldId);
        isValid = false;
      } else if (field.normalizedType == FormFieldType.imageUpload &&
          _isImageUploadFieldInvalid(field)) {
        invalidFieldIds.add(fieldId);
        isValid = false;
      } else if (field.normalizedType == FormFieldType.videoUpload &&
          _isVideoUploadFieldInvalid(field)) {
        invalidFieldIds.add(fieldId);
        isValid = false;
      } else if (field.normalizedType == FormFieldType.scanner &&
          _isScannerFieldInvalid(field)) {
        invalidFieldIds.add(fieldId);
        isValid = false;
      } else if (field.normalizedType == FormFieldType.fileUpload &&
          _isFileUploadFieldInvalid(field)) {
        invalidFieldIds.add(fieldId);
        isValid = false;
      } else if (field.normalizedType == FormFieldType.audioRecording &&
          _isAudioRecordingFieldInvalid(field)) {
        invalidFieldIds.add(fieldId);
        isValid = false;
      }
    }

    return isValid;
  }

  void onSendPressed() {
    if (!validateForm()) return;
    _submitFormEntry();
  }

  Future<void> _submitFormEntry() async {
    isLoading.value = true;

    try {
      final formData = await _buildSubmitFormData();
      _api.submitFormEntry(
        formData: formData,
        onSuccess: (ResponseModel responseModel) {
          isLoading.value = false;
          if (responseModel.isSuccess && responseModel.result != null) {
            final response = BaseResponse.fromJson(
              jsonDecode(responseModel.result!) as Map<String, dynamic>,
            );
            AppUtils.showApiResponseMessage(response.Message ?? '');
            if (response.IsSuccess == true) {
              Get.back(result: true);
            }
          } else {
            AppUtils.showSnackBarMessage(responseModel.statusMessage ?? '');
          }
        },
        onError: (ResponseModel error) {
          isLoading.value = false;
          if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
            AppUtils.showApiResponseMessage('no_internet'.tr);
          } else if (!StringHelper.isEmptyString(error.statusMessage)) {
            AppUtils.showSnackBarMessage(error.statusMessage ?? '');
          }
        },
      );
    } catch (_) {
      isLoading.value = false;
      AppUtils.showSnackBarMessage('Failed to submit form');
    }
  }

  Future<multi.FormData> _buildSubmitFormData() async {
    final payload = <String, dynamic>{
      'form_id': formId,
      'user_id': UserUtils.getLoginUserId(),
    };
    final files = <MapEntry<String, multi.MultipartFile>>[];

    await _appendFieldsToSubmitPayload(fields, payload, files);

    final formData = multi.FormData.fromMap(payload);
    formData.files.addAll(files);
    return formData;
  }

  Future<void> _appendFieldsToSubmitPayload(
    List<FormFieldModel> fieldList,
    Map<String, dynamic> payload,
    List<MapEntry<String, multi.MultipartFile>> files,
  ) async {
    for (final field in fieldList) {
      if (field.normalizedType == FormFieldType.group) {
        await _appendFieldsToSubmitPayload(
          field.fields ?? [],
          payload,
          files,
        );
        continue;
      }

      if (!isFieldVisible(field)) continue;

      final fieldId = field.id;
      if (StringHelper.isEmptyString(fieldId)) continue;

      final key = 'data[$fieldId]';
      final type = field.normalizedType;

      if (type == FormFieldType.dropdown) {
        _appendDropdownValue(field, key, payload);
      } else if (type == FormFieldType.imageSelection) {
        _appendImageSelectionValue(field, key, payload);
      } else if (type == FormFieldType.openEnded ||
          type == FormFieldType.email ||
          type == FormFieldType.number) {
        _appendTextValue(fieldId!, key, payload);
      } else if (type == FormFieldType.phone) {
        _appendPhoneValue(fieldId!, key, payload);
      } else if (type == FormFieldType.rating) {
        _appendRatingValue(fieldId!, key, payload);
      } else if (type == FormFieldType.yesNo) {
        _appendYesNoValue(field, key, payload);
      } else if (type == FormFieldType.task) {
        _appendTaskValue(fieldId!, key, payload);
      } else if (type == FormFieldType.date) {
        _appendDateValue(field, key, payload);
      } else if (type == FormFieldType.numbersSlider) {
        _appendSliderValue(field, key, payload);
      } else if (type == FormFieldType.location) {
        _appendLocationValue(field, key, payload);
      } else if (type == FormFieldType.formula) {
        _appendFormulaValue(field, key, payload);
      } else if (type == FormFieldType.signature) {
        await _appendSignatureFile(fieldId!, key, files);
      } else if (type == FormFieldType.imageUpload) {
        await _appendPathFiles(
          getImageUploadPaths(fieldId!),
          _submitFileFieldKey(
            fieldId,
            allowMultiple: field.allowsMultipleImageUploads,
          ),
          files,
        );
      } else if (type == FormFieldType.videoUpload) {
        await _appendPathFiles(
          getVideoUploadPaths(fieldId!),
          _submitFileFieldKey(
            fieldId,
            allowMultiple: field.allowsMultipleVideoUploads,
          ),
          files,
        );
      } else if (type == FormFieldType.scanner) {
        await _appendPathFiles(
          getScannerUploadPaths(fieldId!),
          _submitFileFieldKey(
            fieldId,
            allowMultiple: field.allowsMultipleScannerUploads,
          ),
          files,
        );
      } else if (type == FormFieldType.fileUpload) {
        await _appendUploadedFiles(
          fieldId!,
          _submitFileFieldKey(
            fieldId,
            allowMultiple: field.allowsMultipleUploadsEnabled,
          ),
          files,
        );
      } else if (type == FormFieldType.audioRecording) {
        await _appendAudioRecordingFile(
          fieldId!,
          _submitFileFieldKey(
            fieldId,
            allowMultiple: field.allowsMultipleUploadsEnabled,
          ),
          files,
        );
      }
    }
  }

  void _appendDropdownValue(
    FormFieldModel field,
    String key,
    Map<String, dynamic> payload,
  ) {
    final fieldId = field.id ?? '';
    if (field.multipleSelection == true) {
      final selected = multipleSelections[fieldId]?.toList() ?? [];
      if (selected.isEmpty) return;
      payload[key] = selected.join(',');
      return;
    }

    final selected = getSingleSelection(fieldId);
    if (!StringHelper.isEmptyString(selected)) {
      payload[key] = selected;
    }
  }

  void _appendImageSelectionValue(
    FormFieldModel field,
    String key,
    Map<String, dynamic> payload,
  ) {
    final fieldId = field.id ?? '';
    final options = field.imageSelectionOptions;
    if (options.isEmpty) return;

    if (field.multipleSelection == true) {
      final selected = multipleSelections[fieldId] ?? {};
      final indices = <int>[];
      for (var index = 0; index < options.length; index++) {
        if (selected.contains(options[index])) {
          indices.add(index);
        }
      }
      if (indices.isEmpty) return;
      payload[key] = indices.map((index) => index.toString()).join(',');
      return;
    }

    final selected = getSingleSelection(fieldId);
    if (StringHelper.isEmptyString(selected)) return;

    final index = options.indexOf(selected!);
    if (index >= 0) {
      payload[key] = index.toString();
    }
  }

  void _appendTextValue(
    String fieldId,
    String key,
    Map<String, dynamic> payload,
  ) {
    final value = getTextValue(fieldId).trim();
    if (value.isEmpty) return;
    payload[key] = value;
  }

  void _appendPhoneValue(
    String fieldId,
    String key,
    Map<String, dynamic> payload,
  ) {
    final phone = phoneValues[fieldId];
    if (phone == null || phone.isEmpty) return;
    payload[key] = '${phone.extension} ${phone.phone.trim()}'.trim();
  }

  void _appendRatingValue(
    String fieldId,
    String key,
    Map<String, dynamic> payload,
  ) {
    final rating = getRating(fieldId);
    if (rating <= 0) return;
    payload[key] = rating.toString();
  }

  void _appendYesNoValue(
    FormFieldModel field,
    String key,
    Map<String, dynamic> payload,
  ) {
    final selected = getSingleSelection(field.id ?? '');
    if (StringHelper.isEmptyString(selected)) return;

    final normalized = selected!.trim().toLowerCase();
    if (normalized == 'yes' || normalized == 'true') {
      payload[key] = 'true';
      return;
    }
    if (normalized == 'no' || normalized == 'false') {
      payload[key] = 'false';
      return;
    }

    final options = field.yesNoOptions;
    if (options.isNotEmpty &&
        normalized == options.first.trim().toLowerCase()) {
      payload[key] = 'true';
    } else {
      payload[key] = 'false';
    }
  }

  void _appendTaskValue(
    String fieldId,
    String key,
    Map<String, dynamic> payload,
  ) {
    payload[key] = isTaskChecked(fieldId).toString();
  }

  void _appendDateValue(
    FormFieldModel field,
    String key,
    Map<String, dynamic> payload,
  ) {
    final value = _formatDateSubmitValue(field);
    if (StringHelper.isEmptyString(value)) return;
    payload[key] = value;
  }

  String? _formatDateSubmitValue(FormFieldModel field) {
    final fieldId = field.id ?? '';
    final value = dateValues[fieldId];
    if (value == null) return null;

    if (field.includesDate && field.includesTime) {
      if (value.date == null || value.time == null) return null;
      final datePart = DateUtil.dateToString(
        value.date,
        DateUtil.DD_MM_YYYY_SLASH,
      );
      final timePart = DateUtil.timeToString(
        value.time,
        DateUtil.HH_MM_24,
      );
      return '$datePart $timePart';
    }

    if (field.includesDate && value.date != null) {
      return DateUtil.dateToString(value.date, DateUtil.DD_MM_YYYY_SLASH);
    }

    if (field.includesTime && value.time != null) {
      return DateUtil.timeToString(value.time, DateUtil.HH_MM_24);
    }

    return null;
  }

  void _appendSliderValue(
    FormFieldModel field,
    String key,
    Map<String, dynamic> payload,
  ) {
    final fieldId = field.id ?? '';
    final value = sliderValues[fieldId];
    if (value == null) return;
    payload[key] = value.toString();
  }

  void _appendLocationValue(
    FormFieldModel field,
    String key,
    Map<String, dynamic> payload,
  ) {
    final fieldId = field.id ?? '';
    final value = locationValues[fieldId];
    if (value == null || !hasLocationValue(field)) return;

    double? lat;
    double? lng;
    String address = '';

    if (field.isManualLocation) {
      final coordinates = FormLocationValue.parseManualInput(value.manualInput);
      lat = coordinates?.latitude;
      lng = coordinates?.longitude;
      address = value.manualInput.trim();
    } else {
      lat = value.latitude;
      lng = value.longitude;
    }

    if (lat == null || lng == null) return;

    payload[key] = jsonEncode({
      'lat': lat,
      'lng': lng,
      'address': address,
    });
  }

  void _appendFormulaValue(
    FormFieldModel field,
    String key,
    Map<String, dynamic> payload,
  ) {
    final value = getFormulaDisplayValue(field).trim();
    if (value.isEmpty) return;
    payload[key] = value;
  }

  String _submitFileFieldKey(String fieldId, {required bool allowMultiple}) {
    return allowMultiple ? 'data[$fieldId][]' : 'data[$fieldId]';
  }

  Future<void> _appendSignatureFile(
    String fieldId,
    String key,
    List<MapEntry<String, multi.MultipartFile>> files,
  ) async {
    final signature = getSignatureValue(fieldId);
    if (signature.isEmpty) return;

    final path = await FormSignatureExporter.exportToTempPng(signature);
    if (path == null) return;

    files.add(
      MapEntry(
        key,
        await multi.MultipartFile.fromFile(path),
      ),
    );
  }

  Future<void> _appendPathFiles(
    List<String> paths,
    String key,
    List<MapEntry<String, multi.MultipartFile>> files,
  ) async {
    for (final path in paths) {
      if (StringHelper.isEmptyString(path) || !File(path).existsSync())
        continue;
      files.add(
        MapEntry(
          key,
          await multi.MultipartFile.fromFile(path),
        ),
      );
    }
  }

  Future<void> _appendUploadedFiles(
    String fieldId,
    String key,
    List<MapEntry<String, multi.MultipartFile>> files,
  ) async {
    for (final file in getFileUploads(fieldId)) {
      if (StringHelper.isEmptyString(file.path) ||
          !File(file.path).existsSync()) {
        continue;
      }
      files.add(
        MapEntry(
          key,
          await multi.MultipartFile.fromFile(
            file.path,
            filename: file.name,
          ),
        ),
      );
    }
  }

  Future<void> _appendAudioRecordingFile(
    String fieldId,
    String key,
    List<MapEntry<String, multi.MultipartFile>> files,
  ) async {
    final recording = getAudioRecording(fieldId);
    if (recording == null || StringHelper.isEmptyString(recording.path)) return;
    if (!File(recording.path).existsSync()) return;

    files.add(
      MapEntry(
        key,
        await multi.MultipartFile.fromFile(
          recording.path,
          filename: recording.displayName,
        ),
      ),
    );
  }
}
