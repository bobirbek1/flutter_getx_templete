


import 'package:dio/dio.dart';
import 'package:flutter_template/core/error/failure.dart';

Failure handleException(Exception e){
  if (e is DioError) {
          switch (e.type) {
            case DioErrorType.cancel:
              return ServerCancelFailure(message: e.message);
            case DioErrorType.response:
              if (e.response?.statusCode == 401) {
                return ServerUnAuthorizeFailure(message: e.message);
              } else if (e.response?.statusCode == 404) {
                return ServerNotFoundFailure(message: e.message);
              } else {
                return ServerUnknownFailure(message: e.message);
              }
            case DioErrorType.other:
              return ServerUnknownFailure(message: e.message);
            default:
              return ServerTimeOutFailure(message: e.message);
          }
        } else {
          return ServerUnknownFailure(message: e.toString());
        }
}