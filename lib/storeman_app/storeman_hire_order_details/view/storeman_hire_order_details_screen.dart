import 'package:belcka/pages/user_orders/hire_module/user_hire_order_details/view/widgets/user_hire_order_details_header.dart';
import 'package:belcka/pages/user_orders/hire_module/user_hire_order_details/view/widgets/user_hire_order_details_product_list.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/storeman_app/storeman_hire_order_details/controller/storeman_hire_order_details_controller.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class StoremanHireOrderDetailsScreen extends StatefulWidget {
  const StoremanHireOrderDetailsScreen({super.key});

  @override
  State<StoremanHireOrderDetailsScreen> createState() =>
      _StoremanHireOrderDetailsScreenState();
}

class _StoremanHireOrderDetailsScreenState
    extends State<StoremanHireOrderDetailsScreen> {
  late final StoremanHireOrderDetailsController controller;
  final RxBool isClearVisible = false.obs;

  @override
  void initState() {
    super.initState();
    controller = Get.put(StoremanHireOrderDetailsController());
  }

  @override
  void dispose() {
    if (Get.isRegistered<StoremanHireOrderDetailsController>()) {
      Get.delete<StoremanHireOrderDetailsController>();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();

    return Obx(
      () {
        final order = controller.orderInfo.value;
        final products = controller.productsList.toList();
        return Container(
          color: backgroundColor_(context),
          child: SafeArea(
            child: Scaffold(
              backgroundColor: dashBoardBgColor_(context),
              appBar: BaseAppBar(
                appBar: AppBar(),
                title: !StringHelper.isEmptyString(order.orderId)
                    ? "${'order'.tr} ${order.orderId ?? ''}"
                    : 'hire_order_details'.tr,
                isCenterTitle: false,
                isBack: true,
                bgColor: backgroundColor_(context),
                onValueChange: (value) {},
                autoFocus: true,
                isClearVisible: isClearVisible,
                onBackPressed: () {
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
                          controller.loadDetail();
                        },
                      )
                    : Visibility(
                        visible: controller.isMainViewVisible.value,
                        child: Column(
                          children: [
                            UserHireOrderDetailsHeader(
                              item: order,
                              onListItem: () {},
                            ),
                            const SizedBox(height: 15),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    UserHireOrderDetailsProductList(
                                      products: products,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                    ),
                                  ],
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
      },
    );
  }
}
