import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/common/enums/http_method_enum.dart';
import 'package:whatsapp_ui/common/utils/utils.dart';

// const BASE_URL = "http://3.110.77.219:3000/";
const BASE_URL = "http://192.168.0.103:3000/";
final httpServiceProvider = Provider<HttpService>((ref) {
  return HttpService();
});

class HttpService {
  Dio? _dio;

  static header() => {"Content-Type": "application/json"};

  Future<HttpService> init() async {
    _dio = Dio(BaseOptions(baseUrl: BASE_URL, headers: header()));
    initInterceptors();
    return this;
  }

  void initInterceptors() {
    _dio!.interceptors.add(
      InterceptorsWrapper(
        onRequest: (requestOptions, handler) {
          logger.i(
              "REQUEST[${requestOptions.method}] => PATH: ${requestOptions.path}"
              "=> REQUEST VALUES: ${requestOptions.queryParameters} => HEADERS: ${requestOptions.headers}");
          return handler.next(requestOptions);
        },
        onResponse: (response, handler) {
          logger
              .i("RESPONSE[${response.statusCode}] => DATA: ${response.data}");
          return handler.next(response);
        },
        onError: (err, handler) {
          logger.i("Error[${err.response?.statusCode}]");
          return handler.next(err);
        },
      ),
    );
  }

  Future<dynamic> request({
    required String endPoint,
    required Method method,
    Map<String, dynamic>? params,
  }) async {
    Response response;

    try {
      if (method == Method.POST) {
        response = await _dio!.post(endPoint, data: params);
      } else if (method == Method.DELETE) {
        response = await _dio!.delete(endPoint);
      } else if (method == Method.PATCH) {
        response = await _dio!.patch(endPoint);
      } else {
        response = await _dio!.get(endPoint, queryParameters: params);
      }

      if (response.statusCode == 200) {
        return response;
      } else if (response.statusCode == 401) {
        throw Exception("Unauthorized");
      } else if (response.statusCode == 500) {
        throw Exception("Server Error");
      } else {
        throw Exception("Something does wen't wrong");
      }
    } on SocketException catch (e) {
      logger.e(e);
      throw Exception("Not Internet Connection");
    } on FormatException catch (e) {
      logger.e(e);
      throw Exception("Bad response format");
    } on DioError catch (e) {
      logger.e(e);
      throw Exception(e);
    } catch (e) {
      logger.e("HTTP SERVICES" + e.toString());
      throw Exception("Something wen't wrong");
    }
  }
}
