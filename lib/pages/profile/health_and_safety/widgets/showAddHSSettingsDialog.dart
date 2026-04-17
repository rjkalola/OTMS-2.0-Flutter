import 'package:belcka/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showAddHSSettingsDialog({
  required BuildContext context,
  required String title,
  required String label,
  required String text,
  required Function(String) onSave,
}) {
  final TextEditingController titleController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {

      titleController.text = text;

      return StatefulBuilder(
        builder: (context, setDialogState) {
          bool isNotEmpty = titleController.text.trim().isNotEmpty;
          return Dialog(
            backgroundColor:dashBoardBgColor_(context),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            insetPadding: const EdgeInsets.symmetric(horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Header with Close Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title.tr,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: primaryTextColor_(context),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close, color: primaryTextColor_(context)),
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 2. Input Label
                  Text(
                    label.tr,
                    style:  TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: primaryTextColor_(context),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // 3. Styled TextField
                  TextField(
                    controller: titleController,
                    autofocus: true, // Opens keyboard immediately
                    onChanged: (val) => setDialogState(() {}), // Refresh button state
                    decoration: InputDecoration(
                      hintText: "${'enter_title'.tr}...",
                      hintStyle:  TextStyle(color: primaryTextColor_(context), fontSize: 15),
                      filled: true,
                      fillColor: dashBoardBgColor_(context),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:  BorderSide(color: defaultAccentColor_(context), width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // 4. Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Cancel Button (Light Blue)
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFFEDF2FF),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(
                          "cancel".tr,
                          style: const TextStyle(color: Color(0xFF2E5AAC), fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Save Button (Dynamic Color)
                      ElevatedButton(
                        onPressed: isNotEmpty
                            ? () {
                          onSave(titleController.text.trim());
                          Navigator.pop(context);
                        }
                            : null, // Disables button automatically
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: isNotEmpty ? defaultAccentColor_(context) : primaryTextColor_(context),
                          foregroundColor: isNotEmpty ? Colors.white : primaryTextColor_(context),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(
                          "save".tr,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}