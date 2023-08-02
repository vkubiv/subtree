import 'package:flutter_login/domain_layer/api/user_api.dart';
import 'package:flutter_login/domain_layer/model/user_profile.dart';
import 'package:flutter_login/domain_layer/user_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserApi extends Mock implements UserApi {}

void main() {
  late MockUserApi userApi;

  setUp(() {
    userApi = MockUserApi();
  });

  test('token stored', () async {
    when(() => userApi.getMyProfile()).thenAnswer((_) async{
      return UserProfile(firstName: 'firstName', lastName: 'lastName', userID: 'userID');
    });

    final service = UserService(userApi: userApi);
    final me = await service.getMyProfile();

    expect(me.firstName, 'firstName');
    expect(me.lastName, 'lastName');
    expect(me.userID, 'userID');
  });
}
