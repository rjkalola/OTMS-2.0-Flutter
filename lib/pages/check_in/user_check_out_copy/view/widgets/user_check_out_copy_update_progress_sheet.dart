import 'package:belcka/pages/check_in/check_in/model/type_of_work_resources_info.dart';
import 'package:belcka/pages/check_in/user_check_out_copy/controller/user_check_out_copy_controller.dart';
import 'package:belcka/pages/check_in/user_check_out_copy/view/widgets/user_check_out_copy_take_photo_button.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserCheckOutCopyUpdateProgressSheet extends StatefulWidget {
  const UserCheckOutCopyUpdateProgressSheet({
    super.key,
    required this.info,
    required this.index,
  });

  final TypeOfWorkResourcesInfo info;
  final int index;

  @override
  State<UserCheckOutCopyUpdateProgressSheet> createState() =>
      _UserCheckOutCopyUpdateProgressSheetState();
}

class _UserCheckOutCopyUpdateProgressSheetState
    extends State<UserCheckOutCopyUpdateProgressSheet> {
  final controller = Get.find<UserCheckOutCopyController>();
  final _scrollController = ScrollController();
  final _noteFocusNode = FocusNode();

  late int _selectedPercent;
  late TextEditingController _noteController;

  static const _options = [100, 75, 50, 25, 0];
  static const Color _taskRowIconBg = Color(0xFFFFF3E8);
  static const Color _taskRowIconColor = Color(0xFFFF7F00);
  static const Color _durationColor = Color(0xFFFF7F00);
  static const Color _progressColor = Color(0xFF32A852);

  @override
  void initState() {
    super.initState();
    _selectedPercent = controller.taskDisplayProgress(widget.info);
    _noteController = TextEditingController(
      text: controller.selectedTypeOfWorkList[widget.index].taskNote ?? '',
    );
  }

  @override
  void dispose() {
    _noteFocusNode.dispose();
    _scrollController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  void _onSave() {
    controller.saveTaskProgress(
      widget.index,
      _selectedPercent,
      _noteController.text,
    );
    Navigator.of(context).pop();
  }

  Color get _barColor {
    if (_selectedPercent == 100) return _progressColor;
    if (_selectedPercent >= 50) return const Color(0xFFFF9800);
    return const Color(0xFFEF5350);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final keyboardHeight = mediaQuery.viewInsets.bottom;
    final keyboardOpen = keyboardHeight > 0;
    final maxHeight = mediaQuery.size.height * 0.92;

    return AnimatedPadding(
      padding: EdgeInsets.only(bottom: keyboardHeight),
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      child: GestureDetector(
        onTap: _dismissKeyboard,
        behavior: HitTestBehavior.opaque,
        child: Container(
          constraints: BoxConstraints(maxHeight: maxHeight),
          decoration: BoxDecoration(
            color: backgroundColor_(context),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  decoration: BoxDecoration(
                    color: dividerColor_(context),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              _buildSheetHeader(context, keyboardOpen: keyboardOpen),
              Flexible(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildProgressContent(context),
                      _buildNoteSection(context),
                      _buildActions(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSheetHeader(BuildContext context, {required bool keyboardOpen}) {
    final titleStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: primaryTextColor_(context),
    );

    if (keyboardOpen) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 8, 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'update_task_progress'.tr,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: titleStyle,
              ),
            ),
            TextButton(
              onPressed: _dismissKeyboard,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'done'.tr,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: defaultAccentColor_(context),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Text(
        'update_task_progress'.tr,
        textAlign: TextAlign.center,
        style: titleStyle,
      ),
    );
  }

  Widget _buildProgressContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
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
                      widget.info.name ?? '',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: primaryTextColor_(context),
                      ),
                    ),
                    if (!StringHelper.isEmptyString(widget.info.duration)) ...[
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
                            widget.info.duration!,
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
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'how_much_task_completed'.tr,
            style: TextStyle(
              fontSize: 14,
              color: secondaryTextColor_(context),
              height: 1.4,
            ),
          ),
        ),
        const SizedBox(height: 14),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              for (int i = 0; i < _options.length; i++) ...[
                if (i > 0) const SizedBox(width: 8),
                Expanded(
                  child: _buildProgressOption(context, _options[i]),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: _selectedPercent / 100,
                    minHeight: 8,
                    backgroundColor: _progressColor.withOpacity(0.15),
                    color: _barColor,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$_selectedPercent%',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: _barColor,
                ),
              ),
            ],
          ),
        ),
        if (_selectedPercent == 100) ...[
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: _progressColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _progressColor.withOpacity(0.3),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: _progressColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'task_fully_completed'.tr,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: _progressColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'change_progress_if_not_completed'.tr,
                          style: TextStyle(
                            fontSize: 11.5,
                            color: _progressColor.withOpacity(0.85),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        const SizedBox(height: 14),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 6),
          child: Obx(() {
            final info = controller.selectedTypeOfWorkList[widget.index];
            final hasPhoto =
                !StringHelper.isEmptyList(info.afterAttachments);
            return UserCheckOutCopyTakePhotoButton(
              hasPhoto: hasPhoto,
              fullWidth: true,
              onTap: () => controller.onSelectTypeOfWorkPhotos(widget.index),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildProgressOption(BuildContext context, int pct) {
    final isSelected = _selectedPercent == pct;
    return GestureDetector(
      onTap: () => setState(() => _selectedPercent = pct),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: double.infinity,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? _progressColor : backgroundColor_(context),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? _progressColor : dividerColor_(context),
            width: 1.5,
          ),
        ),
        child: Text(
          '$pct%',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : secondaryTextColor_(context),
          ),
        ),
      ),
    );
  }

  Widget _buildNoteSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'add_note_optional'.tr,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: primaryTextColor_(context),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _noteController,
            focusNode: _noteFocusNode,
            maxLines: 5,
            minLines: 3,
            maxLength: 200, 
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            style: TextStyle(
              fontSize: 13.5,
              color: primaryTextColor_(context),
            ),
            decoration: InputDecoration(
              hintText: 'add_note_about_task'.tr,
              hintStyle: TextStyle(
                fontSize: 13,
                color: secondaryTextColor_(context),
              ),
              filled: true,
              fillColor: dashBoardBgColor_(context),
              alignLabelWithHint: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12, 
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: dividerColor_(context)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: dividerColor_(context)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: defaultAccentColor_(context),
                ),
              ),
              counterStyle: TextStyle(
                fontSize: 11,
                color: secondaryTextColor_(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 52,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _onSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: defaultAccentColor_(context),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
              ),
              child: Text(
                'save_progress'.tr,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'cancel'.tr,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: secondaryTextColor_(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
