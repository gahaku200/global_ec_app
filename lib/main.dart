// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'app.dart';
import 'consts/loading.dart';
import 'flavors.dart';
import 'view_model/dark_theme_provider.dart';

void main() async {
  await dotenv.load();
  FlavorConfig(
    name: 'PROD',
    color: Colors.blue,
    location: BannerLocation.bottomStart,
    variables: {
      'baseUrl': 'https://local-prodapp.com/api',
    },
  );
  F.appFlavor = Flavor.PROD;
  WidgetsFlutterBinding.ensureInitialized();
  // DIの設定
  GetIt.I.registerLazySingleton<FirebaseFirestore>(() {
    return FirebaseFirestore.instance;
  });
  // Stripeの公開鍵
  Stripe.publishableKey = dotenv.env['STRIPE_PUBLIC_KEY_PRO']!;
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then(
    (_) {
      runApp(
        ProviderScope(
          child: Consumer(
            builder: (BuildContext context, ref, child) {
              return FutureBuilder(
                future: ref.watch(themeState.notifier).initialState(),
                builder: (context, AsyncSnapshot<bool> snapshot) {
                  return snapshot.hasData ? App() : const LoadingView();
                },
              );
            },
          ),
        ),
      );
    },
  );
}
