import 'package:belcka/pages/common/listener/date_filter_listener.dart';
import 'package:belcka/pages/common/widgets/date_filter_options_horizontal_list.dart';
import 'package:belcka/pages/conflicts/controller/conflicts_controller.dart';
import 'package:belcka/pages/conflicts/view/widgets/conflicts_header_view.dart';
import 'package:belcka/pages/conflicts/view/widgets/conflicts_list_view.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ConflictsScreen extends StatefulWidget {
  const ConflictsScreen({super.key});

  @override
  State<ConflictsScreen> createState() => _ConflictsScreenState();
}

class _ConflictsScreenState extends State<ConflictsScreen>
    implements DateFilterListener {
  final controller = Get.put(ConflictsController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor(
        bottomNavigationBarColor: backgroundColor_(context));
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
              title: 'conflicts'.tr,
              isCenterTitle: false,
              isBack: true,
              bgColor: backgroundColor_(context),
              widgets: actionButtons(),
              isSearching: controller.isSearchEnable.value,
              searchController: controller.searchController,
              onValueChange: controller.applySearch,
              onPressedClear: () {
                controller.clearSearch();
                controller.isSearchEnable.value = false;
              },
            ),
            body: ModalProgressHUD(
              inAsyncCall: controller.isLoading.value,
              opacity: 0,
              progressIndicator: const CustomProgressbar(),
              child: controller.isInternetNotAvailable.value
                  ? NoInternetWidget(
                      onPressed: () {
                        controller.isInternetNotAvailable.value = false;
                        controller.loadData(true);
                      },
                    )
                  : controller.isMainViewVisible.value
                      ? Column(
                          children: [
                            // const SizedBox(height: 8),
                            const ConflictsHeaderView(),
                            const SizedBox(height: 12),
                            DateFilterOptionsHorizontalList(
                              padding: const EdgeInsets.fromLTRB(14, 0, 14, 6),
                              startDate: controller.startDate,
                              endDate: controller.endDate,
                              listener: this,
                              selectedPosition:
                                  controller.selectedDateFilterIndex,
                            ),
                            const SizedBox(height: 8),
                            Expanded(child: ConflictsListView()),
                          ],
                        )
                      : const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget>? actionButtons() {
    return [
      if (!controller.isSearchEnable.value)
        InkWell(
          onTap: () {
            controller.isSearchEnable.value = true;
          },
          customBorder: const CircleBorder(),
          child: Padding(
            padding: EdgeInsets.all(6),
            child: ImageUtils.setSvgAssetsImage(
                path: Drawable.searchIcon, width: 24, height: 24),
          ),
        ),
      SizedBox(
        width: 14,
      )
    ];
  }

  @override
  void onSelectDateFilter(int filterIndex, String filter, String startDate,
      String endDate, String dialogIdentifier) {
    controller.startDate = startDate;
    controller.endDate = endDate;
    if (StringHelper.isEmptyString(startDate) &&
        StringHelper.isEmptyString(endDate)) {
      controller.selectedDateFilterIndex.value = -1;
    }
    controller.loadData(true);
  }
}
