// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'consts/theme_data.dart';
import 'flavors.dart';
import 'view/fetch_screen.dart';
import 'view/inner_screens/all_products_screen.dart';
import 'view/inner_screens/cat_screen.dart';
import 'view/inner_screens/on_sale_screen.dart';
import 'view/inner_screens/product.details.dart';
import 'view/screens/auth/forget_password.dart';
import 'view/screens/auth/login.dart';
import 'view/screens/auth/register.dart';
import 'view/screens/auth/user_info.dart';
import 'view/screens/btm_bar.dart';
import 'view/screens/orders/orders_screen.dart';
import 'view/screens/viewed_recently/viewed_recently.dart';
import 'view/screens/wishlist/wishlist_screen.dart';
import 'view_model/dark_theme_provider.dart';

class App extends HookConsumerWidget {
  App({super.key});

  final GoRouter _router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return FetchScreen();
        },
        routes: <RouteBase>[
          GoRoute(
            path: 'BottomBarScreen',
            builder: (BuildContext context, GoRouterState state) {
              return BottomBarScreen();
            },
          ),
          GoRoute(
            path: 'OnSaleScreen',
            builder: (BuildContext context, GoRouterState state) {
              return const OnSaleScreen();
            },
          ),
          GoRoute(
            path: 'AllProductsScreen',
            builder: (BuildContext context, GoRouterState state) {
              return const AllProductsScreen();
            },
          ),
          GoRoute(
            path: 'ProductDetails/:product_id',
            builder: (BuildContext context, GoRouterState state) {
              final productId = state.pathParameters['product_id'];
              return ProductDetails(productId: productId);
            },
          ),
          GoRoute(
            path: 'WishlistScreen',
            builder: (BuildContext context, GoRouterState state) {
              return const WishlistScreen();
            },
          ),
          GoRoute(
            path: 'OrderScreen',
            builder: (BuildContext context, GoRouterState state) {
              return const OrderScreen();
            },
          ),
          GoRoute(
            path: 'ViewedRecentlyScreen',
            builder: (BuildContext context, GoRouterState state) {
              return const ViewedRecentlyScreen();
            },
          ),
          GoRoute(
            path: 'LoginScreen',
            builder: (BuildContext context, GoRouterState state) {
              return LoginScreen();
            },
          ),
          GoRoute(
            path: 'RegisterScreen',
            builder: (BuildContext context, GoRouterState state) {
              return RegisterScreen();
            },
          ),
          GoRoute(
            path: 'ForgetPasswordScreen',
            builder: (BuildContext context, GoRouterState state) {
              return ForgetPasswordScreen();
            },
          ),
          GoRoute(
            path: 'CategoryScreen/:catText',
            builder: (BuildContext context, GoRouterState state) {
              final catName = state.pathParameters['catText'];
              return CategoryScreen(catName: catName);
            },
          ),
          GoRoute(
            path: 'LoginScreen',
            builder: (BuildContext context, GoRouterState state) {
              return LoginScreen();
            },
          ),
          GoRoute(
            path: 'FetchScreen',
            builder: (BuildContext context, GoRouterState state) {
              return FetchScreen();
            },
          ),
          GoRoute(
            path: 'UserInfoScreen',
            builder: (BuildContext context, GoRouterState state) {
              return UserInfoScreen();
            },
          ),
        ],
      ),
    ],
  );

  final firebaseInitialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(themeState);
    return FutureBuilder(
      future: firebaseInitialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          const MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('An Error occured'),
              ),
            ),
          );
        }
        return MaterialApp.router(
          routeInformationProvider: _router.routeInformationProvider,
          routeInformationParser: _router.routeInformationParser,
          routerDelegate: _router.routerDelegate,
          debugShowCheckedModeBanner: false,
          title: F.title,
          theme: Styles.themeData(value, context),
        );
      },
    );
  }
}
