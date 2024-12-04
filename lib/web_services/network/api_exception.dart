import 'package:dio/dio.dart';

class ApiException implements Exception {
  ApiException.fromDioError(DioException dioError) {
   /* switch (dioError.type) {
      case DioExceptionType.cancel:
        message = "Request to API server was cancelled";
        break;
      case DioExceptionType.connectionTimeout:
        message = "Connection timeout with API server";
        break;
      case DioExceptionType.receiveTimeout:
        message = "Receive timeout in connection with API server";
        break;
      case DioExceptionType.badResponse:
        message = _handleError(
          dioError.response?.statusCode,
          dioError.response?.data,
        );
        break;
      case DioExceptionType.sendTimeout:
        message = "Send timeout in connection with API server";
        break;
      case DioExceptionType.connectionError:
        message = 'No Internet';
        break;
        // if (dioError.message.contains("SocketException")) {
        //   message = 'No Internet';
        //   break;
        // }
        message = "Unexpected error occurred";
        break;
      default:
        message = "Something went wrong";
        break;
    }*/
    switch (dioError.type) {
      case DioExceptionType.cancel:
        message = "";
        break;
      case DioExceptionType.connectionTimeout:
        message = "";
        break;
      case DioExceptionType.receiveTimeout:
        message = "";
        break;
      case DioExceptionType.badResponse:
        message = _handleError(
          dioError.response?.statusCode,
          dioError.response?.data,
        );
        break;
      case DioExceptionType.sendTimeout:
        message = "";
        break;
      case DioExceptionType.connectionError:
        // message = 'No Internet';
        message = '';
        break;
        // if (dioError.message.contains("SocketException")) {
        //   message = 'No Internet';
        //   break;
        // }
        message = "Unexpected error occurred";
        break;
      default:
        message = "";
        break;
    }
  }

  late String message;

  @override
  String toString() => message;

  String _handleError(int? statusCode, dynamic error) {
    // switch (statusCode) {
    //   case 400:
    //     return 'Bad request';
    //   case 401:
    //     return 'Unauthorized';
    //   case 403:
    //     return 'Forbidden';
    //   case 404:
    //     return error['error'];
    //   case 500:
    //     return 'Internal server error';
    //   case 502:
    //     return 'Bad gateway';
    //   default:
    //     return 'Oops something went wrong';
    // }
    switch (statusCode) {
      case 400:
        return '';
      case 401:
        return 'Unauthorized';
      case 403:
        return '';
      case 404:
        return error['error'];
      case 500:
        return '';
      case 502:
        return '';
      default:
        return '';
    }
  }
}
