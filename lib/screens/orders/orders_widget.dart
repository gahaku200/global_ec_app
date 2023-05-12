// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../../models/orders_model.dart';
import '../../providers/products_provider.dart';
import '../../services/utils.dart';
import '../../widgets/text_widget.dart';

class OrderWidget extends HookConsumerWidget {
  const OrderWidget({
    super.key,
    required this.orderModel,
  });

  final OrderModel orderModel;

  String formatDateConvert(OrderModel orderModel) {
    final orderDate = orderModel.orderDate;
    final seconds = int.parse(orderDate.substring(18, 28));
    final nanoseconds =
        int.parse(orderDate.substring(42, orderDate.lastIndexOf(')')));
    final convertedDate = Timestamp(seconds, nanoseconds).toDate();

    return '${convertedDate.day}/${convertedDate.month}/${convertedDate.year}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final utils = Utils(context);
    final color = ref.watch(utils.getTheme);
    final size = utils.getScreenSize;
    final getCurrProduct =
        ref.read(productsProvider.notifier).findProdById(orderModel.productId);

    return ListTile(
      subtitle:
          Text('Paid: \$${double.parse(orderModel.price).toStringAsFixed(2)}'),
      onTap: () {
        context.go('/ProductDetails');
      },
      leading: FancyShimmerImage(
        width: size.width * 0.2,
        imageUrl: getCurrProduct.imageUrl,
      ),
      title: TextWidget(
        text: '${getCurrProduct.title}  x${orderModel.quantity}',
        color: color,
        textSize: 18,
      ),
      trailing: TextWidget(
        text: formatDateConvert(orderModel),
        color: color,
        textSize: 18,
      ),
    );
  }
}
