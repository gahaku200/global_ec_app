class ProductModel {
  ProductModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.productCategoryName,
    required this.price,
    required this.salePrice,
    required this.isOnSale,
    required this.isPiece,
  });
  final String id;
  final String title;
  final String imageUrl;
  final String productCategoryName;
  final double price;
  final double salePrice;
  final bool isOnSale;
  final bool isPiece;
}
