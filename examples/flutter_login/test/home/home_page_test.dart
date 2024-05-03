// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_login/domain_layer/model/user_profile.dart';
import 'package:flutter_login/home/home.dart';
import 'package:flutter_login/home/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:subtree/subtree.dart';

class MockHomeActions extends Mock implements HomeActions {}

void main() {
  group('HomePage', () {
    late SubtreeModelContainer subtreeModel;
    late MockHomeActions actions;
    late HomeState state;

    setUp(() {
      subtreeModel = SubtreeModelContainer();
      actions = MockHomeActions();
      state = HomeState();

      subtreeModel.put(state);
      subtreeModel.put<HomeActions>(actions);
    });

    testWidgets('loading indicator is shown', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SubtreeModelProvider(
              subtreeModel,
              child: HomePage(),
            ),
          ),
        ),
      );
      expect(find.byType(ElevatedButton), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('user data shown', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SubtreeModelProvider(
              subtreeModel,
              child: HomePage(),
            ),
          ),
        ),
      );

      state.userProfile.value = UserProfile(firstName: 'John', lastName: 'Doe', userID: 'userID');
      await tester.pump();

      expect(find.byType(ElevatedButton), findsOneWidget);

      final texts = tester.widgetList<Text>(find.byType(Text));

      final firstName = texts.firstWhere((t) => t.data?.contains('First name') ?? false);
      expect(firstName.data, contains('John'));

      final lastName = texts.firstWhere((t) => t.data?.contains('Last name') ?? false);
      expect(lastName.data, contains('Doe'));
    });

    testWidgets('shows SnackBar on initialization error', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SubtreeModelProvider(
              subtreeModel,
              child: HomePage(),
            ),
          ),
        ),
      );
      state.errorEvent.emit('Error message');
      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
