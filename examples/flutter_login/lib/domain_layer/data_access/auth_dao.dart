import 'package:shared_preferences/shared_preferences.dart';

const _kAuthTokenKey = 'AuthTokenKey';
const _kUserId = 'UserId';

class AuthDao {
  Future<String?> get authToken async => (await SharedPreferences.getInstance()).getString(_kAuthTokenKey);

  Future setAuthToken(String token) async => (await SharedPreferences.getInstance()).setString(_kAuthTokenKey, token);

  Future deleteAuthToken() async => (await SharedPreferences.getInstance()).remove(_kAuthTokenKey);

  Future<String?> get userId async => (await SharedPreferences.getInstance()).getString(_kUserId);

  Future setUserId(String id) async => (await SharedPreferences.getInstance()).setString(_kUserId, id);
}
