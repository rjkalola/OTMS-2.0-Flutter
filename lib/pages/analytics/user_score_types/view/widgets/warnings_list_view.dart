import 'package:belcka/pages/analytics/user_score_types/controller/user_score_types_controller.dart';
import 'package:belcka/pages/analytics/user_score_types/model/user_score_warnings_model.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WarningsListView extends StatelessWidget {
  WarningsListView({super.key});

  final controller = Get.put(UserScoreTypesController());

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.warningItems.length,
      itemBuilder: (context, index) {
        return WarningsListItem(
          item: controller.warningItems[index],
        );
      },
    );
  }
}

class WarningsListItem extends StatelessWidget {
  final UserScoreWarningsModel item;

  const WarningsListItem({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CardViewDashboardItem(
          margin: const EdgeInsets.only(top: 14, bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Text(
                item.date,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),

        Positioned(
          left: 20,
          top: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Color(0xFFFF7F00),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              item.tag,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}