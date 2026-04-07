import 'package:belcka/pages/user_orders/order_details/controller/order_details_controller.dart';
import 'package:belcka/pages/user_orders/order_details/view/widgets/order_action_buttons.dart';
import 'package:belcka/pages/user_orders/order_details/view/widgets/order_status_alert_dialog.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class OrderDetailsHeaderView extends StatefulWidget {
  const OrderDetailsHeaderView({super.key});

  @override
  State<OrderDetailsHeaderView> createState() => _OrderDetailsHeaderViewState();
}

class _OrderDetailsHeaderViewState extends State<OrderDetailsHeaderView>{

  final controller = Get.put(OrderDetailsController());
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

    final orderInfo = controller.orderDetails[0];

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor_(context),
        boxShadow: [AppUtils.boxShadow(shadowColor_(context), 10)],
        border: Border.all(width: 0.6, color: Colors.transparent),
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(28), bottomRight:  Radius.circular(28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /*
          Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 8, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.home, size: 25,color: Colors.grey,),
                          SizedBox(width: 8),
                          Expanded(
                            child: TitleTextView(
                                text:orderInfo.projectName ?? "",
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              softWrap: true,
                            ),
                          ),
                        ],
                      )
                      ,
                      SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.store, size: 25,color: Colors.grey,),
                          SizedBox(width: 8),
                          Expanded(
                            child: TitleTextView(
                              text:orderInfo.storeName ?? "",
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.place_outlined, size: 25,color: Colors.grey,),
                          SizedBox(width: 8),
                          Expanded(
                            child: TitleTextView(
                                text: orderInfo.addressName ?? "",
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.library_add_check_outlined, size: 25,color: Colors.grey,),
                          SizedBox(width: 8),
                          TitleTextView(
                              text:"${orderInfo.statusText ?? ""}, ${orderInfo.date ?? ""}",
                              fontSize: 14,
                              fontWeight: FontWeight.w500
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Row(
              children: [
                SizedBox(width: 8),
                TitleTextView(
                  text: "${"total".tr}:",
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                const SizedBox(width: 4),
                TitleTextView(
                    text: "${orderInfo.currency ?? ""}${orderInfo.totalAmount ?? "0.00"}",
                    fontSize: 16,
                    fontWeight: FontWeight.w700
                ),
                SizedBox(width: 4),
                SubtitleTextView(
                  text: "(${controller.getTotalQuantity()} item)",
                )
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (controller.canShowActionButtons)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
              child: _buildOrderActions(orderInfo.status ?? 0),
            ),
          */

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () => setState(() => controller.isExpanded.value = !controller.isExpanded.value),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(width: 8),
                        const Icon(Icons.home, size: 25, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TitleTextView(
                            text: orderInfo.projectName ?? "",
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            softWrap: true,
                          ),
                        ),
                        Icon(
                          controller.isExpanded.value ? Icons.expand_less : Icons.expand_more,
                          color: Colors.grey,
                          size: 28,
                        ),
                      ],
                    ),
                  ),
                ),
                // COLLAPSIBLE SECTION
                if (controller.isExpanded.value) ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 8,right: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.store, size: 25, color: Colors.grey),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TitleTextView(
                                text: orderInfo.storeName ?? "",
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.place_outlined, size: 25, color: Colors.grey),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TitleTextView(
                                text: orderInfo.addressName ?? "",
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.library_add_check_outlined, size: 25, color: Colors.grey),
                            const SizedBox(width: 8),
                            TitleTextView(
                              text: "${orderInfo.statusText ?? ""}, ${orderInfo.date ?? ""}",
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            SizedBox(width: 4),
                            TitleTextView(
                              text: "${"total".tr}:",
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                            const SizedBox(width: 4),
                            TitleTextView(
                                text: "${orderInfo.currency ?? ""}${orderInfo.totalAmount ?? "0.00"}",
                                fontSize: 16,
                                fontWeight: FontWeight.w700
                            ),
                            SizedBox(width: 4),
                            SubtitleTextView(
                              text: "(${controller.getTotalQuantity()} item)",
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (controller.canShowActionButtons)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                            child: _buildOrderActions(orderInfo.status ?? 0),
                          ),
                      ],
                    ),
                  ),

                ],
                if (!controller.isExpanded.value)
                  const SizedBox(height: 8),
              ],
            ),
          )

        ],
      ),
    );
  }

  Widget _buildOrderActions(int status) {
    // Logic to determine which UI to show
    if (status == 1 || status == 3 || status == 4 || status == 5) {
      return _twoButtons();
    }
    return _singleButton();
  }

  Widget _twoButtons() {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Row(
        children: [
          // Cancel Button
          OutlinedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => OrderStatusAlertDialog(
                  title: '${'cancel_order'.tr} ${controller.orderDetails[0].orderId ?? ""}',
                  description: '${'provide_cancel_order_reason_title'.tr}.'
                      '${'provide_cancel_order_reason_description'.tr}',
                  showTextField: true,
                  controller: _reasonController,
                  onConfirm: () {
                    controller.updateOrderStatus(7, _reasonController.text.trim());
                    _reasonController.text = "";
                    Navigator.pop(context);
                  },
                  onCancel: () => Navigator.pop(context),
                ),
              );

            },
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            ),
            child: TitleTextView(
              text: "cancel".tr,
              fontSize: 15,
              color: Colors.red,
              fontWeight: FontWeight.w500,
            ),
          ),

          Spacer(),
          ElevatedButton.icon(
            onPressed: () {
              print('Re-order button pressed');
              controller.orderAgainAction(true, 0);
            },
            icon: Icon(Icons.refresh),
            label: TitleTextView(text: "reorder_all".tr,
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.w500,),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),

        ],
      ),
    );
  }

  Widget _singleButton() {
    return Row(
      children: [
        Spacer(),
        ElevatedButton.icon(
          onPressed: () {
            print('Re-order button pressed');
            controller.orderAgainAction(true, 0);
          },
          icon: Icon(Icons.refresh),
          label: TitleTextView(text: "reorder_all".tr,
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.w500,),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
      ],
    );
  }
}

