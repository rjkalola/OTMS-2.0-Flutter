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

class _OrderDetailsHeaderViewState extends State<OrderDetailsHeaderView> {

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
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
            child: Row(
              children: [
                Row(
                  children: [
                    TitleTextView(
                        text: "order".tr,
                        fontSize: 17,
                        fontWeight: FontWeight.w500
                    ),
                    SizedBox(width: 4),
                    TitleTextView(
                        text: orderInfo.orderId ?? "",
                        fontSize: 18,
                        fontWeight: FontWeight.w700
                    ),
                  ],
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TitleTextView(
                        text: "${orderInfo.currency ?? ""}${orderInfo.totalAmount ?? "0.00"}",
                        fontSize: 16,
                        fontWeight: FontWeight.w700
                    ),
                    SizedBox(width: 4),
                    SubtitleTextView(
                      text: "${orderInfo.orders?.length ?? 0} item",
                    )

                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 12),
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
                          Icon(Icons.store, size: 25,color: Colors.grey,),
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
                        children: [
                          Icon(Icons.home, size: 30,color: Colors.grey,),
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

          const SizedBox(height: 16),
          if (controller.canShowActionButtons)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
              child: _buildOrderActions(orderInfo.status ?? 0),
            ),
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
                  title: 'Cancel Order ${controller.orderDetails[0].orderId ?? ""}',
                  description: 'Please provide a reason for cancelling this order.'
                      'This information is required for project tracking and order history',
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

