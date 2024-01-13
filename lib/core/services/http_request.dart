
import 'package:dio/dio.dart';

import 'http_config.dart';

class HttpRequest {
  static final baseOption = BaseOptions(
      baseUrl: HttpBaseConfig.baseURL,
      method: "get",
      connectTimeout: Duration(seconds: 20));
  static final dio = Dio(baseOption);

  static Future<T?> request<T>(String url,
      {Map<String, dynamic>? params}) async {
    try {
      final option = Options();
      Response<T> rep =
      await dio.request<T>(url, queryParameters: params, options: option);
      return rep.data;
    } on DioException catch (error) {
      return Future.error(error);
    }
  }
}
