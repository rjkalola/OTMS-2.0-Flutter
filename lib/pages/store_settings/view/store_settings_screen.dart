import 'package:belcka/pages/store_settings/controller/store_settings_controller.dart';
import 'package:belcka/pages/store_settings/model/team_member_list_response.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:belcka/widgets/switch/custom_switch.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class StoreSettingsScreen extends StatefulWidget {
  const StoreSettingsScreen({super.key});

  @override
  State<StoreSettingsScreen> createState() => _StoreSettingsScreenState();
}

class _StoreSettingsScreenState extends State<StoreSettingsScreen> {
  final controller = Get.put(StoreSettingsController());

  List<Widget>? _appBarActions() {
    return [
      const SizedBox(width: 6),
      Obx(
        () => Visibility(
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
              ),
            ),
          ),
        ),
      ),
      const SizedBox(width: 6),
    ];
  }

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
        () {
          controller.isSearchEnable.value;
          return Container(
            color: backgroundColor_(context),
            child: SafeArea(
              child: Scaffold(
                backgroundColor: backgroundColor_(context),
                appBar: BaseAppBar(
                  appBar: AppBar(),
                  title: 'store_setting'.tr,
                  isCenterTitle: false,
                  isBack: true,
                  onBackPressed: () {
                    controller.onBackPress();
                  },
                  widgets: _appBarActions(),
                  isSearching: controller.isSearchEnable.value,
                  searchController: controller.searchController,
                  searchHint: 'search_users'.tr,
                  onValueChange: (value) {
                    controller.onSearchChanged(value);
                  },
                  autoFocus: true,
                  onPressedClear: () {
                    controller.clearSearch();
                    controller.isSearchEnable.value = false;
                  },
                ),
                bottomNavigationBar: controller.isMainViewVisible.value
                    ? SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                          child: Opacity(
                            opacity:
                                controller.isDataUpdated.value ? 1 : 0.45,
                            child: PrimaryButton(
                              isFixSize: true,
                              buttonText: 'update'.tr,
                              onPressed: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                if (controller.isDataUpdated.value) {
                                  controller.changeBulkUserStoreStatusApi();
                                }
                              },
                            ),
                          ),
                        ),
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
                            controller.getTeamMemberListApi();
                          },
                        )
                      : Visibility(
                          visible: controller.isMainViewVisible.value,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Divider(height: 1),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    16, 12, 16, 8),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'filter_team'.tr,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: secondaryTextColor_(context),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Obx(
                                      () => Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(45),
                                          onTap: () {
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                            controller
                                                .showFilterTeamBottomSheet();
                                          },
                                          child: Container(
                                            height: 46,
                                            padding: const EdgeInsets
                                                .symmetric(horizontal: 16),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(45),
                                              border: Border.all(
                                                color:
                                                    const Color(0xffcccccc),
                                                width: 1,
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    controller
                                                        .selectedTeamFilterName
                                                        .value,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: primaryTextColor_(
                                                          context),
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
                                  ],
                                ),
                              ),
                              Expanded(child: _buildTeamUserList(context)),
                            ],
                          ),
                        ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTeamUserList(BuildContext context) {
    return Obx(() {
      final slices = controller.buildDisplaySlices();
      if (slices.isEmpty) {
        return Center(
          child: Text(
            'no_data_found'.tr,
            style: TextStyle(color: secondaryTextColor_(context)),
          ),
        );
      }
      final children = <Widget>[];
      for (final slice in slices) {
        children.add(Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _teamHeader(context, slice),
        ));
        for (final u in slice.visibleUsers) {
          children.add(Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: _userRow(context, u),
          ));
        }
      }
      return ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        physics: const ClampingScrollPhysics(),
        children: children,
      );
    });
  }

  Widget _teamHeader(BuildContext context, DisplayTeamSlice slice) {
    final team = slice.team;
    final visible = slice.visibleUsers;
    final allOn = controller.teamSwitchAllOn(visible);
    final count = team.teamMemberCount ?? (team.users?.length ?? 0);
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE8F4FC),
        borderRadius: BorderRadius.circular(8),
        border: const Border(
          left: BorderSide(color: Color(0xFF1976D2), width: 4),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    team.name ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1565C0),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$count ${'users'.tr}',
                    style: TextStyle(
                      fontSize: 12,
                      color: secondaryTextColor_(context),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          CustomSwitch(
            mValue: allOn,
            onValueChange: (value) {
              controller.onTeamToggle(team, visible, value);
            },
          ),
        ],
      ),
    );
  }

  Widget _userRow(BuildContext context, TeamMemberUserInfo u) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor_(context),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: dividerColor_(context)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      AppUtils.onClickUserAvatar(u.id ?? 0);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(45),
                        border: Border.all(
                          width: 2,
                          color: const Color(0xff1E1E1E),
                        ),
                      ),
                      child: ImageUtils.setUserImage(
                        url: u.image ?? "",
                        width: 40,
                        height: 40,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      u.name ?? "",
                      style: TextStyle(
                        fontSize: 17,
                        color: primaryTextColor_(context),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            CustomSwitch(
              mValue: u.isShowStore == true,
              onValueChange: (value) {
                controller.onUserToggle(u, value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
