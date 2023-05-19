// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../../../model/order/order_model.dart';
import '../../../services/utils.dart';
import '../../../view_model/products_provider.dart';
import '../../widgets/text_widget.dart';

class OrderWidget extends HookConsumerWidget {
  const OrderWidget({
    super.key,
    required this.orderModel,
  });

  final OrderModel orderModel;

  String formatDateConvert(OrderModel orderModel) {
    final orderDate = orderModel.orderDate;
    return '${orderDate.day}/${orderDate.month}/${orderDate.year}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final utils = Utils(context);
    final color = ref.watch(utils.getTheme);
    final size = utils.getScreenSize;
    final getCurrProduct =
        ref.read(productsProvider.notifier).findProdById(orderModel.productId);

    return ListTile(
      subtitle: Text('Paid: \$${orderModel.price.toStringAsFixed(2)}'),
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
