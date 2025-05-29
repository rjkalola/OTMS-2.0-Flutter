class AppConstants {
  static const DialogIdentifier dialogIdentifier = DialogIdentifier();
  static const SharedPreferenceKey sharedPreferenceKey = SharedPreferenceKey();
  static const IntentKey intentKey = IntentKey();
  static const Action action = Action();
  static const StockCountType stockCountType = StockCountType();
  static const AttachmentType attachmentType = AttachmentType();
  static const UserType userType = UserType();
  static const Type type = Type();
  static const ShiftType shiftType = ShiftType();

  static const String deviceType = "1";
  static const int productListLimit = 20;
  static const int defaultPhoneExtensionId = 1;
  static const String defaultPhoneExtension = "+44";

  // static const String defaultFlagUrl =
  //     "https://devcdn.otmsystem.com/flags/png/gb_32.png";
  static const String defaultFlagUrl = "assets/country_flag/gb.svg";
  static const String permissionIconsAssetsPath =
      "assets/user_permission_icons/";
  static bool isResourcesLoaded = false;
}

class IntentKey {
  const IntentKey(); // <
  final String phoneExtensionId = 'PHONE_EXTENSION_ID';
  final String phoneExtension = 'PHONE_EXTENSION';
  final String phoneNumber = 'PHONE_NUMBER';
  final String userInfo = 'USER_INFO';
  final String companyData = 'COMPANY_DATA';
  final String companyCode = 'COMPANY_CODE';
  final String fromSignUpScreen = 'FROM_SIGN_UP_SCREEN';
  final String dashboardTabIndex = 'DASHBOARD_TAB_INDEX';
  final String stockCountType = 'STOCK_COUNT_TYPE';
  final String allStockType = 'ALL_STOCK_TYPE';
  final String purchaseOrderInfo = 'PURCHASE_ORDER_INFO';
  final String title = 'TITLE';
  final String count = 'COUNT';
  final String photosType = 'PHOTOS_TYPE';
  final String photosList = 'PHOTOS_LIST';
  final String addressList = 'ADDRESS_LIST';
  final String permissionStep1Info = "PERMISSION_STEP1_INFO";
  final String permissionStep2Info = "PERMISSION_STEP2_INFO";
}

class DialogIdentifier {
  const DialogIdentifier(); // <---
  final String logout = 'logout';
  final String storeList = 'STORE_LIST';
  final String selectCompany = 'SELECT_COMPANY';
  final String joinCompany = 'JOIN_COMPANY';
  final String selectTrade = 'SELECT_TRADE';
  final String selectCurrency = 'SELECT_CURRENCY';
  final String selectProject = 'SELECT_PROJECT';
  final String selectShift = 'SELECT_SHIFT';
  final String sortByDialog = 'SORT_BY_DIALOG';
  final String filterByDialog = 'FILTER_BY_DIALOG';
  final String attachmentOptionsList = 'ATTACHMENT_OPTIONS_LIST';
  final String deleteProductImage = 'DELETE_PRODUCT_IMAGE';
  final String controlPanelMenuDialog = 'CONTROL_PANEL_MENU_DIALOG';
  final String selectCompanyAdmin = 'SELECT_COMPANY_ADMIN';
  final String establishedDate = 'ESTABLISHED_DATE';
  final String insuranceExpiryDate = 'INSURANCE_EXPIRY_DATE';
  final String selectWorkingHourTime = 'SELECT_WORKING_HOUR_TIME';
}

class SharedPreferenceKey {
  const SharedPreferenceKey(); // <---
  final String userInfo = "USER_INFO";
  final String accessToken = "ACCESS_TOKEN";
  final String companyId = "COMPANY_ID";
  final String savedLoginUserList = "SAVED_LOGIN_USER_LIST";
  final String dashboardItemCountData = "DASHBOARD_ITEM_COUNT_DATA";
  final String permissionSettings = "PERMISSION_SETTINGS";
  final String dashboardResponse = "DASHBOARD_RESPONSE";
  final String userPermissionData = "USER_PERMISSION_DATA";
  final String isLocalSequenceChanged = "IS_LOCAL_SEQUENCE_CHANGED";
  final String localSequenceChangeData = "LOCAL_SEQUENCE_CHANGE_DATA";
  final String isWeeklySummeryCounter = "IS_WEEKLY_SUMMERY_COUNTER";
  final String weeklySummeryAmount = "WEEKLY_SUMMERY_AMOUNT";
  final String timeLogId = "TIME_LOG_ID";
  final String checkLogId = "CHECK_LOG_ID";
  final String projectId = "PROJECT_ID";
  final String shiftId = "SHIFT_ID";
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
  final String aToZ = "A_TO_Z";
  final String zToA = "Z_TO_A";
  final String status = "Status";
  final String readyToStartWork = "READY_TO_START_WORk";
  final String inProgress = "IN_PROGRESS";
  final String completed = "COMPLETED";
  final String viewPhoto = "VIEW_PHOTO";
  final String removePhoto = "REMOVE_PHOTO";

  final String clockIn = "ClockIn";
  final String quickTask = "QuickTask";
  final String map = "Map";
  final String teams = "Teams";
  final String users = "Users";
  final String timeSheet = "TimeSheet";
  final String selectCompanyListDialog = "selectCompanyListDialog";
  final String selectTradeListDialog = "selectTradeListDialog";

  final String companyDetails = "COMPANY_DETAILS";
  final String companyTrades = "COMPANY_TRADES";
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

class UserType {
  const UserType(); //
  final int admin = 1;
  final int projectManager = 2;
  final int supervisor = 3;
  final int employee = 4;
  final int driver = 5;
}

class ShiftType {
  const ShiftType(); //
  final int regularShift = 1;
  final int priceWorkShift = 2;
}

class Type {
  const Type(); //
  final int OUTER_WORK = 1;
  final int OUTER_BREAK = 2;
  final int INNER_WORK = 3;
  final int INNER_BREAK = 4;
  final int INNER_FREE_WORK = 5;
  final int OUTER_OVERTIME = 6;
  final String beforePhotos = "BEFORE_PHOTOS";
  final String afterPhotos = "AFTER_PHOTOS";
}
