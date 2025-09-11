import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:belcka/pages/filter/controller/filter_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/res/theme/app_colors.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';

class FilterScreen extends StatelessWidget {
  final controller = Get.put(FilterController());

// Simulating previously selected values

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    return Obx(() => Container(
        color: dashBoardBgColor_(context),
        child: SafeArea(
            child: Scaffold(
          appBar: BaseAppBar(
            appBar: AppBar(),
            title: "Filter",
            isCenterTitle: false,
            bgColor: dashBoardBgColor_(context),
            isBack: true,
            widgets: [
              TextButton(
                onPressed: controller.clearAll,
                child: Text("Clear All",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                        fontWeight: FontWeight.w500)),
              ),
            ],
          ),
          backgroundColor: dashBoardBgColor_(context),
          body: ModalProgressHUD(
            inAsyncCall: controller.isLoading.value,
            opacity: 0,
            progressIndicator: const CustomProgressbar(),
            child: controller.isInternetNotAvailable.value
                ? const Center(
                    child: Text("No Internet"),
                  )
                : Visibility(
                    visible: controller.isMainViewVisible.value,
                    child: Row(
                      children: [
                        // Left Section Tabs
                        Container(
                          width: isTablet ? 200 : 150,
                          color: lightGreyColor(context),
                          child: ListView.builder(
                            itemCount: controller.sections.length,
                            itemBuilder: (_, index) {
                              final section = controller.sections[index];
                              return Obx(() {
                                final isSelected =
                                    controller.selectedSectionIndex.value ==
                                        index;
                                final selectedCount =
                                    controller.getSelectedCount(index);
                                return ListTile(
                                  selected: isSelected,
                                  onTap: () => controller
                                      .selectedSectionIndex.value = index,
                                  title: Row(
                                    children: [
                                      Expanded(child: Text(section.name)),
                                      if (selectedCount > 0)
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            "$selectedCount",
                                            style: TextStyle(
                                                color:
                                                    primaryTextColor_(context),
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              });
                            },
                          ),
                        ),

                        Expanded(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: TextField(
                                  onChanged: (value) =>
                                      controller.searchQuery.value = value,
                                  decoration: InputDecoration(
                                    hintText: 'Search',
                                    prefixIcon: const Icon(Icons.search),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Obx(() {
                                  final items = controller.filteredItems;
                                  return ListView.builder(
                                    itemCount: items.length,
                                    itemBuilder: (_, index) {
                                      final item = items[index];
                                      final sectionIndex =
                                          controller.selectedSectionIndex.value;
                                      final itemIndex = controller
                                          .sections[sectionIndex].data
                                          .indexOf(item);
                                      return CheckboxListTile(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(6)),
                                        side: BorderSide(
                                            color: Colors.grey.shade500),
                                        activeColor:
                                            defaultAccentColor_(context),
                                        checkColor: Colors.white,
                                        title: Text(item.name),
                                        value: item.selected,
                                        onChanged: (_) =>
                                            controller.toggleItemSelection(
                                                sectionIndex, itemIndex),
                                        controlAffinity:
                                            ListTileControlAffinity.trailing,
                                      );
                                    },
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          bottomNavigationBar: BottomAppBar(
            color: dashBoardBgColor_(context),
            elevation: 10,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () => Get.back(),
                      child: Text(
                        "Close",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: primaryTextColor_(context)),
                      )),
                  TextButton(
                      onPressed: () {
                        final selectedMap =
                            controller.getSelectedFiltersAsMap();
                        print(selectedMap); // send to API, etc.
                        controller.searchQuery.value = "";
                        Get.back(result: selectedMap);
                      },
                      child: Text(
                        "Apply",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: defaultAccentColor_(context)),
                      )),
                ],
              ),
            ),
          ),
        ))));
  }
}
