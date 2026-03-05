import 'package:belcka/buyer_app/store_list/controller/buyer_stores_controller.dart';
import 'package:belcka/buyer_app/supplier_list/controller/buyer_supplier_controller.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuyerSupplierList extends StatelessWidget {
  BuyerSupplierList({super.key});

  final controller = Get.put(BuyerSupplierController());

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      itemCount: controller.listItems.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 3 items per row
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
        childAspectRatio: 1, // square item
      ),
      itemBuilder: (context, index) {
        ModuleInfo info = controller.listItems[index];
        return CardViewDashboardItem(
            borderRadius: 16,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(9, 9, 9, 0),
                    alignment: Alignment.bottomCenter,
                    child: !StringHelper.isEmptyString(info.thumbUrl ?? "")
                        ? Image.network(
                            info.thumbUrl ?? "",
                            fit: BoxFit.contain,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder: (context, url, error) =>
                                ImageUtils.getEmptyViewContainer(
                                    width: 70, height: 70, borderRadius: 0),
                          )
                        : ImageUtils.getEmptyViewContainer(
                            width: 70, height: 70, borderRadius: 0),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsetsGeometry.only(left: 6, right: 6),
                  height: 40,
                  child: TitleTextView(
                    text: info.name ?? "",
                    fontSize: 15,
                    textAlign: TextAlign.center,
                    maxLine: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
              ],
            ));
      },
    )

        // child: ListView.separated(
        //     physics: const AlwaysScrollableScrollPhysics(),
        //     shrinkWrap: true,
        //     scrollDirection: Axis.vertical,
        //     itemBuilder: (context, position) {
        //       ModuleInfo info = controller.listItems[position];
        //       return CardViewDashboardItem(
        //         margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        //         padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
        //         borderRadius: 15,
        //         child: GestureDetector(
        //           onTap: () {
        //             // var arguments = {
        //             //   AppConstants.intentKey.leaveId: info.id ?? 0,
        //             // };
        //             // controller.moveToScreen(
        //             //     AppRoutes.leaveDetailsScreen, arguments);
        //           },
        //           child: Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //             children: [
        //               TitleTextView(
        //                 text: info.name ?? "",
        //               ),
        //               TitleTextView(
        //                 text: (info.productsCount ?? 0).toString(),
        //               )
        //             ],
        //           ),
        //         ),
        //       );
        //     },
        //     itemCount: controller.listItems.length,
        //     separatorBuilder: (context, position) => SizedBox(
        //           height: 12,
        //         )),
        );
  }
}
