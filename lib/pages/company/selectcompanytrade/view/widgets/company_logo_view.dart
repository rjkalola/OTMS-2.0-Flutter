import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/company/selectcompanytrade/controller/select_company_trade_controller.dart';
import 'package:otm_inventory/utils/image_utils.dart';

class CompanyLogoView extends StatelessWidget {
  CompanyLogoView({super.key});

  final controller = Get.put(SelectCompanyTradeController());

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ImageUtils.setNetworkImage(
          controller.companyDetails.value.companyLogo ?? "",
          220,
          90,
          BoxFit.contain),
    );
  }
}
