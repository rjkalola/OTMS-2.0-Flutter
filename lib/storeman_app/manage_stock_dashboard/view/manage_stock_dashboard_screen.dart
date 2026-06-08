import 'package:belcka/res/colors.dart';
import 'package:belcka/storeman_app/manage_stock_dashboard/controller/manage_stock_dashboard_controller.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ManageStockDashboardScreen extends StatelessWidget {
  ManageStockDashboardScreen({super.key});

  final controller = Get.put(ManageStockDashboardController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        color: backgroundColor_(context),
        child: SafeArea(
          child: Scaffold(
            appBar: BaseAppBar(
              appBar: AppBar(),
              title: 'manage_stock'.tr,
              isCenterTitle: false,
              bgColor: backgroundColor_(context),
              isBack: true,
              shape: AppUtils.getAppbarShape(),
              widgets: const [],
            ),
            backgroundColor: dashBoardBgColor_(context),
            body: ModalProgressHUD(
              inAsyncCall: controller.isLoading.value,
              opacity: 0,
              progressIndicator: const CustomProgressbar(),
              child: controller.isInternetNotAvailable.value
                  ? Center(
                      child: Text("no_internet_text".tr),
                    )
                  : Visibility(
                      visible: controller.isMainViewVisible.value,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(14, 16, 14, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            GestureDetector(
                              onTap: controller.showStoresDialog,
                              child: Container(
                                height: 50,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  color: backgroundColor_(context),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TitleTextView(
                                        text: controller
                                                .selectedStoreTitle.value
                                                .isNotEmpty
                                            ? controller
                                                .selectedStoreTitle.value
                                            : 'select_store'.tr,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        maxLine: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      size: 26,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _StockStatusCard(
                              title: '${'all'.tr} ${'products'.tr}',
                              count: controller.allProductsCount.value,
                              borderColor: const Color(0xFFB9B9B9),
                              icon: Icons.inventory_2_outlined,
                              onTap: controller.onAllProductsClick,
                            ),
                            const SizedBox(height: 12),
                            _StockStatusCard(
                              title: 'in_stock'.tr,
                              count: controller.inStockCount.value,
                              borderColor: const Color(0xFF2E7D32),
                              icon: Icons.warning_rounded,
                            ),
                            const SizedBox(height: 12),
                            _StockStatusCard(
                              title: 'low_stock'.tr,
                              count: controller.lowStockCount.value,
                              borderColor: const Color(0xFFF4A51D),
                              icon: Icons.warning_rounded,
                            ),
                            const SizedBox(height: 12),
                            _StockStatusCard(
                              title: 'out_of_stock'.tr,
                              count: controller.outOfStockCount.value,
                              borderColor: const Color(0xFFE53935),
                              icon: Icons.do_not_disturb_alt_rounded,
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StockStatusCard extends StatelessWidget {
  final String title;
  final int count;
  final Color borderColor;
  final IconData icon;
  final VoidCallback? onTap;

  const _StockStatusCard({
    required this.title,
    required this.count,
    required this.borderColor,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: borderColor.withOpacity(0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: borderColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: primaryTextColor_(context),
                ),
              ),
            ),
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: primaryTextColor_(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

