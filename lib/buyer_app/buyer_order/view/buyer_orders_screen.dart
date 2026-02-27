import 'package:belcka/buyer_app/buyer_order/controller/buyer_order_controller.dart';
import 'package:belcka/buyer_app/buyer_order/view/widgets/buyer_delivered_order_list.dart';
import 'package:belcka/buyer_app/buyer_order/view/widgets/buyer_order_header_view.dart';
import 'package:belcka/buyer_app/buyer_order/view/widgets/buyer_proceed_order_list.dart';
import 'package:belcka/buyer_app/buyer_order/view/widgets/buyer_request_order_list.dart';
import 'package:belcka/buyer_app/buyer_order/view/widgets/delivery_to_text_widget.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/model/product_info.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/enums/order_tab_type.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../utils/app_constants.dart';

class BuyerOrdersScreen extends StatefulWidget {
  const BuyerOrdersScreen({super.key});

  @override
  State<BuyerOrdersScreen> createState() => _BuyerOrdersScreenState();
}

class _BuyerOrdersScreenState extends State<BuyerOrdersScreen> {
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
        color: backgroundColor_(context),
        child: SafeArea(
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
                            // DeliveryToTextWidget(text: "(Haringey OT)"),
                            Expanded(
                              child: Visibility(
                                  visible: !controller.isLoading.value,
                                  child: selectedOrderList()),
                            ),
                            controller.selectedTab.value == OrderTabType.request
                                ? PrimaryButton(
                                    padding: EdgeInsets.all(14),
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
                                        controller.moveToScreen(
                                            appRout: AppRoutes
                                                .createBuyerOrderScreen,
                                            arguments: arguments);
                                        Get.toNamed(
                                            AppRoutes.createBuyerOrderScreen);
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
      SizedBox(
        width: 10,
      ),
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
    switch (controller.selectedTab.value) {
      case OrderTabType.request:
        return BuyerRequestOrderList();

      case OrderTabType.proceed:
        return BuyerProceedOrderList();

      case OrderTabType.delivered:
        return BuyerDeliveredOrderList();

      default:
        return const SizedBox.shrink();
    }
  }
}
