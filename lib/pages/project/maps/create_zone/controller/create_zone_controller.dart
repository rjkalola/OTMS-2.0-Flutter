import 'dart:convert';

import 'package:belcka/pages/common/drop_down_list_dialog.dart';
import 'package:belcka/pages/common/listener/select_item_listener.dart';
import 'package:belcka/pages/project/add_address/controller/add_address_repository.dart';
import 'package:belcka/pages/project/maps/create_zone/controller/create_zone_repository.dart';
import 'package:belcka/pages/project/maps/create_zone/utils/polygon_vertex_marker_bitmap.dart';
import 'package:belcka/pages/project/project_info/model/geofence_info.dart';
import 'package:belcka/pages/project/project_info/model/project_list_response.dart';
import 'package:belcka/pages/project/project_list/controller/project_list_repository.dart';
import 'package:belcka/pages/profile/post_coder_search/model/post_coder_model.dart';
import 'package:belcka/res/theme/app_theme_extension.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/google_place_service.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum ZoneDrawTool { pan, circle, polygon }

class CreateZoneController extends GetxController
    implements SelectItemListener {
  final _addressApi = AddAddressRepository();
  final _zoneApi = CreateZoneRepository();
  final placesService =
      GooglePlacesService('AIzaSyAdLpTcvwOWzhK4maBtriznqiw5MwBNcZw');

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final searchAddressController = TextEditingController().obs;
  final projectController = TextEditingController().obs;

  final projectsList = <ModuleInfo>[].obs;

  final isLoading = false.obs;
  final isClearVisible = false.obs;
  final addressList = <PostCoderModel>[].obs;

  final title = 'add_zone'.tr.obs;
  final selectedLatLng =
      LatLng(AppConstants.defaultLatitude, AppConstants.defaultLongitude).obs;
  final circleRadiusMeters = 100.obs;

  LatLng _circleCenter =
      LatLng(AppConstants.defaultLatitude, AppConstants.defaultLongitude);
  final drawTool = ZoneDrawTool.circle.obs;

  final polygonPoints = <LatLng>[].obs;
  final isPolygonClosed = false.obs;

  final zoneColor = const Color(0xFF0065FF).obs;
  final displayAddress = ''.obs;

  final mapCircles = <Circle>{}.obs;
  final mapPolygons = <Polygon>{}.obs;
  final mapPolylines = <Polyline>{}.obs;
  final mapMarkers = <Marker>{}.obs;

  BitmapDescriptor? _polyFirstVertexIcon;
  BitmapDescriptor? _polyVertexIcon;
  Color? _cachedVertexFill;
  int _vertexMarkerGen = 0;

  /// Bump when vertex bitmap size/style changes (invalidates cached descriptors).
  static const int _vertexIconSpec = 3;
  int? _vertexIconSpecLoaded;

  GoogleMapController? mapController;
  CameraPosition? lastCameraPosition;

  int projectId = 0;
  int? editingZoneId;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map) {
      // final pid = args['project_id'];
      // if (pid is int) {
      //   projectId = pid;
      // } else if (pid is num) {
      //   projectId = pid.toInt();
      // }
      final zone = args['zone'];
      if (zone is GeofenceInfo) {
        _applyExistingZone(zone);
      }
    }
    _circleCenter = selectedLatLng.value;
    _rebuildMapOverlays();
    getProjectListApi();
  }

  void getProjectListApi() {
    final map = <String, dynamic>{'company_id': ApiConstants.companyId};
    ProjectListRepository().getProjectList(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          final response =
              ProjectListResponse.fromJson(jsonDecode(responseModel.result!));
          projectsList.clear();
          for (final data in response.info ?? []) {
            projectsList.add(
              ModuleInfo(id: data.id ?? 0, name: data.name ?? ''),
            );
          }
          _syncSelectedProjectLabel();
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? '');
        }
      },
      onError: (ResponseModel error) {
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          AppUtils.showSnackBarMessage('no_internet'.tr);
        } else if (error.statusMessage != null &&
            error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage ?? '');
        }
      },
    );
  }

  void _syncSelectedProjectLabel() {
    if (projectId == 0) return;
    for (final e in projectsList) {
      if (e.id == projectId) {
        projectController.value.text = e.name ?? '';
        return;
      }
    }
  }

  void showSelectProjectDialog() {
    if (projectsList.isNotEmpty) {
      Get.bottomSheet(
        DropDownListDialog(
          title: 'select_project'.tr,
          dialogType: AppConstants.action.selectProjectDialog,
          list: projectsList.toList(),
          listener: this,
          isCloseEnable: true,
          isSearchEnable: true,
        ),
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
      );
    } else {
      AppUtils.showToastMessage('empty_data_message'.tr);
    }
  }

  @override
  void onSelectItem(int position, int id, String name, String action) {
    if (action == AppConstants.action.selectProjectDialog) {
      projectId = id;
      projectController.value.text = name;
    }
  }

  /// Call from screen once [context] has theme (e.g. first [build]).
  void applyDefaultAccentIfNeeded(BuildContext context) {
    if (editingZoneId != null) return;
    final ext = Theme.of(context).extension<AppThemeExtension>();
    if (ext != null) {
      zoneColor.value = ext.defaultAccentColor;
      _rebuildMapOverlays();
    }
  }

  void _applyExistingZone(GeofenceInfo z) {
    editingZoneId = z.id;
    title.value = 'update_zone'.tr;
    nameController.text = z.name ?? '';
    displayAddress.value = z.address ?? '';
    final pid = z.projectId;
    if (pid != null && pid != 0) {
      projectId = pid;
    }
    final pn = z.projectName?.trim();
    if (pn != null && pn.isNotEmpty) {
      projectController.value.text = pn;
    }
    if (z.color != null && z.color!.isNotEmpty) {
      final parsed = _parseHexColor(z.color!);
      if (parsed != null) zoneColor.value = parsed;
    }
    final t = (z.type ?? 'circle').toLowerCase();
    if (t == 'polygon' && (z.coordinates?.isNotEmpty ?? false)) {
      drawTool.value = ZoneDrawTool.polygon;
      polygonPoints.assignAll(
        z.coordinates!
            .map((c) => LatLng(c.lat ?? 0, c.lng ?? 0))
            .where((p) => p.latitude != 0 || p.longitude != 0),
      );
      isPolygonClosed.value = polygonPoints.length >= 3;
      try {
        final clat = double.parse(z.latitude ?? '0');
        final clng = double.parse(z.longitude ?? '0');
        if (clat != 0 || clng != 0) {
          selectedLatLng.value = LatLng(clat, clng);
        } else {
          selectedLatLng.value = _polygonCentroid(polygonPoints.toList());
        }
      } catch (_) {
        selectedLatLng.value = _polygonCentroid(polygonPoints.toList());
      }
      _circleCenter = selectedLatLng.value;
    } else {
      drawTool.value = ZoneDrawTool.circle;
      final lat = z.latitude != null
          ? double.parse(z.latitude!)
          : AppConstants.defaultLatitude;
      final lng = z.longitude != null
          ? double.parse(z.longitude!)
          : AppConstants.defaultLongitude;
      selectedLatLng.value = LatLng(lat, lng);
      _circleCenter = selectedLatLng.value;
      final r = z.radius?.round() ?? 100;
      circleRadiusMeters.value = r.clamp(10, 10000);
    }
    _rebuildMapOverlays();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(selectedLatLng.value, 15),
      );
    });
  }

  Color? _parseHexColor(String input) {
    var s = input.trim();
    if (s.isEmpty) return null;
    if (s.startsWith('#')) s = s.substring(1);
    if (s.length == 6) s = 'FF$s';
    if (s.length != 8) return null;
    try {
      return Color(int.parse(s, radix: 16));
    } catch (_) {
      return null;
    }
  }

  String colorToHex(Color c) {
    final r = (c.r * 255.0).round() & 0xff;
    final g = (c.g * 255.0).round() & 0xff;
    final b = (c.b * 255.0).round() & 0xff;
    return '#${r.toRadixString(16).padLeft(2, '0')}'
            '${g.toRadixString(16).padLeft(2, '0')}'
            '${b.toRadixString(16).padLeft(2, '0')}'
        .toLowerCase();
  }

  Color get _fillColor => zoneColor.value.withValues(alpha: 0.35);

  void onMapCreated(GoogleMapController c) {
    mapController = c;
  }

  void setDrawTool(ZoneDrawTool tool) {
    if (tool == ZoneDrawTool.circle && drawTool.value == ZoneDrawTool.polygon) {
      polygonPoints.clear();
      isPolygonClosed.value = false;
    }
    if (tool == ZoneDrawTool.polygon && drawTool.value == ZoneDrawTool.circle) {
      polygonPoints.clear();
      isPolygonClosed.value = false;
    }
    drawTool.value = tool;
    _rebuildMapOverlays();
  }

  bool get hasCompletePolygon =>
      polygonPoints.length >= 3 && isPolygonClosed.value;

  bool get _hasCompletePolygon => hasCompletePolygon;

  bool get _showCircleOverlay {
    if (_hasCompletePolygon) return false;
    if (drawTool.value == ZoneDrawTool.circle) return true;
    if (drawTool.value == ZoneDrawTool.pan && polygonPoints.isEmpty) {
      return true;
    }
    return false;
  }

  bool get showCenterPin => _showCircleOverlay;

  bool get showRadiusSlider =>
      !_hasCompletePolygon && drawTool.value != ZoneDrawTool.polygon;

  void onCameraMove(CameraPosition pos) {
    lastCameraPosition = pos;
  }

  void onCameraIdle() {
    final pos = lastCameraPosition;
    if (pos == null) return;
    if (drawTool.value == ZoneDrawTool.circle ||
        (drawTool.value == ZoneDrawTool.pan && !_hasCompletePolygon)) {
      _circleCenter = pos.target;
      _rebuildMapOverlays();
    }
  }

  void onMapTap(LatLng point) {
    if (drawTool.value != ZoneDrawTool.polygon) return;
    if (isPolygonClosed.value) return;

    if (polygonPoints.length >= 3) {
      final first = polygonPoints.first;
      final d = Geolocator.distanceBetween(
        first.latitude,
        first.longitude,
        point.latitude,
        point.longitude,
      );
      if (d < 55) {
        isPolygonClosed.value = true;
        polygonPoints.refresh();
        _rebuildMapOverlays();
        return;
      }
    }

    if (polygonPoints.length >= 50) return;
    polygonPoints.add(point);
    polygonPoints.refresh();
    _rebuildMapOverlays();
  }

  void _rebuildMapOverlays() {
    mapCircles.clear();
    mapPolygons.clear();
    mapPolylines.clear();

    if (_showCircleOverlay) {
      mapCircles.add(
        Circle(
          circleId: const CircleId('zone_circle'),
          center: _circleCenter,
          radius: circleRadiusMeters.value.toDouble(),
          fillColor: _fillColor,
          strokeColor: zoneColor.value,
          strokeWidth: 2,
        ),
      );
    }

    if (polygonPoints.isNotEmpty) {
      if (isPolygonClosed.value && polygonPoints.length >= 3) {
        mapPolygons.add(
          Polygon(
            polygonId: const PolygonId('zone_poly'),
            points: polygonPoints.toList(),
            fillColor: _fillColor,
            strokeColor: zoneColor.value,
            strokeWidth: 2,
          ),
        );
      } else {
        mapPolylines.add(
          Polyline(
            polylineId: const PolylineId('zone_line'),
            points: polygonPoints.toList(),
            color: zoneColor.value,
            width: 2,
          ),
        );
      }
    }

    mapCircles.refresh();
    mapPolygons.refresh();
    mapPolylines.refresh();

    if (polygonPoints.isEmpty) {
      mapMarkers.clear();
      mapMarkers.refresh();
    } else {
      mapMarkers.clear();
      mapMarkers.refresh();
      _schedulePolygonVertexMarkers();
    }
  }

  void _schedulePolygonVertexMarkers() {
    final gen = ++_vertexMarkerGen;
    Future<void> apply() async {
      if (gen != _vertexMarkerGen) return;
      if (polygonPoints.isEmpty) {
        mapMarkers.clear();
        mapMarkers.refresh();
        return;
      }
      try {
        if (_vertexIconSpecLoaded != _vertexIconSpec) {
          _polyFirstVertexIcon = null;
          _polyVertexIcon = null;
          _cachedVertexFill = null;
          _vertexIconSpecLoaded = _vertexIconSpec;
        }
        _polyFirstVertexIcon ??= await PolygonVertexMarkerBitmap.build(
          fill: const Color(0xFFFF9800),
          borderColor: Colors.white,
          diameterPx: 12,
          borderWidth: 1,
        );
        if (_polyVertexIcon == null || _cachedVertexFill != zoneColor.value) {
          _polyVertexIcon = await PolygonVertexMarkerBitmap.build(
            fill: zoneColor.value,
            borderColor: Colors.white,
            diameterPx: 9,
            borderWidth: 1,
          );
          _cachedVertexFill = zoneColor.value;
        }
      } catch (_) {
        return;
      }
      if (gen != _vertexMarkerGen) return;
      final next = <Marker>{};
      for (var i = 0; i < polygonPoints.length; i++) {
        final icon = i == 0 ? _polyFirstVertexIcon! : _polyVertexIcon!;
        final canCloseFromFirst = i == 0 &&
            polygonPoints.length >= 3 &&
            !isPolygonClosed.value;
        next.add(
          Marker(
            markerId: MarkerId('poly_vtx_$i'),
            position: polygonPoints[i],
            icon: icon,
            anchor: const Offset(0.5, 0.5),
            infoWindow: InfoWindow.noText,
            consumeTapEvents: canCloseFromFirst,
            onTap: canCloseFromFirst
                ? () {
                    if (drawTool.value != ZoneDrawTool.polygon) return;
                    if (isPolygonClosed.value) return;
                    if (polygonPoints.length < 3) return;
                    isPolygonClosed.value = true;
                    polygonPoints.refresh();
                    _rebuildMapOverlays();
                  }
                : null,
          ),
        );
      }
      mapMarkers.clear();
      mapMarkers.addAll(next);
      mapMarkers.refresh();
    }

    Future.microtask(apply);
  }

  LatLng _polygonCentroid(List<LatLng> pts) {
    if (pts.isEmpty) {
      return LatLng(
          AppConstants.defaultLatitude, AppConstants.defaultLongitude);
    }
    double slat = 0, slng = 0;
    for (final p in pts) {
      slat += p.latitude;
      slng += p.longitude;
    }
    return LatLng(slat / pts.length, slng / pts.length);
  }

  Future<void> lookupAddress(String postcode) async {
    try {
      isLoading.value = true;
      addressList.clear();
      final result = await _addressApi.getAddresses(
        postcode: postcode,
        page: 0,
        countryCode: 'GB',
      );
      addressList.assignAll(result);
    } catch (_) {
      addressList.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> selectPlace(String postcode, String summaryLine) async {
    try {
      final loc = await placesService.getLatLngFromPostCode(postcode);
      final latLng = LatLng(loc['lat']!, loc['lng']!);
      selectedLatLng.value = latLng;
      _circleCenter = latLng;
      displayAddress.value = summaryLine;
      mapController?.animateCamera(CameraUpdate.newLatLngZoom(latLng, 15));
      searchAddressController.value.clear();
      isClearVisible.value = false;
      addressList.clear();
      _rebuildMapOverlays();
    } catch (e) {
      AppUtils.showApiResponseMessage(e.toString());
    }
  }

  void clearSearch() {
    searchAddressController.value.clear();
    isClearVisible.value = false;
    addressList.clear();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void onSearchChanged(String v) {
    isClearVisible.value = v.trim().isNotEmpty;
  }

  void onCircleRadiusChanged(double v) {
    circleRadiusMeters.value = v.round().clamp(10, 10000);
    _rebuildMapOverlays();
  }

  void onZoneColorChanged(Color c) {
    zoneColor.value = c;
    _rebuildMapOverlays();
  }

  Future<void> _ensureAddress(LatLng center) async {
    if (displayAddress.value.trim().isNotEmpty) return;
    try {
      final marks =
          await placemarkFromCoordinates(center.latitude, center.longitude);
      if (marks.isEmpty) return;
      final p = marks.first;
      final parts = <String>[
        if ((p.street ?? '').isNotEmpty) p.street!,
        if ((p.subLocality ?? '').isNotEmpty) p.subLocality!,
        if ((p.locality ?? '').isNotEmpty) p.locality!,
        if ((p.postalCode ?? '').isNotEmpty) p.postalCode!,
        if ((p.country ?? '').isNotEmpty) p.country!,
      ];
      displayAddress.value = parts.join(', ');
    } catch (_) {}
  }

  Future<void> save() async {
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }
    if (projectId == 0) {
      AppUtils.showToastMessage('select_project'.tr);
      return;
    }

    final isPolygon = polygonPoints.length >= 3 && isPolygonClosed.value;
    late final String type;
    late final String boundaryJson;
    late final LatLng rootLatLng;

    if (isPolygon) {
      type = 'polygon';
      final list = polygonPoints
          .map((e) => {'lat': e.latitude, 'lng': e.longitude})
          .toList();
      boundaryJson = jsonEncode(list);
      rootLatLng = _polygonCentroid(polygonPoints.toList());
    } else {
      if (drawTool.value == ZoneDrawTool.polygon && !_hasCompletePolygon) {
        AppUtils.showToastMessage('polygon_min_points'.tr);
        return;
      }
      type = 'circle';
      rootLatLng = _circleCenter;
      boundaryJson = jsonEncode({
        'lat': rootLatLng.latitude,
        'lng': rootLatLng.longitude,
        'radius': circleRadiusMeters.value,
      });
    }

    await _ensureAddress(rootLatLng);

    final body = <String, dynamic>{
      'address': displayAddress.value.trim().isEmpty
          ? '${rootLatLng.latitude}, ${rootLatLng.longitude}'
          : displayAddress.value.trim(),
      'address_id': null,
      'boundary': boundaryJson,
      'color': colorToHex(zoneColor.value),
      'company_id': ApiConstants.companyId,
      'lat': rootLatLng.latitude,
      'lng': rootLatLng.longitude,
      'name': nameController.text.trim(),
      'project_id': projectId,
      'type': type,
    };
    if (editingZoneId != null) {
      body['id'] = editingZoneId;
    }

    isLoading.value = true;
    void onOk(ResponseModel rm) {
      isLoading.value = false;
      if (rm.isSuccess) {
        try {
          final response = BaseResponse.fromJson(jsonDecode(rm.result!));
          AppUtils.showApiResponseMessage(response.Message ?? '');
        } catch (_) {
          AppUtils.showApiResponseMessage(rm.statusMessage ?? '');
        }
        Get.back(result: true);
      } else {
        AppUtils.showApiResponseMessage(rm.statusMessage ?? '');
      }
    }

    void onErr(ResponseModel err) {
      isLoading.value = false;
      if (err.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
        AppUtils.showApiResponseMessage('no_internet'.tr);
      } else if (err.statusMessage != null && err.statusMessage!.isNotEmpty) {
        AppUtils.showApiResponseMessage(err.statusMessage!);
      }
    }

    if (editingZoneId != null) {
      _zoneApi.updateZone(data: body, onSuccess: onOk, onError: onErr);
    } else {
      _zoneApi.createZone(data: body, onSuccess: onOk, onError: onErr);
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    searchAddressController.value.dispose();
    projectController.value.dispose();
    super.onClose();
  }
}
