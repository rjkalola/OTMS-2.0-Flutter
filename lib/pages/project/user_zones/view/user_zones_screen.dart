import 'package:belcka/pages/project/user_zones/controller/user_zones_controller.dart';
import 'package:belcka/pages/project/user_zones/model/user_location_models.dart';
import 'package:belcka/pages/project/user_zones/model/zone_group_models.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/res/theme/theme_config.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/PrimaryBorderButton.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:belcka/widgets/map_view/custom_map_view.dart';
import 'package:belcka/widgets/other_widgets/user_avtar_view.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:belcka/widgets/textfield/search_text_field_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class UserZonesScreen extends StatefulWidget {
  const UserZonesScreen({super.key});

  @override
  State<UserZonesScreen> createState() => _UserZonesScreenState();
}

class _UserZonesScreenState extends State<UserZonesScreen> {
  final controller = Get.put(UserZonesController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return Container(
      color: backgroundColor_(context),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: backgroundColor_(context),
          body: Obx(
            () => ModalProgressHUD(
              inAsyncCall: controller.isLoading.value,
              opacity: 0,
              progressIndicator: const CustomProgressbar(),
              child: controller.isInternetNotAvailable.value
                  ? NoInternetWidget(
                      onPressed: () {
                        controller.isInternetNotAvailable.value = false;
                        controller.loadData();
                      },
                    )
                  : Visibility(
                      visible: controller.isMainViewVisible.value,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: CustomMapView(
                              key: const ValueKey<String>('user_zones_map'),
                              onMapCreated: controller.onMapCreated,
                              target: controller.center,
                              markers: controller.markers,
                              circles: controller.circles,
                              polygons: controller.polygons,
                              polylines: controller.polyLines,
                              mapType: controller.mapType,
                            ),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            top: 0,
                            child: headerView(context),
                          ),
                          Positioned(
                            top: 92,
                            right: 10,
                            child: Column(
                              children: [
                                _roundIconButton(
                                  context,
                                  icon: Icons.refresh,
                                  onTap: controller.loadData,
                                ),
                                const SizedBox(height: 8),
                                _roundIconButton(
                                  context,
                                  icon: Icons.my_location,
                                  onTap: controller.moveToCurrentLocation,
                                ),
                              ],
                            ),
                          ),
                          _sidePanelScrim(context),
                          _sidePanel(context),
                        ],
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  double _panelWidth(BuildContext context) =>
      MediaQuery.sizeOf(context).width > 900 ? 420.0 : 360.0;

  Widget _sidePanelScrim(BuildContext context) {
    final panelW = _panelWidth(context);
    return Positioned(
      left: 0,
      top: 0,
      bottom: 0,
      right: panelW,
      child: Offstage(
        offstage: !controller.isPanelScrimVisible.value,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: controller.closePanel,
          child: Container(
            color: Colors.black.withValues(alpha: 0.45),
          ),
        ),
      ),
    );
  }

  Widget headerView(BuildContext context) {
    return Container(
      color: backgroundColor_(context),
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_outlined,
              size: 20,
              color: primaryTextColor_(context),
            ),
            onPressed: () {
              Get.back();
            },
          ),
          const Spacer(),
          // ImageUtils.setSvgAssetsImage(
          //     path: Drawable.filterIcon,
          //     width: 26,
          //     height: 26,
          //     color: primaryTextColor_(Get.context!)),
          _countChip(
            context,
            icon: ImageUtils.setSvgAssetsImage(
                path: Drawable.mapPinIcon,
                width: 18,
                height: 18,
                color: primaryTextColor_(context)),
            text:
                "${controller.visibleZonesCount}/${controller.totalZonesCount}",
            onTap: controller.openZonesPanel,
          ),
          const SizedBox(width: 8),
          _countChip(
            context,
            icon: ImageUtils.setSvgAssetsImage(
                path: Drawable.userGroupIcon,
                width: 18,
                height: 18,
                color: primaryTextColor_(context)),
            text:
                "${controller.visibleUsersCount}/${controller.totalUsersCount}",
            onTap: controller.openStaffPanel,
          ),
        ],
      ),
    );
  }

  Widget _countChip(BuildContext context,
      {required Widget icon,
      required String text,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        decoration: BoxDecoration(
          border:
              Border.all(color: secondaryLightTextColor_(context), width: 0.6),
          borderRadius: BorderRadius.circular(8),
          color: backgroundColor_(context),
        ),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 6),
            Text(
              text,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: defaultAccentColor_(context)),
            ),
            SizedBox(
              width: 2,
            ),
            const Icon(Icons.keyboard_arrow_down, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _roundIconButton(BuildContext context,
      {required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: backgroundColor_(context),
          shape: BoxShape.circle,
          border: Border.all(color: dividerColor_(context)),
        ),
        child: Icon(icon, size: 20),
      ),
    );
  }

  Widget _sidePanel(BuildContext context) {
    final panelWidth = _panelWidth(context);
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOut,
      top: 0,
      bottom: 0,
      right: controller.isPanelOpen.value ? 0 : -panelWidth,
      child: Container(
        width: panelWidth,
        color: backgroundColor_(context),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row(
            //   children: [
            //     Expanded(
            //       child: Text(
            //         controller.isZonesPanel.value ? "ZONES" : "STAFF ON SITE",
            //         style: const TextStyle(
            //             fontSize: 17, fontWeight: FontWeight.w600),
            //       ),
            //     ),
            //     IconButton(
            //       onPressed: controller.togglePanel,
            //       icon: const Icon(Icons.close),
            //     ),
            //   ],
            // ),
            // const SizedBox(height: 8),
            SearchTextFieldAppBar(
              controller: controller.searchController,
              isClearVisible: controller.isSearchClearVisible,
              hint: controller.isZonesPanel.value
                  ? 'search_zone'.tr
                  : 'search_user_trade'.tr,
              onValueChange: controller.onSearchTextChanged,
              onPressedClear: controller.clearSearchField,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: controller.isZonesPanel.value
                    ? controller.filteredZoneGroups.length
                    : controller.filteredGroups.length,
                itemBuilder: (context, index) {
                  if (controller.isZonesPanel.value) {
                    final zoneInfo = controller.filteredZoneGroups[index];
                    return zoneList(context, zoneInfo);
                  }
                  final userInfo = controller.filteredGroups[index];
                  return userList(context, userInfo);
                },
              ),
            ),
            PrimaryBorderButton(
                height: 40,
                borderColor: secondaryExtraLightTextColor_(context),
                fontColor: secondaryTextColor_(context),
                fontWeight: FontWeight.w400,
                fontSize: 15,
                buttonText: 'close'.tr,
                onPressed: () => controller.togglePanel())
            // SizedBox(
            //   width: double.infinity,
            //   child: OutlinedButton(
            //     onPressed: () => controller.togglePanel(),
            //     child: Text('close'.tr),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget userList(BuildContext context, TeamUsersGroup group) {
    return CardViewDashboardItem(
      boxColor: ThemeConfig.isDarkMode
          ? dashBoardBgColor_(context)
          : backgroundColor_(context),
      borderRadius: 10,
      margin: const EdgeInsets.only(bottom: 6, top: 6),
      child: ExpansionTile(
        initiallyExpanded: true,
        shape: Border(),
        collapsedShape: Border(),
        tilePadding: const EdgeInsets.symmetric(horizontal: 12),
        childrenPadding: const EdgeInsets.only(bottom: 14),
        title: Text(
          group.name ?? "",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontWeight: FontWeight.w600, color: primaryTextColor_(context)),
        ),
        children: [
          for (int i = 0; i < group.users.length; i++) ...[
            if (i > 0)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                child: Divider(color: dividerColor_(context)),
              ),
            userListItem(context, group.users[i]),
          ],
        ],
      ),
    );
  }

  Widget userListItem(BuildContext context, UserLocationInfo user) {
    final id = user.id ?? 0;
    final visible = controller.userVisibility[id] ?? true;
    final name = (user.userName ?? "").trim();
    final trade = (user.tradeName ?? "").trim();
    final lastSeen = (user.lastSeen ?? "").trim();
    return InkWell(
      onTap: () {
        controller.focusUser(user);
        controller.closePanel();
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // IconButton(
            //   visualDensity: VisualDensity.compact,
            //   icon:
            //       Icon(visible ? Icons.visibility : Icons.visibility_off, size: 20),
            //   onPressed: () => controller.toggleUserVisibility(id),
            // ),
            UserAvtarView(
              imageUrl: user.userThumbImage ?? "",
              imageSize: 38,
              isOnlineStatusVisible: true,
              onlineStatusColor:
                  (user.isWorking ?? false) ? Colors.green : Colors.redAccent,
              onlineStatusSize: 8,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (name.isNotEmpty)
                    PrimaryTextView(
                      text: name,
                      maxLine: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (trade.isNotEmpty)
                    PrimaryTextView(
                      text: trade,
                      maxLine: 1,
                      overflow: TextOverflow.ellipsis,
                      color: secondaryLightTextColor_(context),
                      fontSize: 12,
                    ),
                  if (lastSeen.isNotEmpty)
                    PrimaryTextView(
                      text: lastSeen,
                      maxLine: 1,
                      overflow: TextOverflow.ellipsis,
                      color: secondaryLightTextColor_(context),
                      fontSize: 11,
                    ),
                ],
              ),
            ),
            // Text(
            //   (user.isWorking ?? false) ? "Working" : "Not Working",
            //   style: TextStyle(
            //     fontSize: 12,
            //     color: (user.isWorking ?? false)
            //         ? const Color(0xff2E7D32)
            //         : Colors.pinkAccent,
            //     fontWeight: FontWeight.w600,
            //   ),
            // ),
            // IconButton(
            //   visualDensity: VisualDensity.compact,
            //   icon: const Icon(Icons.my_location, size: 20),
            //   onPressed: () => controller.focusUser(user),
            // ),
          ],
        ),
      ),
    );
  }

  Widget zoneList(BuildContext context, UserZoneGroupInfo group) {
    final zones = group.zones ?? <UserZoneInfo>[];
    return CardViewDashboardItem(
      boxColor: ThemeConfig.isDarkMode
          ? dashBoardBgColor_(context)
          : backgroundColor_(context),
      borderRadius: 10,
      margin: const EdgeInsets.only(bottom: 6, top: 6),
      child: ExpansionTile(
        initiallyExpanded: true,
        shape: Border(),
        collapsedShape: Border(),
        tilePadding: const EdgeInsets.symmetric(horizontal: 12),
        childrenPadding: const EdgeInsets.only(bottom: 14),
        title: Row(
          children: [
            // const Icon(Icons.visibility_outlined, size: 18),
            // const SizedBox(width: 8),
            // const Icon(Icons.edit_outlined, size: 18),
            // const SizedBox(width: 8),
            Expanded(
              child: Text(
                group.name ?? "",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: primaryTextColor_(context)),
              ),
            ),
          ],
        ),
        children: [
          for (int i = 0; i < zones.length; i++) ...[
            if (i > 0)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                child: Divider(color: dividerColor_(context)),
              ),
            zoneListItem(context, zones[i]),
          ],
        ],
      ),
    );
  }

  Widget zoneListItem(BuildContext context, UserZoneInfo zone) {
    final id = zone.id ?? 0;
    final visible = controller.zoneVisibility[id] ?? true;
    final zoneName = (zone.name ?? "").trim();
    final projectName = (zone.projectName ?? "").trim();
    return InkWell(
      onTap: () {
        controller.focusZone(zone);
        controller.closePanel();
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
        child: Row(
          children: [
            IconButton(
              visualDensity: VisualDensity.compact,
              icon: Icon(
                  visible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 20),
              onPressed: () => controller.toggleZoneVisibility(id),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (zoneName.isNotEmpty)
                    PrimaryTextView(
                      text: zoneName,
                    ),
                  if (projectName.isNotEmpty)
                    PrimaryTextView(
                      text: projectName,
                      maxLine: 1,
                      overflow: TextOverflow.ellipsis,
                      color: secondaryExtraLightTextColor_(context),
                      fontSize: 12,
                    ),
                ],
              ),
            ),
            // IconButton(
            //   visualDensity: VisualDensity.compact,
            //   icon: const Icon(Icons.my_location_outlined, size: 20),
            //   onPressed: () => controller.focusZone(zone),
            // ),
          ],
        ),
      ),
    );
  }
}
