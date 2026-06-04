import 'package:belcka/pages/payment_documents/expire_soon_certificates/controller/expire_soon_certificates_controller.dart';
import 'package:belcka/pages/payment_documents/expire_soon_certificates/view/widgets/expire_soon_list_item.dart';
import 'package:belcka/pages/payment_documents/expire_soon_certificates/view/widgets/expire_soon_section_header.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/widgets/other_widgets/no_data_found_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExpireSoonSectionsList extends StatelessWidget {
  ExpireSoonSectionsList({super.key});

  final controller = Get.put(ExpireSoonCertificatesController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (!controller.hasSections) {
          return const Center(child: NoDataFoundWidget());
        }

        final visibleSections = controller.sectionsList
            .where((section) => section.data?.isNotEmpty ?? false)
            .toList();

        return ListView(
          padding: const EdgeInsets.only(bottom: 8),
          clipBehavior: Clip.none,
          children: [
            ...visibleSections.expand((section) {
              return [
                ExpireSoonSectionHeader(
                  title: section.title ?? "",
                  count: section.count ?? section.data?.length ?? 0,
                ),
                ...section.data!.asMap().entries.map((entry) {
                  final index = entry.key;
                  final info = entry.value;
                  final iconColor =
                      controller.getItemColor(info.id, index);
                  return ExpireSoonListItem(
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
                        controller.loadExpireSoonCertificates(true);
                      }
                    },
                  );
                }),
              ];
            }),
          ],
        );
      },
    );
  }
}
