import 'dart:convert';

import 'package:get/get.dart';
import 'package:otm_inventory/pages/filter/controller/filter_repository.dart';
import 'package:otm_inventory/pages/filter/model/filter_item_model.dart';
import 'package:otm_inventory/pages/filter/model/filter_section_model.dart';
import 'package:otm_inventory/pages/filter/model/filters_list_response.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/user_utils.dart';
import 'package:otm_inventory/web_services/api_constants.dart';
import 'package:otm_inventory/web_services/response/response_model.dart';

class FilterController extends GetxController {
  final _api = FilterRepository();
  RxBool isLoading = false.obs, isInternetNotAvailable = false.obs, isMainViewVisible = false.obs;

  final sections = <FilterSection>[].obs;
  var selectedSectionIndex = 0.obs;
  var searchQuery = ''.obs;

  List<FilterSection> tempList = [];

  void toggleItemSelection(int sectionIndex, int itemIndex) {
    final item = sections[sectionIndex].data[itemIndex];
    item.selected = !item.selected;
    sections.refresh();
  }
  void clearAll() {
    for (var section in sections) {
      for (var item in section.data) {
        item.selected = false;
      }
    }
    sections.refresh();
  }
  void applyExistingFilters(Map<String, String> filtersFromAPI) {
    for (final section in sections) {
      final key = section.key;
      if (filtersFromAPI.containsKey(key)) {
        final selectedIds = filtersFromAPI[key]!
            .split(',')
            .map((e) => int.tryParse(e))
            .where((e) => e != null)
            .toSet();

        for (var item in section.data) {
          item.selected = selectedIds.contains(item.id);
        }
      } else {
        // No previous values — unselect all
        for (var item in section.data) {
          item.selected = false;
        }
      }
    }
    sections.refresh(); // Refresh UI
  }
  List<FilterItem> get filteredItems {
    final section = sections[selectedSectionIndex.value];
    return section.data
        .where((item) => item.name.toLowerCase().contains(searchQuery.value.toLowerCase()))
        .toList();
  }
  int getSelectedCount(int sectionIndex) {
    return sections[sectionIndex]
        .data
        .where((item) => item.selected)
        .length;
  }

  Map<String, String> getSelectedFiltersAsMap() {
    final result = <String, String>{};
    for (final section in sections) {
      final selectedIds = section.data
          .where((item) => item.selected)
          .map((item) => item.id.toString())
          .toList();
      if (selectedIds.isNotEmpty) {
        result[section.key] = selectedIds.join(',');
      }
    }
    return result;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    isMainViewVisible.value = false;
    getRequestFilters();
  }
  void getRequestFilters() async {
    Map<String, dynamic> map = {};
    isLoading.value = true;
    _api.getRequestFilters(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {

          FiltersListResponse response =
          FiltersListResponse.fromJson(jsonDecode(responseModel.result!));

          tempList.clear();
          tempList.addAll(response.info ?? []);

          sections.value = tempList;
          sections.refresh();

          final filterData = Get.arguments as Map<String, String>?;
          if (filterData != null) {
            applyExistingFilters(filterData);
          }

          isMainViewVisible.value = true;
        }
        else{
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