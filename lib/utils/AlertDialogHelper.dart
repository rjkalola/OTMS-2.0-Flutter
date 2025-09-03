import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/res/colors.dart';

import '../pages/common/listener/DialogButtonClickListener.dart';

class AlertDialogHelper {
  static showAlertDialog(
      String title,
      String message,
      String textPositiveButton,
      String textNegativeButton,
      String textOtherButton,
      bool isCancelable,
      bool isMapScreen,
      final DialogButtonClickListener? buttonClickListener,
      final String dialogIdentifier) {
    // set up the buttons

    List<Widget> listButtons = [];
    if (textNegativeButton.isNotEmpty) {
      Widget cancelButton = TextButton(
        child: Text(
          textNegativeButton,
          style: const TextStyle(fontSize: 17),
        ),
        onPressed: () {
          if (buttonClickListener == null) {
            // Navigator.of(context).pop(); // dismis
            Get.back(); // s dialog
          } else {
            buttonClickListener.onNegativeButtonClicked(dialogIdentifier);
          }
        },
      );
      listButtons.add(cancelButton);
    }
    if (textPositiveButton.isNotEmpty) {
      Widget positiveButton = TextButton(
        child: Text(textPositiveButton, style: const TextStyle(fontSize: 17)),
        onPressed: () {
          if (buttonClickListener == null) {
            // Navigator.of(context).pop(); //
            Get.back();
            // dismiss dialog
          } else {
            buttonClickListener.onPositiveButtonClicked(dialogIdentifier);
          }
        },
      );
      listButtons.add(positiveButton);
    }
    if (textOtherButton.isNotEmpty) {
      Widget otherButton = TextButton(
        child: Text(textOtherButton, style: const TextStyle(fontSize: 18)),
        onPressed: () {
          if (buttonClickListener == null) {
            // Navigator.of(context).pop(); // dismiss dialog
            Get.back();
          } else {
            buttonClickListener.onOtherButtonClicked(dialogIdentifier);
          }
        },
      );
      listButtons.add(otherButton);
    }

    // set up the AlertDialog
    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: title.isNotEmpty ? Text(title) : null,
      content: message.isNotEmpty
          ? Text(message, style: const TextStyle(fontSize: 18))
          : null,
      actions: listButtons,
      // shape: const RoundedRectangleBorder(
      //     borderRadius: BorderRadius.all(Radius.circular(8.0))),
      // backgroundColor: backgroundColor,
    );
    // show the dialog

    if (Platform.isIOS && isMapScreen) {
      Get.bottomSheet(
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 60, vertical: 60),
          decoration: BoxDecoration(
            color: Color(0xFFD6D6D6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(12, 20, 12, 6),
                child: Text(
                  message,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        if (buttonClickListener == null) {
                          Get.back(); // s dialog
                        } else {
                          buttonClickListener
                              .onNegativeButtonClicked(dialogIdentifier);
                        }
                      },
                      child: Text(
                        'No',
                        style:
                            TextStyle(color: defaultAccentColor_(Get.context!), fontSize: 16),
                      ),
                    ),
                  ),
                  Container(width: 1, height: 48, color: Colors.grey.shade400),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        if (buttonClickListener == null) {
                          Get.back(); // s dialog
                        } else {
                          buttonClickListener
                              .onPositiveButtonClicked(dialogIdentifier);
                        }
                      },
                      child: Text(
                        'Yes',
                        style:
                            TextStyle(color: defaultAccentColor_(Get.context!), fontSize: 16),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        isDismissible: isCancelable,
        enableDrag: isCancelable,
        backgroundColor: Colors.transparent,
      );
    } else {
      Get.dialog(barrierDismissible: isCancelable, alert);
    }
  }

  static showImagePreviewAlertDialog(
    String imageUrl,
    bool isCancelable,
  ) {
    // set up the AlertDialog
    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Align(
        alignment: Alignment.topRight,
        child: GestureDetector(
          child: const Icon(
            Icons.cancel_outlined,
            color: Colors.white,
          ),
          onTap: () {
            Get.back();
          },
        ),
      ),
      content: Container(
        width: Get.width,
        height: Get.height,
        color: Colors.red,
        child: SizedBox(
          width: Get.width,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 12),
              Text(
                'Hello Flutter s sf sf fsf sf sf sf',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      // shape: const RoundedRectangleBorder(
      //     borderRadius: BorderRadius.all(Radius.circular(8.0))),
      // backgroundColor: backgroundColor,
    );
    // show the dialog
    Get.dialog(barrierDismissible: isCancelable, alert);
  }
}
