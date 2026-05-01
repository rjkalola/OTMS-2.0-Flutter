import 'package:belcka/buyer_app/generate_report/controller/generate_report_repository.dart';
import 'package:belcka/buyer_app/generate_report/model/generate_report_modules_response.dart';
import 'package:belcka/buyer_app/generate_report/view/generate_report_export_bottom_sheet.dart';
import 'package:belcka/pages/common/drop_down_multi_selection_list_dialog.dart';
import 'package:belcka/pages/common/listener/select_date_range_listener.dart';
import 'package:belcka/pages/common/listener/select_multi_item_listener.dart';
import 'package:belcka/pages/common/widgets/download_result_bottom_sheet.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/date_utils.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GenerateReportController extends GetxController
    implements SelectDateRangeListener, SelectMultiItemListener {
  final _api = GenerateReportRepository();

  final isLoading = false.obs;
  final isInternetNotAvailable = false.obs;
  final isExporting = false.obs;
  final exportProgress = 0.obs;

  GenerateReportModulesResponse? modulesData;
  bool get isModulesLoaded => modulesData != null;

  static const List<MapEntry<String, String>> reportTypes = [
    MapEntry('project', 'project_report'),
    MapEntry('address', 'address_report'),
    MapEntry('store', 'store_report'),
    MapEntry('supplier', 'supplier_report'),
    MapEntry('user', 'user_report'),
    MapEntry('trade', 'trade_report'),
    MapEntry('team', 'team_report'),
    MapEntry('item', 'item_report'),
  ];

  final sheetTitle = ''.obs;
  final sheetReportTypeKey = ''.obs;
  final sheetStartDate = ''.obs;
  final sheetEndDate = ''.obs;
  final sheetModuleDisplayText = ''.obs;
  final sheetSelectedIds = <int>[].obs;
  final lastDownloadedPath = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchModules();
  }

  void fetchModules() {
    isLoading.value = true;
    _api.getModules(
      queryParameters: {'company_id': ApiConstants.companyId},
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess && responseModel.result != null) {
          modulesData = _api.parseModulesResponse(responseModel.result);
          isInternetNotAvailable.value = false;
        } else {
          AppUtils.showApiResponseMessage(responseModel.statusMessage ?? '');
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
        } else if (!StringHelper.isEmptyString(error.statusMessage)) {
          AppUtils.showApiResponseMessage(error.statusMessage ?? '');
        }
      },
    );
  }

  void openExportSheet(String reportTypeKey, String titleTranslationKey) {
    if (modulesData == null) {
      AppUtils.showToastMessage('empty_data_message'.tr);
      return;
    }
    final list = modulesData!.listForReportType(reportTypeKey);
    if (list.isEmpty) {
      AppUtils.showToastMessage('empty_data_message'.tr);
      return;
    }
    sheetReportTypeKey.value = reportTypeKey;
    sheetTitle.value = titleTranslationKey.tr;
    final end = DateTime.now();
    final start = end.subtract(const Duration(days: 7));
    sheetStartDate.value =
        DateUtil.dateToString(start, DateUtil.DD_MM_YYYY_SLASH);
    sheetEndDate.value = DateUtil.dateToString(end, DateUtil.DD_MM_YYYY_SLASH);
    sheetModuleDisplayText.value = '';
    sheetSelectedIds.clear();

    Get.bottomSheet(
      GenerateReportExportBottomSheet(controller: this),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void pickDateRange() {
    final start = DateUtil.stringToDate(
            sheetStartDate.value, DateUtil.DD_MM_YYYY_SLASH) ??
        DateTime.now().subtract(const Duration(days: 7));
    final end = DateUtil.stringToDate(
            sheetEndDate.value, DateUtil.DD_MM_YYYY_SLASH) ??
        DateTime.now();
    AppUtils.setStatusBarColor();
    DateUtil.showDateRangeDialog(
      initialFirstDate: start,
      initialLastDate: end,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      dialogIdentifier: AppConstants.dialogIdentifier.generateReportDateRange,
      listener: this,
    );
  }

  void showModulesDialog() {
    if (modulesData == null) return;
    final key = sheetReportTypeKey.value;
    final base = modulesData!.listForReportType(key);
    if (base.isEmpty) {
      AppUtils.showToastMessage('empty_data_message'.tr);
      return;
    }
    final list = <ModuleInfo>[];
    final selected = sheetSelectedIds.toList();
    for (final m in base) {
      final id = m.id ?? 0;
      list.add(ModuleInfo(
        id: m.id,
        name: m.name,
        check: id > 0 && selected.contains(id),
      ));
    }
    Get.bottomSheet(
      DropDownMultiSelectionListDialog(
        title: getSelectModuleTitle(key),
        dialogType: AppConstants.dialogIdentifier.generateReportModules,
        list: list,
        listener: this,
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  List<int> _idsForExport(List<ModuleInfo> picked) {
    return picked
        .map((e) => e.id ?? 0)
        .where((id) => id > 0)
        .toList();
  }

  String getSelectModuleTitle(String reportTypeKey) {
    switch (reportTypeKey) {
      case 'project':
        return 'Select Projects';
      case 'address':
        return 'Select Addresses';
      case 'store':
        return 'Select Stores';
      case 'supplier':
        return 'Select Suppliers';
      case 'user':
        return 'Select Users';
      case 'trade':
        return 'Select Trades';
      case 'team':
        return 'Select Teams';
      case 'item':
        return 'Select Items';
      default:
        return 'Select Modules';
    }
  }

  String _getSelectedCountText(String reportTypeKey, int count) {
    String singular;
    String plural;
    switch (reportTypeKey) {
      case 'project':
        singular = 'Project';
        plural = 'Projects';
        break;
      case 'address':
        singular = 'Address';
        plural = 'Addresses';
        break;
      case 'store':
        singular = 'Store';
        plural = 'Stores';
        break;
      case 'supplier':
        singular = 'Supplier';
        plural = 'Suppliers';
        break;
      case 'user':
        singular = 'User';
        plural = 'Users';
        break;
      case 'trade':
        singular = 'Trade';
        plural = 'Trades';
        break;
      case 'team':
        singular = 'Team';
        plural = 'Teams';
        break;
      case 'item':
        singular = 'Item';
        plural = 'Items';
        break;
      default:
        singular = 'Module';
        plural = 'Modules';
        break;
    }
    final label = count == 1 ? singular : plural;
    return '$count $label Selected';
  }

  @override
  void onSelectMultiItem(List<ModuleInfo> tempList, String action) {
    if (action != AppConstants.dialogIdentifier.generateReportModules) return;
    final picked = <ModuleInfo>[];
    for (final m in tempList) {
      if (m.check ?? false) {
        picked.add(m);
      }
    }
    if (picked.isEmpty) {
      sheetModuleDisplayText.value = '';
      sheetSelectedIds.clear();
      return;
    }
    final ids = _idsForExport(picked);
    sheetSelectedIds.assignAll(ids);
    sheetModuleDisplayText.value =
        _getSelectedCountText(sheetReportTypeKey.value, ids.length);
  }

  @override
  void onSelectDateRange(
      DateTime startDate, DateTime endDate, String dialogIdentifier) {
    if (dialogIdentifier ==
        AppConstants.dialogIdentifier.generateReportDateRange) {
      sheetStartDate.value =
          DateUtil.dateToString(startDate, DateUtil.DD_MM_YYYY_SLASH);
      sheetEndDate.value =
          DateUtil.dateToString(endDate, DateUtil.DD_MM_YYYY_SLASH);
    }
  }

  Future<void> exportReport() async {
    if (sheetSelectedIds.isEmpty) {
      AppUtils.showToastMessage('please_select_modules'.tr);
      return;
    }
    final idStr =
        StringHelper.getCommaSeparatedIntListIds(sheetSelectedIds.toList());
    if (StringHelper.isEmptyString(idStr)) {
      AppUtils.showToastMessage('please_select_modules'.tr);
      return;
    }

    Get.back();
    isExporting.value = true;
    exportProgress.value = 0;
    final typeKey = sheetReportTypeKey.value;
    final fileName =
        'report_${typeKey}_${DateTime.now().millisecondsSinceEpoch}.xlsx';
    try {
      final downloadedPath = await _api.downloadExportReport(
        startDate: sheetStartDate.value,
        endDate: sheetEndDate.value,
        reportType: typeKey,
        moduleIds: idStr,
        fileName: fileName,
        onProgress: (p) => exportProgress.value = p,
      );
      lastDownloadedPath.value = downloadedPath;
      // AppUtils.showToastMessage('file_downloaded'.tr);
      _showViewDocumentDialog(downloadedPath);
    } catch (e) {
      AppUtils.showToastMessage('download_failed'.tr);
    } finally {
      isExporting.value = false;
    }
  }

  void _showViewDocumentDialog(String filePath) {
    Get.bottomSheet(
      DownloadResultBottomSheet(
        filePath: filePath,
        onClose: () => Get.back(),
        onViewFile: () async {
          Get.back();
          final context = Get.context;
          if (context == null) return;
          await ImageUtils.openAttachment(
            context,
            filePath,
            ImageUtils.getFileType(filePath),
          );
        },
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  void onBackPress() {
    Get.back();
    Future.microtask(() {
      if (Get.isRegistered<GenerateReportController>()) {
        Get.delete<GenerateReportController>(force: true);
      }
    });
  }
}
