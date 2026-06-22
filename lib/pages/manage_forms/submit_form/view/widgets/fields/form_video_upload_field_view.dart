import 'package:belcka/pages/manage_forms/submit_form/controller/submit_form_controller.dart';
import 'package:belcka/pages/manage_forms/submit_form/model/form_field_model.dart';
import 'package:belcka/pages/manage_forms/submit_form/view/widgets/shared/form_field_label.dart';
import 'package:belcka/pages/manage_forms/submit_form/view/widgets/shared/form_video_thumbnail.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormVideoUploadFieldView extends StatelessWidget {
  const FormVideoUploadFieldView({
    super.key,
    required this.field,
    this.isNested = false,
  });

  final FormFieldModel field;
  final bool isNested;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SubmitFormController>();
    final fieldId = field.id ?? '';
    final accentColor = defaultAccentColor_(context);
    final allowsMultiple = field.allowsMultipleVideoUploads;

    return Obx(
      () {
        final videoPaths = controller.getVideoUploadPaths(fieldId);
        final hasVideos = videoPaths.isNotEmpty;
        final hasError = controller.showValidationErrors.value &&
            controller.isFieldInvalid(fieldId);
        final uploadLabel = hasVideos && allowsMultiple
            ? 'upload_more_files'.tr
            : 'upload_a_video'.tr;

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
              if (hasVideos) ...[
                const SizedBox(height: 12),
                if (allowsMultiple)
                  _VideoUploadGrid(
                    videoPaths: videoPaths,
                    onRemove: (index) =>
                        controller.removeVideoUploadAt(fieldId, index),
                  )
                else
                  _SingleVideoPreview(
                    videoPath: videoPaths.first,
                    onRemove: () => controller.removeVideoUploadAt(fieldId, 0),
                  ),
              ],
              if (!hasVideos || allowsMultiple) ...[
                SizedBox(height: hasVideos ? 12 : 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => controller.pickVideoUpload(
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
                          Icons.videocam_outlined,
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

class _SingleVideoPreview extends StatelessWidget {
  const _SingleVideoPreview({
    required this.videoPath,
    required this.onRemove,
  });

  final String videoPath;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: 104,
        height: 104,
        child: FormVideoThumbnail(
          videoPath: videoPath,
          onRemove: onRemove,
        ),
      ),
    );
  }
}

class _VideoUploadGrid extends StatelessWidget {
  const _VideoUploadGrid({
    required this.videoPaths,
    required this.onRemove,
  });

  final List<String> videoPaths;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: videoPaths.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        return FormVideoThumbnail(
          videoPath: videoPaths[index],
          onRemove: () => onRemove(index),
        );
      },
    );
  }
}
