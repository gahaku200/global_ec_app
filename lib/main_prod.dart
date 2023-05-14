// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'app.dart';
import 'consts/loading.dart';
import 'flavors.dart';
import 'view_model/dark_theme_provider.dart';

void main() {
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
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
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
