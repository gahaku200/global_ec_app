// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';

// Project imports:
import 'package:global_ec_app/view_model/user_provider.dart';
import 'user_provider_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<BuildContext>(),
])
void main() {
  group('UserNotifierクラスのUnitテスト', () {
    test('getUserDataメソッドのテスト', () async {
      final mockBuildContext = MockBuildContext();

      // カレントユーザーにMockユーザーを設定
      final mockUser = MockUser(isAnonymous: true, uid: 'mockUser');
      final user = MockFirebaseAuth(
        mockUser: mockUser,
        signedIn: true,
      ).currentUser;

      if (user == null) {
        return;
      }

      // DocumentSnapshot<Map<String, dynamic>>として取得するMockの値を定義
      final firestore = FakeFirebaseFirestore();
      await firestore.collection('users').doc(user.uid).set({
        'name': 'Bob',
        'email': 'Bob@example.com',
        'shipping-address': 'Tokyo',
        'sex': 0,
        'birthday': '20000101',
        'country': 'US',
        'zipcode': '1111111',
        'phoneNumber': '000011112222',
        'stripeCustomerId': 'cus_ABC123def456',
      });

      // DIの設定
      GetIt.I.registerLazySingleton<FirebaseFirestore>(() {
        return firestore;
      });

      // テスト実行
      final userNotifier = UserNotifier();
      await userNotifier.getUserData(mockBuildContext, user);
      final userData = userNotifier.getData();

      expect(userData.name, 'Bob');
      expect(userData.email, 'Bob@example.com');
      expect(userData.address, 'Tokyo');
      expect(userData.sex, 0);
      expect(userData.birthday, '20000101');
      expect(userData.country, 'US');
      expect(userData.zipcode, '1111111');
      expect(userData.phoneNumber, '000011112222');
      expect(userData.stripeCustomerId, 'cus_ABC123def456');
    });
    // test('submitFormOnRegisterメソッドのテスト', () async {});
    // test('submitFormOnLoginメソッドのテスト', () async {});
    // test('updateUserNameメソッドのテスト', () async {});
    // test('updateUserEmailメソッドのテスト', () async {});
    // test('updateUserAddressメソッドのテスト', () async {});
    // test('updateUserSexメソッドのテスト', () async {});
    // test('updateUserBirthdayメソッドのテスト', () async {});
    // test('updateUserCountryメソッドのテスト', () async {});
    // test('updateUserZipcodeメソッドのテスト', () async {});
    // test('updateUserPhoneNumberメソッドのテスト', () async {});
    // test('registerUserStripeCustomerIdメソッドのテスト', () async {});
    // test('checkUserInfoEnoughメソッドのテスト', () {});
    // test('signOutメソッドのテスト', () {});
  });
}
