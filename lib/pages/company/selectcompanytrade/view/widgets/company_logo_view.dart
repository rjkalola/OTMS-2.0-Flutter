import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/company/selectcompanytrade/controller/select_company_trade_controller.dart';
import 'package:belcka/utils/image_utils.dart';

class CompanyLogoView extends StatelessWidget {
  CompanyLogoView({super.key});

  final controller = Get.put(SelectCompanyTradeController());

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ImageUtils.setNetworkImage(
          url: controller.companyDetails.value.companyLogo ?? "",
          width: 220,
          height: 90,
          fit: BoxFit.contain),
    );
  }
}
