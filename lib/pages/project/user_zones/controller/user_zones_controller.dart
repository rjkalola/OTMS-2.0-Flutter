import 'dart:convert';
import 'dart:async';

import 'package:belcka/pages/project/user_zones/controller/user_zones_repository.dart';
import 'package:belcka/pages/project/user_zones/model/user_location_models.dart';
import 'package:belcka/pages/project/user_zones/model/zone_group_models.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/location_service_new.dart';
import 'package:belcka/utils/map_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserZonesController extends GetxController {
  final _api = UserZonesRepository();
  final locationService = LocationServiceNew();

  RxBool isLoading = false.obs,
      isMainViewVisible = false.obs,
      isInternetNotAvailable = false.obs,
      isPanelOpen = true.obs,
      isZonesPanel = false.obs;

  final searchController = TextEditingController().obs;

  final center =
      LatLng(51.5072, -0.1276).obs;
  final mapType = MapType.normal.obs;
  final markers = <Marker>{}.obs;
  final circles = <Circle>{}.obs;
  final polygons = <Polygon>{}.obs;
  final polyLines = <Polyline>{}.obs;

  final allUsers = <UserLocationInfo>[].obs;
  final teamGroups = <TeamUsersGroup>[].obs;
  final filteredGroups = <TeamUsersGroup>[].obs;
  final userVisibility = <int, bool>{}.obs;
  final zoneGroups = <UserZoneGroupInfo>[].obs;
  final filteredZoneGroups = <UserZoneGroupInfo>[].obs;
  final zoneVisibility = <int, bool>{}.obs;

  GoogleMapController? mapController;
  BitmapDescriptor? _userMarkerIcon;
  Timer? _refreshTimer;

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void onInit() {
    super.onInit();
    _loadMapIcons();
    loadData();
    loadCurrentLocation();
    _refreshTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      refreshLocationsSilently();
    });
  }

  Future<void> _loadMapIcons() async {
    _userMarkerIcon = await MapUtils.createIcon(
        assetPath: Drawable.bluePin, width: 24, height: 34);
  }

  void loadData() {
    isLoading.value = true;
    final query = {"company_id": ApiConstants.companyId};
    _api.getUserLocations(
      queryParameters: query,
      onSuccess: (response) {
        _onLocationsLoaded(response);
        _api.getZoneGroups(
          queryParameters: query,
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
    final query = {"company_id": ApiConstants.companyId};
    _api.getUserLocations(
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
    if (!responseModel.isSuccess || StringHelper.isEmptyString(responseModel.result)) {
      if (!silent) {
        AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
      }
      return;
    }
    isMainViewVisible.value = true;
    final parsed =
        UserLocationsResponse.fromJson(jsonDecode(responseModel.result!));
    allUsers.assignAll(parsed.info ?? <UserLocationInfo>[]);

    for (final user in allUsers) {
      userVisibility[user.id ?? 0] = userVisibility[user.id ?? 0] ?? true;
    }
    _buildTeams();
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
    if (!responseModel.isSuccess || StringHelper.isEmptyString(responseModel.result)) {
      AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
      return;
    }
    final parsed =
        UserZoneGroupsResponse.fromJson(jsonDecode(responseModel.result!));
    zoneGroups.assignAll(parsed.info ?? <UserZoneGroupInfo>[]);
    filteredZoneGroups.assignAll(zoneGroups);
    for (final group in zoneGroups) {
      for (final zone in group.zones ?? <UserZoneInfo>[]) {
        zoneVisibility[zone.id ?? 0] = zoneVisibility[zone.id ?? 0] ?? true;
      }
    }
    _renderOverlays();
  }

  void filterGroups(String query) {
    if (isZonesPanel.value) {
      if (query.trim().isEmpty) {
        filteredZoneGroups.assignAll(zoneGroups);
        return;
      }
      final q = query.toLowerCase();
      final filtered = zoneGroups.where((g) {
        final groupMatch = (g.name ?? "").toLowerCase().contains(q);
        final zoneMatch = (g.zones ?? <UserZoneInfo>[]).any((z) =>
            (z.name ?? "").toLowerCase().contains(q) ||
            (z.projectName ?? "").toLowerCase().contains(q));
        return groupMatch || zoneMatch;
      }).toList();
      filteredZoneGroups.assignAll(filtered);
      return;
    }

    if (query.trim().isEmpty) {
      filteredGroups.assignAll(teamGroups);
      return;
    }
    final q = query.toLowerCase();
    final filtered = teamGroups.where((g) {
      final groupMatch = g.name.toLowerCase().contains(q);
      final userMatch = g.users.any((u) =>
          (u.userName ?? "").toLowerCase().contains(q) ||
          (u.userCode ?? "").toLowerCase().contains(q) ||
          (u.location ?? "").toLowerCase().contains(q));
      return groupMatch || userMatch;
    }).toList();
    filteredGroups.assignAll(filtered);
  }

  void toggleUserVisibility(int id) {
    final current = userVisibility[id] ?? true;
    userVisibility[id] = !current;
    userVisibility.refresh();
    _renderOverlays();
  }

  void toggleZoneVisibility(int id) {
    final current = zoneVisibility[id] ?? true;
    zoneVisibility[id] = !current;
    zoneVisibility.refresh();
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

  void focusZone(UserZoneInfo zone) {
    final lat = zone.latitude;
    final lng = zone.longitude;
    if (lat == null || lng == null || mapController == null) return;
    mapController!.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(lat, lng), 15.0),
    );
  }

  int get totalUsersCount => allUsers.length;

  int get visibleUsersCount =>
      allUsers.where((u) => userVisibility[u.id ?? 0] ?? true).length;

  int get totalZonesCount =>
      zoneGroups.fold<int>(0, (sum, g) => sum + (g.zones?.length ?? 0));

  int get visibleZonesCount => zoneGroups.fold<int>(0, (sum, g) {
        final zones = g.zones ?? <UserZoneInfo>[];
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

  void togglePanel() => isPanelOpen.value = !isPanelOpen.value;
  void openStaffPanel() {
    isZonesPanel.value = false;
    isPanelOpen.value = true;
    filterGroups(searchController.value.text);
  }

  void openZonesPanel() {
    isZonesPanel.value = true;
    isPanelOpen.value = true;
    filterGroups(searchController.value.text);
  }

  void setMapTypeNormal() => mapType.value = MapType.normal;

  void setMapTypeSatellite() => mapType.value = MapType.satellite;

  void _renderOverlays() {
    markers.clear();
    circles.clear();
    polygons.clear();
    polyLines.clear();

    if (_userMarkerIcon != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('user_location'),
          position: center.value,
          icon: _userMarkerIcon!,
          infoWindow: const InfoWindow(title: 'Your location'),
        ),
      );
    }

    for (final user in allUsers) {
      final id = user.id ?? 0;
      if (!(userVisibility[id] ?? true)) continue;
      if (user.latitude != null && user.longitude != null) {
        final position = LatLng(user.latitude!, user.longitude!);
        markers.add(
          Marker(
            markerId: MarkerId('employee_$id'),
            position: position,
            icon: BitmapDescriptor.defaultMarkerWithHue(
                (user.isWorking ?? false)
                    ? BitmapDescriptor.hueGreen
                    : BitmapDescriptor.hueRed),
            infoWindow: InfoWindow(
              title: user.userName ?? "",
              snippet: user.location ?? "",
            ),
          ),
        );
      }
    }

    // Zone overlays from work-zone/app-get-groups API.
    final allZones = zoneGroups.expand((g) => g.zones ?? <UserZoneInfo>[]).toList();
    for (final zone in allZones) {
      final id = zone.id ?? 0;
      if (!(zoneVisibility[id] ?? true)) continue;

      final type = (zone.type ?? "").toLowerCase();
      final color = !StringHelper.isEmptyString(zone.color)
          ? AppUtils.getColor(zone.color ?? "#1976d2")
          : const Color(0xff1976d2);

      if (zone.latitude != null && zone.longitude != null) {
        markers.add(
          Marker(
            markerId: MarkerId('zone_$id'),
            position: LatLng(zone.latitude!, zone.longitude!),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
            infoWindow: InfoWindow(title: zone.name ?? "Zone"),
          ),
        );
      }

      if (type == AppConstants.zoneType.circle &&
          zone.latitude != null &&
          zone.longitude != null) {
        circles.add(AppUtils.getCircle(
          id: 'zone_circle_$id',
          latLng: LatLng(zone.latitude!, zone.longitude!),
          radius: zone.radius ?? 0,
          color: color,
        ));
      } else if (type == AppConstants.zoneType.polygon &&
          (zone.coordinates ?? []).isNotEmpty) {
        final points = (zone.coordinates ?? <UserZoneCoordinate>[])
            .where((c) => c.lat != null && c.lng != null)
            .map((c) => LatLng(c.lat!, c.lng!))
            .toList();
        if (points.isNotEmpty) {
          polygons.add(AppUtils.getPolygon(
              id: 'zone_polygon_$id', listLatLng: points, color: color));
        }
      } else if (type == AppConstants.zoneType.polyline &&
          (zone.coordinates ?? []).isNotEmpty) {
        final points = (zone.coordinates ?? <UserZoneCoordinate>[])
            .where((c) => c.lat != null && c.lng != null)
            .map((c) => LatLng(c.lat!, c.lng!))
            .toList();
        if (points.isNotEmpty) {
          polyLines.add(AppUtils.getPolyline(
              id: 'zone_polyline_$id', listLatLng: points, color: color));
        }
      }
    }
    markers.refresh();
    circles.refresh();
    polygons.refresh();
    polyLines.refresh();
  }

  void _buildTeams() {
    final map = <String, List<UserLocationInfo>>{};
    for (final user in allUsers) {
      final key = StringHelper.isEmptyString(user.teamName)
          ? 'Unassigned'
          : user.teamName!;
      map.putIfAbsent(key, () => <UserLocationInfo>[]).add(user);
    }
    teamGroups.assignAll(map.entries
        .map((e) => TeamUsersGroup(name: e.key, users: e.value))
        .toList());
    filteredGroups.assignAll(teamGroups);
  }

  @override
  void onClose() {
    _refreshTimer?.cancel();
    searchController.value.dispose();
    super.onClose();
  }
}
