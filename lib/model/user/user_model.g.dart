// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UserModel _$$_UserModelFromJson(Map<String, dynamic> json) => _$_UserModel(
      name: json['name'] as String,
      email: json['email'] as String,
      address: json['address'] as String,
      sex: json['sex'] as int? ?? -1,
      birthday: json['birthday'] as String? ?? '',
      country: json['country'] as String? ?? '',
      zipcode: json['zipcode'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
    );

Map<String, dynamic> _$$_UserModelToJson(_$_UserModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'address': instance.address,
      'sex': instance.sex,
      'birthday': instance.birthday,
      'country': instance.country,
      'zipcode': instance.zipcode,
      'phoneNumber': instance.phoneNumber,
    };
