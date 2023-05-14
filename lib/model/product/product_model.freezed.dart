// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) {
  return _ProductModel.fromJson(json);
}

/// @nodoc
mixin _$ProductModel {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  String get productCategoryName => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  double get salePrice => throw _privateConstructorUsedError;
  bool get isOnSale => throw _privateConstructorUsedError;
  bool get isPiece => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProductModelCopyWith<ProductModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductModelCopyWith<$Res> {
  factory $ProductModelCopyWith(
          ProductModel value, $Res Function(ProductModel) then) =
      _$ProductModelCopyWithImpl<$Res, ProductModel>;
  @useResult
  $Res call(
      {String id,
      String title,
      String imageUrl,
      String productCategoryName,
      double price,
      double salePrice,
      bool isOnSale,
      bool isPiece});
}

/// @nodoc
class _$ProductModelCopyWithImpl<$Res, $Val extends ProductModel>
    implements $ProductModelCopyWith<$Res> {
  _$ProductModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? imageUrl = null,
    Object? productCategoryName = null,
    Object? price = null,
    Object? salePrice = null,
    Object? isOnSale = null,
    Object? isPiece = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      productCategoryName: null == productCategoryName
          ? _value.productCategoryName
          : productCategoryName // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      salePrice: null == salePrice
          ? _value.salePrice
          : salePrice // ignore: cast_nullable_to_non_nullable
              as double,
      isOnSale: null == isOnSale
          ? _value.isOnSale
          : isOnSale // ignore: cast_nullable_to_non_nullable
              as bool,
      isPiece: null == isPiece
          ? _value.isPiece
          : isPiece // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ProductModelCopyWith<$Res>
    implements $ProductModelCopyWith<$Res> {
  factory _$$_ProductModelCopyWith(
          _$_ProductModel value, $Res Function(_$_ProductModel) then) =
      __$$_ProductModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String imageUrl,
      String productCategoryName,
      double price,
      double salePrice,
      bool isOnSale,
      bool isPiece});
}

/// @nodoc
class __$$_ProductModelCopyWithImpl<$Res>
    extends _$ProductModelCopyWithImpl<$Res, _$_ProductModel>
    implements _$$_ProductModelCopyWith<$Res> {
  __$$_ProductModelCopyWithImpl(
      _$_ProductModel _value, $Res Function(_$_ProductModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? imageUrl = null,
    Object? productCategoryName = null,
    Object? price = null,
    Object? salePrice = null,
    Object? isOnSale = null,
    Object? isPiece = null,
  }) {
    return _then(_$_ProductModel(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      productCategoryName: null == productCategoryName
          ? _value.productCategoryName
          : productCategoryName // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      salePrice: null == salePrice
          ? _value.salePrice
          : salePrice // ignore: cast_nullable_to_non_nullable
              as double,
      isOnSale: null == isOnSale
          ? _value.isOnSale
          : isOnSale // ignore: cast_nullable_to_non_nullable
              as bool,
      isPiece: null == isPiece
          ? _value.isPiece
          : isPiece // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ProductModel implements _ProductModel {
  _$_ProductModel(
      {required this.id,
      required this.title,
      required this.imageUrl,
      required this.productCategoryName,
      required this.price,
      required this.salePrice,
      required this.isOnSale,
      required this.isPiece});

  factory _$_ProductModel.fromJson(Map<String, dynamic> json) =>
      _$$_ProductModelFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String imageUrl;
  @override
  final String productCategoryName;
  @override
  final double price;
  @override
  final double salePrice;
  @override
  final bool isOnSale;
  @override
  final bool isPiece;

  @override
  String toString() {
    return 'ProductModel(id: $id, title: $title, imageUrl: $imageUrl, productCategoryName: $productCategoryName, price: $price, salePrice: $salePrice, isOnSale: $isOnSale, isPiece: $isPiece)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ProductModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.productCategoryName, productCategoryName) ||
                other.productCategoryName == productCategoryName) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.salePrice, salePrice) ||
                other.salePrice == salePrice) &&
            (identical(other.isOnSale, isOnSale) ||
                other.isOnSale == isOnSale) &&
            (identical(other.isPiece, isPiece) || other.isPiece == isPiece));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, imageUrl,
      productCategoryName, price, salePrice, isOnSale, isPiece);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ProductModelCopyWith<_$_ProductModel> get copyWith =>
      __$$_ProductModelCopyWithImpl<_$_ProductModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ProductModelToJson(
      this,
    );
  }
}

abstract class _ProductModel implements ProductModel {
  factory _ProductModel(
      {required final String id,
      required final String title,
      required final String imageUrl,
      required final String productCategoryName,
      required final double price,
      required final double salePrice,
      required final bool isOnSale,
      required final bool isPiece}) = _$_ProductModel;

  factory _ProductModel.fromJson(Map<String, dynamic> json) =
      _$_ProductModel.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get imageUrl;
  @override
  String get productCategoryName;
  @override
  double get price;
  @override
  double get salePrice;
  @override
  bool get isOnSale;
  @override
  bool get isPiece;
  @override
  @JsonKey(ignore: true)
  _$$_ProductModelCopyWith<_$_ProductModel> get copyWith =>
      throw _privateConstructorUsedError;
}
