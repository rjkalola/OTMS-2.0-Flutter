import 'package:belcka/pages/manage_forms/submit_form/model/form_field_condition.dart';

class FormFieldModel {
  String? id;
  String? type;
  String? label;
  String? description;
  bool? required;
  bool? showOnlyIf;
  bool? multipleSelection;
  bool? allowMultipleUploads;
  bool? locationStampCapture;
  String? imageSource;
  String? videoSource;
  String? scannerSource;
  String? locationSelectBy;
  String? ratingMinLabel;
  String? ratingMaxLabel;
  int? ratingStarCount;
  bool? dateIncludeDate;
  bool? dateIncludeTime;
  List<String>? options;
  List<dynamic>? optionImages;
  dynamic minValue;
  dynamic maxValue;
  String? formulaExpression;
  String? optionSortMode;
  String? conditionValue;
  String? conditionFieldId;
  String? conditionOperator;
  List<FormFieldCondition>? conditions;
  List<FormFieldModel>? fields;

  FormFieldModel({
    this.id,
    this.type,
    this.label,
    this.description,
    this.required,
    this.showOnlyIf,
    this.multipleSelection,
    this.allowMultipleUploads,
    this.locationStampCapture,
    this.imageSource,
    this.videoSource,
    this.scannerSource,
    this.locationSelectBy,
    this.ratingMinLabel,
    this.ratingMaxLabel,
    this.ratingStarCount,
    this.dateIncludeDate,
    this.dateIncludeTime,
    this.options,
    this.optionImages,
    this.minValue,
    this.maxValue,
    this.formulaExpression,
    this.conditionValue,
    this.conditionFieldId,
    this.conditionOperator,
    this.conditions,
    this.fields,
  });

  FormFieldModel.fromJson(Map<String, dynamic> json) {
    id = (json['field_key'] ?? json['id'])?.toString();
    type = json['type'];
    label = json['label'];
    description = json['description'];
    required = json['required'] ?? json['is_required'];
    showOnlyIf = json['showOnlyIf'] ?? json['show_only_if'];
    multipleSelection = json['multipleSelection'];
    allowMultipleUploads = json['allowMultipleUploads'];
    locationStampCapture = json['locationStampCapture'];
    imageSource = json['imageSource'] ?? json['image_source'];
    videoSource = json['videoSource'] ?? json['video_source'];
    scannerSource = json['scannerSource'] ?? json['scanner_source'];
    locationSelectBy = json['locationSelectBy'] ?? json['location_select_by'];
    ratingMinLabel = json['ratingMinLabel'] ?? json['rating_min_label'];
    ratingMaxLabel = json['ratingMaxLabel'] ?? json['rating_max_label'];
    ratingStarCount = json['ratingStarCount'] ?? json['rating_star_count'];
    dateIncludeDate = json['dateIncludeDate'] ?? json['date_include_date'];
    dateIncludeTime = json['dateIncludeTime'] ?? json['date_include_time'];
    formulaExpression = json['formula_expression'] ?? json['formulaExpression'];
    optionSortMode = json['optionSortMode'] ?? json['option_sort_mode']?.toString();
    conditionValue = json['conditionValue'] ?? json['condition_value']?.toString();
    conditionFieldId = json['conditionFieldId'] ??
        json['condition_field_key']?.toString();
    conditionOperator = json['conditionOperator'] ??
        json['condition_operator']?.toString();

    if (json['options'] != null) {
      options = json['options'].map<String>((v) => v.toString()).toList();
    }
    optionImages = json['option_images'] ?? json['optionImages'];

    minValue = json['min_value'] ?? json['minValue'];
    maxValue = json['max_value'] ?? json['maxValue'];

    if (json['conditions'] != null) {
      conditions = <FormFieldCondition>[];
      json['conditions'].forEach((v) {
        conditions!.add(FormFieldCondition.fromJson(v));
      });
    }

    if (json['fields'] != null) {
      fields = <FormFieldModel>[];
      json['fields'].forEach((v) {
        fields!.add(FormFieldModel.fromJson(v));
      });
    }

    final raw = json['raw'];
    if (raw is Map<String, dynamic>) {
      id ??= raw['id']?.toString();
      type ??= raw['type']?.toString();
      label ??= raw['label']?.toString();
      description ??= raw['description']?.toString();
      required ??= raw['required'];
      showOnlyIf ??= raw['showOnlyIf'];
      multipleSelection ??= raw['multipleSelection'];
      allowMultipleUploads ??= raw['allowMultipleUploads'];
      locationStampCapture ??= raw['locationStampCapture'];
      imageSource ??= raw['imageSource']?.toString();
      videoSource ??= raw['videoSource']?.toString();
      scannerSource ??= raw['scannerSource']?.toString();
      locationSelectBy ??= raw['locationSelectBy'];
      ratingMinLabel ??= raw['ratingMinLabel'];
      ratingMaxLabel ??= raw['ratingMaxLabel'];
      ratingStarCount ??= raw['ratingStarCount'];
      dateIncludeDate ??= raw['dateIncludeDate'];
      dateIncludeTime ??= raw['dateIncludeTime'];
      minValue ??= raw['minValue'];
      maxValue ??= raw['maxValue'];
      formulaExpression ??=
          raw['formulaExpression'] ?? raw['formula_expression']?.toString();
      optionSortMode ??= raw['optionSortMode']?.toString();
      conditionValue ??= raw['conditionValue']?.toString();
      conditionFieldId ??= raw['conditionFieldId']?.toString();
      conditionOperator ??= raw['conditionOperator']?.toString();
      optionImages ??= raw['optionImages'];
      if (options == null && raw['options'] != null) {
        options = raw['options'].map<String>((v) => v.toString()).toList();
      }
    }
  }

  String? getOptionImageAt(int index) {
    final images = optionImages;
    if (images == null || index < 0 || index >= images.length) return null;
    final value = images[index];
    if (value == null) return null;
    final text = value.toString().trim();
    if (text.isEmpty) return null;
    return text;
  }

  /// Resolves selectable values when [options] is missing but [optionImages] exists.
  List<String> get imageSelectionOptions {
    final labels = options ?? const <String>[];
    final imageCount = optionImages?.length ?? 0;
    if (labels.isEmpty && imageCount == 0) return const [];

    final count = labels.length > imageCount ? labels.length : imageCount;
    return List.generate(count, (index) => _imageSelectionLabelAt(index));
  }

  String imageSelectionDisplayLabelAt(int index) =>
      _imageSelectionLabelAt(index);

  String _imageSelectionLabelAt(int index) {
    final labels = options ?? const <String>[];
    if (index < labels.length && labels[index].trim().isNotEmpty) {
      return labels[index];
    }
    return 'Option ${index + 1}';
  }

  String get normalizedType {
    return (type ?? '').trim().toLowerCase().replaceAll('/', '');
  }

  bool get isRequired => required == true;

  bool get isHtmlLabel {
    final value = label ?? '';
    return value.contains('<') && value.contains('>');
  }

  bool get isManualLocation =>
      (locationSelectBy ?? '').trim().toLowerCase() == 'manual';

  int get ratingStars {
    final count = ratingStarCount ?? 5;
    if (count < 3) return 3;
    if (count > 5) return 5;
    return count;
  }

  List<String> get yesNoOptions {
    final values = options ?? [];
    if (values.length >= 2) {
      return values.take(2).map((value) => value.toString()).toList();
    }
    return const ['Yes', 'No'];
  }

  bool get includesDate => dateIncludeDate != false;

  bool get includesTime => dateIncludeTime == true;

  bool get allowsMultipleImageUploads => allowMultipleUploads == true;

  bool get allowsMultipleVideoUploads => allowMultipleUploads == true;

  bool get allowsMultipleScannerUploads => allowMultipleUploads == true;

  bool get allowsMultipleUploadsEnabled => allowMultipleUploads == true;

  String get normalizedImageSource =>
      (imageSource ?? 'both').trim().toLowerCase();

  String get normalizedVideoSource =>
      (videoSource ?? 'both').trim().toLowerCase();

  String get normalizedScannerSource =>
      (scannerSource ?? 'both').trim().toLowerCase();

  double get sliderMin => _parseNumericValue(minValue) ?? 0;

  double get sliderMax {
    final min = sliderMin;
    final max = _parseNumericValue(maxValue);
    if (max == null || max <= min) return min + 100;
    return max;
  }

  double? _parseNumericValue(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }
}
