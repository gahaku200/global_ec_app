// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_OrderModel _$$_OrderModelFromJson(Map<String, dynamic> json) =>
    _$_OrderModel(
      orderId: json['orderId'] as String,
      userId: json['userId'] as String,
      productId: json['productId'] as String,
      userName: json['userName'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      quantity: json['quantity'] as int,
      orderDate: DateTime.parse(json['orderDate'] as String),
      orderStatus: json['orderStatus'] as int,
    );

Map<String, dynamic> _$$_OrderModelToJson(_$_OrderModel instance) =>
    <String, dynamic>{
      'orderId': instance.orderId,
      'userId': instance.userId,
      'productId': instance.productId,
      'userName': instance.userName,
      'price': instance.price,
      'imageUrl': instance.imageUrl,
      'quantity': instance.quantity,
      'orderDate': instance.orderDate.toIso8601String(),
      'orderStatus': instance.orderStatus,
    };
