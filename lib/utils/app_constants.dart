class AppConstants {
  static const DialogIdentifier dialogIdentifier = DialogIdentifier();
  static const SharedPreferenceKey sharedPreferenceKey = SharedPreferenceKey();
  static const IntentKey intentKey = IntentKey();
  static const Action action = Action();
  static const StockCountType stockCountType = StockCountType();
  static const AttachmentType attachmentType = AttachmentType();

  static const String deviceType = "1";
  static const int productListLimit = 20;
  static const int defaultPhoneExtensionId = 1;
  static const String defaultPhoneExtension = "+44";
  static const String defaultFlagUrl =
      "https://devcdn.otmsystem.com/flags/png/gb_32.png";
  static bool isResourcesLoaded = false;
}


class IntentKey {
  const IntentKey(); // <
  final String phoneExtension = 'PHONE_EXTENSION';
  final String phoneNumber = 'PHONE_NUMBER';
  final String dashboardTabIndex = 'DASHBOARD_TAB_INDEX';
  final String stockCountType = 'STOCK_COUNT_TYPE';
  final String allStockType = 'ALL_STOCK_TYPE';
  final String purchaseOrderInfo = 'PURCHASE_ORDER_INFO';
  final String title = 'TITLE';
  final String count = 'COUNT';
}

class DialogIdentifier {
  const DialogIdentifier(); // <---
  final String logout = 'logout';
  final String storeList = 'STORE_LIST';
}

class SharedPreferenceKey {
  const SharedPreferenceKey(); // <---
  final String userInfo = "USER_INFO";
  final String accessToken = "ACCESS_TOKEN";
  final String storeId = "STORE_ID";
  final String storeName = "STORE_NAME";
  final String savedLoginUserList = "SAVED_LOGIN_USER_LIST";
  final String dashboardItemCountData = "DASHBOARD_ITEM_COUNT_DATA";
  final String permissionSettings = "PERMISSION_SETTINGS";
}

class Action {
  const Action(); //
  final String items = "ITEMS";
  final String store = "STORE";
  final String suppliers = "SUPPLIERS";
  final String categories = "CATEGORIES";
  final String stocks = "STOCKS";
  final String vendors = "VENDORS";
  final String manufacturer = "MANUFACTURER";
  final String selectImageFromCamera = 'SELECT_IMAGE_FROM_CAMERA';
  final String selectImageFromGallery = 'SELECT_IMAGE_FROM_GALLERY';
  final String a4Print = "A4Print";
  final String a4WithPicturesPrint = "A4WithPicturesPrint";
  final String mobilePrint = "MobilePrint";
  final String viewPdf = "VIEW_PDF";
  final String downloadPdf = "DOWNLOAD_PDF";

  final String clockIn = "ClockIn";
  final String quickTask = "QuickTask";
  final String map = "Map";
  final String teams = "Teams";
  final String users = "Users";
  final String timeSheet = "TimeSheet";
  final String selectCompanyListDialog = "selectCompanyListDialog";
  final String selectTradeListDialog = "selectTradeListDialog";
}

class StockCountType {
  const StockCountType(); //
  final int inStock = 1;
  final int lowStock = 2;
  final int outOfStock = 3;
  final int minusStock = 4;
  final int finishingStock = 5;
}

class AttachmentType {
  const AttachmentType(); //
  final String image = "image";
  final String camera = "camera";
  final String croppedImage = "croppedImage";
}
