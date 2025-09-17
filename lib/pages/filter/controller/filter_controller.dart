import 'dart:convert';

import 'package:belcka/pages/filter/controller/filter_repository.dart';
import 'package:belcka/pages/filter/model/filter_info.dart';
import 'package:belcka/pages/filter/model/filters_list_response.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:get/get.dart';

import '../../../utils/app_constants.dart';

class FilterController extends GetxController {
  final _api = FilterRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;

  final sections = <FilterInfo>[].obs;
  var selectedSectionIndex = 0.obs;
  var searchQuery = ''.obs;
  String filterType = "";

  List<FilterInfo> tempList = [];

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      filterType = arguments[AppConstants.intentKey.filterType] ?? "";
    }
    getFilters();
  }

  void toggleItemSelection(int sectionIndex, int itemIndex) {
    final item = sections[sectionIndex].data![itemIndex];
    item.selected = !(item.selected ?? false);
    sections.refresh();
  }

  void clearAll() {
    for (var section in sections) {
      for (var item in section.data!) {
        item.selected = false;
      }
    }
    sections.refresh();
  }

  void applyExistingFilters(Map<String, String> filtersFromAPI) {
    for (final section in sections) {
      final key = section.key;
      print("key:" + key!);
      if (filtersFromAPI.containsKey(key)) {
        final selectedIds = filtersFromAPI[key]!
            .split(',')
            .map((e) => e)
            .where((e) => e != null)
            .toSet();

        for (var item in section.data!) {
          if (filterType == AppConstants.filterType.timesheetFilter) {
            item.selected = selectedIds
                .contains(key == "day" ? item.key : item.id.toString());
          } else {
            item.selected = selectedIds.contains(item.id.toString());
          }
        }
      } else {
        // No previous values — unselect all
        for (var item in section.data!) {
          item.selected = false;
        }
      }
    }
    sections.refresh(); // Refresh UI
  }

  List<FilterInfo> get filteredItems {
    final section = sections[selectedSectionIndex.value];
    return section.data!
        .where((item) =>
            item.name!.toLowerCase().contains(searchQuery.value.toLowerCase()))
        .toList();
  }

  int getSelectedCount(int sectionIndex) {
    return sections[sectionIndex]
        .data!
        .where((item) => (item.selected ?? false))
        .length;
  }

  Map<String, String> getSelectedFiltersAsMap() {
    final result = <String, String>{};
    for (final section in sections) {
      List<String> selectedIds = [];
      if (filterType == AppConstants.filterType.timesheetFilter) {
        selectedIds = section.data!
            .where((item) => (item.selected ?? false))
            .map((item) =>
                section.key == "day" ? item.key.toString() : item.id.toString())
            .toList();
      } else {
        selectedIds = section.data!
            .where((item) => (item.selected ?? false))
            .map((item) => item.id.toString())
            .toList();
      }
      if (selectedIds.isNotEmpty) {
        result[section.key!] = selectedIds.join(',');
      }
    }
    return result;
  }

  void getFilters() async {
    String url = "";
    if (filterType == AppConstants.filterType.myRequestFilter) {
      url = ApiConstants.getRequestFilters;
    } else if (filterType == AppConstants.filterType.timesheetFilter) {
      url = ApiConstants.getTimesheetFilters;
    }
    Map<String, dynamic> map = {};
    isLoading.value = true;
    _api.getFilters(
      url: url,
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          FiltersListResponse response =
              FiltersListResponse.fromJson(jsonDecode(responseModel.result!));

          tempList.clear();
          tempList.addAll(response.info ?? []);

          sections.value = tempList;
          sections.refresh();

          // final filterData = Get.arguments as Map<String, String>?;
          var arguments = Get.arguments;
          final filterData = arguments[AppConstants.intentKey.filterData];
          if (filterData != null) {
            applyExistingFilters(filterData);
          }

          isMainViewVisible.value = true;
        } else {
          AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          AppUtils.showApiResponseMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showApiResponseMessage(error.statusMessage);
        }
      },
    );
  }
}
