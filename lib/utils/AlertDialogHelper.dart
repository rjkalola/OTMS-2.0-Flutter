import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../pages/common/listener/DialogButtonClickListener.dart';

class AlertDialogHelper {
  static showAlertDialog(
      String title,
      String message,
      String textPositiveButton,
      String textNegativeButton,
      String textOtherButton,
      bool isCancelable,
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

    Get.dialog(barrierDismissible: isCancelable, alert);
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
