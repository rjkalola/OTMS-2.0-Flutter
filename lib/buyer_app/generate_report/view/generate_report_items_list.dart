import 'package:belcka/buyer_app/generate_report/controller/generate_report_controller.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/other_widgets/right_arrow_widget.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GenerateReportItemsList extends StatelessWidget {
  GenerateReportItemsList({super.key});

  final controller = Get.find<GenerateReportController>();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, position) {
          final entry = GenerateReportController.reportTypes[position];
          return GestureDetector(
            onTap: () =>
                controller.openExportSheet(entry.key, entry.value),
            child: CardViewDashboardItem(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
              borderRadius: 15,
              child: Row(
                children: [
                  Expanded(
                    child: TitleTextView(
                      text: entry.value.tr,
                    ),
                  ),
                  RightArrowWidget(),
                ],
              ),
            ),
          );
        },
        itemCount: GenerateReportController.reportTypes.length,
        separatorBuilder: (context, position) => const SizedBox(height: 12),
      ),
    );
  }
}
