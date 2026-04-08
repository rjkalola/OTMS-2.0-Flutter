import 'package:belcka/pages/user_orders/order_details/view/widgets/order_status_alert_dialog.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/storeman_app/storeman_internal_order_details/controller/storeman_internal_order_details_controller.dart';
import 'package:belcka/storeman_app/storeman_internal_order_details/view/widgets/internal_order_details_list_with_quantity.dart';
import 'package:belcka/storeman_app/storeman_internal_order_details/view/widgets/order_details_header_view.dart';
import 'package:belcka/storeman_app/storeman_internal_order_details/view/widgets/order_details_orders_list.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class StoremanInternalOrderDetailsScreen extends StatefulWidget {
  const StoremanInternalOrderDetailsScreen({super.key});

  @override
  State<StoremanInternalOrderDetailsScreen> createState() =>
      _StoremanInternalOrderDetailsScreenState();
}

class _StoremanInternalOrderDetailsScreenState
    extends State<StoremanInternalOrderDetailsScreen> {
  final controller = Get.put(StoremanInternalOrderDetailsController());
  late TextEditingController _reasonController;

  @override
  void initState() {
    super.initState();
    _reasonController = TextEditingController();
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return Obx(
      () => PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop || result != null) return;
          controller.onBackPress();
        },
        child: Container(
          color: backgroundColor_(context),
          child: SafeArea(
            child: GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: Scaffold(
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
                          },
                        )
                      : controller.isMainViewVisible.value
                          ? Column(
                              children: [
                                OrderDetailsHeaderView(),
                                SizedBox(height: 15),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 0, 16, 8),
                                  child: Row(
                                    children: [
                                      // Return Button
                                      if (controller.status.value ==
                                          AppConstants
                                              .internalOrderStatus.delivered)
                                        OutlinedButton(
                                          onPressed: () {
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                            showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  OrderStatusAlertDialog(
                                                title:
                                                    'Return Order ${controller.orderDetails[0].orderId ?? ""}',
                                                description:
                                                    'Please provide a reason for returning this order.'
                                                    'This information is required for project tracking and order history',
                                                showTextField: false,
                                                confirmText: "return_order".tr,
                                                onConfirm: () {
                                                  controller.updateOrderStatus(
                                                      8, "");
                                                  Navigator.pop(context);
                                                },
                                                onCancel: () =>
                                                    Navigator.pop(context),
                                              ),
                                            );
                                          },
                                          style: OutlinedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            foregroundColor: Colors.red,
                                            side: const BorderSide(
                                                color: Colors.red),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.0)),
                                          ),
                                          child: TitleTextView(
                                            text: "return".tr,
                                            fontSize: 15,
                                            color: Colors.red,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),

                                      Spacer(),
                                      //Cancel button
                                      if (controller.status.value ==
                                              AppConstants.internalOrderStatus
                                                  .newOrder ||
                                          controller.status.value ==
                                              AppConstants.internalOrderStatus
                                                  .partialDelivered ||
                                          controller.status.value ==
                                              AppConstants
                                                  .internalOrderStatus.ready ||
                                          controller.status.value ==
                                              AppConstants.internalOrderStatus
                                                  .preparing )
                                        OutlinedButton(
                                          onPressed: () {
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                            showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  OrderStatusAlertDialog(
                                                title:
                                                    '${'cancel_order'.tr} ${controller.orderDetails[0].orderId ?? ""}',
                                                description:
                                                    '${'provide_cancel_order_reason_title'.tr}'
                                                    '${'provide_cancel_order_reason_description'.tr}',
                                                showTextField: true,
                                                controller: _reasonController,
                                                onConfirm: () {
                                                  controller.updateOrderStatus(
                                                      7,
                                                      _reasonController.text
                                                          .trim());
                                                  _reasonController.text = "";
                                                },
                                                onCancel: () =>
                                                    Navigator.pop(context),
                                              ),
                                            );
                                          },
                                          style: OutlinedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            foregroundColor: Colors.green,
                                            side: const BorderSide(
                                                color: Colors.green),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.0)),
                                          ),
                                          child: TitleTextView(
                                            text: "cancel_order".tr,
                                            fontSize: 15,
                                            color: Colors.green,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                    child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      if (controller.status.value !=
                                          AppConstants
                                              .internalOrderStatus.ready)
                                        OrderDetailsOrdersList(),
                                      if (controller.status.value ==
                                          AppConstants
                                              .internalOrderStatus.ready)
                                        InternalOrderDetailsListWithQuantity()
                                    ],
                                  ),
                                )),
                                //mark as prepare
                                if (controller.status.value ==
                                    AppConstants.internalOrderStatus.newOrder)
                                  PrimaryButton(
                                    margin: const EdgeInsets.all(14),
                                    buttonText: 'mark_as_preparing'.tr,
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
                                              'collect_order_preparing'.tr,
                                          showTextField: false,
                                          confirmText: "confirm".tr,
                                          confirmColor: Colors.green,
                                          onConfirm: () {
                                            controller.updateOrderStatus(
                                                AppConstants.internalOrderStatus
                                                    .preparing,
                                                "");
                                            Navigator.pop(context);
                                          },
                                          onCancel: () =>
                                              Navigator.pop(context),
                                        ),
                                      );
                                    },
                                    color: Colors.green,
                                  ),
                                //ready to collect
                                if (controller.status.value ==
                                    AppConstants.internalOrderStatus.confirmed)
                                  PrimaryButton(
                                    margin: const EdgeInsets.all(14),
                                    buttonText: 'ready_to_collect'.tr,
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
                                              'collect_order_confirmation'.tr,
                                          showTextField: false,
                                          confirmText: "confirm".tr,
                                          confirmColor: Colors.green,
                                          onConfirm: () {
                                            controller.updateOrderStatus(
                                                AppConstants.internalOrderStatus
                                                    .preparing,
                                                "");
                                            Navigator.pop(context);
                                          },
                                          onCancel: () =>
                                              Navigator.pop(context),
                                        ),
                                      );
                                    },
                                    color: Colors.green,
                                  ),
                                //mark as ready
                                if (controller.status.value ==
                                    AppConstants.internalOrderStatus.preparing)
                                  PrimaryButton(
                                    margin: const EdgeInsets.all(14),
                                    buttonText: 'mark_as_ready'.tr,
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
                                              "${'collect_order_confirmation'.tr}?",
                                          showTextField: false,
                                          confirmText: "confirm".tr,
                                          confirmColor: Colors.green,
                                          onConfirm: () {
                                            controller.updateOrderStatus(
                                                AppConstants
                                                    .internalOrderStatus.ready,
                                                "");
                                            Navigator.pop(context);
                                          },
                                          onCancel: () =>
                                              Navigator.pop(context),
                                        ),
                                      );
                                    },
                                    color: Colors.green,
                                  ),
                                //delivered
                                if (controller.status.value ==
                                        AppConstants
                                            .internalOrderStatus.ready &&
                                    controller.getSelectedItemsCount() > 0)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14, horizontal: 14),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        // Cancel Button
                                        Expanded(
                                          flex: 2,
                                          child: SizedBox(
                                            height: 44,
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  for (var order in controller
                                                      .orderDetails[0]
                                                      .orders!) {
                                                    order.isSelected = false;
                                                  }
                                                });
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                                foregroundColor: Colors.white,
                                                elevation: 1,
                                                shape: const StadiumBorder(),
                                              ),
                                              child: Text(
                                                'cancel'.tr,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 12,
                                        ),
                                        // Confirm Button
                                        Expanded(
                                          flex: 3,
                                          child: SizedBox(
                                            height: 44,
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                FocusManager
                                                    .instance.primaryFocus
                                                    ?.unfocus();
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      OrderStatusAlertDialog(
                                                    title:
                                                        '${'confirm_order'.tr} ${controller.orderDetails[0].orderId ?? ""}',
                                                    description:
                                                        'order_delivered_confirmation'
                                                            .tr,
                                                    showTextField: false,
                                                    confirmText: "confirm".tr,
                                                    confirmColor: Colors.green,
                                                    onConfirm: () {
                                                      controller.updateOrderStatus(
                                                          AppConstants
                                                              .internalOrderStatus
                                                              .delivered,
                                                          "");
                                                      Navigator.pop(context);
                                                    },
                                                    onCancel: () =>
                                                        Navigator.pop(context),
                                                  ),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.green,
                                                foregroundColor: Colors.white,
                                                elevation: 1,
                                                shape: const StadiumBorder(),
                                              ),
                                              child: Text(
                                                'mark_as_delivered'.tr,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w400),
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
      ),
    );
  }
}
