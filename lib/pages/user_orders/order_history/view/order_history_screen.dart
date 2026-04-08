import 'package:belcka/pages/user_orders/order_history/controller/order_history_controller.dart';
import 'package:belcka/pages/user_orders/order_history/view/widgets/order_history_filter_tabs.dart';
import 'package:belcka/pages/user_orders/order_history/view/widgets/order_history_list.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';


class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final controller = Get.put(OrderHistoryController());

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
          child: Obx(
                () => Scaffold(
              backgroundColor: dashBoardBgColor_(context),
              appBar: BaseAppBar(
                appBar: AppBar(),
                title: 'history'.tr,
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
                onPressedClear: (){
                  controller.clearSearch();
                  controller.isSearchEnable.value =
                      !controller.isSearchEnable.value;
                },
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
                    ? Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      OrderHistoryFilterTabs(),
                      SizedBox(height: 12),
                      OrderHistoryList()
                    ],
                  ),
                )
                    : const SizedBox.shrink(),
              ),
            ),
          ),
        ),
      ),
    );
  }
  List<Widget>? actionButtons() {
    return [
      Visibility(
        visible: !controller.isSearchEnable.value,
        child: InkWell(
          onTap: () {
            if (controller.isSearchEnable.value) {
              controller.clearSearch();
            }
            controller.isSearchEnable.value = !controller.isSearchEnable.value;
          },
          customBorder: const CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: ImageUtils.setSvgAssetsImage(
              path: Drawable.searchIcon,
              width: 24,
              height: 24,
            ),
          ),
        ),
      ),
      SizedBox(
        width: 10,
      ),
    ];
  }
}
