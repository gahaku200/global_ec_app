// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  factory UserModel({
    required String name,
    required String email,
    required String address,
    @Default(-1) int sex,
    @Default('') String birthday,
    @Default('') String country,
    @Default('') String zipcode,
    @Default('') String phoneNumber,
    @Default('') String stripeCustomerId,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
