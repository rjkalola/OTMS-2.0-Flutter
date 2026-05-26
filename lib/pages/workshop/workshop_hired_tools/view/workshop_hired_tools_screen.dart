import 'package:belcka/pages/workshop/workshop_hired_tools/controller/workshop_hired_tools_controller.dart';
import 'package:belcka/pages/workshop/workshop_hired_tools/view/widgets/workshop_hired_tools_list_item.dart';
import 'package:belcka/pages/workshop/workshop_hired_tools/view/widgets/workshop_hired_tools_tabs.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:belcka/widgets/other_widgets/no_data_found_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class WorkshopHiredToolsScreen extends StatefulWidget {
  const WorkshopHiredToolsScreen({super.key});

  @override
  State<WorkshopHiredToolsScreen> createState() =>
      _WorkshopHiredToolsScreenState();
}

class _WorkshopHiredToolsScreenState extends State<WorkshopHiredToolsScreen> {
  final controller = Get.put(WorkshopHiredToolsController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return Obx(
      () => Container(
        color: dashBoardBgColor_(context),
        child: SafeArea(
          top: false,
          bottom: !GetPlatform.isIOS,
          child: Scaffold(
            backgroundColor: dashBoardBgColor_(context),
            appBar: BaseAppBar(
              appBar: AppBar(),
              title: 'Tools hired by your team',
              isCenterTitle: false,
              isBack: true,
              bgColor: backgroundColor_(context),
              widgets: _appBarActions(context),
              isSearching: controller.isSearchEnable.value,
              searchController: controller.searchController,
              onValueChange: controller.searchItem,
              onPressedClear: () {
                controller.clearSearch();
                controller.isSearchEnable.value = false;
              },
              autoFocus: true,
              // elevation: 5,
              // shadowColor: shadowColor_(context).withValues(alpha: 0.28),
              surfaceTintColor: Colors.transparent,
              // shape: const RoundedRectangleBorder(
              //   borderRadius: BorderRadius.only(
              //     bottomLeft: Radius.circular(18),
              //     bottomRight: Radius.circular(18),
              //   ),
              // ),
            ),
            body: ModalProgressHUD(
              inAsyncCall: controller.isLoading.value,
              opacity: 0,
              progressIndicator: const CustomProgressbar(),
              child: controller.isInternetNotAvailable.value
                  ? NoInternetWidget(
                      onPressed: () {
                        controller.isInternetNotAvailable.value = false;
                        controller.getWorkshopHiredToolsApi();
                      },
                    )
                  : Visibility(
                      visible: controller.isMainViewVisible.value,
                      child: Column(
                        children: [
                          _headerView(context),
                          const SizedBox(height: 12),
                          Expanded(child: _toolsList()),
                        ],
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _headerView(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor_(context),
        boxShadow: [AppUtils.boxShadow(shadowColor_(context), 10)],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(18),
          bottomRight: Radius.circular(18),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 8),
          WorkshopHiredToolsTabs(),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _toolsList() {
    return Obx(() {
      if (controller.toolsList.isEmpty) {
        return const Center(child: NoDataFoundWidget());
      }

      return ListView.separated(
        padding: const EdgeInsets.only(bottom: 16),
        physics: const ClampingScrollPhysics(),
        itemCount: controller.toolsList.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final item = controller.toolsList[index];
          return WorkshopHiredToolsListItem(
            item: item,
            isHired: controller.isHiredTab,
            onTap: () => controller.onHireOrderItemClick(
              item.id ?? 0,
              productId: item.productId ?? 0,
            ),
          );
        },
      );
    });
  }

  List<Widget>? _appBarActions(BuildContext context) {
    return [
      Visibility(
        visible: !controller.isSearchEnable.value,
        child: InkWell(
          onTap: () {
            controller.isSearchEnable.value = true;
          },
          customBorder: const CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: ImageUtils.setSvgAssetsImage(
              path: Drawable.searchIcon,
              width: 24,
              height: 24,
              color: primaryTextColor_(context),
            ),
          ),
        ),
      ),
      // const SizedBox(width: 4),
      // Icon(
      //   Icons.more_vert,
      //   color: primaryTextColor_(context),
      //   size: 26,
      // ),
      const SizedBox(width: 8),
    ];
  }
}
