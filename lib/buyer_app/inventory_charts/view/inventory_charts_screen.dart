import 'package:belcka/buyer_app/inventory_charts/controller/inventory_charts_controller.dart';
import 'package:belcka/buyer_app/inventory_charts/view/widgets/inventory_line_chart_card.dart';
import 'package:belcka/buyer_app/inventory_charts/view/widgets/inventory_week_bar_chart_card.dart';
import 'package:belcka/pages/common/listener/date_filter_listener.dart';
import 'package:belcka/pages/common/widgets/date_filter_options_horizontal_list.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class InventoryChartsScreen extends StatefulWidget {
  const InventoryChartsScreen({super.key});

  @override
  State<InventoryChartsScreen> createState() => _InventoryChartsScreenState();
}

class _InventoryChartsScreenState extends State<InventoryChartsScreen>
    implements DateFilterListener {
  late final InventoryChartsController controller;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<InventoryChartsController>()) {
      Get.delete<InventoryChartsController>(force: true);
    }
    controller = Get.put(InventoryChartsController());
  }

  @override
  void dispose() {
    Get.delete<InventoryChartsController>(force: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();

    return Obx(
      () => Container(
        color: backgroundColor_(context),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: dashBoardBgColor_(context),
            appBar: BaseAppBar(
              appBar: AppBar(),
              title: 'inventory'.tr,
              isCenterTitle: false,
              isBack: true,
              bgColor: backgroundColor_(context),
              widgets: _chartMenuActions(context),
            ),
            body: ModalProgressHUD(
              inAsyncCall: controller.isLoading.value,
              opacity: 0,
              progressIndicator: const CustomProgressbar(),
              child: controller.isInternetNotAvailable.value
                  ? Center(child: Text('no_internet_text'.tr))
                  : Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 14,
                          decoration: BoxDecoration(
                            color: backgroundColor_(context),
                            boxShadow: [
                              AppUtils.boxShadow(shadowColor_(context), 6)
                            ],
                            border: Border.all(
                                width: 0.6, color: Colors.transparent),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(45),
                              bottomRight: Radius.circular(45),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: controller.isMainViewVisible.value,
                          child: Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 12),
                                  DateFilterOptionsHorizontalList(
                                    padding:
                                        const EdgeInsets.fromLTRB(14, 0, 14, 6),
                                    startDate: controller.startDate.value,
                                    endDate: controller.endDate.value,
                                    listener: this,
                                    selectedPosition:
                                        controller.selectedDateFilterIndex,
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: CardViewDashboardItem(
                                      padding: const EdgeInsets.all(6),
                                      margin: const EdgeInsets.only(
                                        left: 14,
                                        right: 14,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      borderRadius: 8,
                                      child: TitleTextView(
                                        textAlign: TextAlign.center,
                                        text:
                                            "${controller.displayStartDate.value} - ${controller.displayEndDate.value}",
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(14, 4, 14, 8),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () => controller
                                                .showSelectStoreDialog(),
                                            child: Row(
                                              children: [
                                                Text(
                                                  '${'store'.tr}: ',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                    color: primaryTextColor_(
                                                        context),
                                                  ),
                                                ),
                                                Text(
                                                  controller
                                                      .selectedStoreLabel.value,
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: primaryTextColor_(
                                                        context),
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Icon(
                                                  Icons.chevron_right,
                                                  color: primaryTextColor_(
                                                      context),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        _LegendChip(
                                          color: const Color(0xFF4CAF50),
                                          label: 'inventory_in_legend'.tr,
                                        ),
                                        const SizedBox(width: 10),
                                        _LegendChip(
                                          color: controller
                                                      .chartDisplayType.value ==
                                                  InventoryChartDisplayType.bar
                                              ? const Color(0xFFFF9800)
                                              : const Color(0xFFE53935),
                                          label: 'inventory_out_legend'.tr,
                                        ),
                                      ],
                                    ),
                                  ),
                                  _ChartBody(controller: controller),
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
      ),
    );
  }

  List<Widget>? _chartMenuActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.more_vert_outlined),
        onPressed: () => controller.showMenuItemsDialog(context),
      ),
    ];
  }

  @override
  void onSelectDateFilter(int filterIndex, String filter, String startDateStr,
      String endDateStr, String dialogIdentifier) {
    controller.onSelectDateFilter(
        filterIndex, filter, startDateStr, endDateStr, dialogIdentifier);
  }
}

class _LegendChip extends StatelessWidget {
  const _LegendChip({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: primaryTextColor_(context),
          ),
        ),
      ],
    );
  }
}

class _ChartBody extends StatelessWidget {
  const _ChartBody({required this.controller});

  final InventoryChartsController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final data = controller.overviewData.value;
      final currency = data.currency ?? '£';

      if (controller.chartDisplayType.value == InventoryChartDisplayType.bar) {
        final blocks = data.weekDaysWiseData ?? [];
        if (blocks.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Center(child: Text('empty_data_message'.tr)),
          );
        }
        return Column(
          children: [
            for (final b in blocks)
              InventoryWeekBarChartCard(block: b, currency: currency),
          ],
        );
      }

      final weeks = data.weekWiseData ?? [];
      if (weeks.isEmpty) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Center(child: Text('empty_data_message'.tr)),
        );
      }
      final title =
          "${controller.displayStartDate.value} - ${controller.displayEndDate.value}";
      return InventoryLineChartCard(
        weeks: weeks,
        currency: currency,
        titleRange: title,
      );
    });
  }
}
