import 'dart:io';

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
  static const Results results = Results();
  static const Status status = Status();
  static const CompanyResourcesFlag companyResourcesFlag =
      CompanyResourcesFlag();
  static const NotificationType notificationType = NotificationType();
  static const RequestType requestType = RequestType();
  static const FilterType filterType = FilterType();
  static const ZoneType zoneType = ZoneType();

  static String deviceType = Platform.isAndroid ? "1" : "2";
  static const int productListLimit = 20;
  static const int defaultPhoneExtensionId = 1;
  static const String defaultPhoneExtension = "+44";
  static const double defaultLatitude = 51.5072;
  static const double defaultLongitude = 0.1276;

  // static const String defaultFlagUrl =
  //     "https://devcdn.otmsystem.com/flags/png/gb_32.png";
  static const String defaultFlagUrl = "assets/country_flag/gb.svg";
  static const String permissionIconsAssetsPath =
      "assets/user_permission_icons/";
  static bool isResourcesLoaded = false;
  static bool isUpdatedPermission = false;
}

class Results {
  const Results();

  final String permissionUsersChanged = 'PERMISSION_USERS_CHANGED';
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
  final String isAllUserTimeSheet = 'IS_ALL_USER_TIMESHEET';
  final String isAllUserTeams = 'IS_ALL_USER_TEAMS';
  final String fromDashboardScreen = 'FROM_DASHBOARD_SCREEN';
  final String dashboardTabIndex = 'DASHBOARD_TAB_INDEX';
  final String stockCountType = 'STOCK_COUNT_TYPE';
  final String allStockType = 'ALL_STOCK_TYPE';
  final String purchaseOrderInfo = 'PURCHASE_ORDER_INFO';
  final String title = 'TITLE';
  final String count = 'COUNT';
  final String photosType = 'PHOTOS_TYPE';
  final String photosList = 'PHOTOS_LIST';
  final String beforePhotosList = 'BEFORE_PHOTOS_LIST';
  final String afterPhotosList = 'AFTER_PHOTOS_LIST';
  final String addressList = 'ADDRESS_LIST';
  final String permissionStep1Info = "PERMISSION_STEP1_INFO";
  final String permissionStep2Info = "PERMISSION_STEP2_INFO";
  final String permissionId = "PERMISSION_ID";
  final String teamId = "TEAM_ID";
  final String companyId = "COMPANY_ID";
  final String teamInfo = "TEAM_INFO";
  final String announcementId = "ANNOUNCEMENT_ID";
  final String projectInfo = "PROJECT_INFO";
  final String leaveInfo = "Leave_INFO";
  final String leaveId = "Leave_ID";
  final String userId = "USER_ID";
  final String userName = "USER_NAME";
  final String userList = "USER_LIST";
  final String shiftInfo = "SHIFT_INFO";
  final String billingInfo = "BILLING_INFO";
  final String fromStartShiftScreen = 'FROM_START_SHIFT_SCREEN';
  final String switchProject = 'SWITCH_PROJECT';
  final String workLogInfo = "WORK_LOG_INFO";
  final String ID = "ID";
  final String workLogId = "WORK_LOG_ID";
  final String checkLogId = "CHECK_LOG_ID";
  final String companyTaskId = "COMPANY_TASK_ID";
  final String projectId = "PROJECT_ID";
  final String isPriceWork = "IS_PRICE_WORK";
  final String addressId = "ADDRESS_ID";
  final String date = "DATE";
  final String checkLogInfo = "CHECK_LOG_INFO";
  final String isEditable = 'IS_EDITABLE';
  final String removeIdsList = 'REMOVE_IDS_LIST';
  final String index = 'INDEX';
  final String itemList = 'ITEM_LIST';
  final String addressInfo = "ADDRESS_INFO";
  final String addressDetailsInfo = "ADDRESS_DETAILS_INFO";
  final String fromNotification = "FROM_NOTIFICATION";
  final String fromRequest = "FROM_REQUEST";
  final String filterType = "FILTER_TYPE";
  final String filterData = "FILTER_DATA";
  final String typeOfWorkInfo = "TYPE_OF_WORK_INFO";
}

class DialogIdentifier {
  const DialogIdentifier(); // <---
  final String logout = 'logout';
  final String storeList = 'STORE_LIST';
  final String selectCompany = 'SELECT_COMPANY';
  final String joinCompany = 'JOIN_COMPANY';
  final String selectTrade = 'SELECT_TRADE';
  final String selectLocation = 'SELECT_LOCATION';
  final String selectTypeOfWork = 'SELECT_TYPE_OF_WORK';
  final String selectTypeOfDayWork = 'SELECT_TYPE_OF_DAY_WORK';
  final String selectCurrency = 'SELECT_CURRENCY';
  final String selectProject = 'SELECT_PROJECT';
  final String selectShift = 'SELECT_SHIFT';
  final String selectTeam = 'SELECT_TEAM';
  final String selectUser = 'SELECT_USER';
  final String sortByDialog = 'SORT_BY_DIALOG';
  final String filterByDialog = 'FILTER_BY_DIALOG';
  final String attachmentOptionsList = 'ATTACHMENT_OPTIONS_LIST';
  final String deleteProductImage = 'DELETE_PRODUCT_IMAGE';
  final String controlPanelMenuDialog = 'CONTROL_PANEL_MENU_DIALOG';
  final String selectCompanyAdmin = 'SELECT_COMPANY_ADMIN';
  final String establishedDate = 'ESTABLISHED_DATE';
  final String insuranceExpiryDate = 'INSURANCE_EXPIRY_DATE';
  final String selectWorkingHourTime = 'SELECT_WORKING_HOUR_TIME';
  final String selectMenuItemsDialog = 'selectMenuItemsDialog';
  final String selectTeamMembers = 'SELECT_TEAM_MEMBERS';
  final String deleteTeam = 'DELETE_TEAM';
  final String removeSubContractor = 'REMOVE_SUB_CONTRACTOR';
  final String selectShiftStartTime = 'SELECT_SHIFT_START_TIME';
  final String selectShiftEndTime = 'SELECT_SHIFT_END_TIME';
  final String selectBreakStartTime = 'SELECT_BREAK_START_TIME';
  final String selectBreakEndTime = 'SELECT_BREAK_END_TIME';
  final String deleteShift = 'DELETE_SHIFT';
  final String selectDayFilter = 'SELECT_DAY_FILTER';
  final String approve = 'APPROVE';
  final String reject = 'REJECT';
  final String delete = 'DELETE';
  final String selectAddress = 'SELECT_ADDRESS';
  final String deleteProject = 'DELETE_PROJECT';
  final String selectDate = 'SELECT_DATE';
  final String selectCategory = 'SELECT_CATEGORY';
  final String startDate = 'START_DATE';
  final String endDate = 'END_DATE';
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
  final String themeMode = "THEME_MODE";
  final String lastLocation = "LAST_LOCATION";
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
  final String selectSupervisorDialog = 'selectSupervisorDialog';
  final String selectProjectDialog = 'selectProjectDialog';
  final String selectShiftDialog = 'selectShiftDialog';
  final String selectLeaveTypeDialog = 'selectLeaveTypeDialog';
  final String add = 'ADD';
  final String edit = 'EDIT';
  final String delete = 'DELETE';
  final String createCode = 'CREATE_CODE';
  final String subContractorDetails = 'SUB_CONTRACTOR_DETAILS';
  final String removeSubContractor = 'REMOVE_SUB_CONTRACTOR';
  final String joinCompany = 'JOIN_COMPANY';
  final String archiveTeam = 'ARCHIVE_TEAM';
  final String archivedItems = 'ARCHIVED_ITEMS';
  final String archiveShift = 'ARCHIVE_SHIFT';
  final String generateCode = 'GENERATE_CODE';
  final String addOrJoin = 'ADD_OR_JOIN';
  final String share = 'SHARE';
  final String viewAmount = 'VIEW_AMOUNT';
  final String historyLogs = 'HISTORY_LOGS';
  final String lock = 'LOCK';
  final String unlock = 'UNLOCK';
  final String markAsPaid = 'MARK_AS_PAID';
  final String archive = 'ARCHIVE';
  final String archivedTimesheet = 'ARCHIVED_TIMESHEET';

  final String companyDetails = "COMPANY_DETAILS";
  final String companyTrades = "COMPANY_TRADES";
  final String widgets = "WIDGETS";
  final String companyPermissions = "COMPANY_PERMISSIONS";
  final String userPermissions = "USER_PERMISSIONS";
  final String settings = "SETTINGS";
  final String companies = "COMPANIES";
  final String notificationSettings = "NOTIFICATION_SETTINGS";
  final String archiveProject = 'ARCHIVE_PROJECT';
  final String archivedProjects = 'ARCHIVED_PROJECTS';
  final String archivedAddress = 'ARCHIVED_ADDRESS';
  final String beforePhotos = 'BEFORE_PHOTOS';
  final String afterPhotos = 'AFTER_PHOTOS';
  final String inviteUser = 'INVITE_USER';

  final String billingInfo = 'BillingInfo';
  final String healthInfo = 'HealthInfo';
  final String healthSafety = 'HealthSafety';
  final String myRequests = 'MyRequests';
  final String documents = 'Documents';
  final String myLeaves = 'MyLeaves';
  final String digitalId = 'DigitalId';
  final String rent = 'Rent';
  final String history = 'History';

  final String checkIn = "CheckIn";
  final String trades = "Trades";
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
  final String multiImage = "multi_image";
  final String croppedImage = "croppedImage";
  final String documents = "documents";
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

class Status {
  const Status(); //

  final int pending = 3;
  final int approved = 5;
  final int rejected = 12;

  final int lock = 6;
  final int unlock = 7;
  final int markAsPaid = 9;
// 6 lock
// 7 unlock
// 9 paid
}

class CompanyResourcesFlag {
  const CompanyResourcesFlag(); //

  final String shiftList = "shiftList";
  final String teamList = "teamList";
  final String userList = "usersList";
  final String tradeList = "tradeList";
}

class FilterType {
  const FilterType(); //

  final String myRequestFilter = "MY_REQUEST_FILTER";
  final String timesheetFilter = "TIMESHEET_FILTER";
}

class NotificationType {
  const NotificationType(); //

//Company
  final String JOIN_COMPANY = "1001";

//Work
  final String USER_WORK_STOP_AUTOMATICALLY = "2001";

//Team
  final String USER_ADDED_TO_TEAM = "3001";
  final String USER_REMOVED_FROM_TEAM = "3002";

//Timesheet
  final String TIMESHEET_APPROVE = "4001";
  final String TIMESHEET_UNAPPROVE = "4002";
  final String TIMESHEET_CHANGE_HOURS = "4003";
  final String TIMESHEET_REQUEST_REJECT = "4004";
  final String TIMESHEET_REQUEST_DELETE = "4005";
  final String TIMESHEET_TO_BE_PAID = "4006";
  final String TIMESHEET_EDIT = "4007";

//Project
  final String ASSIGN_USER_TO_PROJECT = "5001";

// Time clock
  final String TIME_CLOCK_EDIT_WORKLOG = "7001";

//User worklog
  final String WORKLOG_APPROVE = "8001";
  final String WORKLOG_REJECT = "8002";

  //User companies
  final String CHNAGE_RATE = "6001";

//Billing Info
  final String CREATE_BILLING_INFO = "9001";
  final String UPDATE_BILLING_INFO = "9002";
  final String REJECT_REQUEST = "9003";
  final String APPROVE_REQUEST = "9004";
  final String ADD_REQUEST = "9005";
  final String UPDATE_REQUEST = "9006";

  //Leaves
  final String leaveAdd = "11001";
  final String leaveUpdate = "11002";
  final String leaveDelete = "11003";
  final String leaveRequest = "11004";
  final String leaveApprove = "11005";
  final String leaveReject = "11006";
}

class RequestType {
  const RequestType(); //

//Company
  final int shift = 102;
  final int billingInfo = 103;
  final int company = 105;
  final int leave = 110;

//Work
  final String USER_WORK_STOP_AUTOMATICALLY = "2001";

//Team
  final String USER_ADDED_TO_TEAM = "3001";
  final String USER_REMOVED_FROM_TEAM = "3002";

//Timesheet
  final String TIMESHEET_APPROVE = "4001";
  final String TIMESHEET_UNAPPROVE = "4002";
  final String TIMESHEET_CHANGE_HOURS = "4003";
  final String TIMESHEET_REQUEST_REJECT = "4004";
  final String TIMESHEET_REQUEST_DELETE = "4005";
  final String TIMESHEET_TO_BE_PAID = "4006";
  final String TIMESHEET_EDIT = "4007";

//Project
  final String ASSIGN_USER_TO_PROJECT = "5001";

// Time clock
  final String TIME_CLOCK_EDIT_WORKLOG = "7001";

//User worklog
  final String WORKLOG_APPROVE = "8001";
  final String WORKLOG_REJECT = "8002";

  //User companies
  final String CHNAGE_RATE = "6001";

//Billing Info
  final String CREATE_BILLING_INFO = "9001";
  final String UPDATE_BILLING_INFO = "9002";
  final String REJECT_REQUEST = "9003";
  final String APPROVE_REQUEST = "9004";
  final String ADD_REQUEST = "9005";
  final String UPDATE_REQUEST = "9006";
}

class ZoneType {
  const ZoneType(); //

  final String circle = "circle";
  final String polyline = "polyline";
  final String polygon = "polygon";
}
