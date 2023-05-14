// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'viewed_model.freezed.dart';

@freezed
class ViewedProdModel with _$ViewedProdModel {
  factory ViewedProdModel({
    required String id,
    required String productId,
  }) = _ViewedProdModel;
}
