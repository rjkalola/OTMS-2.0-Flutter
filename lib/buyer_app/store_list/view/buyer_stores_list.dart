import 'package:belcka/buyer_app/store_list/controller/buyer_stores_controller.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/other_widgets/no_data_found_widget.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/app_constants.dart';

class BuyerStoresList extends StatelessWidget {
  BuyerStoresList({super.key});

  final controller = Get.put(BuyerStoresController());

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: controller.listItems.isNotEmpty
          ? ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, position) {
                ModuleInfo info = controller.listItems[position];
                return GestureDetector(
                  onTap: () {
                    var arguments = {
                      AppConstants.intentKey.recordId: info.id ?? 0,
                      AppConstants.intentKey.title: info.name ?? "",
                      AppConstants.intentKey.filterType:
                          AppConstants.action.stores,
                    };
                    Get.toNamed(AppRoutes.buyerOrdersScreen,
                        arguments: arguments);
                  },
                  child: CardViewDashboardItem(
                    margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
                    borderRadius: 15,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TitleTextView(
                          text: info.name ?? "",
                        ),
                        TitleTextView(
                          text: (info.productsCount ?? 0).toString(),
                        )
                      ],
                    ),
                  ),
                );
              },
              itemCount: controller.listItems.length,
              separatorBuilder: (context, position) => SizedBox(
                    height: 12,
                  ))
          : Center(
              child: NoDataFoundWidget(),
            ),
    );
  }
}
