import 'package:belcka/pages/payment_documents/payment_documents/controller/payment_documents_controller.dart';
import 'package:belcka/pages/payment_documents/payment_documents/view/widgets/payment_document_tabs.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HeaderTabView extends StatelessWidget {
  final controller = Get.put(PaymentDocumentsController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        color: backgroundColor_(context),
        boxShadow: [AppUtils.boxShadow(shadowColor_(context), 10)],
        border: Border.all(width: 0.6, color: Colors.transparent),
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(28), bottomRight: Radius.circular(28)),
      ),
      child: PaymentDocumentTabs(),
    );
  }
}
