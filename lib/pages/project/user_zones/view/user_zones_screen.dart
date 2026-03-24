import 'package:belcka/pages/project/user_zones/controller/user_zones_controller.dart';
import 'package:belcka/pages/project/user_zones/model/user_location_models.dart';
import 'package:belcka/pages/project/user_zones/model/zone_group_models.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:belcka/widgets/map_view/custom_map_view.dart';
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
      color: dashBoardBgColor_(context),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: dashBoardBgColor_(context),
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
                            child: _topBar(context),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            top: 64,
                            child: Center(
                              child: Text(
                                "Select Date",
                                style: TextStyle(
                                    color: primaryTextColor_(context),
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
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
                          Positioned(
                            top: 100,
                            left: 12,
                            child: _mapTypeToggle(context),
                          ),
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

  Widget _topBar(BuildContext context) {
    return Container(
      color: backgroundColor_(context),
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.filter_alt_outlined),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit_outlined),
          ),
          const SizedBox(width: 4),
          _countChip(
            context,
            icon: Icons.location_on_outlined,
            text:
                "${controller.visibleZonesCount}/${controller.totalZonesCount}",
            onTap: controller.openZonesPanel,
          ),
          const SizedBox(width: 8),
          _countChip(
            context,
            icon: Icons.group_outlined,
            text:
                "${controller.visibleUsersCount}/${controller.totalUsersCount}",
            onTap: controller.openStaffPanel,
          ),
        ],
      ),
    );
  }

  Widget _countChip(BuildContext context,
      {required IconData icon,
      required String text,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: dividerColor_(context)),
          borderRadius: BorderRadius.circular(8),
          color: backgroundColor_(context),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: secondaryLightTextColor_(context)),
            const SizedBox(width: 6),
            Text(
              text,
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: defaultAccentColor_(context)),
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

  Widget _mapTypeToggle(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor_(context),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: dividerColor_(context)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _mapTypeButton(
            context,
            "Map",
            selected: controller.mapType.value == MapType.normal,
            onTap: controller.setMapTypeNormal,
          ),
          _mapTypeButton(
            context,
            "Satellite",
            selected: controller.mapType.value == MapType.satellite,
            onTap: controller.setMapTypeSatellite,
          ),
        ],
      ),
    );
  }

  Widget _mapTypeButton(BuildContext context, String title,
      {required bool selected, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? lightGreyColor(context) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(title),
      ),
    );
  }

  Widget _sidePanel(BuildContext context) {
    final panelWidth = MediaQuery.of(context).size.width > 900 ? 420.0 : 360.0;
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOut,
      top: 0,
      bottom: 0,
      right: controller.isPanelOpen.value ? 0 : -panelWidth,
      child: Container(
        width: panelWidth,
        color: backgroundColor_(context),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    controller.isZonesPanel.value ? "ZONES" : "STAFF ON SITE",
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                ),
                IconButton(
                  onPressed: controller.togglePanel,
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller.searchController.value,
              onChanged: controller.filterGroups,
              decoration: InputDecoration(
                hintText: controller.isZonesPanel.value
                    ? "Search Zone"
                    : "Search User/Trade",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: lightGreyColor(context),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: controller.isZonesPanel.value
                    ? controller.filteredZoneGroups.length
                    : controller.filteredGroups.length,
                itemBuilder: (context, index) {
                  if (controller.isZonesPanel.value) {
                    final group = controller.filteredZoneGroups[index];
                    return _zoneGroupCard(context, group);
                  }
                  final group = controller.filteredGroups[index];
                  return _groupCard(context, group);
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => controller.togglePanel(),
                child: Text('close'.tr),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _groupCard(BuildContext context, TeamUsersGroup group) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: dividerColor_(context)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 12),
        childrenPadding: const EdgeInsets.only(bottom: 8),
        title: Text(group.name, style: const TextStyle(fontWeight: FontWeight.w600)),
        children: group.users
            .map((z) => _userRow(context, z))
            .toList(),
      ),
    );
  }

  Widget _userRow(BuildContext context, UserLocationInfo user) {
    final id = user.id ?? 0;
    final visible = controller.userVisibility[id] ?? true;
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 4, 10, 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: dividerColor_(context)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: Icon(visible ? Icons.visibility : Icons.visibility_off,
                size: 20),
            onPressed: () => controller.toggleUserVisibility(id),
          ),
          CircleAvatar(
            radius: 19,
            backgroundColor: lightGreyColor(context),
            backgroundImage: (user.userThumbImage ?? "").isNotEmpty
                ? NetworkImage(user.userThumbImage!)
                : null,
            child: (user.userThumbImage ?? "").isEmpty
                ? Text(
                    (user.userName ?? "U").isNotEmpty
                        ? user.userName![0].toUpperCase()
                        : "U",
                  )
                : null,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.userName ?? "",
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(
                  user.tradeName ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: secondaryLightTextColor_(context), fontSize: 12),
                ),
                const SizedBox(height: 2),
                Text(
                  user.lastSeen ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: secondaryLightTextColor_(context), fontSize: 11),
                ),
              ],
            ),
          ),
          Text(
            (user.isWorking ?? false) ? "Working" : "Not Working",
            style: TextStyle(
              fontSize: 12,
              color: (user.isWorking ?? false)
                  ? const Color(0xff2E7D32)
                  : Colors.pinkAccent,
              fontWeight: FontWeight.w600,
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.my_location, size: 20),
            onPressed: () => controller.focusUser(user),
          ),
        ],
      ),
    );
  }

  Widget _zoneGroupCard(BuildContext context, UserZoneGroupInfo group) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: dividerColor_(context)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 12),
        childrenPadding: const EdgeInsets.only(bottom: 8),
        title: Row(
          children: [
            const Icon(Icons.visibility_outlined, size: 18),
            const SizedBox(width: 8),
            const Icon(Icons.edit_outlined, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                group.name ?? "",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        children: (group.zones ?? <UserZoneInfo>[])
            .map((z) => _zoneRow(context, z))
            .toList(),
      ),
    );
  }

  Widget _zoneRow(BuildContext context, UserZoneInfo zone) {
    final id = zone.id ?? 0;
    final visible = controller.zoneVisibility[id] ?? true;
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 4, 10, 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: dividerColor_(context)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: Icon(visible ? Icons.visibility : Icons.visibility_off,
                size: 20),
            onPressed: () => controller.toggleZoneVisibility(id),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(zone.name ?? "",
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(
                  zone.projectName ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: secondaryLightTextColor_(context), fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.my_location, size: 20),
            onPressed: () => controller.focusZone(zone),
          ),
        ],
      ),
    );
  }
}
