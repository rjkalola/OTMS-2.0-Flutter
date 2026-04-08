import 'package:belcka/pages/user_orders/order_details/controller/order_details_controller.dart';
import 'package:belcka/pages/user_orders/order_details/view/widgets/order_details_header_view.dart';
import 'package:belcka/pages/user_orders/order_details/view/widgets/order_details_orders_list.dart';
import 'package:belcka/pages/user_orders/order_details/view/widgets/order_status_alert_dialog.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {

  final controller = Get.put(OrderDetailsController());

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
                title: !StringHelper.isEmptyString(
                    controller.orderInfo.value.orderId)
                    ? "${'order'.tr} ${controller.orderInfo.value.orderId ?? ""}"
                    : "",
                isCenterTitle: false,
                isBack: true,
                bgColor: backgroundColor_(context),
                autoFocus: true,
                isClearVisible: false.obs,
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
                    ? Column(
                  children: [
                    OrderDetailsHeaderView(),
                    SizedBox(height: 12),
                    Expanded(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: OrderDetailsOrdersList(),
                        )),

                    //Collect button
                    if ( controller.getSelectedItemsCount() > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Cancel Button
                          Expanded(
                            child: SizedBox(
                              height: 45,
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    for (var order in controller.orderDetails[0].orders!) {
                                      order.isSelected = false;
                                    }
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  elevation: 4,
                                  shape: const StadiumBorder(),
                                ),
                                child: Text(
                                  'cancel'.tr,
                                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 16,),
                          // Confirm Button
                          Expanded(
                            child: SizedBox(
                              height: 45,
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  FocusManager.instance.primaryFocus
                                      ?.unfocus();
                                  showDialog(
                                    context: context,
                                    builder: (context) =>
                                        OrderStatusAlertDialog(
                                          title:
                                          '${'confirm_order'.tr} ${controller.orderDetails[0].orderId ?? ""}',
                                          description:
                                          "collected_order_confirmation".tr,
                                          showTextField: false,
                                          confirmText: "confirm".tr,
                                          confirmColor: Colors.green,
                                          onConfirm: () {
                                            controller.updateOrderStatus(2, "");
                                            Navigator.pop(context);
                                          },
                                          onCancel: () => Navigator.pop(context),
                                        ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  elevation: 4,
                                  shape: const StadiumBorder(),
                                ),
                                child: Text(
                                  'collect'.tr,
                                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
                    : const SizedBox.shrink(),
              ),

            ),
          ),
        ),
      ),
    );
  }
}