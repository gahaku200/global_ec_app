// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:badges/badges.dart' as badges;
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../../view_model/btm_bar_provider.dart';
import '../../view_model/cart_provider.dart';
import '../../view_model/dark_theme_provider.dart';
import '../widgets/text_widget.dart';
import 'cart/cart_screen.dart';
import 'categories.dart';
import 'home_screen.dart';
import 'user/user.dart';

class BottomBarScreen extends HookConsumerWidget {
  BottomBarScreen({super.key});

  final List<Map<String, dynamic>> _pages = [
    {'page': const HomeScreen(), 'title': 'Home Screen'},
    {'page': const CategoriesScreen(), 'title': 'Categories Screen'},
    {'page': const CartScreen(), 'title': 'Cart Screen'},
    {'page': UserScreen(), 'title': 'User Screen'},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(btmBarState);
    final isDark = ref.watch(themeState);
    final carts = ref.watch(cartProvider);

    return Scaffold(
      body: _pages[selectedIndex]['page'] as Widget,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: isDark ? Theme.of(context).cardColor : Colors.white,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: selectedIndex,
        unselectedItemColor: isDark ? Colors.white10 : Colors.black12,
        selectedItemColor: isDark ? Colors.lightBlue.shade200 : Colors.black87,
        onTap: (index) {
          ref.read(btmBarState.notifier).setBtmBarState(index);
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(selectedIndex == 0 ? IconlyBold.home : IconlyLight.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              selectedIndex == 1 ? IconlyBold.category : IconlyLight.category,
            ),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: badges.Badge(
              position: badges.BadgePosition.topEnd(top: -12, end: -9),
              badgeContent: FittedBox(
                child: TextWidget(
                  text: carts.length.toString(),
                  color: Colors.white,
                  textSize: 15,
                ),
              ),
              badgeAnimation: const badges.BadgeAnimation.rotation(
                animationDuration: Duration(seconds: 1),
                colorChangeAnimationDuration: Duration(seconds: 1),
                curve: Curves.fastOutSlowIn,
                colorChangeAnimationCurve: Curves.easeInCubic,
              ),
              badgeStyle: badges.BadgeStyle(
                //shape: badges.BadgeShape.circle,
                badgeColor: Colors.blue,
                //padding: const EdgeInsets.all(5),
                borderRadius: BorderRadius.circular(8),
                elevation: 0,
              ),
              child: Icon(
                selectedIndex == 2 ? IconlyBold.buy : IconlyLight.buy,
              ),
            ),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon:
                Icon(selectedIndex == 3 ? IconlyBold.user2 : IconlyLight.user2),
            label: 'User',
          ),
        ],
      ),
    );
  }
}
