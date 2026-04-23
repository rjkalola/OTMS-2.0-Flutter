import 'package:belcka/buyer_app/suppliers/supplier_list/controller/buyer_supplier_controller.dart';
import 'package:belcka/buyer_app/suppliers/supplier_list/models/supplier_info.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/other_widgets/no_data_found_widget.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class BuyerSupplierList extends StatelessWidget {
  BuyerSupplierList({super.key});

  final controller = Get.put(BuyerSupplierController());

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: controller.listItems.isNotEmpty
            ? GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                itemCount: controller.listItems.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 3 items per row
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 6,
                  childAspectRatio: 1, // square item
                ),
                itemBuilder: (context, index) {
                  SupplierInfo info = controller.listItems[index];
                  return GestureDetector(
                    onTap: () {
                      var arguments = {
                        AppConstants.intentKey.itemDetails: info,
                      };
                      controller.moveToScreen(
                          appRout: AppRoutes.buyerAddSupplierScreen,
                          arguments: arguments);
                     /* var arguments = {
                        AppConstants.intentKey.recordId: info.id ?? 0,
                        AppConstants.intentKey.title: info.name ?? "",
                        AppConstants.intentKey.filterType:
                            AppConstants.action.suppliers,
                      };
                      Get.toNamed(AppRoutes.buyerOrdersScreen,
                          arguments: arguments);*/
                    },
                    child: CardViewDashboardItem(
                        borderRadius: 16,
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.fromLTRB(9, 9, 9, 0),
                                alignment: Alignment.bottomCenter,
                                child: !StringHelper.isEmptyString(
                                        info.thumbUrl ?? "")
                                    ? Image.network(
                                        info.thumbUrl ?? "",
                                        fit: BoxFit.contain,
                                        width: double.infinity,
                                        height: double.infinity,
                                        errorBuilder: (context, url, error) =>
                                            ImageUtils.getEmptyViewContainer(
                                                width: 70,
                                                height: 70,
                                                borderRadius: 0),
                                      )
                                    : ImageUtils.getEmptyViewContainer(
                                        width: 70, height: 70, borderRadius: 0),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              padding:
                                  EdgeInsetsGeometry.only(left: 10, right: 10),
                              height: 40,
                              child: TitleTextView(
                                text: info.name ?? "",
                                fontSize: 13,
                                textAlign: TextAlign.center,
                                maxLine: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                          ],
                        )),
                  );
                },
              )
            : Center(
                child: NoDataFoundWidget(),
              )

        // child: ListView.separated(
        //     physics: const ClampingScrollPhysics(),
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
