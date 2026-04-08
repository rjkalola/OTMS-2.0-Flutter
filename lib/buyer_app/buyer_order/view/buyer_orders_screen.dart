import 'package:belcka/buyer_app/buyer_order/controller/buyer_order_controller.dart';
import 'package:belcka/buyer_app/buyer_order/view/widgets/buyer_filter_selected_items_list.dart';
import 'package:belcka/buyer_app/buyer_order/view/widgets/buyer_order_header_view.dart';
import 'package:belcka/buyer_app/buyer_order/view/widgets/buyer_order_status_list.dart';
import 'package:belcka/buyer_app/buyer_order/view/widgets/buyer_products_list.dart';
import 'package:belcka/pages/common/listener/date_filter_listener.dart';
import 'package:belcka/pages/common/widgets/date_filter_options_horizontal_list.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/model/product_info.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/enums/order_tab_type.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../utils/app_constants.dart';

class BuyerOrdersScreen extends StatefulWidget {
  const BuyerOrdersScreen({super.key});

  @override
  State<BuyerOrdersScreen> createState() => _BuyerOrdersScreenState();
}

class _BuyerOrdersScreenState extends State<BuyerOrdersScreen>
    implements DateFilterListener {
  late final BuyerOrderController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(BuyerOrderController());
  }

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
              title: 'orders'.tr,
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
              onPressedClear: () {
                controller.clearSearch();
                controller.isSearchEnable.value =
                    !controller.isSearchEnable.value;
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
                          // controller.getCompanyDetailsApi();
                        },
                      )
                    : Visibility(
                        visible: controller.isMainViewVisible.value,
                        child: Column(
                          children: [
                            BuyerOrderHeaderView(),
                            SizedBox(
                              height: 12,
                            ),
                            Visibility(
                              visible: controller.selectedTab.value ==
                                  OrderTabType.request,
                              child: BuyerFilterSelectedItemsList(),
                            ),
                            Visibility(
                              visible: controller.selectedTab.value !=
                                  OrderTabType.request,
                              child: DateFilterOptionsHorizontalList(
                                padding: EdgeInsets.fromLTRB(14, 0, 14, 6),
                                startDate: controller.startDate.value,
                                endDate: controller.endDate.value,
                                listener: this,
                                selectedPosition:
                                    controller.selectedDateFilterIndex,
                              ),
                            ),
                            Visibility(
                              visible: controller.selectedTab.value !=
                                  OrderTabType.request,
                              child: SizedBox(
                                width: double.infinity,
                                child: CardViewDashboardItem(
                                    padding: EdgeInsets.all(6),
                                    margin: EdgeInsetsGeometry.only(
                                        left: 14, right: 14, top: 6, bottom: 6),
                                    borderRadius: 8,
                                    child: TitleTextView(
                                      textAlign: TextAlign.center,
                                      text:
                                          "${controller.displayStartDate.value} - ${controller.displayEndDate.value}",
                                    )),
                              ),
                            ),
                            // DeliveryToTextWidget(text: "(Haringey OT)"),
                            Expanded(
                              child: selectedOrderList(),
                            ),
                            controller.selectedTab.value == OrderTabType.request
                                ? PrimaryButton(
                                    margin: EdgeInsets.all(14),
                                    buttonText: 'create_order'.tr,
                                    onPressed: () {
                                      var list = <ProductInfo>[];
                                      for (var item
                                          in controller.requestOrdersList) {
                                        if ((item.cartQty ?? 0) > 0) {
                                          list.add(item);
                                        }
                                      }
                                      if (list.isNotEmpty) {
                                        var arguments = {
                                          AppConstants.intentKey.productsData:
                                              list,
                                        };
                                        controller.moveToCreateOrderScreen(
                                            appRout: AppRoutes
                                                .createBuyerOrderScreen,
                                            arguments: arguments);
                                      } else {
                                        AppUtils.showToastMessage(
                                            'msg_add_at_least_one_qty'.tr);
                                      }
                                    },
                                    color: Colors.green,
                                  )
                                : Container()
                          ],
                        ),
                      )),
          ),
        ),
      ),
    );
  }

  List<Widget>? actionButtons() {
    return [
      const SizedBox(width: 6),
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
              color: primaryTextColor_(context),
            ),
          ),
        ),
      ),
      SizedBox(
        width: 10,
      ),
      Visibility(
        visible: !controller.isSingleFilter.value &&
            controller.selectedTab.value == OrderTabType.request,
        child: InkWell(
          borderRadius: BorderRadius.circular(45),
          onTap: () async {
            controller.moveToFilterScreen();
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
      )
      // if (UserUtils.isAdmin())
      //   IconButton(
      //     icon: const Icon(Icons.more_vert_outlined),
      //     onPressed: () {},
      //   ),
    ];
  }

  // ------------------------------------------------
  // Selected Tab Content
  // ------------------------------------------------

  Widget selectedOrderList() {
    if (controller.selectedTab.value == OrderTabType.request) {
      return BuyerProductsList();
    }
    if (controller.selectedTab.value == OrderTabType.upcoming ||
        controller.selectedTab.value == OrderTabType.proceed ||
        controller.selectedTab.value == OrderTabType.delivered ||
        controller.selectedTab.value == OrderTabType.cancelled) {
      return const BuyerOrderStatusList();
    }
    return Container();
  }

  @override
  void onSelectDateFilter(int filterIndex, String filter, String startDate,
      String endDate, String dialogIdentifier) {
    print("filterIndex:" + filterIndex.toString());
    print("filter:" + filter);
    // controller.isResetEnable.value = true;
    controller.startDate.value = startDate;
    controller.endDate.value = endDate;
    controller.loadData();
    print("startDate:" + startDate);
    print("endDate:" + endDate);
  }
}
