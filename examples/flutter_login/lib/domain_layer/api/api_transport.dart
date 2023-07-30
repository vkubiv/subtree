import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

class ApiTransport {
  ApiTransport({required this.baseApiUrl});

  Dio createHttpClient() {
    return Dio(BaseOptions(baseUrl: baseApiUrl));
  }

  @protected
  String baseApiUrl;
}
