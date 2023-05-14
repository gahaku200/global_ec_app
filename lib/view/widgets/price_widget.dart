// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../../services/utils.dart';
import 'text_widget.dart';

class PriceWidget extends HookConsumerWidget {
  const PriceWidget({
    super.key,
    required this.salePrice,
    required this.price,
    required this.textPrice,
    required this.isOnSale,
  });
  final double salePrice;
  final double price;
  final String textPrice;
  final bool isOnSale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final utils = Utils(context);
    final color = ref.watch(utils.getTheme);
    final userPrice = isOnSale ? salePrice : price;
    return FittedBox(
      child: Row(
        children: [
          TextWidget(
            text: '\$${(userPrice * int.parse(textPrice)).toStringAsFixed(2)}',
            color: Colors.green,
            textSize: 18,
          ),
          const SizedBox(
            width: 5,
          ),
          Visibility(
            visible: isOnSale,
            child: Text(
              '\$${(price * int.parse(textPrice)).toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 15,
                color: color,
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
