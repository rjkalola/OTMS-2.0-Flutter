import 'package:belcka/pages/manage_forms/form_details/controller/form_details_controller.dart';
import 'package:belcka/pages/manage_forms/form_details/model/form_field_model.dart';
import 'package:belcka/pages/manage_forms/form_details/view/widgets/shared/form_field_label.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/image/grid_image.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormScannerFieldView extends StatelessWidget {
  const FormScannerFieldView({
    super.key,
    required this.field,
    this.isNested = false,
  });

  final FormFieldModel field;
  final bool isNested;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FormDetailsController>();
    final fieldId = field.id ?? '';
    final accentColor = defaultAccentColor_(context);
    final allowsMultiple = field.allowsMultipleScannerUploads;

    return Obx(
      () {
        final scanPaths = controller.getScannerUploadPaths(fieldId);
        final hasScans = scanPaths.isNotEmpty;
        final hasError = controller.showValidationErrors.value &&
            controller.isFieldInvalid(fieldId);
        final scanLabel = hasScans && allowsMultiple
            ? 'upload_more_files'.tr
            : 'scan'.tr;

        return CardViewDashboardItem(
          borderRadius: isNested ? 12 : 16,
          margin: isNested
              ? const EdgeInsets.symmetric(horizontal: 4)
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
              if (hasScans) ...[
                const SizedBox(height: 12),
                if (allowsMultiple)
                  _ScannerUploadGrid(
                    imagePaths: scanPaths,
                    onRemove: (index) =>
                        controller.removeScannerUploadAt(fieldId, index),
                  )
                else
                  _SingleScanPreview(
                    imagePath: scanPaths.first,
                    onRemove: () => controller.removeScannerUploadAt(fieldId, 0),
                  ),
              ],
              if (!hasScans || allowsMultiple) ...[
                SizedBox(height: hasScans ? 12 : 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => controller.scanDocument(
                      context: context,
                      field: field,
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: accentColor,
                      side: BorderSide(color: dividerColor_(context)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: const StadiumBorder(),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.document_scanner_outlined,
                          size: 18,
                          color: accentColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          scanLabel,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: accentColor,
                          ),
                        ),
                      ],
                    ),
                  ),
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

class _SingleScanPreview extends StatelessWidget {
  const _SingleScanPreview({
    required this.imagePath,
    required this.onRemove,
  });

  final String imagePath;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: 104,
        height: 104,
        child: GridImage(
          file: imagePath,
          fileRadius: 10,
          onRemoveClick: onRemove,
        ),
      ),
    );
  }
}

class _ScannerUploadGrid extends StatelessWidget {
  const _ScannerUploadGrid({
    required this.imagePaths,
    required this.onRemove,
  });

  final List<String> imagePaths;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: imagePaths.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        return GridImage(
          file: imagePaths[index],
          fileRadius: 10,
          onRemoveClick: () => onRemove(index),
        );
      },
    );
  }
}
