import 'package:belcka/pages/payment_documents/payment_documents/controller/payment_documents_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/PrimaryBorderButton.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DocumentFooterButtonsView extends StatelessWidget {
  DocumentFooterButtonsView({super.key});

  final controller = Get.put(PaymentDocumentsController());

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Visibility(
          visible: controller.isDownloadEnable.value,
          child: Padding(
            padding: const EdgeInsets.only(left: 14, right: 14, bottom: 14),
            child: Row(
              children: [
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: PrimaryButton(
                      buttonText: 'download'.tr, onPressed: () {}),
                ),
                SizedBox(
                  width: 12,
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: PrimaryBorderButton(
                      borderColor: secondaryLightTextColor_(context),
                      fontColor: secondaryLightTextColor_(context),
                      buttonText: 'cancel'.tr,
                      onPressed: () {
                        controller.isDownloadEnable.value = false;
                        controller.unCheckAll();
                      }),
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: controller.isDeleteEnable.value,
          child: Padding(
            padding: const EdgeInsets.only(left: 14, right: 14, bottom: 14),
            child: Row(
              children: [
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: PrimaryButton(
                      buttonText: 'delete'.tr,
                      color: Colors.red,
                      onPressed: () {}),
                ),
                SizedBox(
                  width: 12,
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: PrimaryBorderButton(
                      borderColor: secondaryLightTextColor_(context),
                      fontColor: secondaryLightTextColor_(context),
                      buttonText: 'cancel'.tr,
                      onPressed: () {
                        controller.isDeleteEnable.value = false;
                        controller.unCheckAll();
                      }),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
