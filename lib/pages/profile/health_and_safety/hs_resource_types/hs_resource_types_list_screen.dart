import 'package:belcka/pages/profile/health_and_safety/hs_resource_types/hs_management_type.dart';
import 'package:belcka/pages/profile/health_and_safety/hs_resource_types/hs_resource_types_list_controller.dart';
import 'package:belcka/pages/profile/health_and_safety/widgets/showAddHSSettingsDialog.dart';
import 'package:belcka/pages/user_orders/widgets/empty_state_view.dart';
import 'package:belcka/pages/user_orders/widgets/orders_base_app_bar.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HsResourceTypesListScreen extends StatefulWidget {
  const HsResourceTypesListScreen({super.key});

  @override
  State<HsResourceTypesListScreen> createState() => _HsResourceTypesListScreenState();
}

class _HsResourceTypesListScreenState extends State<HsResourceTypesListScreen> {

  final controller = Get.put(HsResourceTypesListController());

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: dashBoardBgColor_(context),
      appBar: OrdersBaseAppBar(
        appBar: AppBar(),
        title: '${controller.selectedTypeTitle}'.tr,
        isCenterTitle: false,
        isBack: true,
        bgColor: backgroundColor_(context),
        onBackPressed: (){
          controller.onBackPress();
        },
      ),
      body: controller.managementTypeList.isNotEmpty ? Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: controller.managementTypeList.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  return _buildManagementTile(
                    context: context,
                    title: controller.managementTypeList[index].title,
                    type: controller.selectedManagementType?.title ?? "",
                    onEdit: (){

                    },
                    onDelete: (){

                    },
                  );
                },
              ),
            ),
          ],
        ),
      ) : EmptyStateView(
          title: controller.noDataFoundMsg.value.tr,
          message:"",),
    );
  }

  List<Widget>? actionButtons() {
    return [
      InkWell(
        onTap: (){
          showAddHSSettingsDialog(
            context: context,
            title: controller.dialogueBoxTitle.value,
            label: controller.dialogueBoxLabel.value,
            onSave: (val) {
              // Add logic to save via your service
              if (controller.selectedManagementType == HSManagementType.hazards){
                print("New Hazard: $val");
                controller.healthAndSafetyService.toggleStoreHazard(val);
                controller.healthAndSafetyService.hazards.refresh();
                controller.managementTypeList.value = controller.healthAndSafetyService.hazards;
              }
              else if (controller.selectedManagementType == HSManagementType.incidentTypes){
                print("New Incident: $val");
              }
              else{
                print("New threat: $val");
              }

            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(Icons.add,
            color: primaryTextColor_(context) ,
            size: 25,
          ),
        ),
      ),
      SizedBox(width: 8,),
    ];
  }

  Widget _buildManagementTile({
    required BuildContext context,
    required String title,
    required String type,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    return CardViewDashboardItem(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Dynamic Icon based on type
          _getLeadingIcon(type),
          const SizedBox(width: 12),

          // Title
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1C1E),
              ),
            ),
          ),

          // Action Buttons
        /*
          IconButton(
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined, color: Colors.black38, size: 22),
          ),
          */
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 22),
          ),
        ],
      ),
    );
  }

  // Helper to change left icons easily for other 2 types
  Widget _getLeadingIcon(String type) {
    switch (type) {
      case 'incident_types':
        return const Icon(Icons.medical_services_outlined, color: Colors.blueAccent, size: 22);
      case 'hazards':
        return const Icon(Icons.warning_amber_rounded, color: Colors.orangeAccent, size: 22);
      case 'threat_levels':
        return const Icon(Icons.shield_outlined, color: Colors.redAccent, size: 22);
      default:
        return const Icon(Icons.info_outline);
    }
  }
}