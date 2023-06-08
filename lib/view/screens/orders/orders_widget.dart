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
  OrderWidget({
    super.key,
    required this.orderModel,
  });

  final OrderModel orderModel;

  final List<String> orderStatus = [
    'Payment completed',
    'Shipping',
    'Received',
    'Cancel',
    'Returns',
  ];

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

    return GestureDetector(
      onTap: () {
        context.go('/ProductDetails/${orderModel.productId}');
      },
      child: Row(
        children: [
          const SizedBox(width: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: FancyShimmerImage(
              height: size.width * 0.15,
              width: size.width * 0.2,
              imageUrl: getCurrProduct.imageUrlList[0],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: SizedBox(
              height: size.width * 0.15,
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      TextWidget(
                        text: orderStatus[orderModel.orderStatus],
                        color: Colors.red.shade400,
                        textSize: 13,
                      ),
                      const Spacer(),
                      TextWidget(
                        text: formatDateConvert(orderModel),
                        color: Colors.grey.shade500,
                        textSize: 13,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      TextWidget(
                        text:
                            '${getCurrProduct.title}  x${orderModel.quantity}',
                        color: color,
                        textSize: 18,
                      ),
                      const Spacer(),
                      Text('Paid: \$${orderModel.price.toStringAsFixed(2)}'),
                    ],
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}
