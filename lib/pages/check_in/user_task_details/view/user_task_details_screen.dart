import 'package:belcka/pages/check_in/user_check_out/view/widgets/check_in_out_display_note_widget.dart';
import 'package:belcka/pages/check_in/user_task_details/controller/user_task_details_controller.dart';
import 'package:belcka/pages/common/model/file_info.dart';
import 'package:belcka/pages/check_in/user_task_details/view/widgets/before_after_photos_list.dart';
import 'package:belcka/pages/check_in/user_task_details/view/widgets/check_log_summery.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class UserTaskDetailsScreen extends StatefulWidget {
  const UserTaskDetailsScreen({super.key});

  @override
  State<UserTaskDetailsScreen> createState() => _UserTaskDetailsScreenState();
}

class _UserTaskDetailsScreenState extends State<UserTaskDetailsScreen> {
  final controller = Get.put(UserTaskDetailsController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop || result != null) return;
        controller.onBackPress();
      },
      child: Scaffold(
        backgroundColor: backgroundColor_(context),
        body: Obx(
          () => ModalProgressHUD(
            inAsyncCall: controller.isLoading.value,
            opacity: 0,
            progressIndicator: const CustomProgressbar(),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  ColoredBox(
                    color: backgroundColor_(context),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16, top: 4),
                        child: _BackButton(
                          onPressed: controller.onBackPress,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 9,),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _TaskHeaderSection(controller: controller),
                          if (controller.isAfterEnable.value)
                            _ProgressSection(controller: controller),
                          if (_showBeforeSection())
                            _PhotosSection(
                              title: 'photos_before'.tr,
                              photosType: AppConstants.type.beforePhotos,
                              filesList: controller.beforePhotosList,
                              showAddButton: controller.isEditable.value,
                              onAddTap: () => controller.onAddPhotoTap(
                                  AppConstants.type.beforePhotos),
                              onGridItemClick: controller.onGridItemClick,
                              isEditable: controller.isEditable.value,
                              footer: CheckInOutDisplayNoteWidget(
                                note: controller.checkInNote,
                                labelText: 'check_in_note'.tr,
                                padding: const EdgeInsets.fromLTRB(4, 12, 4, 0),
                              ),
                            ),
                          if (controller.isAfterEnable.value)
                            _PhotosSection(
                              title: 'photos_after'.tr,
                              photosType: AppConstants.type.afterPhotos,
                              filesList: controller.afterPhotosList,
                              showAddButton: controller.isEditable.value,
                              onAddTap: () => controller.onAddPhotoTap(
                                  AppConstants.type.afterPhotos),
                              onGridItemClick: controller.onGridItemClick,
                              isEditable: controller.isEditable.value,
                              footer: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CheckInOutDisplayNoteWidget(
                                    note: controller.checkOutNote,
                                    labelText: 'check_out_note'.tr,
                                    padding:
                                        const EdgeInsets.fromLTRB(4, 12, 4, 0),
                                  ),
                                  CheckLogSummery(),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _showBeforeSection() {
    if (!controller.isBeforeEnable.value) return false;
    if (controller.isAfterEnable.value) return true;
    return !StringHelper.isEmptyList(controller.beforePhotosList) ||
        !StringHelper.isEmptyString(controller.checkInNote);
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          width: 42,
          height: 42,
          margin:  EdgeInsets.only(left: 6),
          decoration: BoxDecoration(
            color: backgroundColor_(context),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: primaryTextColor_(context),
          ),
        ),
      ),
    );
  }
}

class _TaskHeaderSection extends StatelessWidget {
  const _TaskHeaderSection({required this.controller});

  final UserTaskDetailsController controller;

  static const Color _taskRowIconBg = Color(0xFFFFF3E8);
  static const Color _taskRowIconColor = Color(0xFFFF7F00);
  static const Color _durationColor = Color(0xFFFF7F00);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final info = controller.info.value;

      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
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
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    info.name ?? '',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: primaryTextColor_(context),
                    ),
                  ),
                  if (!StringHelper.isEmptyString(info.duration)) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
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
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _ProgressSection extends StatelessWidget {
  const _ProgressSection({required this.controller});

  final UserTaskDetailsController controller;

  static const Color _progressColor = Color(0xFF32A852);

  static Color _barColor(int percent) {
    if (percent == 100) return _progressColor;
    if (percent >= 50) return const Color(0xFFFF9800);
    return const Color(0xFFEF5350);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final percent = controller.progressPercent;
        final barColor = _barColor(percent);

        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'progress'.tr,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: primaryTextColor_(context),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: controller.progressValue,
                        minHeight: 8,
                        backgroundColor: barColor.withOpacity(0.15),
                        color: barColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$percent%',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: barColor,
                    ),
                  ),
                ],
              ),
              if (!StringHelper.isEmptyString(
                  controller.info.value.taskNote)) ...[
                const SizedBox(height: 16),
                CheckInOutDisplayNoteWidget(
                  note: controller.info.value.taskNote,
                  labelText: 'task_note'.tr,
                  padding: EdgeInsets.zero,
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _PhotosSection extends StatelessWidget {
  const _PhotosSection({
    required this.title,
    required this.photosType,
    required this.filesList,
    required this.showAddButton,
    required this.onAddTap,
    required this.onGridItemClick,
    required this.isEditable,
    required this.footer,
  });

  final String title;
  final String photosType;
  final RxList<FilesInfo> filesList;
  final bool showAddButton;
  final VoidCallback onAddTap;
  final Function(int index, String action, String photoType) onGridItemClick;
  final bool isEditable;
  final Widget footer;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: primaryTextColor_(context),
                    ),
                  ),
                ),
                if (showAddButton) ...[
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: onAddTap,
                    child: Icon(
                      Icons.add_circle_outline,
                      size: 24,
                      color: primaryTextColor_(context),
                    ),
                  ),
                ],
              ],
            ),
            if (!StringHelper.isEmptyList(filesList)) ...[
              BeforeAfterPhotosList(
                onGridItemClick: onGridItemClick,
                filesList: filesList,
                photosType: photosType,
                isEditable: isEditable,
              ),
            ],
            footer,
          ],
        ),
      ),
    );
  }
}
