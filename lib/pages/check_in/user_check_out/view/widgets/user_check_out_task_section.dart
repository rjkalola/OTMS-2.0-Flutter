import 'package:belcka/pages/check_in/check_in/model/type_of_work_resources_info.dart';
import 'package:belcka/pages/check_in/user_check_out/controller/user_check_out_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/pages/check_in/user_check_out/view/widgets/user_check_out_take_photo_button.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserCheckOutTaskSection extends StatelessWidget {
  UserCheckOutTaskSection({super.key});

  final controller = Get.put(UserCheckOutController());

  static const Color _taskIconBg = Color(0xFFF3E8FC);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final taskText = controller.typeOfWorkController.value.text;
      final tasks = controller.selectedTypeOfWorkList;
      final hasTask = tasks.isNotEmpty;
      final isEditable = StringHelper.isEmptyString(
          controller.checkLogInfo.value.checkoutDateTime);

      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: backgroundColor_(context),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _taskIconBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: ImageUtils.setSvgAssetsImage(
                        path: Drawable.checkinTaskIcon,
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'select_task'.tr,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: primaryTextColor_(context),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          hasTask ? taskText : 'choose_todays_task'.tr,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: hasTask
                                ? primaryTextColor_(context)
                                : secondaryTextColor_(context),
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (hasTask) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
                child: Text(
                  'your_tasks'.tr,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: secondaryTextColor_(context),
                  ),
                ),
              ),
              ...List.generate(tasks.length, (index) {
                final info = tasks[index];
                return Padding(
                  padding: EdgeInsets.fromLTRB(
                    14,
                    0,
                    14,
                    index == tasks.length - 1 ? 12 : 8,
                  ),
                  child: _CheckoutTaskRow(
                    info: info,
                    isEditable: isEditable,
                    onPhotoTap: () =>
                        controller.onSelectTypeOfWorkPhotos(index),
                    onDetailsTap: () =>
                        controller.typeOfWorkDetails(info, index),
                    onProgressTap: () =>
                        controller.showUpdateProgressSheet(info, index),
                  ),
                );
              }),
            ],
          ],
        ),
      );
    });
  }
}

class _CheckoutTaskRow extends StatelessWidget {
  const _CheckoutTaskRow({
    required this.info,
    required this.isEditable,
    required this.onPhotoTap,
    required this.onDetailsTap,
    required this.onProgressTap,
  });

  final TypeOfWorkResourcesInfo info;
  final bool isEditable;
  final VoidCallback onPhotoTap;
  final VoidCallback onDetailsTap;
  final VoidCallback onProgressTap;

  static const Color _taskRowIconBg = Color(0xFFFFF3E8);
  static const Color _taskRowIconColor = Color(0xFFFF7F00);
  static const Color _durationColor = Color(0xFFFF7F00);
  static const Color _progressColor = Color(0xFF32A852);

  int get _progressValue =>
      (info.progress ?? 0) != 0 ? (info.progress ?? 0) : 100;

  @override
  Widget build(BuildContext context) {
    final hasPhoto = !StringHelper.isEmptyList(info.afterAttachments);

    return GestureDetector(
      onTap: onDetailsTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
        decoration: BoxDecoration(
          color: backgroundColor_(context),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: dividerColor_(context)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: _taskRowIconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: ImageUtils.setSvgAssetsImage(
                  path: Drawable.checkinTaskIcon,
                  width: 18,
                  height: 18,
                  color: _taskRowIconColor,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    info.name ?? "",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: primaryTextColor_(context),
                    ),
                  ),
                  if (!StringHelper.isEmptyString(info.duration)) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 14,
                          color: _durationColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          info.duration!,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: _durationColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: _progressValue / 100,
                            minHeight: 6,
                            backgroundColor: _progressColor.withOpacity(0.15),
                            color: _progressColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: isEditable ? onProgressTap : onDetailsTap,
                        child: Text(
                          '$_progressValue%',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _progressColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            UserCheckOutTakePhotoButton(
              hasPhoto: hasPhoto,
              onTap: isEditable ? onPhotoTap : onDetailsTap,
            ),
          ],
        ),
      ),
    );
  }
}
