// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:global_ec_app/model/user/user_model.dart';

void main() {
  test('UserModelクラスのUnitテスト', () {
    final defaultResult = UserModel(
      name: 'John',
      email: 'John@example.com',
      address: 'somewhere',
    );
    expect(defaultResult.name, 'John');
    expect(defaultResult.email, 'John@example.com');
    expect(defaultResult.address, 'somewhere');
    expect(defaultResult.sex, -1);
    expect(defaultResult.birthday, '');
    expect(defaultResult.country, '');
    expect(defaultResult.zipcode, '');
    expect(defaultResult.phoneNumber, '');
    expect(defaultResult.stripeCustomerId, '');

    final editedResult = UserModel(
      name: 'Jane',
      email: 'Jane@example.com',
      address: 'somewhere else',
      sex: 0,
      birthday: '20000101',
      country: 'United states',
      zipcode: '123456789',
      phoneNumber: '0123456789',
      stripeCustomerId: 'testId',
    );
    expect(editedResult.name, 'Jane');
    expect(editedResult.email, 'Jane@example.com');
    expect(editedResult.address, 'somewhere else');
    expect(editedResult.sex, 0);
    expect(editedResult.birthday, '20000101');
    expect(editedResult.country, 'United states');
    expect(editedResult.zipcode, '123456789');
    expect(editedResult.phoneNumber, '0123456789');
    expect(editedResult.stripeCustomerId, 'testId');
  });
}
