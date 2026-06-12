import 'package:belcka/pages/common/widgets/date_filter_options_horizontal_list.dart';
import 'package:belcka/pages/workshop/workshop_teams/controller/workshop_teams_controller.dart';
import 'package:belcka/pages/workshop/workshop_teams/view/widgets/workshop_teams_list_item.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class WorkshopTeamsScreen extends StatefulWidget {
  const WorkshopTeamsScreen({super.key});

  @override
  State<WorkshopTeamsScreen> createState() => _WorkshopTeamsScreenState();
}

class _WorkshopTeamsScreenState extends State<WorkshopTeamsScreen> {
  final controller = Get.put(WorkshopTeamsController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop || result != null) return;
        controller.onBackPress();
      },
      child: Obx(
        () => Container(
          color: dashBoardBgColor_(context),
          child: SafeArea(
            top: false,
            bottom: !GetPlatform.isIOS,
            child: Scaffold(
              backgroundColor: dashBoardBgColor_(context),
              appBar: BaseAppBar(
                appBar: AppBar(),
                title: 'team'.tr,
                isCenterTitle: false,
                isBack: true,
                onBackPressed: controller.onBackPress,
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
                elevation: 5,
                shadowColor: shadowColor_(context).withValues(alpha: 0.28),
                surfaceTintColor: Colors.transparent,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(18),
                    bottomRight: Radius.circular(18),
                  ),
                ),
              ),
              body: ModalProgressHUD(
                inAsyncCall: controller.isLoading.value,
                opacity: 0,
                progressIndicator: const CustomProgressbar(),
                child: controller.isInternetNotAvailable.value
                    ? NoInternetWidget(
                        onPressed: () {
                          controller.isInternetNotAvailable.value = false;
                          controller.getTeamMemberListApi(isRefresh: true);
                        },
                      )
                    : Visibility(
                        visible: controller.isMainViewVisible.value,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 12),
                            DateFilterOptionsHorizontalList(
                              padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                              startDate: controller.startDate.value,
                              endDate: controller.endDate.value,
                              listener: controller,
                              selectedPosition:
                                  controller.selectedDateFilterIndex,
                            ),
                            _teamFilter(context),
                            Expanded(child: _usersList(context)),
                          ],
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
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
      Visibility(
        visible: !controller.isSearchEnable.value,
        child: const SizedBox(width: 4),
      ),
      Visibility(
        visible: !controller.isSearchEnable.value,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: controller.moveToRemoveMemberScreen,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Icon(
              Icons.delete_outline,
              color: primaryTextColor_(context),
              size: 24,
            ),
          ),
        ),
      ),
      Visibility(
        visible: !controller.isSearchEnable.value,
        child: const SizedBox(width: 4),
      ),
      Visibility(
        visible: !controller.isSearchEnable.value,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: controller.moveToAddMemberScreen,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Icon(
              Icons.add,
              color: primaryTextColor_(context),
              size: 24,
            ),
          ),
        ),
      ),
      const SizedBox(width: 8),
    ];
  }

  Widget _teamFilter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
      child: Row(
        children: [
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(45),
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  controller.showFilterTeamBottomSheet();
                },
                child: Container(
                  height: 46,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(45),
                    border: Border.all(
                      color: const Color(0xffcccccc),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Obx(
                          () => Text(
                            controller.selectedTeamFilterName.value,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: primaryTextColor_(context),
                            ),
                          ),
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: hintColor_(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Obx(
            () => Text(
              '${controller.getDisplayWorkingMemberCount()}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: defaultAccentColor_(context),
              ),
            ),
          ),
          Obx(
            () => Text(
              '/${controller.getDisplayTeamMemberCount()} ${'working'.tr}',
              style: TextStyle(
                fontSize: 14,
                color: secondaryTextColor_(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _usersList(BuildContext context) {
    return Obx(() {
      final users = controller.buildDisplayUsers();
      if (users.isEmpty) {
        return Center(
          child: TitleTextView(text: 'empty_data_message'.tr),
        );
      }

      return ListView.separated(
        padding: const EdgeInsets.only(bottom: 16, top: 12),
        physics: const ClampingScrollPhysics(),
        controller: controller.scrollController,
        itemBuilder: (context, index) => WorkshopTeamsListItem(
          info: users[index],
          onTap: () => controller.moveToUserChecklogs(users[index]),
        ),
        separatorBuilder: (_, __) => const SizedBox(height: 6),
        itemCount: users.length,
      );
    });
  }
}
