// coverage:ignore-file
// Api module should be tested on integration level.

import 'package:dio/dio.dart';

class ApiTransport {
  ApiTransport({required String baseApiUrl}) : _baseApiUrl = baseApiUrl;

  Dio createHttpClient() {
    return Dio(BaseOptions(baseUrl: _baseApiUrl));
  }

  final String _baseApiUrl;
}
