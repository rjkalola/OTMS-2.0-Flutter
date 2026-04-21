import 'package:belcka/pages/analytics/kpi_analytics/controller/kpi_analytics_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KpiAnalyticsGridView extends StatelessWidget {
  KpiAnalyticsGridView({super.key});

  final controller = Get.find<KpiAnalyticsController>();

  @override
  Widget build(BuildContext context) {
    final data = controller.kpiScore.value;
    if (data == null) return const SizedBox();

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      itemCount: 1,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        mainAxisExtent: 94,
      ),
      itemBuilder: (context, index) {
        return CardViewDashboardItem(
          padding: const EdgeInsets.fromLTRB(14, 0, 10, 0),
          child: Row(
            children: [
              const Icon(Icons.login, color: Color(0xFF9C6AEF), size: 24),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PrimaryTextView(
                      text: "check_ins".tr,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      textAlign: TextAlign.center,
                      color: primaryTextColorLight_(context),
                      maxLine: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    PrimaryTextView(
                      text: data.checkIns.toString(),
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                      textAlign: TextAlign.center,
                      color: secondaryLightTextColor_(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
