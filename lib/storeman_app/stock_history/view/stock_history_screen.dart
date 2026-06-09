import 'package:belcka/pages/common/listener/date_filter_listener.dart';
import 'package:belcka/pages/common/widgets/date_filter_options_horizontal_list.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/storeman_app/stock_history/controller/stock_history_controller.dart';
import 'package:belcka/storeman_app/stock_history/view/widgets/stock_history_list.dart';
import 'package:belcka/storeman_app/stock_history/view/widgets/stock_history_tabs.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class StockHistoryScreen extends StatefulWidget {
  const StockHistoryScreen({super.key});

  @override
  State<StockHistoryScreen> createState() => _StockHistoryScreenState();
}

class _StockHistoryScreenState extends State<StockHistoryScreen>
    implements DateFilterListener {
  final controller = Get.put(StockHistoryController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();

    return Obx(
      () => Container(
        color: dashBoardBgColor_(context),
        child: SafeArea(
          top: false,
          child: Scaffold(
            backgroundColor: dashBoardBgColor_(context),
            appBar: BaseAppBar(
              appBar: AppBar(),
              title: 'stock_movement'.tr,
              isCenterTitle: false,
              bgColor: backgroundColor_(context),
              isBack: true,
              widgets: [
                Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: Center(
                    child: Text(
                      controller.totalCount.value.toString(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: defaultAccentColor_(context),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            body: ModalProgressHUD(
              inAsyncCall: controller.isLoading.value,
              opacity: 0,
              progressIndicator: const CustomProgressbar(),
              child: controller.isInternetNotAvailable.value
                  ? NoInternetWidget(
                      onPressed: () {
                        controller.isInternetNotAvailable.value = false;
                        controller.getStockHistory(true);
                      },
                    )
                  : Visibility(
                      visible: controller.isMainViewVisible.value,
                      child: Column(
                        children: [
                          _buildHeaderView(context),
                          const SizedBox(height: 12),
                          DateFilterOptionsHorizontalList(
                            padding: const EdgeInsets.fromLTRB(14, 0, 14, 6),
                            startDate: controller.startDate,
                            endDate: controller.endDate,
                            listener: this,
                            selectedPosition:
                                controller.selectedDateFilterIndex,
                          ),
                          const Expanded(child: StockHistoryList()),
                        ],
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderView(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor_(context),
        boxShadow: [AppUtils.boxShadow(shadowColor_(context), 10)],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Column(
        children: [
          // if (controller.startDate.isNotEmpty &&
          //     controller.endDate.isNotEmpty)
          //   SizedBox(
          //     width: double.infinity,
          //     child: CardViewDashboardItem(
          //       padding: const EdgeInsets.all(6),
          //       margin: const EdgeInsets.only(left: 14, right: 14, bottom: 6),
          //       borderRadius: 8,
          //       child: TitleTextView(
          //         textAlign: TextAlign.center,
          //         text: '${controller.startDate} - ${controller.endDate}',
          //       ),
          //     ),
          //   ),
          const StockHistoryTabs(),
          const SizedBox(height: 12),
        ],
      ),
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
    controller.startDate = startDate;
    controller.endDate = endDate;
    controller.getStockHistory(true);
  }
}
