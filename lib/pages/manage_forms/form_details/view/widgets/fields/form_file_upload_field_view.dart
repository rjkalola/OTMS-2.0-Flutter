import 'package:belcka/pages/manage_forms/form_details/controller/form_details_controller.dart';
import 'package:belcka/pages/manage_forms/form_details/model/form_field_model.dart';
import 'package:belcka/pages/manage_forms/form_details/model/form_uploaded_file.dart';
import 'package:belcka/pages/manage_forms/form_details/view/widgets/shared/form_field_label.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormFileUploadFieldView extends StatelessWidget {
  const FormFileUploadFieldView({
    super.key,
    required this.field,
    this.isNested = false,
  });

  final FormFieldModel field;
  final bool isNested;

  static const Color _fileIconColor = Color(0xFF26C6DA);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FormDetailsController>();
    final fieldId = field.id ?? '';
    final accentColor = defaultAccentColor_(context);
    final allowsMultiple = field.allowsMultipleUploadsEnabled;

    return Obx(
      () {
        final files = controller.getFileUploads(fieldId);
        final hasFiles = files.isNotEmpty;
        final hasError = controller.showValidationErrors.value &&
            controller.isFieldInvalid(fieldId);
        final uploadLabel = hasFiles && allowsMultiple
            ? 'upload_more_files'.tr
            : 'upload_a_file'.tr;

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
              if (hasFiles) ...[
                const SizedBox(height: 12),
                ...List.generate(files.length, (index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index == files.length - 1 ? 0 : 10,
                    ),
                    child: _UploadedFileRow(
                      file: files[index],
                      onRemove: () =>
                          controller.removeFileUploadAt(fieldId, index),
                    ),
                  );
                }),
              ],
              if (!hasFiles || allowsMultiple) ...[
                SizedBox(height: hasFiles ? 12 : 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => controller.pickFileUpload(field: field),
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
                          Icons.insert_drive_file_outlined,
                          size: 18,
                          color: accentColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          uploadLabel,
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

class _UploadedFileRow extends StatelessWidget {
  const _UploadedFileRow({
    required this.file,
    required this.onRemove,
  });

  final FormUploadedFile file;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: FormFileUploadFieldView._fileIconColor,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.description_outlined,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            file.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: primaryTextColor_(context),
            ),
          ),
        ),
        IconButton(
          onPressed: onRemove,
          icon: Icon(
            Icons.close,
            size: 20,
            color: secondaryExtraLightTextColor_(context),
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(
            minWidth: 32,
            minHeight: 32,
          ),
        ),
      ],
    );
  }
}
