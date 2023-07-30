import 'dart:async';
import 'package:dio/dio.dart';

class ApiAuthProvider {
  Stream<void> get onAuthFailed => _onAuthFailedSubject.stream;

  bool get isAuthenticated => _authToken != null;

  Dio addAuth(Dio httpClient) {
    httpClient.options.headers.addAll({'Authorization': 'Bearer ${_authToken!}'});

    httpClient.interceptors.add(InterceptorsWrapper(onError: (e, handler) {
      if (e.response != null && e.response!.statusCode == 401) {
        _onAuthFailedSubject.sink.add(null);
      } else {
        handler.next(e);
      }
    }));

    return httpClient;
  }

  void setAuthToken(String token) {
    _authToken = token;
  }

  void resetAuthToken() {
    _authToken = null;
  }

  final _onAuthFailedSubject = StreamController<void>.broadcast();
  String? _authToken;
}
