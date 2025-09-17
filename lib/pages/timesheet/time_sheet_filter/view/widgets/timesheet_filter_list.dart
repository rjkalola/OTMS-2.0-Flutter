import 'package:belcka/pages/filter/model/filter_info.dart';
import 'package:belcka/pages/timesheet/time_sheet_filter/controller/time_sheet_filter_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class TimesheetFilterList extends StatelessWidget {
  TimesheetFilterList({super.key});

  final controller = Get.put(TimeSheetFilterController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          color: titleBgColor_(context),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(), //
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: List.generate(
              controller.filterList.length,
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
                        padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                  softWrap: true,
                                  controller.filterList[position].name!,
                                  style:  TextStyle(
                                    color: primaryTextColor_(context),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                  )),
                            ),
                            Visibility(
                              visible: getSelectedItemCount(controller
                                      .filterData.value.info![position].data!,position) >
                                  0,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 6),
                                child: PrimaryTextView(
                                  text: getSelectedItemCount(controller
                                          .filterData
                                          .value
                                          .info![position]
                                          .data!,position)
                                      .toString(),
                                  fontSize: 14,
                                  color: primaryTextColor_(context),
                                ),
                              ),
                            )
                          ],
                        ),
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

  int getSelectedItemCount(List<FilterInfo> listCategory, int index) {
    int count = 0;
    if (index != controller.selectedSupplierIndex.value) {
      for (var info in listCategory) {
        if (info.selected ?? false) {
          count = count + 1;
        }
      }
    } else {
      for (var info in controller.categoriesList) {
        if (info.selected ?? false) {
          count = count + 1;
        }
      }
    }

    return count;
  }
}
