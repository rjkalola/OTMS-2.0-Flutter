import 'package:belcka/pages/common/model/dialog_title_view.dart';
import 'package:belcka/pages/payment_documents/certificate_details/controller/certificate_details_controller.dart';
import 'package:belcka/pages/payment_documents/create_certificate/view/widgets/certificate_file_upload_view.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReplaceCertificateBottomSheet extends StatelessWidget {
  const ReplaceCertificateBottomSheet({
    super.key,
    required this.controller,
  });

  final CertificateDetailsController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor_(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DialogTitleView(title: 'replace_document'.tr),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PrimaryTextView(
                      text: 'upload_file'.tr,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(height: 10),
                    CertificateFileUploadView(
                      filePath: controller.replaceFilePath,
                      selectedFileName: controller.replaceSelectedFileName,
                      onUploadTap: controller.showReplaceAttachmentOptionsDialog,
                      onRemove: controller.removeReplaceFile,
                    ),
                    const SizedBox(height: 20),
                    PrimaryButton(
                      buttonText: 'replace_document'.tr,
                      onPressed: controller.onReplaceDocumentSubmit,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
