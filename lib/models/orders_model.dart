class OrderModel {
  OrderModel({
    required this.orderId,
    required this.userId,
    required this.productId,
    required this.userName,
    required this.price,
    required this.imageUrl,
    required this.quantity,
    required this.orderDate,
  });
  final String orderId;
  final String userId;
  final String productId;
  final String userName;
  final String price;
  final String imageUrl;
  final String quantity;
  final String orderDate;
}
