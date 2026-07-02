import 'package:belcka/pages/check_in/user_check_in/controller/user_check_in_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserCheckInNoteSection extends StatefulWidget {
  const UserCheckInNoteSection({super.key});

  static const int maxNoteLength = 200;

  @override
  State<UserCheckInNoteSection> createState() => _UserCheckInNoteSectionState();
}

class _UserCheckInNoteSectionState extends State<UserCheckInNoteSection> {
  late final UserCheckInController _controller;
  late final TextEditingController _noteController;
  int _charCount = 0;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<UserCheckInController>();
    _noteController = _controller.noteController.value;
    _charCount = _noteController.text.length;
    _noteController.addListener(_onNoteChanged);
  }

  void _onNoteChanged() {
    setState(() => _charCount = _noteController.text.length);
  }

  @override
  void dispose() {
    _noteController.removeListener(_onNoteChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12,top: 10 ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 15,
                  color: primaryTextColor_(context),
                ),
                children: [
                  TextSpan(
                    text: 'add_note'.tr,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(
                    text: ' ${'optional_parenthesis'.tr}',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: secondaryTextColor_(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 7),
          TextField(
            controller: _noteController,
            maxLines: 5,
            minLines: 4,
            maxLength: UserCheckInNoteSection.maxNoteLength,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            style: TextStyle(
              fontSize: 14,
              color: primaryTextColor_(context),
              height: 1.4,
            ),
            decoration: InputDecoration(
              hintText: 'add_note_about_task'.tr,
              hintStyle: TextStyle(
                fontSize: 14,
                color: secondaryTextColor_(context),
                height: 1.4,
              ),
              filled: true,
              fillColor: backgroundColor_(context),
              contentPadding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
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
                borderSide: BorderSide(color: dividerColor_(context)),
              ),
              counterText: '$_charCount/${UserCheckInNoteSection.maxNoteLength}',
              counterStyle: TextStyle(
                fontSize: 12,
                color: secondaryTextColor_(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
