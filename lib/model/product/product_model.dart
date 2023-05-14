// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
class ProductModel with _$ProductModel {
  factory ProductModel({
    required String id,
    required String title,
    required String imageUrl,
    required String productCategoryName,
    required double price,
    required double salePrice,
    required bool isOnSale,
    required bool isPiece,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);
}
