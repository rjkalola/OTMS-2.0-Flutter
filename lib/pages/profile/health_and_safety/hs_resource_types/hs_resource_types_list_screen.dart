import 'package:belcka/pages/profile/health_and_safety/hs_resource_types/hs_management_type.dart';
import 'package:belcka/pages/profile/health_and_safety/hs_resource_types/hs_resource_types_list_controller.dart';
import 'package:belcka/pages/profile/health_and_safety/widgets/showAddHSSettingsDialog.dart';
import 'package:belcka/pages/profile/health_and_safety/widgets/showHSConfirmationDialog.dart';
import 'package:belcka/pages/user_orders/widgets/empty_state_view.dart';
import 'package:belcka/pages/user_orders/widgets/orders_base_app_bar.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class HsResourceTypesListScreen extends StatefulWidget {
  const HsResourceTypesListScreen({super.key});

  @override
  State<HsResourceTypesListScreen> createState() => _HsResourceTypesListScreenState();
}

class _HsResourceTypesListScreenState extends State<HsResourceTypesListScreen> {

  final controller = Get.put(HsResourceTypesListController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return Obx(
            () => Container(
      color: dashBoardBgColor_(context),
      child: Scaffold(
        backgroundColor: dashBoardBgColor_(context),
        appBar: OrdersBaseAppBar(
          appBar: AppBar(),
          title: '${controller.selectedTypeTitle}'.tr,
          isCenterTitle: false,
          isBack: true,
          bgColor: backgroundColor_(context),
          widgets: actionButtons(),
          onBackPressed: (){
            controller.onBackPress();
          },
        ),
        body: ModalProgressHUD(
          inAsyncCall: controller.isLoading.value,
          opacity: 0,
          progressIndicator: const CustomProgressbar(),
          child: controller.isInternetNotAvailable.value
              ? NoInternetWidget(
            onPressed: () {
              controller.isInternetNotAvailable.value = false;
            },
          )
              : controller.isMainViewVisible.value
              ? controller.managementTypeList.isNotEmpty ? Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
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
                          showAddHSSettingsDialog(
                            context: context,
                            title: controller.dialogueBoxEditTitle.value,
                            label: controller.dialogueBoxLabel.value,
                            text: controller.managementTypeList[index].title,
                            onSave: (val) {
                              if (controller.selectedManagementType == HSManagementType.hazards){
                                controller.toggleStoreHazard(val,controller.managementTypeList[index].id);
                              }
                              else if (controller.selectedManagementType == HSManagementType.incidentTypes){
                                controller.toggleStoreIncidentType(val,controller.managementTypeList[index].id);
                              }
                              else{
                                print("New threat: $val");
                                controller.toggleThreatLevel(val,controller.managementTypeList[index].id);
                              }

                            },
                          );
                        },
                        onDelete: (){
                          if (controller.selectedManagementType == HSManagementType.hazards){
                            showHSConfirmationDialog(
                              context: context,
                              title: "${'delete_hazard'.tr}?",
                              subtitle: "delete_confirmation",
                              confirmText: "delete",
                              confirmColor: const Color(0xFFF05261),
                              onConfirm: () => controller.deleteHazardType(controller.managementTypeList[index].id),
                            );
                          }
                          else if (controller.selectedManagementType == HSManagementType.incidentTypes){
                            showHSConfirmationDialog(
                              context: context,
                              title: "${'delete_incident_type'.tr}?",
                              subtitle: "delete_confirmation",
                              confirmText: "delete",
                              confirmColor: const Color(0xFFF05261),
                              onConfirm: () => controller.deleteIncidentType(controller.managementTypeList[index].id),
                            );
                          }

                          else if (controller.selectedManagementType == HSManagementType.threatLevels){
                            showHSConfirmationDialog(
                              context: context,
                              title: "${'delete_threat_level'.tr}?",
                              subtitle: "delete_confirmation",
                              confirmText: "delete",
                              confirmColor: const Color(0xFFF05261),
                              onConfirm: () => controller.deleteThreatLevel(controller.managementTypeList[index].id),
                            );
                          }

                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ) : EmptyStateView(
            title: controller.noDataFoundMsg.value.tr,
            message:"",)
              : const SizedBox.shrink(),
        ),
      ),
    ));
  }

  List<Widget>? actionButtons() {
    return [
      InkWell(
        onTap: (){
          showAddHSSettingsDialog(
            context: context,
            title: controller.dialogueBoxTitle.value,
            label: controller.dialogueBoxLabel.value,
            text: "",
            onSave: (val) {
              if (controller.selectedManagementType == HSManagementType.hazards){
                print("New Hazard: $val");
                controller.toggleStoreHazard(val,0);
              }
              else if (controller.selectedManagementType == HSManagementType.incidentTypes){
                print("New Incident: $val");
                controller.toggleStoreIncidentType(val,0);
              }
              else{
                print("New threat: $val");
                controller.toggleThreatLevel(val,0);
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
      padding: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Row(
          children: [
            _getLeadingIcon(type),
            const SizedBox(width: 16),
            // Title
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1A1C1E),
                ),
              ),
            ),

            Row(
              children: [
                GestureDetector(
                  onTap: onEdit,
                  child:  Icon(
                    Icons.edit_outlined,
                    color: secondaryTextColor_(context),
                    size: 22,
                  ),
                ),
                SizedBox(width: 16,),
                GestureDetector(
                  onTap: onDelete,
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.redAccent,
                    size: 22,
                  ),
                ),
              ],
            ),
          ],
        ),
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