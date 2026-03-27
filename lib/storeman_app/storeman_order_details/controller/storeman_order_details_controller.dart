import 'dart:convert';

import 'package:belcka/buyer_app/buyer_order/controller/buyer_order_repository.dart';
import 'package:belcka/buyer_app/buyer_order/model/buyer_order_invoice_response.dart';
import 'package:belcka/buyer_app/buyer_order/model/order_info.dart';
import 'package:belcka/buyer_app/buyer_order_details/model/buyer_order_details_response.dart';
import 'package:belcka/pages/common/listener/DialogButtonClickListener.dart';
import 'package:belcka/pages/common/listener/menu_item_listener.dart';
import 'package:belcka/pages/common/listener/select_date_listener.dart';
import 'package:belcka/pages/common/menu_items_list_bottom_dialog.dart';
import 'package:belcka/pages/common/model/file_info.dart';
import 'package:belcka/pages/manageattachment/controller/manage_attachment_controller.dart';
import 'package:belcka/pages/manageattachment/listener/select_attachment_listener.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/model/product_info.dart';
import 'package:belcka/storeman_app/storeman_order_details/controller/storeman_order_details_repository.dart';
import 'package:belcka/storeman_app/storeman_order_details/model/order_deliver_response.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/date_utils.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:dio/dio.dart' as multi;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../utils/AlertDialogHelper.dart';

class StoremanOrderDetailsController extends GetxController
    implements
        SelectDateListener,
        DialogButtonClickListener,
        SelectAttachmentListener,
        MenuItemListener {
  final _api = StoremanOrderDetailsRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isCancelQtyAvailable = false.obs;
  RxInt status = 0.obs;
  final noteController = TextEditingController().obs;
  final receiveDateController = TextEditingController().obs;
  DateTime? receiveDate;
  final orderInfo = OrderInfo().obs;
  final orderProductsList = <ProductInfo>[].obs;
  List<ProductInfo> tempOrderProductsList = [];
  int orderId = 0, initialStatus = 0, selectedIndex = 0;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      orderId = arguments[AppConstants.intentKey.orderId] ?? 0;
      initialStatus = arguments[AppConstants.intentKey.status] ?? 0;
    }
    receiveDateController.value.text =
        DateUtil.dateToString(DateTime.now(), DateUtil.DD_MM_YYYY_SLASH);
    orderDetailsApi();
  }

  void orderDetailsApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {
      "company_id": ApiConstants.companyId,
      "id": orderId,
    };

    _api.orderDetails(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          BuyerOrderDetailsResponse response =
              BuyerOrderDetailsResponse.fromJson(
                  jsonDecode(responseModel.result!));
          orderInfo.value = response.info!;
          status.value = orderInfo.value.status ?? 0;
          status.value =
              initialStatus != 0 ? initialStatus : orderInfo.value.status ?? 0;
          tempOrderProductsList.clear();

          for (var info in orderInfo.value.purchaseOrders!) {
            info.cartQty = (info.qty ?? 0) -
                (info.deliveredQty ?? 0) -
                (info.cancelledQty ?? 0);
            if ((info.cancelledQty ?? 0) > 0) {
              isCancelQtyAvailable.value = true;
            }
            tempOrderProductsList.add(info);
          }

          orderProductsList.assignAll(tempOrderProductsList);
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage ?? "");
        }
      },
    );
  }

  void buyerOrderInvoiceApi(int id, {bool? isCancelled}) {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    map["id"] = id;
    if (isCancelled ?? false) map["type"] = "cancel";
    BuyerOrderRepository().buyerOrderInvoice(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) async {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          BuyerOrderInvoiceResponse response =
              BuyerOrderInvoiceResponse.fromJson(
                  jsonDecode(responseModel.result!));
          String fileUrl = response.invoice ?? "";
          await ImageUtils.openAttachment(
              Get.context!, fileUrl, ImageUtils.getFileType(fileUrl));
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

  // void onClickReceiveOrder() {
  //   var productList = <ProductRequestInfo>[];
  //   for (var item in orderProductsList) {
  //     if ((item.cartQty ?? 0) > 0) {
  //       ProductRequestInfo info = ProductRequestInfo();
  //       info.productId = item.productId ?? 0;
  //       info.qty = (item.cartQty ?? 0).toInt();
  //       info.price = item.price ?? "";
  //       productList.add(info);
  //     }
  //   }
  //   if (productList.isNotEmpty) {
  //     receiveOrderApi(productList);
  //   } else {
  //     AppUtils.showToastMessage('msg_select_at_least_one_qty'.tr);
  //   }
  // }

  bool isProductQuantityValid() {
    bool valid = true;
    int count = 0;
    for (var item in orderProductsList) {
      if ((item.cartQty ?? 0) > 0) {
        count = count + 1;
      }
    }
    valid = count != 0;
    return valid;
  }

  bool isValidOrder() {
    bool valid = true;
    for (int i = 0; i < orderProductsList.length; i++) {
      ProductInfo productInfo = orderProductsList[i];
      if (((productInfo.qty ?? 0) -
                  (productInfo.deliveredQty ?? 0) -
                  (productInfo.cancelledQty ?? 0))
              .toInt() !=
          (productInfo.cartQty ?? 0).toInt()) {
        if (StringHelper.isEmptyString(productInfo.tempNote)) {
          valid = false;
          break;
        }
        if (StringHelper.isEmptyList(productInfo.tempAttachments)) {
          valid = false;
          break;
        }
      }
    }
    return valid;
  }

  void proceedOrder(int clickStatus) async {
    Map<String, dynamic> map = {};
    map["id"] = orderId;
    map["company_id"] = ApiConstants.companyId;
    map["status"] = status.value == AppConstants.orderStatus.received
        ? AppConstants.orderStatus.processing
        : clickStatus;

    if (status.value == AppConstants.orderStatus.processing ||
        status.value == AppConstants.orderStatus.partialReceived) {
      for (int i = 0; i < orderProductsList.length; i++) {
        ProductInfo productInfo = orderProductsList[i];
        map["product_data[$i][id]"] = productInfo.productId ?? 0;
        map["product_data[$i][qty]"] = productInfo.cartQty ?? 0;
        map["product_data[$i][note]"] = productInfo.tempNote ?? "";
      }
    }

    print("map:" + map.toString());
    multi.FormData formData = multi.FormData.fromMap(map);

    if (status.value == AppConstants.orderStatus.processing ||
        status.value == AppConstants.orderStatus.partialReceived) {
      for (int i = 0; i < orderProductsList.length; i++) {
        ProductInfo productInfo = orderProductsList[i];
        // if ((productInfo.qty ?? 0).toInt() !=
        //     (productInfo.cartQty ?? 0).toInt()) {
        for (FilesInfo filesInfo in productInfo.tempAttachments ?? []) {
          if (!StringHelper.isEmptyString(filesInfo.imageUrl) &&
              !filesInfo.imageUrl!.startsWith("http")) {
            print("product_data[$i][images][]" + (filesInfo.imageUrl ?? ""));
            formData.files.add(
              MapEntry("product_data[$i][images][]",
                  await multi.MultipartFile.fromFile(filesInfo.imageUrl ?? "")),
            );
          }
          // }
        }
      }
    }

    isLoading.value = true;
    _api.proceedStoremanOrder(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          OrderDeliverResponse response =
              OrderDeliverResponse.fromJson(jsonDecode(responseModel.result!));
          AppUtils.showApiResponseMessage(response.message ?? "");
          int status = response.info?.status ?? 0;
          var arguments = {
            AppConstants.intentKey.status: status,
            AppConstants.intentKey.result: true,
          };
          Get.back(result: arguments);
        } else {
          AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          AppUtils.showApiResponseMessage('no_internet'.tr);
        }
      },
    );
  }

  // void receiveOrderApi(List<ProductRequestInfo> productList) {
  //   isLoading.value = true;
  //   Map<String, dynamic> map = {
  //     "order_id": orderId,
  //     "company_id": ApiConstants.companyId,
  //     "store_id": orderInfo.value.storeId ?? 0,
  //     "receive_date": StringHelper.getText(receiveDateController.value),
  //     "note": StringHelper.getText(noteController.value),
  //     "product_data": productList,
  //   };
  //
  //   _api.receiveStoremanOrder(
  //     data: map,
  //     onSuccess: (ResponseModel responseModel) {
  //       if (responseModel.isSuccess) {
  //         BaseResponse response =
  //             BaseResponse.fromJson(jsonDecode(responseModel.result!));
  //         AppUtils.showToastMessage(response.Message ?? "");
  //         Get.back(result: true);
  //       } else {
  //         isLoading.value = false;
  //         AppUtils.showSnackBarMessage(responseModel.statusMessage ?? "");
  //       }
  //     },
  //     onError: (ResponseModel error) {
  //       isLoading.value = false;
  //       if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
  //         isInternetNotAvailable.value = true;
  //       } else if (error.statusMessage!.isNotEmpty) {
  //         AppUtils.showSnackBarMessage(error.statusMessage ?? "");
  //       }
  //     },
  //   );
  // }

  void increaseQty(int index) {
    final maxRemaining = ((orderProductsList[index].qty ?? 0) -
            (orderProductsList[index].deliveredQty ?? 0) -
            (orderProductsList[index].cancelledQty ?? 0))
        .toInt();
    if ((orderProductsList[index].cartQty ?? 0) < maxRemaining) {
      orderProductsList[index].cartQty =
          (orderProductsList[index].cartQty ?? 0) + 1;
      orderProductsList.refresh();
    }
  }

  void decreaseQty(int index) {
    if ((orderProductsList[index].cartQty ?? 0) > 0) {
      orderProductsList[index].cartQty =
          (orderProductsList[index].cartQty ?? 0) - 1;
      orderProductsList.refresh();
    }
  }

  void onItemClick(int index) {}

  void searchItem(String value) {
    if (value.isEmpty) {
      orderProductsList.assignAll(tempOrderProductsList);
    } else {
      orderProductsList.assignAll(tempOrderProductsList
          .where((element) => (element.name != null &&
              element.name!.toLowerCase().contains(value.toLowerCase())))
          .toList());
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
      receiveDate = date;
      receiveDateController.value.text =
          DateUtil.dateToString(date, DateUtil.DD_MM_YYYY_SLASH);
    }
  }

  void showOrderProceedDialog() {
    AlertDialogHelper.showAlertDialog(
        "",
        'order_proceed_msg'.tr,
        'yes'.tr,
        'no'.tr,
        "",
        true,
        false,
        this,
        AppConstants.dialogIdentifier.orderProceed);
  }

  void showOrderDeliveredDialog() {
    AlertDialogHelper.showAlertDialog(
        "",
        'order_deliver_msg'.tr,
        'yes'.tr,
        'no'.tr,
        "",
        true,
        false,
        this,
        AppConstants.dialogIdentifier.orderDelivered);
  }

  void showOrderCancelDialog() {
    AlertDialogHelper.showAlertDialog(
        "",
        'order_cancel_msg'.tr,
        'yes'.tr,
        'no'.tr,
        "",
        true,
        false,
        this,
        AppConstants.dialogIdentifier.orderCancelled);
  }

  @override
  void onNegativeButtonClicked(String dialogIdentifier) {
    Get.back();
  }

  @override
  void onOtherButtonClicked(String dialogIdentifier) {
    Get.back();
  }

  @override
  void onPositiveButtonClicked(String dialogIdentifier) {
    if (dialogIdentifier == AppConstants.dialogIdentifier.orderDelivered) {
      Get.back();
      proceedOrder(AppConstants.orderStatus.inStock);
    } else if (dialogIdentifier == AppConstants.dialogIdentifier.orderProceed) {
      Get.back();
      proceedOrder(AppConstants.orderStatus.processing);
    } else if (dialogIdentifier ==
        AppConstants.dialogIdentifier.orderCancelled) {
      Get.back();
      proceedOrder(AppConstants.orderStatus.cancelled);
    }
  }

  showAttachmentOptionsDialog(int index) async {
    selectedIndex = index;
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

    ManageAttachmentController().showAttachmentOptionsDialog(
        'select_photo_from_'.tr, listOptions, this);
  }

  @override
  void onSelectAttachment(List<String> paths, String action) {
    if (action == AppConstants.attachmentType.camera) {
      addPhotoToList(paths[0]);
    } else if (action == AppConstants.attachmentType.multiImage) {
      for (var path in paths) {
        addPhotoToList(path);
      }
    }
  }

  addPhotoToList(String? path) {
    if (!StringHelper.isEmptyString(path)) {
      List<FilesInfo> listPhotos =
          orderProductsList[selectedIndex].tempAttachments ?? [];
      FilesInfo info = FilesInfo();
      info.imageUrl = path;
      listPhotos.add(info);
      orderProductsList[selectedIndex].tempAttachments = listPhotos;
      orderProductsList.refresh();
      // attachmentList.add(info);
    }
  }

  void showMenuItemsDialog(BuildContext context) {
    List<ModuleInfo> listItems = [];
    listItems.add(ModuleInfo(
        name: 'cancelled_order_invoice'.tr,
        action: AppConstants.action.cancelledOrderInvoice));
    showCupertinoModalPopup(
      context: context,
      builder: (_) =>
          MenuItemsListBottomDialog(list: listItems, listener: this),
    );
  }

  @override
  Future<void> onSelectMenuItem(ModuleInfo info, String dialogType) async {
    if (info.action == AppConstants.action.cancelledOrderInvoice) {
      buyerOrderInvoiceApi(orderInfo.value.id ?? 0, isCancelled: true);
    }
  }
}
