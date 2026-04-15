import 'package:belcka/pages/profile/health_and_safety/hs_resource_types/hs_management_type.dart';
import 'package:belcka/pages/profile/health_and_safety/hs_settings/hs_settings_controller.dart';
import 'package:belcka/pages/user_orders/widgets/orders_base_app_bar.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HsSettingsScreen extends StatefulWidget {
  const HsSettingsScreen({super.key});

  @override
  State<HsSettingsScreen> createState() => _HsSettingsScreenState();
}

class _HsSettingsScreenState extends State<HsSettingsScreen> {

  final controller = Get.put(HsSettingsController());

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
              title: 'health_safety_settings'.tr,
              isCenterTitle: false,
              isBack: true,
              bgColor: backgroundColor_(context),
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
                      label: HSManagementType.hazards.title.tr,
                      icon: HSManagementType.hazards.icon,
                      onTap: () {
                        var arguments = {"selectedManagementType": HSManagementType.hazards,};
                        controller.moveToScreen(
                            AppRoutes.hsResourceTypesListScreen, arguments);
                      },
                    ),
                    const SizedBox(height: 4),
                    _buildMenuButton(
                      label: HSManagementType.incidentTypes.title.tr,
                      icon: HSManagementType.incidentTypes.icon,
                      onTap: () {
                        var arguments = {"selectedManagementType": HSManagementType.incidentTypes,};
                        controller.moveToScreen(
                            AppRoutes.hsResourceTypesListScreen, arguments);
                      },
                    ),
                    const SizedBox(height: 4),
                    _buildMenuButton(
                      label: HSManagementType.threatLevels.title.tr,
                      icon: HSManagementType.threatLevels.icon,
                      onTap: () {
                        var arguments = {"selectedManagementType": HSManagementType.threatLevels,};
                        controller.moveToScreen(
                            AppRoutes.hsResourceTypesListScreen, arguments);
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
              Icon(icon, size: 22,),
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
}
