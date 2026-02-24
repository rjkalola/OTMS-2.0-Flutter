import 'dart:async';
import 'dart:convert';

import 'package:belcka/pages/common/listener/DialogButtonClickListener.dart';
import 'package:belcka/pages/common/listener/menu_item_listener.dart';
import 'package:belcka/pages/common/menu_items_list_bottom_dialog.dart';
import 'package:belcka/pages/manageattachment/listener/download_file_listener.dart';
import 'package:belcka/pages/payment_documents/add_invoice/model/invoice_date_info.dart';
import 'package:belcka/pages/payment_documents/add_payslip/model/payslip_date_info.dart';
import 'package:belcka/pages/payment_documents/payment_documents/controller/payment_documents_repository.dart';
import 'package:belcka/pages/payment_documents/payment_documents/model/download_document_response.dart';
import 'package:belcka/pages/payment_documents/payment_documents/model/invoices_list_response.dart';
import 'package:belcka/pages/payment_documents/payment_documents/model/payments_info.dart';
import 'package:belcka/pages/payment_documents/payment_documents/model/payments_list_response.dart';
import 'package:belcka/pages/payment_documents/payment_documents/model/payslips_list_response.dart';
import 'package:belcka/utils/AlertDialogHelper.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../manageattachment/controller/download_controller.dart';

class PaymentDocumentsController extends GetxController
    implements
        MenuItemListener,
        DialogButtonClickListener,
        DownloadFileListener {
  final _api = PaymentDocumentsRepository();
  final searchController = TextEditingController().obs;
  final downloadController = Get.put(DownloadController());
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isDataUpdated = false.obs,
      isResetEnable = false.obs,
      isSearchEnable = false.obs,
      isClearSearch = false.obs,
      isDownloadEnable = false.obs,
      isDeleteEnable = false.obs,
      isCheckAll = false.obs;

  RxInt invoicesCount = 0.obs,
      paymentsCount = 0.obs,
      payslipsCount = 0.obs,
      selectedDateFilterIndex = (1).obs;

  RxString selectedFilter = AppConstants.action.invoices.obs;

  String filterPerDay = "", startDate = "", endDate = "";
  int userId = UserUtils.getLoginUserId();

  //Home Tab
  final selectedActionButtonPagerPosition = 0.obs;
  final dashboardActionButtonsController = PageController(
    initialPage: 0,
  );

  final listInvoices = <InvoiceDateInfo>[].obs;
  final tempInvoices = <InvoiceDateInfo>[].obs;

  final listPayslips = <PayslipDateInfo>[].obs;
  final tempPayslips = <PayslipDateInfo>[].obs;

  final listPayments = <PaymentsInfo>[].obs;
  final tempPayments = <PaymentsInfo>[].obs;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      userId = arguments[AppConstants.intentKey.userId] ?? 0;
      selectedFilter.value = arguments[AppConstants.intentKey.documentType] ??
          AppConstants.action.invoices;
    }
    loadData(true);
  }

  void loadData(bool isProgress) async {
    resetSelectedItems();
    if (selectedFilter.value == AppConstants.action.invoices) {
      getInvoicesApi(isProgress);
    } else if (selectedFilter.value == AppConstants.action.payments) {
      getPayments(isProgress);
    } else if (selectedFilter.value == AppConstants.action.payslips) {
      getPayslipsApi(isProgress);
    }
  }

  void onTabChange(String action) {
    resetSelectedItems();
    selectedFilter.value = action;
    loadData(true);
  }

  void resetSelectedItems() {
    isDownloadEnable.value = false;
    isDeleteEnable.value = false;
    unCheckAll();
  }

  void getPayslipsApi(bool isProgress) {
    isLoading.value = isProgress;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    map["user_id"] = userId;
    map["start_date"] = startDate;
    map["end_date"] = endDate;

    _api.getPayslips(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          PayslipsListResponse response =
              PayslipsListResponse.fromJson(jsonDecode(responseModel.result!));
          tempPayslips.clear();
          tempPayslips.addAll(response.info ?? []);
          listPayslips.value = tempPayslips;
          listPayslips.refresh();
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

  void getInvoicesApi(bool isProgress) {
    isLoading.value = isProgress;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    map["user_id"] = userId;
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

  void getPayments(bool isProgress) {
    isLoading.value = isProgress;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    map["user_id"] = userId;
    map["start_date"] = startDate;
    map["end_date"] = endDate;

    _api.getPayments(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          PaymentsListResponse response =
              PaymentsListResponse.fromJson(jsonDecode(responseModel.result!));
          tempPayments.clear();
          tempPayments.addAll(response.info ?? []);
          listPayments.value = tempPayments;
          listPayments.refresh();
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

  void deleteDocumentApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["ids"] = StringHelper.getCommaSeparatedIntListIds(getCheckedIds());

    String url = "";
    if (selectedFilter.value == AppConstants.action.invoices) {
      url = ApiConstants.invoiceDelete;
    } else if (selectedFilter.value == AppConstants.action.payslips) {
      url = ApiConstants.payslipsDelete;
    }

    _api.deleteDocument(
      data: map,
      url: url,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
          AppUtils.showSnackBarMessage(response.Message ?? "");
          loadData(true);
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? "");
        }
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

  void downloadDocumentApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["ids"] = getCheckedIds();

    String url = "";
    if (selectedFilter.value == AppConstants.action.invoices) {
      url = ApiConstants.invoiceZip;
    } else if (selectedFilter.value == AppConstants.action.payslips) {
      url = ApiConstants.payslipsZip;
    }

    _api.downloadDocument(
      data: map,
      url: url,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isLoading.value = false;
          DownloadDocumentResponse response = DownloadDocumentResponse.fromJson(
              jsonDecode(responseModel.result!));
          if (response.data != null &&
              !StringHelper.isEmptyString(response.data!.url)) {
            String url = response.data?.url ?? "";
            print("url:::::" + url ?? "");
            print("url name:::::" + ImageUtils.getFileNameFromUrl(url ?? ""));
            if (!StringHelper.isEmptyString(url)) {
              downloadController.isDownloading.value
                  ? null
                  : downloadController.downloadFile(
                      url, ImageUtils.getFileNameFromUrl(url ?? ""),
                      downloadSuccessMessage: "", listener: this);
            }
          }
          // AppUtils.showSnackBarMessage(response.Message ?? "");
          // loadData(true);
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? "");
        }
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

  void onBackPress() {
    Get.back(result: isDataUpdated.value);
  }

  Future<void> moveToScreen(String rout, dynamic arguments) async {
    var result = await Get.toNamed(rout, arguments: arguments);
    if (result != null && result) {
      isDataUpdated.value = true;
      loadData(true);
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
    listItems.add(
        ModuleInfo(name: 'download'.tr, action: AppConstants.action.download));
    if (UserUtils.isAdmin()) {
      listItems.add(
          ModuleInfo(name: 'delete'.tr, action: AppConstants.action.delete));
    }
    showCupertinoModalPopup(
      context: context,
      builder: (_) =>
          MenuItemsListBottomDialog(list: listItems, listener: this),
    );
  }

  @override
  void onSelectMenuItem(ModuleInfo info, String dialogType) {
    bool isDataAvailable = false;
    if (selectedFilter.value == AppConstants.action.invoices &&
        listInvoices.isNotEmpty) {
      isDataAvailable = true;
    } else if (selectedFilter.value == AppConstants.action.payslips &&
        listPayslips.isNotEmpty) {
      isDataAvailable = true;
    }

    if(isDataAvailable){
      if (info.action == AppConstants.action.download) {
        isDownloadEnable.value = true;
      } else if (info.action == AppConstants.action.delete) {
        isDeleteEnable.value = true;
      }
    }else{
      AppUtils.showToastMessage('empty_data_message'.tr);
    }

  }

  showDeleteDialog() async {
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
      deleteDocumentApi();
      Get.back();
    }
  }

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

  void checkSelectAll() {
    bool isAllSelected = true;

    if (selectedFilter.value == AppConstants.action.invoices) {
      for (var info in listInvoices) {
        for (var data in info.data!) {
          if (!(data.isCheck ?? false)) {
            isAllSelected = false;
            break;
          }
        }
        if (!isAllSelected) break;
      }
    } else if (selectedFilter.value == AppConstants.action.payslips) {
      for (var info in listPayslips) {
        for (var data in info.data!) {
          if (!(data.isCheck ?? false)) {
            isAllSelected = false;
            break;
          }
        }
        if (!isAllSelected) break;
      }
    }

    isCheckAll.value = isAllSelected;
  }

  void checkAll() {
    isCheckAll.value = true;

    if (selectedFilter.value == AppConstants.action.invoices) {
      for (var info in listInvoices) {
        for (var data in info.data!) {
          data.isCheck = true;
        }
      }
      listInvoices.refresh();
    } else if (selectedFilter.value == AppConstants.action.payslips) {
      for (var info in listPayslips) {
        for (var data in info.data!) {
          data.isCheck = true;
        }
      }
      listPayslips.refresh();
    }
  }

  void unCheckAll() {
    isCheckAll.value = false;
    if (selectedFilter.value == AppConstants.action.invoices) {
      for (var info in listInvoices) {
        for (var data in info.data!) {
          data.isCheck = false;
        }
      }
      listInvoices.refresh();
    } else if (selectedFilter.value == AppConstants.action.payslips) {
      for (var info in listPayslips) {
        for (var data in info.data!) {
          data.isCheck = false;
        }
      }
      listPayslips.refresh();
    }
  }

  List<int> getCheckedIds() {
    var listCheckedIds = <int>[];
    if (selectedFilter.value == AppConstants.action.invoices) {
      for (var info in listInvoices) {
        for (var data in info.data!) {
          if (data.isCheck ?? false) {
            listCheckedIds.add(data.id ?? 0);
          }
        }
      }
    } else if (selectedFilter.value == AppConstants.action.payslips) {
      for (var info in listPayslips) {
        for (var data in info.data!) {
          if (data.isCheck ?? false) {
            listCheckedIds.add(data.id ?? 0);
          }
        }
      }
    }
    return listCheckedIds;
  }

  void onClickDelete() {
    if (getCheckedIds().isNotEmpty) {
      showDeleteDialog();
    } else {
      AppUtils.showToastMessage('msg_empty_selected_document'.tr);
    }
  }

  void onClickDownload() {
    if (getCheckedIds().isNotEmpty) {
      downloadDocumentApi();
    } else {
      AppUtils.showToastMessage('msg_empty_selected_document'.tr);
    }
  }

  @override
  void afterDownload({required String filaPath, required String action}) {
    AppUtils.showToastMessage('file_downloaded'.tr);
    resetSelectedItems();
    print("filaPath:::::" + filaPath);
  }

  @override
  void onDownload({required int progress, required String action}) {
    print("progress:::::" + progress.toString());
  }

  void clearSearch() {
    searchController.value.clear();
    // searchTradeRecords("");
    // searchCheckInRecords("");
  }
}
