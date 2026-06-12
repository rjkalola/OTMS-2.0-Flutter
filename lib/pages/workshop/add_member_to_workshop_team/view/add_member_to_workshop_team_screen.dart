import 'package:belcka/pages/workshop/add_member_to_workshop_team/controller/add_member_to_workshop_team_controller.dart';
import 'package:belcka/pages/workshop/add_member_to_workshop_team/view/widgets/add_member_to_workshop_team_item.dart';
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

class AddMemberToWorkshopTeamScreen extends StatefulWidget {
  const AddMemberToWorkshopTeamScreen({super.key});

  @override
  State<AddMemberToWorkshopTeamScreen> createState() =>
      _AddMemberToWorkshopTeamScreenState();
}

class _AddMemberToWorkshopTeamScreenState
    extends State<AddMemberToWorkshopTeamScreen> {
  final controller = Get.put(AddMemberToWorkshopTeamController());

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
                title: 'Add to Team',
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
            bottomNavigationBar: controller.isMainViewVisible.value
                ? SafeArea(
                    child: _bottomActionBar(context),
                  )
                : null,
            body: ModalProgressHUD(
              inAsyncCall: controller.isLoading.value,
              opacity: 0,
              progressIndicator: const CustomProgressbar(),
              child: controller.isInternetNotAvailable.value
                  ? NoInternetWidget(
                      onPressed: () {
                        controller.isInternetNotAvailable.value = false;
                        controller.getInitialData();
                      },
                    )
                  : Visibility(
                      visible: controller.isMainViewVisible.value,
                      child: Column(
                        children: [
                          const SizedBox(height: 14),
                          _teamDropdown(context),
                          const SizedBox(height: 28),
                          Expanded(child: _usersList()),
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
      const SizedBox(width: 8),
    ];
  }

  Widget _teamDropdown(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(45),
          onTap: controller.showTeamDropdown,
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
                      controller.selectedTeamName.value,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: primaryTextColor_(context),
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
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
    );
  }

  Widget _usersList() {
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
        itemBuilder: (context, index) {
          final item = users[index];
          return AddMemberToWorkshopTeamItem(
            info: item,
            onTap: () => controller.toggleUser(item),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(height: 0),
        itemCount: users.length,
      );
    });
  }

  Widget _bottomActionBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      padding: const EdgeInsets.fromLTRB(16, 10, 8, 10),
      decoration: BoxDecoration(
        color: backgroundColor_(context),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: shadowColor_(context).withValues(alpha: 0.16),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Obx(
            () => Text(
              '${controller.selectedUsersCount()}',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: primaryTextColor_(context),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Text(
            'selected'.tr,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: secondaryTextColor_(context),
            ),
          ),
          const Spacer(),
          Obx(() {
            final enabled = controller.selectedUsersCount() > 0;
            return ElevatedButton.icon(
              onPressed: enabled ? controller.addSelectedUsersToTeam : null,
              icon: const Icon(Icons.group_add_outlined, size: 18),
              label: const Text('Add to my team'),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: enabled
                    ? Colors.green
                    : Colors.green.withValues(alpha: 0.25),
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.green.withValues(alpha: 0.25),
                disabledForegroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
