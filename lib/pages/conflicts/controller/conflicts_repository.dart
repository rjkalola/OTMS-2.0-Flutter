import 'package:belcka/web_services/response/response_model.dart';

import '../../../../web_services/api_constants.dart';
import '../../../../web_services/network/api_request.dart';

class ConflictsRepository {
  void getConflicts({
    Map<String, dynamic>? queryParameters,
    Function(ResponseModel responseModel)? onSuccess,
    Function(ResponseModel error)? onError,
  }) {
    ApiRequest(
      url: ApiConstants.companyConflicts,
      queryParameters: queryParameters,
      isFormData: false,
    ).getRequest(
      onSuccess: (data) {
        onSuccess?.call(data);
      },
      onError: (error) {
        if (onError != null) {
          onError(error);
        }
      },
    );
  }

  void deleteTimesheetWorklog({
    required int worklogId,
    Function(ResponseModel responseModel)? onSuccess,
    Function(ResponseModel error)? onError,
  }) {
    ApiRequest(
      url: ApiConstants.deleteTimesheetWorklog,
      data: <String, dynamic>{"worklog_id": worklogId},
      isFormData: false,
    ).postRequest(
      onSuccess: (data) => onSuccess?.call(data),
      onError: (error) => onError?.call(error),
    );
  }

  void cutTimesheetWorklog({
    required List<Map<String, dynamic>> cutData,
    Function(ResponseModel responseModel)? onSuccess,
    Function(ResponseModel error)? onError,
  }) {
    ApiRequest(
      url: ApiConstants.cutTimesheetWorklog,
      data: <String, dynamic>{"cut_data": cutData},
      isFormData: false,
    ).postRequest(
      onSuccess: (data) => onSuccess?.call(data),
      onError: (error) => onError?.call(error),
    );
  }

  void splitTimesheetWorklog({
    required List<Map<String, dynamic>> splitData,
    Function(ResponseModel responseModel)? onSuccess,
    Function(ResponseModel error)? onError,
  }) {
    ApiRequest(
      url: ApiConstants.splitTimesheetWorklog,
      data: <String, dynamic>{"split_data": splitData},
      isFormData: false,
    ).postRequest(
      onSuccess: (data) => onSuccess?.call(data),
      onError: (error) => onError?.call(error),
    );
  }

  void resolveTeamConflict({
    required int teamId,
    Function(ResponseModel responseModel)? onSuccess,
    Function(ResponseModel error)? onError,
  }) {
    ApiRequest(
      url: ApiConstants.resolveTeamConflict,
      data: <String, dynamic>{"team_id": teamId},
      isFormData: false,
    ).postRequest(
      onSuccess: (data) => onSuccess?.call(data),
      onError: (error) => onError?.call(error),
    );
  }

  void resolveHealthSafetyConflict({
    required String conflictType,
    required int recordId,
    Function(ResponseModel responseModel)? onSuccess,
    Function(ResponseModel error)? onError,
  }) {
    ApiRequest(
      url: ApiConstants.resolveHealthSafetyConflict,
      data: <String, dynamic>{
        "conflict_type": conflictType,
        "record_id": recordId,
      },
      isFormData: false,
    ).postRequest(
      onSuccess: (data) => onSuccess?.call(data),
      onError: (error) => onError?.call(error),
    );
  }

  void resolveStoreConflict({
    required String conflictType,
    required int storeId,
    int productId = 0,
    Function(ResponseModel responseModel)? onSuccess,
    Function(ResponseModel error)? onError,
  }) {
    final data = <String, dynamic>{
      "conflict_type": conflictType,
      "store_id": storeId,
    };
    if (productId != 0) {
      data["product_id"] = productId;
    }
    ApiRequest(
      url: ApiConstants.resolveStoreConflict,
      data: data,
      isFormData: false,
    ).postRequest(
      onSuccess: (data) => onSuccess?.call(data),
      onError: (error) => onError?.call(error),
    );
  }

  void approveBillingConflictKeepChanges({
    required int logId,
    required int userId,
    Function(ResponseModel responseModel)? onSuccess,
    Function(ResponseModel error)? onError,
  }) {
    ApiRequest(
      url: ApiConstants.approveRequest,
      data: <String, dynamic>{
        "log_id": logId,
        "user_id": userId,
      },
      isFormData: false,
    ).postRequest(
      onSuccess: (data) => onSuccess?.call(data),
      onError: (error) => onError?.call(error),
    );
  }

  void rejectBillingConflictRequest({
    required int logId,
    required int userId,
    Function(ResponseModel responseModel)? onSuccess,
    Function(ResponseModel error)? onError,
  }) {
    ApiRequest(
      url: ApiConstants.rejectRequest,
      data: <String, dynamic>{
        "log_id": logId,
        "user_id": userId,
      },
      isFormData: false,
    ).postRequest(
      onSuccess: (data) => onSuccess?.call(data),
      onError: (error) => onError?.call(error),
    );
  }

  void discardBillingConflictChanges({
    required int companyId,
    required int userId,
    Function(ResponseModel responseModel)? onSuccess,
    Function(ResponseModel error)? onError,
  }) {
    ApiRequest(
      url: ApiConstants.userBillingResolveConflict,
      data: <String, dynamic>{
        "company_id": companyId,
        "user_id": userId,
      },
      isFormData: false,
    ).postRequest(
      onSuccess: (data) => onSuccess?.call(data),
      onError: (error) => onError?.call(error),
    );
  }
}
