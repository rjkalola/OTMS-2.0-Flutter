import 'dart:convert';

import 'package:belcka/pages/common/drop_down_list_dialog.dart';
import 'package:belcka/pages/common/listener/DialogButtonClickListener.dart';
import 'package:belcka/pages/common/listener/select_date_listener.dart';
import 'package:belcka/pages/common/listener/select_item_listener.dart';
import 'package:belcka/pages/common/model/file_info.dart';
import 'package:belcka/pages/expense/add_expense/controller/add_expense_repository.dart';
import 'package:belcka/pages/expense/add_expense/model/expense_details_response.dart';
import 'package:belcka/pages/expense/add_expense/model/expense_info.dart';
import 'package:belcka/pages/expense/add_expense/model/expense_resources_response.dart';
import 'package:belcka/pages/manageattachment/controller/manage_attachment_controller.dart';
import 'package:belcka/pages/manageattachment/listener/select_attachment_listener.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/AlertDialogHelper.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/date_utils.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:dio/dio.dart' as multi;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddExpenseController extends GetxController
    implements
        SelectItemListener,
        SelectDateListener,
        DialogButtonClickListener,
        SelectAttachmentListener {
  final projectController = TextEditingController().obs;
  final addressController = TextEditingController().obs;
  final categoryController = TextEditingController().obs;
  final sumOfTotalController = TextEditingController().obs;
  final dateOfReceiptController = TextEditingController().obs;
  final noteController = TextEditingController().obs;

  DateTime? selectDate;

  final formKey = GlobalKey<FormState>();
  final _api = AddExpenseRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isSaveEnable = false.obs,
      isProjectDropDownEnable = true.obs;
  RxInt expenseId = 0.obs;

  final projectList = <ModuleInfo>[].obs;
  final addressList = <ModuleInfo>[].obs;
  final categoryList = <ModuleInfo>[].obs;
  int projectId = 0,
      addressId = 0,
      categoryId = 0,
      userWorkLogId = 0,
      userId = 0;
  List<String> removeFileIds = [];
  final expenseInfo = ExpenseInfo().obs;
  final title = ''.obs;
  var attachmentList = <FilesInfo>[].obs;

  ExpenseResourcesResponse? expenseResourcesData;
  bool fromNotification = false;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      expenseId.value = arguments[AppConstants.intentKey.expenseId] ?? 0;
      userId = arguments[AppConstants.intentKey.userId] ?? 0;
      userWorkLogId = arguments[AppConstants.intentKey.workLogId] ?? 0;
      projectId = arguments[AppConstants.intentKey.projectId] ?? 0;
      projectController.value.text =
          arguments[AppConstants.intentKey.projectName] ?? "";
      isProjectDropDownEnable.value = projectId == 0;
      fromNotification =
          arguments[AppConstants.intentKey.fromNotification] ?? false;
      // expenseInfo = arguments[AppConstants.intentKey.expenseInfo];
    }
    getExpenseResourcesApi();
  }

  void setInitData() {
    FilesInfo info = FilesInfo();
    attachmentList.add(info);
    if (expenseId.value != 0) {
      title.value = 'edit_expense'.tr;

      projectId = expenseInfo.value.projectId ?? 0;
      addressId = expenseInfo.value.addressId ?? 0;
      categoryId = expenseInfo.value.categoryId ?? 0;
      userId = expenseInfo.value.userId ?? 0;
      userWorkLogId = expenseInfo.value.worklogId ?? 0;

      projectController.value.text = expenseInfo.value.projectName ?? "";
      addressController.value.text = expenseInfo.value.addressName ?? "";
      categoryController.value.text = expenseInfo.value.categoryName ?? "";
      sumOfTotalController.value.text =
          (expenseInfo.value.totalAmount ?? 0).toString();
      dateOfReceiptController.value.text = expenseInfo.value.receiptDate ?? "";
      noteController.value.text = expenseInfo.value.note ?? "";

      attachmentList.addAll(expenseInfo.value.attachments ?? []);
    } else {
      title.value = 'add_expense'.tr;
      setInitialDateTime();
      isSaveEnable.value = true;
    }
  }

  void addExpenseApi() async {
    if (valid()) {
      Map<String, dynamic> map = {};
      map["user_id"] = userId;
      map["project_id"] = projectId;
      map["address_id"] = addressId;
      map["user_worklog_id"] = userWorkLogId;
      map["expense_category_id"] = categoryId;
      map["receipt_date"] = StringHelper.getText(dateOfReceiptController.value);
      map["total_amount"] = StringHelper.getText(sumOfTotalController.value);
      map["note"] = StringHelper.getText(noteController.value);

      multi.FormData formData = multi.FormData.fromMap(map);
      print("reques value:" + map.toString());

      List<String> listPhotos = [];
      for (int i = 0; i < attachmentList.length; i++) {
        if (!StringHelper.isEmptyString(attachmentList[i].imageUrl) &&
            !attachmentList[i].imageUrl!.startsWith("http")) {
          listPhotos.add(attachmentList[i].imageUrl ?? "");
        }
      }

      for (int i = 0; i < listPhotos.length; i++) {
        print("listPhotos[i]:" + listPhotos[i]);
        formData.files.add(
          MapEntry(
            "files[]",
            await multi.MultipartFile.fromFile(
              listPhotos[i],
            ),
          ),
        );
      }

      isLoading.value = true;
      _api.addExpense(
        formData: formData,
        onSuccess: (ResponseModel responseModel) {
          if (responseModel.isSuccess) {
            BaseResponse response =
                BaseResponse.fromJson(jsonDecode(responseModel.result!));
            AppUtils.showToastMessage(response.Message ?? "");
            Get.back(result: true);
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

  void editExpenseApi() async {
    if (valid()) {
      Map<String, dynamic> map = {};
      map["expense_id"] = expenseId.value;
      map["user_id"] = userId;
      map["project_id"] = projectId;
      map["address_id"] = addressId;
      if (userWorkLogId != 0) map["user_worklog_id"] = userWorkLogId;
      map["expense_category_id"] = categoryId;
      map["receipt_date"] = StringHelper.getText(dateOfReceiptController.value);
      map["total_amount"] = StringHelper.getText(sumOfTotalController.value);
      map["note"] = StringHelper.getText(noteController.value);
      map["remove_file_ids"] =
          StringHelper.getCommaSeparatedStringIds(removeFileIds);

      multi.FormData formData = multi.FormData.fromMap(map);
      print("reques value:" + map.toString());

      List<String> listPhotos = [];
      for (int i = 0; i < attachmentList.length; i++) {
        if (!StringHelper.isEmptyString(attachmentList[i].imageUrl) &&
            !attachmentList[i].imageUrl!.startsWith("http")) {
          print("URL:" + attachmentList[i].imageUrl!);
          listPhotos.add(attachmentList[i].imageUrl ?? "");
        }
      }

      for (int i = 0; i < listPhotos.length; i++) {
        formData.files.add(
          MapEntry(
            "files[]",
            await multi.MultipartFile.fromFile(
              listPhotos[i],
            ),
          ),
        );
      }

      isLoading.value = true;
      _api.editExpense(
        formData: formData,
        onSuccess: (ResponseModel responseModel) {
          if (responseModel.isSuccess) {
            BaseResponse response =
                BaseResponse.fromJson(jsonDecode(responseModel.result!));
            AppUtils.showToastMessage(response.Message ?? "");
            Get.back(result: true);
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

/*  void deleteLeaveApi() async {
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    map["user_leave_id"] = expenseInfo?.id ?? 0;
    print("map:" + map.toString());

    isLoading.value = true;
    _api.deleteLeave(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
          AppUtils.showApiResponseMessage(response.Message ?? "");
          Get.back(result: true);
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
  }*/

  void getExpenseResourcesApi() async {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    _api.getExpenseResources(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          ExpenseResourcesResponse response = ExpenseResourcesResponse.fromJson(
              jsonDecode(responseModel.result!));
          expenseResourcesData = response;

          if(expenseId.value == 0 && (response.id??0) != 0){
            projectId = response.id??0;
            projectController.value.text = response.name??"";
          }

          if (projectId != 0) {
            for (var info in expenseResourcesData!.addresses!) {
              if (info.projectId == projectId) {
                addressList.add(info);
              }
            }
          } else {
            addressList.addAll(expenseResourcesData!.addresses!);
          }

          projectList.addAll(expenseResourcesData!.projects!);
          categoryList.addAll(expenseResourcesData!.categories!);

          if (expenseId.value != 0) {
            getExpenseDetailsApi();
          } else {
            isLoading.value = false;
            isMainViewVisible.value = true;
            setInitData();
          }
        } else {
          AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
          isLoading.value = false;
        }
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          AppUtils.showApiResponseMessage('no_internet'.tr);
        }
      },
    );
  }

  void getExpenseDetailsApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    map["expense_id"] = expenseId.value;
    _api.expenseDetails(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          ExpenseDetailsResponse response = ExpenseDetailsResponse.fromJson(
              jsonDecode(responseModel.result!));
          expenseInfo.value = response.info!;
          setInitData();
        } else {
          AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
          // AppUtils.showApiResponseMessage('no_internet'.tr);
          // Utils.showApiResponseMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showApiResponseMessage(error.statusMessage ?? "");
        }
      },
    );
  }

  void deleteExpenseApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["expense_id"] = expenseId.value;
    _api.deleteExpense(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
          AppUtils.showToastMessage(response.Message ?? "");
          Get.back(result: true);
        } else {
          AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
          // AppUtils.showApiResponseMessage('no_internet'.tr);
          // Utils.showApiResponseMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showApiResponseMessage(error.statusMessage ?? "");
        }
      },
    );
  }

  bool valid() {
    return formKey.currentState!.validate();
  }

  void showSelectProjectDialog() {
    if (projectList.isNotEmpty) {
      showDropDownDialog(AppConstants.action.selectProjectDialog,
          'select_project'.tr, projectList, this);
    } else {
      AppUtils.showToastMessage('empty_data_message'.tr);
    }
  }

  void showSelectAddressDialog() {
    if (projectId != 0) {
      if (addressList.isNotEmpty) {
        showDropDownDialog(AppConstants.action.selectAddressDialog,
            'select_address'.tr, addressList, this);
      } else {
        AppUtils.showToastMessage('empty_data_message'.tr);
      }
    } else {
      AppUtils.showToastMessage('please_select_project'.tr);
    }
  }

  void showSelectCategoryDialog() {
    if (categoryList.isNotEmpty) {
      showDropDownDialog(AppConstants.action.selectCategoryDialog,
          'select_category'.tr, categoryList, this);
    } else {
      AppUtils.showToastMessage('empty_data_message'.tr);
    }
  }

  void showDropDownDialog(String dialogType, String title,
      List<ModuleInfo> list, SelectItemListener listener) {
    Get.bottomSheet(
        DropDownListDialog(
          title: title,
          dialogType: dialogType,
          list: list,
          listener: listener,
          isCloseEnable: true,
          isSearchEnable: true,
        ),
        backgroundColor: Colors.transparent,
        isScrollControlled: true);
  }

  @override
  void onSelectItem(int position, int id, String name, String action) {
    if (action == AppConstants.action.selectProjectDialog) {
      isSaveEnable.value = true;
      projectId = id;
      projectController.value.text = name;

      addressList.clear();
      for (var info in expenseResourcesData!.addresses!) {
        if (info.projectId == projectId) {
          addressList.add(info);
        }
      }

      addressId = 0;
      addressController.value.text = "";
    } else if (action == AppConstants.action.selectAddressDialog) {
      isSaveEnable.value = true;
      addressId = id;
      addressController.value.text = name;
    } else if (action == AppConstants.action.selectCategoryDialog) {
      isSaveEnable.value = true;
      categoryId = id;
      categoryController.value.text = name;
    }
  }

  void showDatePickerDialog(String dialogIdentifier, DateTime? date,
      DateTime firstDate, DateTime lastDate) {
    DateUtil.showDatePickerDialog(
        initialDate: date,
        firstDate: firstDate,
        lastDate: lastDate,
        dialogIdentifier: dialogIdentifier,
        selectDateListener: this);
  }

  @override
  void onSelectDate(DateTime date, String dialogIdentifier) {
    if (dialogIdentifier == AppConstants.dialogIdentifier.selectDate) {
      selectDate = date;
      dateOfReceiptController.value.text =
          DateUtil.dateToString(date, DateUtil.DD_MM_YYYY_SLASH);
      isSaveEnable.value = true;
    }
  }

  void setInitialDateTime() {
    DateTime currentDay = DateTime.now();
    selectDate = currentDay;
    dateOfReceiptController.value.text =
        DateUtil.dateToString(selectDate, DateUtil.DD_MM_YYYY_SLASH);
  }

  DateTime getDateOnly(DateTime inputDate) {
    return DateTime(inputDate.year, inputDate.month, inputDate.day);
  }

  onGridItemClick(int index, String action) async {
    if (action == AppConstants.action.viewPhoto) {
      if (index == 0) {
        showAttachmentOptionsDialog();
      } else {
        // var list = attachmentList.sublist(1, attachmentList.length);
        // ImageUtils.moveToImagePreview(list, index - 1);

        String fileUrl = attachmentList[index].imageUrl ?? "";
        await ImageUtils.openAttachment(
            Get.context!, fileUrl, ImageUtils.getFileType(fileUrl));
      }
    } else if (action == AppConstants.action.removePhoto) {
      isSaveEnable.value = true;
      removePhotoFromList(index: index);
    }
  }

  showAttachmentOptionsDialog() async {
    var listOptions = <ModuleInfo>[].obs;
    ModuleInfo? info;

    info = ModuleInfo();
    info.name = 'camera'.tr;
    info.action = AppConstants.attachmentType.camera;
    listOptions.add(info);

    info = ModuleInfo();
    info.name = 'gallery'.tr;
    info.action = AppConstants.attachmentType.multiImage;
    listOptions.add(info);

    info = ModuleInfo();
    info.name = 'pdf'.tr;
    info.action = AppConstants.attachmentType.pdf;
    listOptions.add(info);

    ManageAttachmentController().showAttachmentOptionsDialog(
        'select_photo_from_'.tr, listOptions, this);
  }

  @override
  void onSelectAttachment(List<String> paths, String action) {
    isSaveEnable.value = true;
    if (action == AppConstants.attachmentType.camera) {
      addPhotoToList(paths[0]);
    } else if (action == AppConstants.attachmentType.pdf) {
      for (var path in paths) {
        addPhotoToList(path);
      }
    } else if (action == AppConstants.attachmentType.multiImage) {
      for (var path in paths) {
        addPhotoToList(path);
      }
    }
  }

  addPhotoToList(String? path) {
    if (!StringHelper.isEmptyString(path)) {
      FilesInfo info = FilesInfo();
      info.imageUrl = path;
      attachmentList.add(info);
    }
  }

  removePhotoFromList({required int index}) {
    if ((attachmentList[index].id ?? 0) != 0) {
      removeFileIds.add(attachmentList[index].id.toString());
    }
    attachmentList.removeAt(index);
  }

  showRemoveDialog() async {
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
      Get.back();
      deleteExpenseApi();
    }
  }

  void onBackPress() {
    if (fromNotification) {
      Get.offAllNamed(AppRoutes.dashboardScreen);
    } else {
      Get.back();
    }
  }
}
