import 'package:belcka/pages/common/listener/date_filter_listener.dart';
import 'package:belcka/pages/common/widgets/date_filter_options_horizontal_list.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/storeman_app/storeman_internal_orders/controller/storeman_internal_order_controller.dart';
import 'package:belcka/storeman_app/storeman_internal_orders/view/widgets/storeman_internal_order_list.dart';
import 'package:belcka/storeman_app/storeman_internal_orders/view/widgets/storeman_internal_order_tabs.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class StoremanInternalOrdersScreen extends StatefulWidget {
  const StoremanInternalOrdersScreen({super.key});

  @override
  State<StoremanInternalOrdersScreen> createState() =>
      _StoremanInternalOrdersScreenState();
}

class _StoremanInternalOrdersScreenState extends State<StoremanInternalOrdersScreen>
    implements DateFilterListener {
  late final StoremanInternalOrderController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(StoremanInternalOrderController());
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
              title: 'internal_orders'.tr,
              isCenterTitle: false,
              isBack: true,
              bgColor: backgroundColor_(context),
              widgets: actionButtons(),
              isSearching: controller.isSearchEnable.value,
              searchController: controller.searchController,
              onValueChange: (value) {
                controller.searchItem(value);
              },
              autoFocus: true,
              isClearVisible: false.obs,
            ),
            body: ModalProgressHUD(
              inAsyncCall: controller.isLoading.value,
              opacity: 0,
              progressIndicator: const CustomProgressbar(),
              child: controller.isInternetNotAvailable.value
                  ? NoInternetWidget(
                      onPressed: () {
                        controller.isInternetNotAvailable.value = false;
                        controller.loadData();
                      },
                    )
                  : Column(
                      children: [
                        _buildHeaderView(),
                        const SizedBox(height: 12),
                        DateFilterOptionsHorizontalList(
                          padding: const EdgeInsets.fromLTRB(14, 0, 14, 6),
                          startDate: controller.startDate.value,
                          endDate: controller.endDate.value,
                          listener: this,
                          selectedPosition: controller.selectedDateFilterIndex,
                        ),
                        if (controller.startDate.value.isNotEmpty &&
                            controller.endDate.value.isNotEmpty)
                          SizedBox(
                            width: double.infinity,
                            child: CardViewDashboardItem(
                              padding: const EdgeInsets.all(6),
                              margin: const EdgeInsets.only(
                                  left: 14, right: 14, top: 6, bottom: 6),
                              borderRadius: 8,
                              child: TitleTextView(
                                textAlign: TextAlign.center,
                                text:
                                    "${controller.startDate.value} - ${controller.endDate.value}",
                              ),
                            ),
                          ),
                        Expanded(
                          child: StoremanInternalOrderList(),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderView() {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor_(context),
        boxShadow: [AppUtils.boxShadow(shadowColor_(context), 10)],
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(28), bottomRight: Radius.circular(28)),
      ),
      child: Column(
        children: [
          StoremanInternalOrderTabs(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  List<Widget>? actionButtons() {
    return [
      const SizedBox(width: 6),
      InkWell(
        onTap: () {
          controller.isSearchEnable.toggle();
          if (!controller.isSearchEnable.value) {
            controller.clearSearch();
          }
        },
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Obx(() => controller.isSearchEnable.value
              ? Icon(
                  Icons.close,
                  color: primaryTextColor_(context),
                )
              : ImageUtils.setSvgAssetsImage(
                  path: Drawable.searchIcon,
                  width: 24,
                  height: 24,
                  color: primaryTextColor_(context),
                )),
        ),
      ),
      const SizedBox(width: 10),
      InkWell(
        borderRadius: BorderRadius.circular(45),
        onTap: () {
          // Implement filter logic if needed
        },
        child: Padding(
          padding: const EdgeInsets.only(right: 9),
          child: ImageUtils.setSvgAssetsImage(
              path: Drawable.filterIcon,
              width: 26,
              height: 26,
              color: primaryTextColor_(Get.context!)),
        ),
      ),
    ];
  }

  @override
  void onSelectDateFilter(int filterIndex, String filter, String startDate,
      String endDate, String dialogIdentifier) {
    controller.startDate.value = startDate;
    controller.endDate.value = endDate;
    controller.loadData();
  }
}
