import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/stock_filter/controller/stock_filter_controller.dart';

import '../../../../res/colors.dart';

class StockFilterSupplierList extends StatelessWidget {
  StockFilterSupplierList({super.key});

  final controller = Get.put(StockFilterController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          color: titleBgColor_(context),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(), //
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: List.generate(
              controller.supplierList.length,
              (position) => InkWell(
                onTap: () {
                  controller.onSelectSupplier(position);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.maxFinite,
                      color: controller.selectedSupplierIndex.value == position
                          ? backgroundColor_(context)
                          : titleBgColor_(context),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                        child: Text(
                            softWrap: true,
                            controller.supplierList[position].name!,
                            style:  TextStyle(
                              color: primaryTextColor_(context),
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            )),
                      ),
                    ),
                     Divider(
                      color: dividerColor_(context),
                      height: 0.5,
                      thickness: 0.5,
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
