import 'package:belcka/pages/user_orders/order_details/view/widgets/order_status_alert_dialog.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/storeman_app/storeman_internal_order_details/controller/storeman_internal_order_details_controller.dart';
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

class _OrderDetailsHeaderViewState extends State<OrderDetailsHeaderView> with WidgetsBindingObserver{

  final controller = Get.put(StoremanInternalOrderDetailsController());
  late TextEditingController _reasonController;

  @override
  void initState() {
    super.initState();
    _reasonController = TextEditingController();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _reasonController.dispose();
    super.dispose();
  }
  @override
  void didChangeMetrics() {
    final bottomInset = View.of(context).viewInsets.bottom;
    if (bottomInset > 0 && controller.isExpanded.value) {
      setState(() {
        controller.isExpanded.value = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (controller.orderDetails.isEmpty) {
      return const Center(
        child: Text("No orders found."), // Or a CircularProgressIndicator()
      );
    }
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
                        TitleTextView(
                          text: "${'expected_delivery_time'.tr}: ${orderInfo.deliverOn ?? ""}",
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                TitleTextView(
                                  text: "${"total".tr}:",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                                const SizedBox(width: 4),
                                TitleTextView(
                                  text: "${controller.getTotalQuantity()} item",
                                  fontSize: 16,
                                ),
                              ],
                            ),
                            TitleTextView(
                              text: orderInfo.userName ?? "",
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
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
}

