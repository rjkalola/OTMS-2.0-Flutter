import 'package:belcka/pages/workshop/team_member_list/controller/team_member_list_controller.dart';
import 'package:belcka/pages/workshop/team_member_list/view/widgets/team_member_list_item.dart';
import 'package:belcka/pages/common/widgets/date_filter_options_horizontal_list.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class TeamMemberListScreen extends StatefulWidget {
  const TeamMemberListScreen({super.key});

  @override
  State<TeamMemberListScreen> createState() => _TeamMemberListScreenState();
}

class _TeamMemberListScreenState extends State<TeamMemberListScreen> {
  final controller = Get.put(TeamMemberListController());

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
                widgets: _appBarActions(),
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
                          controller.getTeamMemberListApi();
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

  List<Widget>? _appBarActions() {
    return [
      InkWell(
        customBorder: const CircleBorder(),
        onTap: controller.moveToCreateTeamScreen,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(
            Icons.add,
            color: primaryTextColor_(context),
            size: 30,
          ),
        ),
      ),
      const SizedBox(width: 4),
      InkWell(
        customBorder: const CircleBorder(),
        onTap: controller.moveToTeamListScreen,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(
            Icons.more_vert,
            color: primaryTextColor_(context),
            size: 26,
          ),
        ),
      ),
      const SizedBox(width: 8),
    ];
  }

  Widget _teamFilter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(45),
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
          controller.showFilterTeamBottomSheet();
        },
        child: Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Expanded(
                child: Obx(
                  () => Text(
                    '${controller.selectedTeamFilterName.value} Team Filter',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: secondaryTextColor_(context),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Obx(
                () => Text(
                  '${controller.buildDisplayUsers().length}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: defaultAccentColor_(context),
                  ),
                ),
              ),
              Text(
                '/${_totalUsers()} ${'working'.tr}',
                style: TextStyle(
                  fontSize: 14,
                  color: secondaryTextColor_(context),
                ),
              ),
            ],
          ),
        ),
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
        padding: const EdgeInsets.only(bottom: 16),
        physics: const ClampingScrollPhysics(),
        itemBuilder: (context, index) => TeamMemberListItem(info: users[index]),
        separatorBuilder: (_, __) => const SizedBox(height: 0),
        itemCount: users.length,
      );
    });
  }

  int _totalUsers() {
    int total = 0;
    for (final team in controller.teams) {
      total += team.users?.length ?? 0;
    }
    return total;
  }
}
