// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_model.freezed.dart';
part 'order_model.g.dart';

@freezed
class OrderModel with _$OrderModel {
  factory OrderModel({
    required String orderId,
    required String userId,
    required String productId,
    required String userName,
    required double price,
    required String imageUrl,
    required int quantity,
    required DateTime orderDate,
  }) = _OrderModel;

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);
}
