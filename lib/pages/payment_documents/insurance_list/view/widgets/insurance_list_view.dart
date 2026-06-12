import 'package:belcka/pages/payment_documents/certificates_list/view/widgets/certificate_list_item.dart';
import 'package:belcka/pages/payment_documents/insurance_list/controller/insurance_list_controller.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/widgets/other_widgets/no_data_found_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InsuranceListView extends StatelessWidget {
  InsuranceListView({super.key});

  final controller = Get.put(InsuranceListController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.insuranceList.isEmpty
          ? const Center(child: NoDataFoundWidget())
          : ListView.builder(
              padding: const EdgeInsets.only(top: 16, bottom: 16),
              clipBehavior: Clip.none,
              itemCount: controller.insuranceList.length,
              itemBuilder: (context, index) {
                final info = controller.insuranceList[index];
                final iconColor = controller.getItemColor(info.id, index);
                return CertificateListItem(
                  info: info,
                  iconBackgroundColor: iconColor,
                  onTap: () async {
                    final result = await Get.toNamed(
                      AppRoutes.certificateDetailsScreen,
                      arguments: {
                        AppConstants.intentKey.ID: info.id,
                        AppConstants.intentKey.certificateIconColor:
                            iconColor,
                      },
                    );
                    if (result != null && result == true) {
                      controller.isDataUpdated.value = true;
                      controller.loadInsuranceList(true);
                    }
                  },
                );
              },
            ),
    );
  }
}
