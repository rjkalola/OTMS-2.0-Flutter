import 'dart:async';
import 'dart:convert';

import 'package:belcka/pages/common/listener/DialogButtonClickListener.dart';
import 'package:belcka/pages/common/listener/menu_item_listener.dart';
import 'package:belcka/pages/common/menu_items_list_bottom_dialog.dart';
import 'package:belcka/pages/payment_documents/add_invoice/model/invoice_date_info.dart';
import 'package:belcka/pages/payment_documents/payment_documents/controller/payment_documents_repository.dart';
import 'package:belcka/pages/payment_documents/payment_documents/model/invoices_list_response.dart';
import 'package:belcka/pages/project/project_details/model/project_detals_item.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/AlertDialogHelper.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class PaymentDocumentsController extends GetxController
    implements MenuItemListener, DialogButtonClickListener {
  final _api = PaymentDocumentsRepository();
  final searchController = TextEditingController().obs;

  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isDataUpdated = false.obs,
      isResetEnable = false.obs,
      isSearchEnable = false.obs,
      isClearSearch = false.obs;

  RxInt invoicesCount = 0.obs,
      paymentsCount = 0.obs,
      payslipsCount = 0.obs,
      selectedDateFilterIndex = (1).obs;

  RxString selectedFilter = AppConstants.action.invoices.obs;
  final selectedIndex = 0.obs;
  late final PageController pageController;

  String filterPerDay = "", startDate = "", endDate = "";
  int userId = UserUtils.getLoginUserId();

  //Home Tab
  final selectedActionButtonPagerPosition = 0.obs;
  final dashboardActionButtonsController = PageController(
    initialPage: 0,
  );

  final listInvoices = <InvoiceDateInfo>[].obs;
  final tempInvoices = <InvoiceDateInfo>[].obs;

  // final listTrades = <CheckLogInfo>[].obs;
  // final tempTrades = <CheckLogInfo>[].obs;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: selectedIndex.value);
    var arguments = Get.arguments;
    if (arguments != null) {
      // addressInfo = arguments[AppConstants.intentKey.addressInfo];
      // addressId = addressInfo?.id ?? 0;
      // projectId = addressInfo?.projectId ?? 0;
    }
    loadData(true);
  }

  void loadData(bool isProgress) async {
    getInvoicesApi(isProgress);
  }

  void getInvoicesApi(bool isProgress) {
    isLoading.value = isProgress;
    // isMainViewVisible.value = false;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    // map["user_id"] = userId;
    // map["start_date"] = !StringHelper.isEmptyString(startDate)
    //     ? DateUtil.changeDateFormat(
    //         startDate, DateUtil.DD_MM_YYYY_SLASH, DateUtil.YYYY_MM_DD_DASH)
    //     : "";
    // map["end_date"] = !StringHelper.isEmptyString(endDate)
    //     ? DateUtil.changeDateFormat(
    //         endDate, DateUtil.DD_MM_YYYY_SLASH, DateUtil.YYYY_MM_DD_DASH)
    //     : "";
    map["start_date"] = startDate;
    map["end_date"] = endDate;

    _api.getInvoices(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          InvoicesListResponse response =
              InvoicesListResponse.fromJson(jsonDecode(responseModel.result!));
          tempInvoices.clear();
          tempInvoices.addAll(response.info ?? []);
          listInvoices.value = tempInvoices;
          listInvoices.refresh();
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
          // AppUtils.showSnackBarMessage('no_internet'.tr);
          // Utils.showSnackBarMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage ?? "");
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int index) {
    selectedIndex.value = index;
    print("selectedIndex.value:${selectedIndex.value}");
  }

  void onItemTapped(int index) {
    pageController.jumpToPage(index);
  }

  void onBackPress() {
    Get.back(result: isDataUpdated.value);
  }

  Future<void> moveToScreen(String rout, dynamic arguments) async {
    var result = await Get.toNamed(rout, arguments: arguments);
    if (result != null && result) {
      isDataUpdated.value = true;
      // getAddressDetailsApi();
    }
  }

  void clearFilter() {
    isResetEnable.value = false;
    filterPerDay = "";
    startDate = "";
    endDate = "";
    selectedDateFilterIndex.value = -1;
    isSearchEnable.value = false;
    clearSearch();
    // loadAddressDetailsData(true);
  }

  void showMenuItemsDialog(BuildContext context) {
    List<ModuleInfo> listItems = [];
    if (UserUtils.isAdmin()) {
      listItems.add(ModuleInfo(
          name: 'archive_address'.tr,
          action: AppConstants.action.archiveProject));
      listItems.add(ModuleInfo(
          name: 'delete_address'.tr, action: AppConstants.action.delete));
      listItems.add(ModuleInfo(
          name: 'edit_address'.tr, action: AppConstants.action.edit));
      listItems.add(ModuleInfo(
          name: 'change_progress'.tr, action: AppConstants.action.inProgress));
    }
    showCupertinoModalPopup(
      context: context,
      builder: (_) =>
          MenuItemsListBottomDialog(list: listItems, listener: this),
    );
  }

  @override
  void onSelectMenuItem(ModuleInfo info, String dialogType) {
    if (info.action == AppConstants.action.archiveProject) {
      // archiveAddressApi();
    } else if (info.action == AppConstants.action.delete) {
      showDeleteTeamDialog();
    } else if (info.action == AppConstants.action.edit) {
      // var arguments = {
      //   AppConstants.intentKey.addressDetailsInfo: addressDetailsInfo
      // };
      // moveToScreen(AppRoutes.addAddressScreen, arguments);
    } else if (info.action == AppConstants.action.inProgress) {
      // openBottomSheet(Get.context!);
    }
  }

  void onSelectAddressFilter(String action, bool isProgress) {
    // clearFilter();
    if (action == AppConstants.action.checkIn) {
      // getProjectCheckLogsApi(isProgress);
    } else if (action == AppConstants.action.trades) {
      // getProjectTradeRecordsApi(isProgress);
    }
  }

  showDeleteTeamDialog() async {
    AlertDialogHelper.showAlertDialog(
        "",
        'are_you_sure_you_want_to_delete'.tr,
        'yes'.tr,
        'no'.tr,
        "",
        true,
        false,
        this,
        AppConstants.dialogIdentifier.delete);
  }

  @override
  void onNegativeButtonClicked(String dialogIdentifier) {
    Get.back();
  }

  @override
  void onOtherButtonClicked(String dialogIdentifier) {}

  @override
  void onPositiveButtonClicked(String dialogIdentifier) {
    if (dialogIdentifier == AppConstants.dialogIdentifier.delete) {
      // deleteAddressApi();
      Get.back();
    }
  }

  final List<ProjectDetalsItem> items = [
    ProjectDetalsItem(
        title: 'check_in_'.tr,
        subtitle: '',
        iconPath: Drawable.clockIcon,
        iconColor: "#000000",
        flagName: "Check-In"),
    ProjectDetalsItem(
        title: 'materials'.tr,
        subtitle: '',
        iconPath: Drawable.poundIcon,
        iconColor: "#000000",
        flagName: "Materials"),
    ProjectDetalsItem(
        title: 'trades'.tr,
        subtitle: '',
        iconPath: Drawable.tradesPermissionIcon,
        iconColor: "#000000",
        flagName: "Trades"),
    ProjectDetalsItem(
        title: 'documents'.tr,
        subtitle: '',
        iconPath: Drawable.todoPermissionIcon,
        iconColor: "#000000",
        flagName: "Documents"),
  ];

  Future<void> searchItems(String value) async {
    // if(selectedFilter.value == AppConstants.action.trades){
    //   searchTradeRecords(value);
    // }else {
    //   print("searchItems");
    //   listCheckInRecords.value = tempCheckInRecords;
    //   listCheckInRecords.refresh();
    // }
    // selectedFilter.value == AppConstants.action.trades
    //     ? searchTradeRecords(value)
    //     : searchCheckInRecords(value);
  }

  // Future<void> searchTradeRecords(String value) async {
  //   print(value);
  //   List<CheckLogInfo> results = [];
  //   if (value.isEmpty) {
  //     results = tempTrades;
  //   } else {
  //     results = tempTrades
  //         .where((element) => (!StringHelper.isEmptyString(element.userName) &&
  //             element.userName!.toLowerCase().contains(value.toLowerCase())))
  //         .toList();
  //   }
  //   listTrades.value = results;
  // }
  //
  // Future<void> searchCheckInRecords(String value) async {
  //   print("searchCheckInRecords value: $value");
  //
  //   // If search text is empty, restore full list
  //   if (value.isEmpty) {
  //     listCheckInRecords.value = List.from(tempCheckInRecords);
  //     return;
  //   }
  //
  //   // Otherwise, filter nested data safely
  //   final results = tempCheckInRecords
  //       .map((record) {
  //         final filteredLogs = (record.data ?? []).where((log) {
  //           final name = log.userName?.toLowerCase() ?? '';
  //           return name.contains(value.toLowerCase());
  //         }).toList();
  //
  //         // Return a new object (don’t mutate the original one)
  //         return CheckInRecordsInfo(
  //           date: record.date,
  //           data: filteredLogs,
  //         );
  //       })
  //       .where((r) => r.data?.isNotEmpty ?? false)
  //       .toList();
  //
  //   listCheckInRecords.value = results;
  // }

  void clearSearch() {
    searchController.value.clear();
    // searchTradeRecords("");
    // searchCheckInRecords("");
  }
}
