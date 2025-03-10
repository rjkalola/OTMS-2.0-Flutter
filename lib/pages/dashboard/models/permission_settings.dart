class PermissionSettings {
  bool? isSuccess;
  String? message;
  bool? companyUsers;
  bool? editOtherUserDetail;
  bool? archiveUser;
  bool? createTeam;
  bool? addUserInTeam;
  bool? removeUserInTeam;
  bool? deleteTeam;
  bool? deleteCompanyUser;
  bool? changeGroupOwner;
  bool? moveTeamUser;
  bool? teamLocation;
  bool? viewTeamList;
  bool? viewUserDetails;
  bool? addUserToCompany;
  bool? viewStopWorkButtonInOtherUserProfile;
  bool? travelExpenseSwitch;
  bool? removeZoneInTeam;
  bool? editTimesheet;
  bool? deleteTimesheet;
  bool? exportTimeshset;
  bool? timesheet;
  bool? timesheetUserDetails;
  bool? viewPriceAmount;
  bool? approveEditedHours;
  bool? approveAndUnapproveBtn;
  bool? approveTimesheet;
  bool? addWorklog;
  bool? inviteUsers;
  bool? viewSetting;
  bool? viewAnalysisAndCharts;
  bool? viewPermission;
  bool? deleteFeed;
  bool? clearFeed;
  bool? createAnnouncement;
  bool? showRequestIcon;
  bool? uploadCertificates;
  bool? showNetGross;
  bool? viewPersonalInfo;
  bool? editMyWorkInfo;
  bool? viewPersonalHistory;
  bool? viewBookeeper;
  bool? statusBookeeper;
  bool? exportBookeeper;
  bool? editBookeeper;
  bool? plannerAddTask;
  bool? plannerEditTask;
  bool? plannerDeleteTask;
  bool? plannerAddFolder;
  bool? plannerEditFolder;
  bool? plannerDeleteFolder;
  bool? plannerAddProject;
  bool? plannerEditProject;
  bool? plannerDeleteProject;
  bool? assignShift;
  bool? allShift;
  bool? statusPriceWork;
  bool? exportPriceWork;
  bool? allowToSeeAmountOfPriceworkRecordsOfAllUsers;
  bool? statusExpense;
  bool? exportExpense;
  bool? showPaymentIconInMenu;
  bool? showPayslipRecords;
  bool? showInvoiceRecords;
  bool? showPaymentScheduledRecords;
  bool? editPayslipRecords;
  bool? addPayslipRecords;
  bool? deletePayslipRecords;
  bool? payslipPayment;
  bool? showInventory;
  bool? addProduct;
  bool? updateProduct;
  bool? deleteProduct;
  bool? archiveProduct;
  bool? addStore;
  bool? updateStore;
  bool? deleteStore;
  bool? viewStore;
  bool? addProductCategory;
  bool? updateProductCategory;
  bool? deleteProductCategory;
  bool? addStoreQty;
  bool? updateStoreQty;
  bool? deleteStoreQty;
  bool? archiveStoreQty;
  bool? addSupplier;
  bool? updateSupplier;
  bool? deleteSupplier;
  bool? addManufacturer;
  bool? updateManufacturer;
  bool? deleteManufacturer;
  bool? modifyInventorySetting;
  bool? teamEditZone;
  bool? teamAddZone;
  bool? teamDetail;
  bool? addZone;
  bool? editZone;
  bool? viewTeamZones;
  bool? deleteZone;
  bool? editWorkInfo;
  bool? workInfoRate;
  bool? viewWorkInfo;
  bool? viewNotificationSetting;
  bool? editCompanyInfo;
  bool? addCompany;
  bool? viewPriceProject;
  bool? priceTaskRate;
  bool? viewHistory;
  bool? nearMissIncident;
  bool? editNearMissIncident;
  bool? viewHealthSafety;
  bool? addNearMissReport;
  bool? addReportIncident;
  bool? addInductionTraining;
  Permissions? permissions;

  PermissionSettings(
      {this.isSuccess,
        this.message,
        this.companyUsers,
        this.editOtherUserDetail,
        this.archiveUser,
        this.createTeam,
        this.addUserInTeam,
        this.removeUserInTeam,
        this.deleteTeam,
        this.deleteCompanyUser,
        this.changeGroupOwner,
        this.moveTeamUser,
        this.teamLocation,
        this.viewTeamList,
        this.viewUserDetails,
        this.addUserToCompany,
        this.viewStopWorkButtonInOtherUserProfile,
        this.travelExpenseSwitch,
        this.removeZoneInTeam,
        this.editTimesheet,
        this.deleteTimesheet,
        this.exportTimeshset,
        this.timesheet,
        this.timesheetUserDetails,
        this.viewPriceAmount,
        this.approveEditedHours,
        this.approveAndUnapproveBtn,
        this.approveTimesheet,
        this.addWorklog,
        this.inviteUsers,
        this.viewSetting,
        this.viewAnalysisAndCharts,
        this.viewPermission,
        this.deleteFeed,
        this.clearFeed,
        this.createAnnouncement,
        this.showRequestIcon,
        this.uploadCertificates,
        this.showNetGross,
        this.viewPersonalInfo,
        this.editMyWorkInfo,
        this.viewPersonalHistory,
        this.viewBookeeper,
        this.statusBookeeper,
        this.exportBookeeper,
        this.editBookeeper,
        this.plannerAddTask,
        this.plannerEditTask,
        this.plannerDeleteTask,
        this.plannerAddFolder,
        this.plannerEditFolder,
        this.plannerDeleteFolder,
        this.plannerAddProject,
        this.plannerEditProject,
        this.plannerDeleteProject,
        this.assignShift,
        this.allShift,
        this.statusPriceWork,
        this.exportPriceWork,
        this.allowToSeeAmountOfPriceworkRecordsOfAllUsers,
        this.statusExpense,
        this.exportExpense,
        this.showPaymentIconInMenu,
        this.showPayslipRecords,
        this.showInvoiceRecords,
        this.showPaymentScheduledRecords,
        this.editPayslipRecords,
        this.addPayslipRecords,
        this.deletePayslipRecords,
        this.payslipPayment,
        this.showInventory,
        this.addProduct,
        this.updateProduct,
        this.deleteProduct,
        this.archiveProduct,
        this.addStore,
        this.updateStore,
        this.deleteStore,
        this.viewStore,
        this.addProductCategory,
        this.updateProductCategory,
        this.deleteProductCategory,
        this.addStoreQty,
        this.updateStoreQty,
        this.deleteStoreQty,
        this.archiveStoreQty,
        this.addSupplier,
        this.updateSupplier,
        this.deleteSupplier,
        this.addManufacturer,
        this.updateManufacturer,
        this.deleteManufacturer,
        this.modifyInventorySetting,
        this.teamEditZone,
        this.teamAddZone,
        this.teamDetail,
        this.addZone,
        this.editZone,
        this.viewTeamZones,
        this.deleteZone,
        this.editWorkInfo,
        this.workInfoRate,
        this.viewWorkInfo,
        this.viewNotificationSetting,
        this.editCompanyInfo,
        this.addCompany,
        this.viewPriceProject,
        this.priceTaskRate,
        this.viewHistory,
        this.nearMissIncident,
        this.editNearMissIncident,
        this.viewHealthSafety,
        this.addNearMissReport,
        this.addReportIncident,
        this.addInductionTraining,
        this.permissions});

  PermissionSettings.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['Message'];
    companyUsers = json['company_users'];
    editOtherUserDetail = json['edit_other_user_detail'];
    archiveUser = json['archive_user'];
    createTeam = json['create_team'];
    addUserInTeam = json['add_user_in_team'];
    removeUserInTeam = json['remove_user_in_team'];
    deleteTeam = json['delete_team'];
    deleteCompanyUser = json['delete_company_user'];
    changeGroupOwner = json['change_group_owner'];
    moveTeamUser = json['move_team_user'];
    teamLocation = json['team_location'];
    viewTeamList = json['view_team_list'];
    viewUserDetails = json['view_user_details'];
    addUserToCompany = json['add_user_to_company'];
    viewStopWorkButtonInOtherUserProfile =
    json['view_stop_work_button_in_other_user_profile'];
    travelExpenseSwitch = json['travel_expense_switch'];
    removeZoneInTeam = json['remove_zone_in_team'];
    editTimesheet = json['edit_timesheet'];
    deleteTimesheet = json['delete_timesheet'];
    exportTimeshset = json['export_timeshset'];
    timesheet = json['timesheet'];
    timesheetUserDetails = json['timesheet_user_details'];
    viewPriceAmount = json['view_price_amount'];
    approveEditedHours = json['approve_edited_hours'];
    approveAndUnapproveBtn = json['approve_and_unapprove_btn'];
    approveTimesheet = json['approve_timesheet'];
    addWorklog = json['add_worklog'];
    inviteUsers = json['invite_users'];
    viewSetting = json['view_setting'];
    viewAnalysisAndCharts = json['view_analysis_and_charts'];
    viewPermission = json['view_permission'];
    deleteFeed = json['delete_feed'];
    clearFeed = json['clear_feed'];
    createAnnouncement = json['create_announcement'];
    showRequestIcon = json['show_request_icon'];
    uploadCertificates = json['upload_certificates'];
    showNetGross = json['show_net_gross'];
    viewPersonalInfo = json['view_personal_info'];
    editMyWorkInfo = json['edit_my_work_info'];
    viewPersonalHistory = json['view_personal_history'];
    viewBookeeper = json['view_bookeeper'];
    statusBookeeper = json['status_bookeeper'];
    exportBookeeper = json['export_bookeeper'];
    editBookeeper = json['edit_bookeeper'];
    plannerAddTask = json['planner_add_task'];
    plannerEditTask = json['planner_edit_task'];
    plannerDeleteTask = json['planner_delete_task'];
    plannerAddFolder = json['planner_add_folder'];
    plannerEditFolder = json['planner_edit_folder'];
    plannerDeleteFolder = json['planner_delete_folder'];
    plannerAddProject = json['planner_add_project'];
    plannerEditProject = json['planner_edit_project'];
    plannerDeleteProject = json['planner_delete_project'];
    assignShift = json['assign_shift'];
    allShift = json['all_shift'];
    statusPriceWork = json['status_price_work'];
    exportPriceWork = json['export_price_work'];
    allowToSeeAmountOfPriceworkRecordsOfAllUsers =
    json['allow_to_see_amount_of_pricework_records_of_all_users'];
    statusExpense = json['status_expense'];
    exportExpense = json['export_expense'];
    showPaymentIconInMenu = json['show_payment_icon_in_menu'];
    showPayslipRecords = json['show_payslip_records'];
    showInvoiceRecords = json['show_invoice_records'];
    showPaymentScheduledRecords = json['show_payment_scheduled_records'];
    editPayslipRecords = json['edit_payslip_records'];
    addPayslipRecords = json['add_payslip_records'];
    deletePayslipRecords = json['delete_payslip_records'];
    payslipPayment = json['payslip_payment'];
    showInventory = json['show_inventory'];
    addProduct = json['add_product'];
    updateProduct = json['update_product'];
    deleteProduct = json['delete_product'];
    archiveProduct = json['archive_product'];
    addStore = json['add_store'];
    updateStore = json['update_store'];
    deleteStore = json['delete_store'];
    viewStore = json['view_store'];
    addProductCategory = json['add_product_category'];
    updateProductCategory = json['update_product_category'];
    deleteProductCategory = json['delete_product_category'];
    addStoreQty = json['add_store_qty'];
    updateStoreQty = json['update_store_qty'];
    deleteStoreQty = json['delete_store_qty'];
    archiveStoreQty = json['archive_store_qty'];
    addSupplier = json['add_supplier'];
    updateSupplier = json['update_supplier'];
    deleteSupplier = json['delete_supplier'];
    addManufacturer = json['add_manufacturer'];
    updateManufacturer = json['update_manufacturer'];
    deleteManufacturer = json['delete_manufacturer'];
    modifyInventorySetting = json['modify_inventory_setting'];
    teamEditZone = json['team_edit_zone'];
    teamAddZone = json['team_add_zone'];
    teamDetail = json['team_detail'];
    addZone = json['add_zone'];
    editZone = json['edit_zone'];
    viewTeamZones = json['view_team_zones'];
    deleteZone = json['delete_zone'];
    editWorkInfo = json['edit_work_info'];
    workInfoRate = json['work_info_rate'];
    viewWorkInfo = json['view_work_info'];
    viewNotificationSetting = json['view_notification_setting'];
    editCompanyInfo = json['edit_company_info'];
    addCompany = json['add_company'];
    viewPriceProject = json['view_price_project'];
    priceTaskRate = json['price_task_rate'];
    viewHistory = json['view_history'];
    nearMissIncident = json['near_miss_incident'];
    editNearMissIncident = json['edit_near_miss_incident'];
    viewHealthSafety = json['view_health_safety'];
    addNearMissReport = json['add_near_miss_report'];
    addReportIncident = json['add_report_incident'];
    addInductionTraining = json['add_induction_training'];
    permissions = json['permissions'] != null
        ? new Permissions.fromJson(json['permissions'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['Message'] = this.message;
    data['company_users'] = this.companyUsers;
    data['edit_other_user_detail'] = this.editOtherUserDetail;
    data['archive_user'] = this.archiveUser;
    data['create_team'] = this.createTeam;
    data['add_user_in_team'] = this.addUserInTeam;
    data['remove_user_in_team'] = this.removeUserInTeam;
    data['delete_team'] = this.deleteTeam;
    data['delete_company_user'] = this.deleteCompanyUser;
    data['change_group_owner'] = this.changeGroupOwner;
    data['move_team_user'] = this.moveTeamUser;
    data['team_location'] = this.teamLocation;
    data['view_team_list'] = this.viewTeamList;
    data['view_user_details'] = this.viewUserDetails;
    data['add_user_to_company'] = this.addUserToCompany;
    data['view_stop_work_button_in_other_user_profile'] =
        this.viewStopWorkButtonInOtherUserProfile;
    data['travel_expense_switch'] = this.travelExpenseSwitch;
    data['remove_zone_in_team'] = this.removeZoneInTeam;
    data['edit_timesheet'] = this.editTimesheet;
    data['delete_timesheet'] = this.deleteTimesheet;
    data['export_timeshset'] = this.exportTimeshset;
    data['timesheet'] = this.timesheet;
    data['timesheet_user_details'] = this.timesheetUserDetails;
    data['view_price_amount'] = this.viewPriceAmount;
    data['approve_edited_hours'] = this.approveEditedHours;
    data['approve_and_unapprove_btn'] = this.approveAndUnapproveBtn;
    data['approve_timesheet'] = this.approveTimesheet;
    data['add_worklog'] = this.addWorklog;
    data['invite_users'] = this.inviteUsers;
    data['view_setting'] = this.viewSetting;
    data['view_analysis_and_charts'] = this.viewAnalysisAndCharts;
    data['view_permission'] = this.viewPermission;
    data['delete_feed'] = this.deleteFeed;
    data['clear_feed'] = this.clearFeed;
    data['create_announcement'] = this.createAnnouncement;
    data['show_request_icon'] = this.showRequestIcon;
    data['upload_certificates'] = this.uploadCertificates;
    data['show_net_gross'] = this.showNetGross;
    data['view_personal_info'] = this.viewPersonalInfo;
    data['edit_my_work_info'] = this.editMyWorkInfo;
    data['view_personal_history'] = this.viewPersonalHistory;
    data['view_bookeeper'] = this.viewBookeeper;
    data['status_bookeeper'] = this.statusBookeeper;
    data['export_bookeeper'] = this.exportBookeeper;
    data['edit_bookeeper'] = this.editBookeeper;
    data['planner_add_task'] = this.plannerAddTask;
    data['planner_edit_task'] = this.plannerEditTask;
    data['planner_delete_task'] = this.plannerDeleteTask;
    data['planner_add_folder'] = this.plannerAddFolder;
    data['planner_edit_folder'] = this.plannerEditFolder;
    data['planner_delete_folder'] = this.plannerDeleteFolder;
    data['planner_add_project'] = this.plannerAddProject;
    data['planner_edit_project'] = this.plannerEditProject;
    data['planner_delete_project'] = this.plannerDeleteProject;
    data['assign_shift'] = this.assignShift;
    data['all_shift'] = this.allShift;
    data['status_price_work'] = this.statusPriceWork;
    data['export_price_work'] = this.exportPriceWork;
    data['allow_to_see_amount_of_pricework_records_of_all_users'] =
        this.allowToSeeAmountOfPriceworkRecordsOfAllUsers;
    data['status_expense'] = this.statusExpense;
    data['export_expense'] = this.exportExpense;
    data['show_payment_icon_in_menu'] = this.showPaymentIconInMenu;
    data['show_payslip_records'] = this.showPayslipRecords;
    data['show_invoice_records'] = this.showInvoiceRecords;
    data['show_payment_scheduled_records'] = this.showPaymentScheduledRecords;
    data['edit_payslip_records'] = this.editPayslipRecords;
    data['add_payslip_records'] = this.addPayslipRecords;
    data['delete_payslip_records'] = this.deletePayslipRecords;
    data['payslip_payment'] = this.payslipPayment;
    data['show_inventory'] = this.showInventory;
    data['add_product'] = this.addProduct;
    data['update_product'] = this.updateProduct;
    data['delete_product'] = this.deleteProduct;
    data['archive_product'] = this.archiveProduct;
    data['add_store'] = this.addStore;
    data['update_store'] = this.updateStore;
    data['delete_store'] = this.deleteStore;
    data['view_store'] = this.viewStore;
    data['add_product_category'] = this.addProductCategory;
    data['update_product_category'] = this.updateProductCategory;
    data['delete_product_category'] = this.deleteProductCategory;
    data['add_store_qty'] = this.addStoreQty;
    data['update_store_qty'] = this.updateStoreQty;
    data['delete_store_qty'] = this.deleteStoreQty;
    data['archive_store_qty'] = this.archiveStoreQty;
    data['add_supplier'] = this.addSupplier;
    data['update_supplier'] = this.updateSupplier;
    data['delete_supplier'] = this.deleteSupplier;
    data['add_manufacturer'] = this.addManufacturer;
    data['update_manufacturer'] = this.updateManufacturer;
    data['delete_manufacturer'] = this.deleteManufacturer;
    data['modify_inventory_setting'] = this.modifyInventorySetting;
    data['team_edit_zone'] = this.teamEditZone;
    data['team_add_zone'] = this.teamAddZone;
    data['team_detail'] = this.teamDetail;
    data['add_zone'] = this.addZone;
    data['edit_zone'] = this.editZone;
    data['view_team_zones'] = this.viewTeamZones;
    data['delete_zone'] = this.deleteZone;
    data['edit_work_info'] = this.editWorkInfo;
    data['work_info_rate'] = this.workInfoRate;
    data['view_work_info'] = this.viewWorkInfo;
    data['view_notification_setting'] = this.viewNotificationSetting;
    data['edit_company_info'] = this.editCompanyInfo;
    data['add_company'] = this.addCompany;
    data['view_price_project'] = this.viewPriceProject;
    data['price_task_rate'] = this.priceTaskRate;
    data['view_history'] = this.viewHistory;
    data['near_miss_incident'] = this.nearMissIncident;
    data['edit_near_miss_incident'] = this.editNearMissIncident;
    data['view_health_safety'] = this.viewHealthSafety;
    data['add_near_miss_report'] = this.addNearMissReport;
    data['add_report_incident'] = this.addReportIncident;
    data['add_induction_training'] = this.addInductionTraining;
    if (this.permissions != null) {
      data['permissions'] = this.permissions!.toJson();
    }
    return data;
  }
}

class Permissions {
  bool? startWorkReminderMobile;
  bool? allShift;
  bool? stopWorkReminderMobile;
  bool? startBreakReminderMobile;
  bool? stopBreakReminderMobile;
  bool? forgetStartWorkAfterShiftStartOwnerMobile;
  bool? forgetStartWorkAfterShiftStartMemberMobile;
  bool? forgetStopWorkAfterShiftEndOwnerMobile;
  bool? forgetStopWorkAfterShiftEndMemberMobile;
  bool? forgetToBreakOutReminderOwnerMobile;
  bool? forgetToBreakOutReminderMemberMobile;
  bool? startWorkReminderEmail;
  bool? stopWorkReminderEmail;
  bool? startBreakReminderEmail;
  bool? stopBreakReminderEmail;
  bool? forgetStartWorkAfterShiftStartOwnerEmail;
  bool? forgetStartWorkAfterShiftStartMemberEmail;
  bool? forgetStopWorkAfterShiftEndOwnerEmail;
  bool? forgetStopWorkAfterShiftEndMemberEmail;
  bool? forgetToBreakOutReminderOwnerEmail;
  bool? forgetToBreakOutReminderMemberEmail;
  bool? chatNotification;
  bool? updateLocationReminderMobile;
  bool? updateLocationReminderEmail;
  bool? workInfoRate;
  bool? timesheetNotification;
  bool? expenseNotification;
  bool? priceworkNotification;
  bool? leaveNotification;
  bool? teamNotification;
  bool? requestNotification;
  bool? feedNotification;
  bool? updateLocationReminderHourCheck;
  bool? startWork;
  bool? stopWork;
  bool? locationBoundaryNotification;
  bool? travelExpenseSwitch;

  Permissions(
      {this.startWorkReminderMobile,
        this.allShift,
        this.stopWorkReminderMobile,
        this.startBreakReminderMobile,
        this.stopBreakReminderMobile,
        this.forgetStartWorkAfterShiftStartOwnerMobile,
        this.forgetStartWorkAfterShiftStartMemberMobile,
        this.forgetStopWorkAfterShiftEndOwnerMobile,
        this.forgetStopWorkAfterShiftEndMemberMobile,
        this.forgetToBreakOutReminderOwnerMobile,
        this.forgetToBreakOutReminderMemberMobile,
        this.startWorkReminderEmail,
        this.stopWorkReminderEmail,
        this.startBreakReminderEmail,
        this.stopBreakReminderEmail,
        this.forgetStartWorkAfterShiftStartOwnerEmail,
        this.forgetStartWorkAfterShiftStartMemberEmail,
        this.forgetStopWorkAfterShiftEndOwnerEmail,
        this.forgetStopWorkAfterShiftEndMemberEmail,
        this.forgetToBreakOutReminderOwnerEmail,
        this.forgetToBreakOutReminderMemberEmail,
        this.chatNotification,
        this.updateLocationReminderMobile,
        this.updateLocationReminderEmail,
        this.workInfoRate,
        this.timesheetNotification,
        this.expenseNotification,
        this.priceworkNotification,
        this.leaveNotification,
        this.teamNotification,
        this.requestNotification,
        this.feedNotification,
        this.updateLocationReminderHourCheck,
        this.startWork,
        this.stopWork,
        this.locationBoundaryNotification,
        this.travelExpenseSwitch});

  Permissions.fromJson(Map<String, dynamic> json) {
    startWorkReminderMobile = json['start_work_reminder_mobile'];
    allShift = json['all_shift'];
    stopWorkReminderMobile = json['stop_work_reminder_mobile'];
    startBreakReminderMobile = json['start_break_reminder_mobile'];
    stopBreakReminderMobile = json['stop_break_reminder_mobile'];
    forgetStartWorkAfterShiftStartOwnerMobile =
    json['forget_start_work_after_shift_start_owner_mobile'];
    forgetStartWorkAfterShiftStartMemberMobile =
    json['forget_start_work_after_shift_start_member_mobile'];
    forgetStopWorkAfterShiftEndOwnerMobile =
    json['forget_stop_work_after_shift_end_owner_mobile'];
    forgetStopWorkAfterShiftEndMemberMobile =
    json['forget_stop_work_after_shift_end_member_mobile'];
    forgetToBreakOutReminderOwnerMobile =
    json['forget_to_break_out_reminder_owner_mobile'];
    forgetToBreakOutReminderMemberMobile =
    json['forget_to_break_out_reminder_member_mobile'];
    startWorkReminderEmail = json['start_work_reminder_email'];
    stopWorkReminderEmail = json['stop_work_reminder_email'];
    startBreakReminderEmail = json['start_break_reminder_email'];
    stopBreakReminderEmail = json['stop_break_reminder_email'];
    forgetStartWorkAfterShiftStartOwnerEmail =
    json['forget_start_work_after_shift_start_owner_email'];
    forgetStartWorkAfterShiftStartMemberEmail =
    json['forget_start_work_after_shift_start_member_email'];
    forgetStopWorkAfterShiftEndOwnerEmail =
    json['forget_stop_work_after_shift_end_owner_email'];
    forgetStopWorkAfterShiftEndMemberEmail =
    json['forget_stop_work_after_shift_end_member_email'];
    forgetToBreakOutReminderOwnerEmail =
    json['forget_to_break_out_reminder_owner_email'];
    forgetToBreakOutReminderMemberEmail =
    json['forget_to_break_out_reminder_member_email'];
    chatNotification = json['chat_notification'];
    updateLocationReminderMobile = json['update_location_reminder_mobile'];
    updateLocationReminderEmail = json['update_location_reminder_email'];
    workInfoRate = json['work_info_rate'];
    timesheetNotification = json['timesheet_notification'];
    expenseNotification = json['expense_notification'];
    priceworkNotification = json['pricework_notification'];
    leaveNotification = json['leave_notification'];
    teamNotification = json['team_notification'];
    requestNotification = json['request_notification'];
    feedNotification = json['feed_notification'];
    updateLocationReminderHourCheck =
    json['update_location_reminder_hour_check'];
    startWork = json['start_work'];
    stopWork = json['stop_work'];
    locationBoundaryNotification = json['location_boundary_notification'];
    travelExpenseSwitch = json['travel_expense_switch'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start_work_reminder_mobile'] = this.startWorkReminderMobile;
    data['all_shift'] = this.allShift;
    data['stop_work_reminder_mobile'] = this.stopWorkReminderMobile;
    data['start_break_reminder_mobile'] = this.startBreakReminderMobile;
    data['stop_break_reminder_mobile'] = this.stopBreakReminderMobile;
    data['forget_start_work_after_shift_start_owner_mobile'] =
        this.forgetStartWorkAfterShiftStartOwnerMobile;
    data['forget_start_work_after_shift_start_member_mobile'] =
        this.forgetStartWorkAfterShiftStartMemberMobile;
    data['forget_stop_work_after_shift_end_owner_mobile'] =
        this.forgetStopWorkAfterShiftEndOwnerMobile;
    data['forget_stop_work_after_shift_end_member_mobile'] =
        this.forgetStopWorkAfterShiftEndMemberMobile;
    data['forget_to_break_out_reminder_owner_mobile'] =
        this.forgetToBreakOutReminderOwnerMobile;
    data['forget_to_break_out_reminder_member_mobile'] =
        this.forgetToBreakOutReminderMemberMobile;
    data['start_work_reminder_email'] = this.startWorkReminderEmail;
    data['stop_work_reminder_email'] = this.stopWorkReminderEmail;
    data['start_break_reminder_email'] = this.startBreakReminderEmail;
    data['stop_break_reminder_email'] = this.stopBreakReminderEmail;
    data['forget_start_work_after_shift_start_owner_email'] =
        this.forgetStartWorkAfterShiftStartOwnerEmail;
    data['forget_start_work_after_shift_start_member_email'] =
        this.forgetStartWorkAfterShiftStartMemberEmail;
    data['forget_stop_work_after_shift_end_owner_email'] =
        this.forgetStopWorkAfterShiftEndOwnerEmail;
    data['forget_stop_work_after_shift_end_member_email'] =
        this.forgetStopWorkAfterShiftEndMemberEmail;
    data['forget_to_break_out_reminder_owner_email'] =
        this.forgetToBreakOutReminderOwnerEmail;
    data['forget_to_break_out_reminder_member_email'] =
        this.forgetToBreakOutReminderMemberEmail;
    data['chat_notification'] = this.chatNotification;
    data['update_location_reminder_mobile'] = this.updateLocationReminderMobile;
    data['update_location_reminder_email'] = this.updateLocationReminderEmail;
    data['work_info_rate'] = this.workInfoRate;
    data['timesheet_notification'] = this.timesheetNotification;
    data['expense_notification'] = this.expenseNotification;
    data['pricework_notification'] = this.priceworkNotification;
    data['leave_notification'] = this.leaveNotification;
    data['team_notification'] = this.teamNotification;
    data['request_notification'] = this.requestNotification;
    data['feed_notification'] = this.feedNotification;
    data['update_location_reminder_hour_check'] =
        this.updateLocationReminderHourCheck;
    data['start_work'] = this.startWork;
    data['stop_work'] = this.stopWork;
    data['location_boundary_notification'] = this.locationBoundaryNotification;
    data['travel_expense_switch'] = this.travelExpenseSwitch;
    return data;
  }
}
