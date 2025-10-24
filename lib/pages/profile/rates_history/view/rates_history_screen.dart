import 'package:belcka/pages/common/listener/date_filter_listener.dart';
import 'package:belcka/pages/common/widgets/date_filter_options_horizontal_list.dart';
import 'package:belcka/pages/profile/rates_history/controller/rates_history_controller.dart';
import 'package:belcka/pages/profile/rates_history/view/widgets/no_rate_history_view.dart';
import 'package:belcka/pages/profile/rates_history/view/widgets/rate_history_timeline_card.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/text/toolbar_menu_item_text_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RatesHistoryScreen extends StatelessWidget implements DateFilterListener {
  final controller = Get.put(RatesHistoryController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();

    return Obx(() => Container(
        color: dashBoardBgColor_(context),
        child: SafeArea(
            child: Scaffold(
              appBar: BaseAppBar(
                appBar: AppBar(),
                title:"rate_history".tr,
                isCenterTitle: false,
                bgColor: dashBoardBgColor_(context),
                isBack: true,
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
                  child: Column(
                    children: [
                      /*
                      DateFilterOptionsHorizontalList(
                        padding: EdgeInsets.fromLTRB(14, 0, 14, 6),
                        startDate: controller.startDate,
                        endDate: controller.endDate,
                        listener: this,
                        selectedPosition: controller.selectedDateFilterIndex,
                      ),
                      */
                      Expanded(
                        child: (controller.rateHistoryList.length > 0) ? Stack(
                          children:[
                            ListView.builder(
                              padding: EdgeInsets.all(12),
                              itemCount: controller.rateHistoryList.length,
                              itemBuilder: (context, index) {
                                final request = controller.rateHistoryList[index];
                                final isLast = index == controller.rateHistoryList.length - 1;
                                return RateHistoryTimelineCard(item: request,isLast:isLast);
                              },
                            ),
                          ] ,
                        ) : NoRateHistoryView(),
                      ),
                    ],
                  ),
                ),
              ),
            ))));
  }

  void setState(Null Function() param0) {}

  @override
  void onSelectDateFilter(
      String startDate, String endDate, String dialogIdentifier) {
    controller.isResetEnable.value = true;
    controller.startDate = startDate;
    controller.endDate = endDate;
    controller.getRateHistory(controller.appliedFilters);
    print("startDate:" + startDate);
    print("endDate:" + endDate);
  }

  List<Widget>? actionButtons() {
    return [
      Visibility(
        visible: false,
        child: ToolbarMenuItemTextView(
          text: 'reset'.tr,
          padding: EdgeInsets.only(left: 6, right: 14),
          onTap: () {
            controller.clearFilter();
          },
        ),
      ),
      InkWell(
        borderRadius: BorderRadius.circular(45),
        onTap: () async {
          var arguments = {
            AppConstants.intentKey.filterType:
            AppConstants.filterType.myRequestFilter,
            AppConstants.intentKey.filterData: controller.appliedFilters,
          };
          var result =
          await Get.toNamed(AppRoutes.filterScreen, arguments: arguments);
          if (result != null) {
            controller.isResetEnable.value = true;
            controller.appliedFilters = result;
            controller.getRateHistory(result);
          }
        },
        child: Visibility(
          visible: true,
          child: Padding(
            padding: const EdgeInsets.only(right: 9),
            child: ImageUtils.setSvgAssetsImage(
                path: Drawable.filterIcon,
                width: 26,
                height: 26,
                color: primaryTextColor_(Get.context!)),
          ),
        ),
      )
    ];
  }
}

