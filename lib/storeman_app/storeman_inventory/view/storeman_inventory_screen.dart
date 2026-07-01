import 'package:belcka/pages/common/listener/date_filter_listener.dart';
import 'package:belcka/pages/common/widgets/date_filter_options_horizontal_list.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/controller/storeman_catalog_controller.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/storeman_app/storeman_inventory/controller/storeman_inventory_controller.dart';
import 'package:belcka/storeman_app/storeman_inventory/view/widgets/hire_card_view.dart';
import 'package:belcka/storeman_app/storeman_inventory/view/widgets/internal_orders_card_view.dart';
import 'package:belcka/storeman_app/storeman_inventory/view/widgets/inventory_dashboard_widgets.dart';
import 'package:belcka/storeman_app/storeman_inventory/view/widgets/manage_stock_view.dart';
import 'package:belcka/storeman_app/storeman_inventory/view/widgets/suppliers_card_view.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class StoremanInventoryScreen extends StatefulWidget {
  const StoremanInventoryScreen({super.key});

  @override
  State<StoremanInventoryScreen> createState() =>
      _StoremanInventoryScreenState();
}

class _StoremanInventoryScreenState extends State<StoremanInventoryScreen>
    implements DateFilterListener {
  final controller = Get.put(StoremanInventoryController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: inventoryPageBg,
        body: SafeArea(
          child: ModalProgressHUD(
            inAsyncCall: controller.isLoading.value,
            opacity: 0,
            progressIndicator: const CustomProgressbar(),
            child: controller.isInternetNotAvailable.value
                ? Center(child: Text("no_internet_text".tr))
                : Column(
                    children: [
                      _InventoryHeader(
                        onAddTap: _onAddTap,
                        onHistoryTap: controller.onHireHistoryClick,
                        showHistory: controller.isMainViewVisible.value,
                      ),
                      Expanded(
                        child: Visibility(
                          visible: controller.isMainViewVisible.value,
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.only(bottom: 14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 14),
                                DateFilterOptionsHorizontalList(
                                  padding: const EdgeInsets.fromLTRB(
                                    16,
                                    0,
                                    16,
                                    8,
                                  ),
                                  startDate: controller.startDate.value,
                                  endDate: controller.endDate.value,
                                  listener: this,
                                  selectedPosition:
                                      controller.selectedDateFilterIndex,
                                ),
                                _DateRangeView(
                                  text:
                                      "${controller.displayStartDate.value} - ${controller.displayEndDate.value}",
                                ),
                                SuppliersCardView(),
                                InternalOrdersCardView(),
                                HireCardView(),
                                ManageStockView(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  void _onAddTap() {
    if (Get.isRegistered<StoremanCatalogController>()) {
      Get.delete<StoremanCatalogController>();
    }
    controller.moveToScreen(
      appRout: AppRoutes.storemanCatalogScreen,
      arguments: {'comingFromInventory': true},
    );
  }

  @override
  void onSelectDateFilter(
    int filterIndex,
    String filter,
    String startDate,
    String endDate,
    String dialogIdentifier,
  ) {
    controller.selectedDateFilterIndex.value = filterIndex;
    controller.startDate.value = startDate;
    controller.endDate.value = endDate;
    controller.inventoryOverviewApi(true);
  }
}

class _InventoryHeader extends StatelessWidget {
  final VoidCallback onAddTap;
  final VoidCallback onHistoryTap;
  final bool showHistory;

  const _InventoryHeader({
    required this.onAddTap,
    required this.onHistoryTap,
    required this.showHistory,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
      child: Row(
        children: [
          _HeaderButton(
            icon: Icons.arrow_back,
            onTap: Get.back,
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Text(
              "inventory".tr,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: inventoryTextPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Visibility(
            visible: showHistory,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: _HeaderButton(
              icon: Icons.add_rounded,
              iconColor: inventoryBlue,
              onTap: onAddTap,
            ),
          ),
          const SizedBox(width: 12),
          Visibility(
            visible: showHistory,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: _HeaderButton(
              icon: Icons.history_rounded,
              onTap: onHistoryTap,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const _HeaderButton({
    required this.icon,
    required this.onTap,
    this.iconColor = inventoryTextPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: const Color(0xFFFBFCFF),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE9ECF4)),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
    );
  }
}

class _DateRangeView extends StatelessWidget {
  final String text;

  const _DateRangeView({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 14),
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE8EBF3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.calendar_today_outlined,
            color: inventoryTextSecondary,
            size: 18,
          ),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: inventoryTextPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: inventoryTextSecondary,
            size: 24,
          ),
        ],
      ),
    );
  }
}
