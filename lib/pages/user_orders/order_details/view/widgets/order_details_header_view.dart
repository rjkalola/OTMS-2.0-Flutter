import 'package:belcka/pages/user_orders/order_details/controller/order_details_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderDetailsHeaderView extends StatelessWidget {
  OrderDetailsHeaderView({super.key});

  final controller = Get.put(OrderDetailsController());

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
          /*
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
            child: buildActionButtons(orderInfo.status ?? 0),
          )
          */
        ],
      ),
    );
  }
}


Widget buildActionButtons(int status) {
  if (status == 1 || status == 2 || status == 4) {
    //return _singleButton("Cancel", Colors.red);
    return Row(
      children: [
        Expanded(
          child: _actionButton(
            title: "Cancel",
            textColor: Colors.red,
            onTap: () {},
          ),
        ),
        Spacer(),
        Expanded(
          child: _actionButton(
            title: "Reorder All",
            textColor: Colors.green,
            onTap: () {},
          ),
        ),
      ],
    );
  }

  if (status == 6 || status == 7) {
    return Row(
      children: [
        Expanded(
          child: _actionButton(
            title: "Return",
            textColor: Colors.red,
            onTap: () {},
          ),
        ),
        Spacer(),
        Expanded(
          child: _actionButton(
            title: "Reorder All",
            textColor: Colors.green,
            onTap: () {},
          ),
        ),
      ],
    );
  }

  if (status == 3 || status == 8 || status == 9) {
    return _singleButton("Reorder All", Colors.green);
  }

  return _singleButton("Reorder All", Colors.green);//const SizedBox();
}

Widget _actionButton({
  required String title,
  required Color textColor,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(30),
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}

Widget _singleButton(String title, Color color) {
  return Row(
    children: [
      Expanded(
        child: _actionButton(
          title: title,
          textColor: color,
          onTap: () {},
        ),
      ),
      Spacer()
    ],
  );
}