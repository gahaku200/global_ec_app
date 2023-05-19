// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../../../services/global_method.dart';
import '../../../services/utils.dart';
import '../../../view_model/viewed_provider.dart';
import '../../widgets/back_widget.dart';
import '../../widgets/empty_screen.dart';
import '../../widgets/text_widget.dart';
import 'viewed_widget.dart';

class ViewedRecentlyScreen extends HookConsumerWidget {
  const ViewedRecentlyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final utils = Utils(context);
    final color = ref.watch(utils.getTheme);
    final viewedProd = ref.watch(viewedProdProvider);
    final viewedProdItemsList = viewedProd.values.toList().reversed.toList();

    if (viewedProdItemsList.isEmpty) {
      return const EmptyScreen(
        imagePath: 'assets/images/offers/Offer1.jpg',
        title: 'Your history is empty',
        subtitle: 'No products has been viewed yet!',
        buttonText: 'Shop now',
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: const BackWidget(),
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor:
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
          title: TextWidget(
            text: 'History',
            color: color,
            textSize: 24,
            isTitle: true,
          ),
          actions: [
            IconButton(
              onPressed: () {
                GlobalMethods.warningDialog(
                  title: 'Empty your history?',
                  subtitle: 'Are you sure?',
                  fct: () {
                    ref.read(viewedProdProvider.notifier).clearHistory();
                  },
                  context: context,
                );
              },
              icon: Icon(
                IconlyBroken.delete,
                color: color,
              ),
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: viewedProdItemsList.length,
          itemBuilder: (ctx, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
              child: ViewedRecentlyWidget(
                viewedProdModel: viewedProdItemsList[index],
              ),
            );
          },
        ),
      );
    }
  }
}
