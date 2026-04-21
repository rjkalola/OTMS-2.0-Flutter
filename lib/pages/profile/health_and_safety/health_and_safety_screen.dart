import 'package:belcka/pages/profile/health_and_safety/health_and_safety_controller.dart';
import 'package:belcka/pages/profile/health_and_safety/widgets/showAddHSSettingsDialog.dart';
import 'package:belcka/pages/user_orders/widgets/orders_base_app_bar.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HealthAndSafetyScreen extends StatefulWidget {
  const HealthAndSafetyScreen({super.key});

  @override
  State<HealthAndSafetyScreen> createState() => _HealthAndSafetyScreenState();
}

class _HealthAndSafetyScreenState extends State<HealthAndSafetyScreen> {

  final controller = Get.put(HealthAndSafetyController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop || result != null) return;
        controller.onBackPress();
      },
      child: Container(
        color: dashBoardBgColor_(context),
        child: SafeArea(
          top: false,
          child: Scaffold(
            backgroundColor: dashBoardBgColor_(context),
            appBar: OrdersBaseAppBar(
              appBar: AppBar(),
              title: 'health_safety'.tr,
              isCenterTitle: false,
              isBack: true,
              bgColor: backgroundColor_(context),
              widgets: actionButtons(),
              onBackPressed: (){
                controller.onBackPress();
              },
            ),
            body: Padding(
              padding: const EdgeInsets.all(12),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMenuButton(
                      label: "near_miss_reporting".tr,
                      icon: Icons.build_outlined,
                      onTap: () {
                        Get.toNamed(AppRoutes.nearMissListScreen,);
                      },
                    ),
                    const SizedBox(height: 4),
                    _buildMenuButton(
                      label: "report_incident".tr,
                      icon: Icons.report_problem_outlined,
                      onTap: () {
                        Get.toNamed(AppRoutes.reportIncidentsListScreen,);
                      },
                    ),
                    const SizedBox(height: 4),

                    _buildMenuButton(
                      label: "induction_and_training".tr,
                      icon: Icons.menu_book_outlined,
                      onTap: () {
                        Get.toNamed(AppRoutes.inductionTrainingListScreen,);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return CardViewDashboardItem(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Row(
            children: [
              // Icon Container
              Icon(icon, size: 22,color: secondaryTextColor_(context),),
              const SizedBox(width: 16),
              // Text
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              // Arrow
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget>? actionButtons() {
    return [
      InkWell(
        onTap: (){
          Get.toNamed(AppRoutes.hsSettingsScreen,);
        },
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(Icons.settings,
            color: primaryTextColor_(context) ,
            size: 23,
          ),
        ),
      ),
      SizedBox(width: 8,),
    ];
  }
}
