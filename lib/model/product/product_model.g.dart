// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ProductModel _$$_ProductModelFromJson(Map<String, dynamic> json) =>
    _$_ProductModel(
      id: json['id'] as String,
      title: json['title'] as String,
      imageUrlList: (json['imageUrlList'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      productCategoryName: json['productCategoryName'] as String,
      price: (json['price'] as num).toDouble(),
      salePrice: (json['salePrice'] as num).toDouble(),
      isOnSale: json['isOnSale'] as bool,
      isPiece: json['isPiece'] as bool,
      description: json['description'] as String,
    );

Map<String, dynamic> _$$_ProductModelToJson(_$_ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'imageUrlList': instance.imageUrlList,
      'productCategoryName': instance.productCategoryName,
      'price': instance.price,
      'salePrice': instance.salePrice,
      'isOnSale': instance.isOnSale,
      'isPiece': instance.isPiece,
      'description': instance.description,
    };
