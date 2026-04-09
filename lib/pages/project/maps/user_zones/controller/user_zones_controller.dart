import 'dart:async';
import 'dart:convert';

import 'package:belcka/pages/project/maps/user_zones/controller/user_zones_repository.dart';
import 'package:belcka/pages/project/maps/user_zones/model/user_location_models.dart';
import 'package:belcka/pages/project/maps/user_zones/model/zone_group_models.dart';
import 'package:belcka/pages/project/project_info/model/geofence_info.dart';
import 'package:belcka/utils/AlertDialogHelper.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/location_service_new.dart';
import 'package:belcka/pages/project/maps/user_zones/utils/team_user_marker_bitmap.dart';
import 'package:belcka/pages/project/maps/user_zones/utils/zone_label_marker_bitmap.dart';
import 'package:belcka/pages/common/menu_items_list_bottom_dialog.dart';
import 'package:belcka/pages/common/listener/DialogButtonClickListener.dart';
import 'package:belcka/pages/common/listener/menu_item_listener.dart';
import 'package:belcka/pages/common/listener/select_date_listener.dart';
import 'package:belcka/pages/common/listener/select_time_listener.dart';
import 'package:belcka/pages/project/maps/user_zones/view/widgets/user_zones_user_bottom_sheet.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/date_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserZonesController extends GetxController
    implements
        MenuItemListener,
        DialogButtonClickListener,
        SelectDateListener,
        SelectTimeListener {
  final _api = UserZonesRepository();
  final locationService = LocationServiceNew();

  RxBool isLoading = false.obs,
      isMainViewVisible = false.obs,
      isInternetNotAvailable = false.obs,
      isPanelOpen = false.obs,
      isZonesPanel = false.obs,
      isPanelScrimVisible = false.obs;

  final searchController = TextEditingController().obs;
  final isSearchClearVisible = false.obs;

  final center = LatLng(51.5072, -0.1276).obs;
  final mapType = MapType.normal.obs;
  final markers = <Marker>{}.obs;
  final circles = <Circle>{}.obs;
  final polygons = <Polygon>{}.obs;
  final polyLines = <Polyline>{}.obs;

  /// Bumped in [_renderOverlays] so [CustomMapView] rebuilds when overlay *content*
  /// changes but set sizes stay the same (e.g. after zone create/edit).
  final mapOverlayRevision = 0.obs;

  final allUsers = <UserLocationInfo>[].obs;
  final teamGroups = <TeamUsersGroup>[].obs;
  final filteredGroups = <TeamUsersGroup>[].obs;
  final userVisibility = <int, bool>{}.obs;
  final zoneGroups = <UserZoneGroupInfo>[].obs;
  final filteredZoneGroups = <UserZoneGroupInfo>[].obs;
  final zoneVisibility = <int, bool>{}.obs;

  GoogleMapController? mapController;
  final Map<String, BitmapDescriptor> _teamUserMarkerIconCache = {};
  final Set<String> _teamUserMarkerIconBuilding = {};
  final Map<String, BitmapDescriptor> _zoneMarkerIconCache = {};
  final Set<String> _zoneMarkerIconBuilding = {};

  GeofenceInfo? _zonePendingDelete;

  /// Filter screen selections (query keys/values for zone APIs — extend when backend is ready).
  Map<String, String> appliedFilters = {};
  final filterItemsList = <ModuleInfo>[].obs;

  /// Map filter: `datetime` query value formatted `dd/MM/yyyy HH:mm` (e.g. 11/04/2026 11:18).
  DateTime? zoneFilterDateTime;
  DateTime? _pendingZoneFilterDate;
  static const String _zoneFilterDateId = 'USER_ZONE_FILTER_DATE';
  static const String _zoneFilterTimeId = 'USER_ZONE_FILTER_TIME';

  /// Purchasing-style range line; when only one moment is selected, [displayEndDate] matches [displayStartDate].
  final displayStartDate = ''.obs;
  final displayEndDate = ''.obs;

  // Timer? _refreshTimer;
  Timer? _panelScrimTimer;

  static const String _zoneMenuActionAddByShape = 'zone_add_by_shape';
  static const String _zoneMenuActionAddByPostCode = 'zone_add_by_post_code';

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  /// Add / edit / delete zones and map taps that open the editor — admin only.
  bool get canManageZones => UserUtils.isAdmin();

  @override
  void onInit() {
    super.onInit();
    loadData();
    loadCurrentLocation();
    // _refreshTimer = Timer.periodic(const Duration(seconds: 15), (_) {
    //   refreshLocationsSilently();
    // });
  }

  /// `user-location/get-team-user-locations` — company, filter fields, and `datetime` (date filter).
  Map<String, dynamic> _buildTeamUserLocationsQueryParams() {
    final query = <String, dynamic>{
      'company_id': ApiConstants.companyId,
    };
    for (final e in appliedFilters.entries) {
      final v = e.value.trim();
      if (v.isNotEmpty) {
        query[e.key] = v;
      }
    }
    return query;
  }

  /// `work-zone/get-app-zones` — company id only (no map filters / date range).
  Map<String, dynamic> _buildZoneGroupsQueryParams() {
    return <String, dynamic>{
      'company_id': ApiConstants.companyId,
    };
  }

  void loadData() {
    isLoading.value = true;
    final teamQuery = _buildTeamUserLocationsQueryParams();
    final zoneQuery = _buildZoneGroupsQueryParams();
    _api.getTeamUserLocations(
      queryParameters: teamQuery,
      onSuccess: (response) {
        _onLocationsLoaded(response);
        _api.getZoneGroups(
          queryParameters: zoneQuery,
          onSuccess: (zoneResponse) {
            _onZoneGroupsLoaded(zoneResponse);
            isLoading.value = false;
          },
          onError: _onError,
        );
      },
      onError: _onError,
    );
  }

  void refreshLocationsSilently() {
    final query = _buildTeamUserLocationsQueryParams();
    _api.getTeamUserLocations(
      queryParameters: query,
      onSuccess: (response) {
        _onLocationsLoaded(response, silent: true);
      },
      onError: (_) {},
    );
  }

  Future<void> loadCurrentLocation() async {
    final isGranted = await locationService.checkLocationService();
    if (!isGranted) return;
    final Position? pos = await LocationServiceNew.getCurrentLocation();
    if (pos == null) return;
    center.value = LatLng(pos.latitude, pos.longitude);
    _renderOverlays();
    if (mapController != null) {
      mapController!.moveCamera(CameraUpdate.newLatLngZoom(center.value, 13.5));
    }
  }

  void _onLocationsLoaded(ResponseModel responseModel, {bool silent = false}) {
    if (!responseModel.isSuccess ||
        StringHelper.isEmptyString(responseModel.result)) {
      if (!silent) {
        AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
      }
      return;
    }
    final parsed =
        UserLocationsResponse.fromJson(jsonDecode(responseModel.result!));
    final teams = parsed.info ?? <TeamUserLocationsGroup>[];
    allUsers.assignAll(teams.expand((t) => t.users));

    for (final user in allUsers) {
      userVisibility[user.id ?? 0] = userVisibility[user.id ?? 0] ?? true;
    }
    teamGroups.assignAll(teams
        .map((t) => TeamUsersGroup(
              name: t.teamName ?? '',
              users: t.users,
            ))
        .toList());
    filteredGroups.assignAll(teamGroups);
    _renderOverlays();
  }

  void _onError(ResponseModel error) {
    isLoading.value = false;
    if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
      isInternetNotAvailable.value = true;
    } else {
      AppUtils.showApiResponseMessage(error.statusMessage ?? "");
    }
  }

  void _onZoneGroupsLoaded(ResponseModel responseModel) {
    if (!responseModel.isSuccess ||
        StringHelper.isEmptyString(responseModel.result)) {
      AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
      return;
    }
    isMainViewVisible.value = true;
    final parsed =
        UserZoneGroupsResponse.fromJson(jsonDecode(responseModel.result!));
    zoneGroups.assignAll(parsed.info ?? <UserZoneGroupInfo>[]);
    filteredZoneGroups.assignAll(zoneGroups);
    for (final group in zoneGroups) {
      for (final zone in group.zones ?? <GeofenceInfo>[]) {
        zoneVisibility[zone.id ?? 0] = zoneVisibility[zone.id ?? 0] ?? true;
      }
    }
    _renderOverlays();
  }

  void onSearchTextChanged(String value) {
    filterGroups(value);
    isSearchClearVisible.value = !StringHelper.isEmptyString(value);
  }

  void clearSearchField() {
    searchController.value.clear();
    filterGroups("");
    isSearchClearVisible.value = false;
  }

  void filterGroups(String query) {
    if (isZonesPanel.value) {
      if (query.trim().isEmpty) {
        filteredZoneGroups.assignAll(zoneGroups);
        return;
      }
      final q = query.toLowerCase();
      final filtered = <UserZoneGroupInfo>[];
      for (final g in zoneGroups) {
        final groupMatch = (g.name ?? "").toLowerCase().contains(q);
        final zones = g.zones ?? <GeofenceInfo>[];
        final matchedZones = zones.where((z) {
          return (z.name ?? "").toLowerCase().contains(q) ||
              (z.projectName ?? "").toLowerCase().contains(q) ||
              (z.type ?? "").toLowerCase().contains(q);
        }).toList();

        if (groupMatch || matchedZones.isNotEmpty) {
          filtered.add(UserZoneGroupInfo(
            id: g.id,
            name: g.name,
            companyId: g.companyId,
            isUnassigned: g.isUnassigned,
            zones: groupMatch ? zones : matchedZones,
          ));
        }
      }
      filteredZoneGroups.assignAll(filtered);
      return;
    }

    if (query.trim().isEmpty) {
      filteredGroups.assignAll(teamGroups);
      return;
    }
    final q = query.toLowerCase();
    final filtered = <TeamUsersGroup>[];
    for (final g in teamGroups) {
      final groupMatch = g.name.toLowerCase().contains(q);
      final matchedUsers = g.users.where((u) {
        return (u.userName ?? "").toLowerCase().contains(q) ||
            (u.userCode ?? "").toLowerCase().contains(q) ||
            (u.tradeName ?? "").toLowerCase().contains(q) ||
            (u.location ?? "").toLowerCase().contains(q);
      }).toList();

      if (groupMatch || matchedUsers.isNotEmpty) {
        filtered.add(TeamUsersGroup(
          name: g.name,
          users: groupMatch ? g.users : matchedUsers,
        ));
      }
    }
    filteredGroups.assignAll(filtered);
  }

  void toggleUserVisibility(int id) {
    final current = userVisibility[id] ?? true;
    userVisibility[id] = !current;
    userVisibility.refresh();
    _renderOverlays();
  }

  void toggleZoneVisibility(int id) {
    final m = Map<int, bool>.from(zoneVisibility);
    m[id] = !(m[id] ?? true);
    zoneVisibility.assignAll(m);
    _renderOverlays();
  }

  void focusUser(UserLocationInfo user) {
    final lat = user.latitude;
    final lng = user.longitude;
    if (lat == null || lng == null || mapController == null) return;
    mapController!.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(lat, lng), 15.0),
    );
  }

  void focusZone(GeofenceInfo zone) {
    final lat = double.parse(zone.latitude ?? "0");
    final lng = double.parse(zone.longitude ?? "0");
    if (mapController == null) return;
    mapController!.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(lat, lng), 15.0),
    );
  }

  /// Map tap hit-test for zones (circle / polygon / polyline). Native shape
  /// [onTap] is unreliable on some platforms; this mirrors the drawn geometry.
  void onMapZoneTap(LatLng tap) {
    if (!canManageZones) return;
    final flat = zoneGroups
        .expand((g) => g.zones ?? <GeofenceInfo>[])
        .where((z) => zoneVisibility[z.id ?? 0] ?? true)
        .toList();
    for (var i = flat.length - 1; i >= 0; i--) {
      final zone = flat[i];
      final type = (zone.type ?? "").toLowerCase();
      if (type == AppConstants.zoneType.circle &&
          zone.latitude != null &&
          zone.longitude != null) {
        final r = zone.radius ?? 0;
        if (r <= 0) continue;
        final center = LatLng(
          double.parse(zone.latitude!),
          double.parse(zone.longitude!),
        );
        final d = Geolocator.distanceBetween(
          tap.latitude,
          tap.longitude,
          center.latitude,
          center.longitude,
        );
        if (d <= r) {
          onEditZone(zone);
          return;
        }
      } else if (type == AppConstants.zoneType.polygon &&
          (zone.coordinates ?? []).length >= 3) {
        final pts = (zone.coordinates ?? <GeofenceCoordinates>[])
            .where((c) => c.lat != null && c.lng != null)
            .map((c) => LatLng(c.lat!, c.lng!))
            .toList();
        if (pts.length >= 3 && _pointInPolygon(tap, pts)) {
          onEditZone(zone);
          return;
        }
      } else if (type == AppConstants.zoneType.polyline &&
          (zone.coordinates ?? []).length >= 2) {
        final pts = (zone.coordinates ?? <GeofenceCoordinates>[])
            .where((c) => c.lat != null && c.lng != null)
            .map((c) => LatLng(c.lat!, c.lng!))
            .toList();
        if (pts.length >= 2 && _tapNearPolyline(tap, pts, maxMeters: 28)) {
          onEditZone(zone);
          return;
        }
      }
    }
  }

  static bool _pointInPolygon(LatLng point, List<LatLng> polygon) {
    final x = point.longitude;
    final y = point.latitude;
    var inside = false;
    for (var i = 0, j = polygon.length - 1; i < polygon.length; j = i++) {
      final xi = polygon[i].longitude;
      final yi = polygon[i].latitude;
      final xj = polygon[j].longitude;
      final yj = polygon[j].latitude;
      if ((yi > y) == (yj > y)) continue;
      final dy = yj - yi;
      if (dy.abs() < 1e-15) continue;
      final xIntersect = (xj - xi) * (y - yi) / dy + xi;
      if (x < xIntersect) inside = !inside;
    }
    return inside;
  }

  static bool _tapNearPolyline(LatLng tap, List<LatLng> pts,
      {required double maxMeters}) {
    for (var i = 0; i < pts.length - 1; i++) {
      final a = pts[i];
      final b = pts[i + 1];
      for (var t = 0.0; t <= 1.001; t += 0.125) {
        final lat = a.latitude + t * (b.latitude - a.latitude);
        final lng = a.longitude + t * (b.longitude - a.longitude);
        final d = Geolocator.distanceBetween(
          tap.latitude,
          tap.longitude,
          lat,
          lng,
        );
        if (d <= maxMeters) return true;
      }
    }
    return false;
  }

  void onEditZone(GeofenceInfo zone) {
    if (!canManageZones) return;
    // final pid = zone.projectId ?? 0;
    // if (pid == null || pid == 0) {
    //   AppUtils.showToastMessage('zone_project_required'.tr);
    //   return;
    // }
    closePanel();
    Get.toNamed(
      AppRoutes.createZoneScreen,
      arguments: <String, dynamic>{'zone': zone},
    )?.then((dynamic result) {
      if (result == true) loadData();
    });
  }

  // int? _firstProjectIdFromZones() {
  //   for (final g in zoneGroups) {
  //     for (final z in g.zones ?? <GeofenceInfo>[]) {
  //       final id = z.projectId;
  //       if (id != null && id != 0) return id;
  //     }
  //   }
  //   return null;
  // }

  void onDeleteZone(GeofenceInfo zone) {
    if (!canManageZones) return;
    if (Get.context == null) return;
    _zonePendingDelete = zone;
    AlertDialogHelper.showAlertDialog(
      "",
      'are_you_sure_you_want_to_delete'.tr,
      'yes'.tr,
      'no'.tr,
      "",
      true,
      true,
      this,
      AppConstants.dialogIdentifier.deleteUserZone,
    );
  }

  void _deleteZoneApi(GeofenceInfo zone) {
    final id = zone.id;
    if (id == null || id == 0) {
      AppUtils.showApiResponseMessage('try_again'.tr);
      return;
    }
    isLoading.value = true;
    _api.deleteZone(
      queryParameters: {'id': id},
      onSuccess: (ResponseModel rm) {
        isLoading.value = false;
        if (rm.isSuccess) {
          if (!StringHelper.isEmptyString(rm.result) && rm.result != 'null') {
            try {
              final response = BaseResponse.fromJson(jsonDecode(rm.result!));
              AppUtils.showApiResponseMessage(response.Message ?? '');
            } catch (_) {
              AppUtils.showApiResponseMessage(rm.statusMessage ?? '');
            }
          }
          _removeZoneFromLists(zone);
        } else {
          AppUtils.showApiResponseMessage(rm.statusMessage ?? '');
        }
      },
      onError: (ResponseModel err) {
        isLoading.value = false;
        _onError(err);
      },
    );
  }

  void _removeZoneFromLists(GeofenceInfo zone) {
    final targetId = zone.id;
    final newGroups = <UserZoneGroupInfo>[];
    for (final g in zoneGroups) {
      final list = (g.zones ?? <GeofenceInfo>[]).where((z) {
        if (targetId != null) return z.id != targetId;
        return !identical(z, zone);
      }).toList();
      newGroups.add(UserZoneGroupInfo(
        id: g.id,
        name: g.name,
        companyId: g.companyId,
        isUnassigned: g.isUnassigned,
        zones: list,
      ));
    }
    zoneGroups.assignAll(newGroups);
    if (targetId != null) {
      zoneVisibility.remove(targetId);
    }
    filterGroups(searchController.value.text);
    _renderOverlays();
  }

  int get totalUsersCount => allUsers.length;

  int get visibleUsersCount =>
      allUsers.where((u) => userVisibility[u.id ?? 0] ?? true).length;

  int get totalZonesCount =>
      zoneGroups.fold<int>(0, (sum, g) => sum + (g.zones?.length ?? 0));

  int get visibleZonesCount => zoneGroups.fold<int>(0, (sum, g) {
        final zones = g.zones ?? <GeofenceInfo>[];
        return sum +
            zones.where((z) => zoneVisibility[z.id ?? 0] ?? true).length;
      });

  Future<void> moveToCurrentLocation() async {
    final isGranted = await locationService.checkLocationService();
    if (!isGranted) return;
    final pos = await LocationServiceNew.getCurrentLocation();
    if (pos == null || mapController == null) return;
    final latLng = LatLng(pos.latitude, pos.longitude);
    center.value = latLng;
    mapController!.animateCamera(CameraUpdate.newLatLngZoom(latLng, 14.5));
    _renderOverlays();
  }

  static const Duration _panelAnimDuration = Duration(milliseconds: 240);

  void togglePanel() {
    if (isPanelOpen.value) {
      closePanel();
    } else {
      openPanel();
    }
  }

  void openPanel() {
    _panelScrimTimer?.cancel();
    isPanelOpen.value = true;
    isPanelScrimVisible.value = false;
    _panelScrimTimer = Timer(_panelAnimDuration, () {
      if (isPanelOpen.value) {
        isPanelScrimVisible.value = true;
      }
    });
  }

  void closePanel() {
    _panelScrimTimer?.cancel();
    isPanelScrimVisible.value = false;
    isPanelOpen.value = false;
  }

  void openStaffPanel() {
    isZonesPanel.value = false;
    openPanel();
    filterGroups(searchController.value.text);
  }

  void openZonesPanel() {
    isZonesPanel.value = true;
    openPanel();
    filterGroups(searchController.value.text);
  }

  Future<void> moveToFilterScreen() async {
    final arguments = {
      AppConstants.intentKey.filterType:
          AppConstants.filterType.userZonesFilter,
      AppConstants.intentKey.filterData: appliedFilters,
    };
    final result =
        await Get.toNamed(AppRoutes.filterScreen, arguments: arguments);
    if (result is Map) {
      appliedFilters = {};
      for (final e in result.entries) {
        appliedFilters[e.key.toString()] = e.value?.toString() ?? '';
      }
      _syncZoneFilterDisplayFromApplied();
      setFilterItems();
      loadData();
    }
  }

  void _syncZoneFilterDisplayFromApplied() {
    final dtStr = appliedFilters['datetime']?.trim() ?? '';
    if (dtStr.isEmpty) {
      displayStartDate.value = '';
      displayEndDate.value = '';
      zoneFilterDateTime = null;
      return;
    }
    displayStartDate.value = dtStr;
    displayEndDate.value = dtStr;
    zoneFilterDateTime =
        DateUtil.stringToDate(dtStr, DateUtil.DD_MM_YYYY_TIME_24_SLASH);
  }

  void setFilterItems() {
    filterItemsList.clear();
    for (final entry in appliedFilters.entries) {
      final key = entry.key;
      final value = entry.value;
      if (value.trim().isEmpty) continue;
      final info = ModuleInfo();
      info.name = StringHelper.capitalizeFirstLetter(_formatFilterLabel(key));
      info.value = value;
      final list = value.split(',');
      info.count = list.length;
      filterItemsList.add(info);
    }
    if (filterItemsList.isNotEmpty) {
      filterItemsList.insert(
        0,
        ModuleInfo(name: 'reset'.tr, action: AppConstants.action.reset),
      );
    }
    filterItemsList.refresh();
  }

  String _formatFilterLabel(String input) {
    return input
        .split('_')
        .map((word) => word.isNotEmpty
            ? word[0].toUpperCase() + word.substring(1).toLowerCase()
            : '')
        .join(' ');
  }

  /// Purchasing-style `"start - end"`; when both match, [zoneDateTimeDisplayLine] shows a single value.
  String get zoneDateTimeDisplayLine {
    final a = displayStartDate.value;
    final b = displayEndDate.value;
    if (a.isEmpty) return '';
    if (a == b) return a;
    return '$a - $b';
  }

  void openZoneDateTimeFilter() {
    final now = zoneFilterDateTime ?? DateTime.now();
    DateUtil.showDatePickerDialog(
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      dialogIdentifier: _zoneFilterDateId,
      selectDateListener: this,
    );
  }

  @override
  void onSelectDate(DateTime date, String dialogIdentifier) {
    if (dialogIdentifier != _zoneFilterDateId) return;
    _pendingZoneFilterDate = DateTime(date.year, date.month, date.day);
    final base = zoneFilterDateTime ?? DateTime.now();
    final combined = DateTime(
      _pendingZoneFilterDate!.year,
      _pendingZoneFilterDate!.month,
      _pendingZoneFilterDate!.day,
      base.hour,
      base.minute,
    );
    DateUtil.showTimePickerDialog(
      initialTime: combined,
      dialogIdentifier: _zoneFilterTimeId,
      selectTimeListener: this,
    );
  }

  @override
  void onSelectTime(DateTime time, String dialogIdentifier) {
    if (dialogIdentifier != _zoneFilterTimeId) return;
    final d = _pendingZoneFilterDate;
    if (d == null) return;
    final dt = DateTime(d.year, d.month, d.day, time.hour, time.minute);
    zoneFilterDateTime = dt;
    final s = DateUtil.dateToString(dt, DateUtil.DD_MM_YYYY_TIME_24_SLASH);
    appliedFilters['datetime'] = s;
    _syncZoneFilterDisplayFromApplied();
    setFilterItems();
    loadData();
  }

  void clearFilter() {
    appliedFilters.clear();
    zoneFilterDateTime = null;
    _pendingZoneFilterDate = null;
    displayStartDate.value = '';
    displayEndDate.value = '';
    setFilterItems();
    loadData();
  }

  void setMapTypeNormal() => mapType.value = MapType.normal;

  void setMapTypeSatellite() => mapType.value = MapType.satellite;

  void onAddZonePressed() {
    if (!canManageZones) return;
    closePanel();
    Get.toNamed(
      AppRoutes.createZoneScreen,
      // arguments: <String, dynamic>{'project_id': pid},
    )?.then((dynamic result) {
      if (result == true) loadData();
    });
    // showMenuItemsDialog(Get.context!);
  }

  void showMenuItemsDialog(BuildContext context) {
    final listItems = <ModuleInfo>[
      ModuleInfo(name: 'add_by_shape'.tr, action: _zoneMenuActionAddByShape),
      ModuleInfo(
        name: 'add_by_post_code'.tr,
        action: _zoneMenuActionAddByPostCode,
      ),
    ];

    showCupertinoModalPopup(
      context: context,
      builder: (_) =>
          MenuItemsListBottomDialog(list: listItems, listener: this),
    );
  }

  @override
  void onSelectMenuItem(ModuleInfo info, String dialogType) {
    if (info.action == _zoneMenuActionAddByShape) {
      // final pid = _firstProjectIdFromZones();
      // if (pid == null) {
      //   AppUtils.showToastMessage('zone_project_required'.tr);
      //   return;
      // }
      // Get.toNamed(
      //   AppRoutes.createZoneScreen,
      //   arguments: <String, dynamic>{'project_id': pid},
      // )?.then((dynamic result) {
      //   if (result == true) loadData();
      // });
    } else if (info.action == _zoneMenuActionAddByPostCode) {
      AppUtils.showToastMessage('add_by_post_code'.tr);
    }
  }

  void showUserMarkerBottomSheet(UserLocationInfo user) {
    Get.bottomSheet(
      UserZonesUserBottomSheet(user: user),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  void _renderOverlays() {
    markers.clear();
    circles.clear();
    polygons.clear();
    polyLines.clear();

    for (final user in allUsers) {
      final id = user.id ?? 0;
      if (!(userVisibility[id] ?? true)) continue;
      if (user.latitude != null && user.longitude != null) {
        final position = LatLng(user.latitude!, user.longitude!);
        // Bump version when team marker bitmap pipeline changes (invalidates cache).
        final markerKey = 'user_v8_${id}_${user.userThumbImage ?? ""}';
        final icon = _teamUserMarkerIconCache[markerKey];
        if (icon == null) {
          _prepareTeamUserMarkerIcon(markerKey, user.userThumbImage);
        }
        markers.add(
          Marker(
            markerId: MarkerId('employee_$id'),
            position: position,
            consumeTapEvents: true,
            icon: icon ??
                BitmapDescriptor.defaultMarkerWithHue(
                  (user.isWorking ?? false)
                      ? BitmapDescriptor.hueGreen
                      : BitmapDescriptor.hueRed,
                ),
            anchor: const Offset(0.5, 1.0),
            infoWindow: InfoWindow.noText,
            onTap: () => showUserMarkerBottomSheet(user),
          ),
        );
      }
    }

    // Zone overlays from work-zone/app-get-groups API.
    final allZones =
        zoneGroups.expand((g) => g.zones ?? <GeofenceInfo>[]).toList();
    for (final zone in allZones) {
      final id = zone.id ?? 0;
      if (!(zoneVisibility[id] ?? true)) continue;

      final type = (zone.type ?? "").toLowerCase();
      final color = !StringHelper.isEmptyString(zone.color)
          ? AppUtils.getColor(zone.color ?? "#1976d2")
          : const Color(0xff1976d2);

      if (zone.latitude != null && zone.longitude != null) {
        final zoneLabel =
            (zone.name ?? "").trim().isEmpty ? "Zone" : zone.name!;
        // Prefix bumps when zone bitmap quality/layout changes (invalidates cache).
        final markerKey = 'zbm_x2_${id}_${zoneLabel}_${color.toARGB32()}';
        final icon = _zoneMarkerIconCache[markerKey];
        if (icon == null) {
          _prepareZoneMarkerIcon(
            markerKey: markerKey,
            label: zoneLabel,
            zoneColor: color,
          );
        }
        markers.add(
          Marker(
            markerId: MarkerId('zone_$id'),
            position: LatLng(double.parse(zone.latitude ?? "0"),
                double.parse(zone.longitude ?? "0")),
            icon: icon ??
                BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueAzure),
            anchor: Offset(0.5, ZoneLabelMarkerBitmap.anchorY),
            infoWindow: InfoWindow(title: zone.name ?? "Zone"),
            consumeTapEvents: canManageZones,
            onTap: canManageZones ? () => onEditZone(zone) : null,
          ),
        );
      }

      if (type == AppConstants.zoneType.circle &&
          zone.latitude != null &&
          zone.longitude != null) {
        circles.add(AppUtils.getCircle(
          id: 'zone_circle_$id',
          latLng: LatLng(double.parse(zone.latitude ?? "0"),
              double.parse(zone.longitude ?? "0")),
          radius: zone.radius ?? 0,
          color: color,
        ));
      } else if (type == AppConstants.zoneType.polygon &&
          (zone.coordinates ?? []).isNotEmpty) {
        final points = (zone.coordinates ?? <GeofenceCoordinates>[])
            .where((c) => c.lat != null && c.lng != null)
            .map((c) => LatLng(c.lat!, c.lng!))
            .toList();
        if (points.isNotEmpty) {
          polygons.add(AppUtils.getPolygon(
            id: 'zone_polygon_$id',
            listLatLng: points,
            color: color,
          ));
        }
      } else if (type == AppConstants.zoneType.polyline &&
          (zone.coordinates ?? []).isNotEmpty) {
        final points = (zone.coordinates ?? <GeofenceCoordinates>[])
            .where((c) => c.lat != null && c.lng != null)
            .map((c) => LatLng(c.lat!, c.lng!))
            .toList();
        if (points.isNotEmpty) {
          polyLines.add(AppUtils.getPolyline(
            id: 'zone_polyline_$id',
            listLatLng: points,
            color: color,
          ));
        }
      }
    }
    markers.refresh();
    circles.refresh();
    polygons.refresh();
    polyLines.refresh();
    mapOverlayRevision.value++;
  }

  void _prepareTeamUserMarkerIcon(String markerKey, String? thumbUrl) {
    if (_teamUserMarkerIconCache.containsKey(markerKey) ||
        _teamUserMarkerIconBuilding.contains(markerKey)) {
      return;
    }
    _teamUserMarkerIconBuilding.add(markerKey);
    TeamUserMarkerBitmap.build(thumbUrl: thumbUrl).then((icon) {
      _teamUserMarkerIconCache[markerKey] = icon;
      _renderOverlays();
    }).whenComplete(() {
      _teamUserMarkerIconBuilding.remove(markerKey);
    });
  }

  void _prepareZoneMarkerIcon({
    required String markerKey,
    required String label,
    required Color zoneColor,
  }) {
    if (_zoneMarkerIconCache.containsKey(markerKey) ||
        _zoneMarkerIconBuilding.contains(markerKey)) {
      return;
    }
    _zoneMarkerIconBuilding.add(markerKey);
    ZoneLabelMarkerBitmap.build(label: label, zoneColor: zoneColor)
        .then((icon) {
      _zoneMarkerIconCache[markerKey] = icon;
      _renderOverlays();
    }).whenComplete(() {
      _zoneMarkerIconBuilding.remove(markerKey);
    });
  }

  @override
  void onNegativeButtonClicked(String dialogIdentifier) {
    if (dialogIdentifier == AppConstants.dialogIdentifier.deleteUserZone) {
      _zonePendingDelete = null;
    }
    Get.back();
  }

  @override
  void onOtherButtonClicked(String dialogIdentifier) {}

  @override
  void onPositiveButtonClicked(String dialogIdentifier) {
    if (dialogIdentifier == AppConstants.dialogIdentifier.deleteUserZone) {
      Get.back();
      final zone = _zonePendingDelete;
      _zonePendingDelete = null;
      if (zone != null) {
        _deleteZoneApi(zone);
      }
    }
  }

  @override
  void onClose() {
    // _refreshTimer?.cancel();
    _panelScrimTimer?.cancel();
    searchController.value.dispose();
    super.onClose();
  }
}
