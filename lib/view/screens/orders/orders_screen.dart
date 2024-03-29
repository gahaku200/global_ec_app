// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../../../services/utils.dart';
import '../../../view_model/orders_provider.dart';
import '../../widgets/back_widget.dart';
import '../../widgets/empty_screen.dart';
import '../../widgets/text_widget.dart';
import 'orders_widget.dart';

class OrderScreen extends HookConsumerWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final utils = Utils(context);
    final color = ref.watch(utils.getTheme);
    final ordersList = ref.watch(ordersProvider);

    return ordersList.isEmpty
        ? const EmptyScreen(
            imagePath: 'assets/images/offers/shopping-cart.jpeg',
            title: 'You didnt place any order yet',
            subtitle: 'order something and make me happy :)',
            buttonText: 'Shop now',
          )
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              leading: const BackWidget(),
              elevation: 0,
              backgroundColor:
                  Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
              title: TextWidget(
                text: 'Your orders (${ordersList.length})',
                color: color,
                textSize: 24,
                isTitle: true,
              ),
            ),
            body: ListView.separated(
              itemCount: ordersList.length,
              itemBuilder: (ctx, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                  child: OrderWidget(orderModel: ordersList[index]),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  color: color,
                  thickness: 0.1,
                );
              },
            ),
          );
  }
}
