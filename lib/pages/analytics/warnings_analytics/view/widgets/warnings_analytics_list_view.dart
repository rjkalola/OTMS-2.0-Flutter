import 'package:belcka/pages/analytics/warnings_analytics/controller/warnings_analytics_controller.dart';
import 'package:belcka/pages/analytics/warnings_analytics/model/warning_item_model.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/TextViewWithContainer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WarningsAnalyticsListView extends StatelessWidget {
  WarningsAnalyticsListView({super.key});

  final controller = Get.find<WarningsAnalyticsController>();

  @override
  Widget build(BuildContext context) {
    final warnings = controller.warningsScore.value?.items ?? [];
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      itemCount: warnings.length,
      itemBuilder: (context, index) {
        return _WarningsAnalyticsItem(item: warnings[index]);
      },
    );
  }
}

class _WarningsAnalyticsItem extends StatelessWidget {
  const _WarningsAnalyticsItem({required this.item});

  final WarningItemModel item;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CardViewDashboardItem(
          margin: const EdgeInsets.only(top: 14, bottom: 10),
          padding: const EdgeInsets.fromLTRB(20, 10, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    item.date,
                    style: TextStyle(
                      fontSize: 14,
                      color: secondaryTextColor_(context),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          left: 20,
          top: 4,
          child: TextViewWithContainer(
            text: item.incidentType,
            boxColor: const Color(0xFFFF8C00),
            borderRadius: 14,
            borderWidth: 0,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            fontSize: 12,
            fontWeight: FontWeight.w400,
            fontColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
