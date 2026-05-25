import 'package:belcka/pages/workshop/workshop_dashboard/controller/workshop_dashboard_controller.dart';
import 'package:belcka/pages/workshop/workshop_dashboard/view/widgets/workshop_dashboard_menu_tile.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkshopDashboardScreen extends StatelessWidget {
  WorkshopDashboardScreen({super.key});

  final controller = Get.put(WorkshopDashboardController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();

    return Container(
      color: dashBoardBgColor_(context),
      child: SafeArea(
        top: false,
        bottom: !GetPlatform.isIOS,
        child: Scaffold(
          backgroundColor: dashBoardBgColor_(context),
          appBar: BaseAppBar(
            appBar: AppBar(),
            title: 'Workshop',
            isCenterTitle: false,
            isBack: true,
            bgColor: backgroundColor_(context),
            elevation: 5,
            shadowColor: shadowColor_(context).withValues(alpha: 0.28),
            surfaceTintColor: Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(14, 20, 14, 0),
            child: ListView.separated(
              itemCount: controller.dashboardItems.length,
              separatorBuilder: (_, __) => const SizedBox(height: 15),
              itemBuilder: (context, index) {
                final item = controller.dashboardItems[index];
                return WorkshopDashboardMenuTile(
                  title: item.title,
                  icon: item.icon,
                  iconColor: item.iconColor,
                  iconBackgroundColor: item.iconBackgroundColor,
                  onTap: () => controller.onItemTap(item),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
