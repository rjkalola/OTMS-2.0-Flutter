import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showHSConfirmationDialog({
  required BuildContext context,
  required String title,
  required String subtitle,
  required String confirmText,
  Color confirmColor = const Color(0xFFF05261), // Default red for Delete
  required VoidCallback onConfirm,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0), // Rounded corners from screenshot
        ),
        insetPadding: const EdgeInsets.all(20), // Mobile screen margin
        child: Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Wrap content
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Dynamic Title
              Text(
                title.tr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1C1E), // Dark navy
                ),
              ),
              const SizedBox(height: 8),

              // 2. Dynamic Subtitle
              Text(
                subtitle.tr,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF808B9A), // Muted grey text
                  height: 1.5, // Better line spacing for readability
                ),
              ),
              const SizedBox(height: 8),

              // 3. Action Buttons Row
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Cancel Button
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "cancel".tr,
                      style: const TextStyle(
                        color: Color(0xFF1A1C1E),
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Action Button (Confirm/Delete)
                  ElevatedButton(
                    onPressed: () {
                      onConfirm();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: confirmColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      confirmText.tr,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
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
}