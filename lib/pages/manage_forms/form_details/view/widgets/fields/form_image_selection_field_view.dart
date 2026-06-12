import 'dart:convert';
import 'dart:typed_data';

import 'package:belcka/pages/manage_forms/form_details/controller/form_details_controller.dart';
import 'package:belcka/pages/manage_forms/form_details/model/form_field_model.dart';
import 'package:belcka/pages/manage_forms/form_details/view/widgets/shared/form_field_label.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class _OptionRowLayout {
  static const double itemSpacing = 12;
  static const double controlSize = 22;
  static const double controlColumnWidth = 24;
  static const double radioTextGap = 4;
  static const double checkboxTextGap = 0;
  static const double cardBorderWidth = 2;
  static const double cardBorderRadius = 12;
  static const double rowLeadingMargin = 8;
  static const EdgeInsets selectionRowPadding =
      EdgeInsets.fromLTRB(rowLeadingMargin, 10, 12, 12);
  static const EdgeInsets textOnlySelectionRowPadding =
      EdgeInsets.fromLTRB(rowLeadingMargin, 4, 12, 4);
}

Uint8List? _decodeOptionImageBytes(String? value) {
  if (StringHelper.isEmptyString(value)) return null;

  try {
    final data = value!;
    final commaIndex = data.indexOf(',');
    final encoded = commaIndex == -1 ? data : data.substring(commaIndex + 1);
    return base64Decode(encoded);
  } catch (_) {
    return null;
  }
}

class FormImageSelectionFieldView extends StatelessWidget {
  const FormImageSelectionFieldView({
    super.key,
    required this.field,
    this.isNested = false,
  });

  final FormFieldModel field;
  final bool isNested;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FormDetailsController>();
    final options = field.imageSelectionOptions;
    final fieldId = field.id ?? '';
    final allowsMultiple = field.multipleSelection == true;
    final imageBytesByOption = [
      for (var i = 0; i < options.length; i++)
        _decodeOptionImageBytes(field.getOptionImageAt(i)),
    ];
    final displayLabels = [
      for (var i = 0; i < options.length; i++)
        field.imageSelectionDisplayLabelAt(i),
    ];

    return Obx(
      () {
        final hasError = controller.showValidationErrors.value &&
            controller.isFieldInvalid(fieldId);

        return CardViewDashboardItem(
          borderRadius: isNested ? 12 : 16,
          margin: isNested
              ? EdgeInsets.zero
              : const EdgeInsets.fromLTRB(16, 0, 16, 12),
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormFieldLabel(
                label: field.label ?? '',
                isRequired: field.isRequired,
              ),
              if (!StringHelper.isEmptyString(field.description)) ...[
                const SizedBox(height: 4),
                SubtitleTextView(
                  text: field.description!,
                  fontSize: 14,
                  color: secondaryExtraLightTextColor_(context),
                  maxLine: 4,
                ),
              ],
              if (options.isNotEmpty) ...[
                const SizedBox(height: 12),
                if (allowsMultiple)
                  _MultipleImageOptions(
                    fieldId: fieldId,
                    options: options,
                    displayLabels: displayLabels,
                    imageBytesByOption: imageBytesByOption,
                    controller: controller,
                  )
                else
                  _SingleImageOptions(
                    fieldId: fieldId,
                    options: options,
                    displayLabels: displayLabels,
                    imageBytesByOption: imageBytesByOption,
                    controller: controller,
                  ),
              ],
              if (hasError && field.isRequired) ...[
                const SizedBox(height: 6),
                Text(
                  'this_field_is_required'.tr,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: rejectTextColor_(context),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _SingleImageOptions extends StatelessWidget {
  const _SingleImageOptions({
    required this.fieldId,
    required this.options,
    required this.displayLabels,
    required this.imageBytesByOption,
    required this.controller,
  });

  final String fieldId;
  final List<String> options;
  final List<String> displayLabels;
  final List<Uint8List?> imageBytesByOption;
  final FormDetailsController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => RadioGroup<String>(
        groupValue: controller.getSingleSelection(fieldId),
        onChanged: (value) => controller.setSingleSelection(fieldId, value),
        child: Column(
          children: [
            for (var i = 0; i < options.length; i++) ...[
              if (i > 0) const SizedBox(height: _OptionRowLayout.itemSpacing),
              _ImageSelectionOption(
                key: ValueKey('$fieldId-$i-${options[i]}'),
                fieldId: fieldId,
                selectionValue: options[i],
                displayLabel: displayLabels[i],
                imageBytes: imageBytesByOption[i],
                isMultiple: false,
                controller: controller,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MultipleImageOptions extends StatelessWidget {
  const _MultipleImageOptions({
    required this.fieldId,
    required this.options,
    required this.displayLabels,
    required this.imageBytesByOption,
    required this.controller,
  });

  final String fieldId;
  final List<String> options;
  final List<String> displayLabels;
  final List<Uint8List?> imageBytesByOption;
  final FormDetailsController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < options.length; i++) ...[
          if (i > 0) const SizedBox(height: _OptionRowLayout.itemSpacing),
          _ImageSelectionOption(
            key: ValueKey('$fieldId-$i-${options[i]}'),
            fieldId: fieldId,
            selectionValue: options[i],
            displayLabel: displayLabels[i],
            imageBytes: imageBytesByOption[i],
            isMultiple: true,
            controller: controller,
          ),
        ],
      ],
    );
  }
}

class _ImageSelectionOption extends StatelessWidget {
  const _ImageSelectionOption({
    super.key,
    required this.fieldId,
    required this.selectionValue,
    required this.displayLabel,
    required this.imageBytes,
    required this.isMultiple,
    required this.controller,
  });

  final String fieldId;
  final String selectionValue;
  final String displayLabel;
  final Uint8List? imageBytes;
  final bool isMultiple;
  final FormDetailsController controller;

  bool _isSelected() {
    return isMultiple
        ? controller.isMultipleSelected(fieldId, selectionValue)
        : controller.getSingleSelection(fieldId) == selectionValue;
  }

  VoidCallback _onTap() {
    return () {
      if (isMultiple) {
        controller.toggleMultipleSelection(fieldId, selectionValue);
      } else {
        controller.setSingleSelection(fieldId, selectionValue);
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = imageBytes != null;
    final onTap = _onTap();

    return Obx(
      () {
        final isSelected = _isSelected();
        final borderColor = hasImage
            ? (isSelected
                ? defaultAccentColor_(context)
                : dividerColor_(context))
            : Colors.transparent;

        return SizedBox(
          width: double.infinity,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius:
                  BorderRadius.circular(_OptionRowLayout.cardBorderRadius),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(_OptionRowLayout.cardBorderRadius),
                  border: Border.all(
                    color: borderColor,
                    width: _OptionRowLayout.cardBorderWidth,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (hasImage)
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(
                            _OptionRowLayout.cardBorderRadius - 1,
                          ),
                        ),
                        child: _StableOptionImage(
                          key: ValueKey(selectionValue),
                          bytes: imageBytes!,
                        ),
                      ),
                    _SelectionRow(
                      selectionValue: selectionValue,
                      displayLabel: displayLabel,
                      isSelected: isSelected,
                      isMultiple: isMultiple,
                      onTap: onTap,
                      padding: hasImage
                          ? _OptionRowLayout.selectionRowPadding
                          : _OptionRowLayout.textOnlySelectionRowPadding,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SelectionRow extends StatelessWidget {
  const _SelectionRow({
    required this.selectionValue,
    required this.displayLabel,
    required this.isSelected,
    required this.isMultiple,
    required this.onTap,
    required this.padding,
  });

  final String selectionValue;
  final String displayLabel;
  final bool isSelected;
  final bool isMultiple;
  final VoidCallback onTap;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final accentColor = defaultAccentColor_(context);
    final textGap = isMultiple
        ? _OptionRowLayout.checkboxTextGap
        : _OptionRowLayout.radioTextGap;

    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: _OptionRowLayout.controlColumnWidth,
            child: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: _OptionRowLayout.controlSize,
                height: _OptionRowLayout.controlSize,
                child: isMultiple
                    ? Checkbox(
                        value: isSelected,
                        activeColor: accentColor,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: const VisualDensity(
                          horizontal: -4,
                          vertical: -4,
                        ),
                        onChanged: (_) => onTap(),
                      )
                    : Radio<String>(
                        value: selectionValue,
                        activeColor: accentColor,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: const VisualDensity(
                          horizontal: -4,
                          vertical: -4,
                        ),
                      ),
              ),
            ),
          ),
          if (displayLabel.isNotEmpty) ...[
            SizedBox(width: textGap),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 1),
                child: Text(
                  displayLabel,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: primaryTextColor_(context),
                    height: 1.2,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StableOptionImage extends StatefulWidget {
  const _StableOptionImage({
    super.key,
    required this.bytes,
  });

  final Uint8List bytes;

  @override
  State<_StableOptionImage> createState() => _StableOptionImageState();
}

class _StableOptionImageState extends State<_StableOptionImage> {
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Image.memory(
        widget.bytes,
        width: double.infinity,
        height: 150,
        fit: BoxFit.cover,
        gaplessPlayback: true,
        filterQuality: FilterQuality.medium,
      ),
    );
  }
}
