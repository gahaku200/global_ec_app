// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'wishlist_model.freezed.dart';
part 'wishlist_model.g.dart';

@freezed
class WishlistModel with _$WishlistModel {
  factory WishlistModel({
    required String id,
    required String productId,
  }) = _WishlistModel;

  factory WishlistModel.fromJson(Map<String, dynamic> json) =>
      _$WishlistModelFromJson(json);
}
