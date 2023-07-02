// Flutter imports:
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../../consts/firebase_consts.dart';
import '../../services/global_method.dart';
import '../../services/utils.dart';
import '../../view_model/dark_theme_provider.dart';
import '../../view_model/user_provider.dart';
import '../widgets/text_widget.dart';
import 'loading_manager.dart';

class UserScreen extends HookConsumerWidget {
  UserScreen({super.key});

  final isLoadingProvider = StateProvider((ref) => false);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final utils = Utils(context);
    final color = ref.watch(utils.getTheme);
    final isDark = ref.watch(themeState);
    final isLoading = ref.watch(isLoadingProvider);
    final isLoadingNotifier = ref.read(isLoadingProvider.notifier);
    final themeStateNotifier = ref.read(themeState.notifier);
    final user = ref.watch(userProvider);
    final userNotifier = ref.read(userProvider.notifier);

    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          isLoadingNotifier.state = true;
          await userNotifier.getUserData(context);
          isLoadingNotifier.state = false;
        });
        return;
      },
      [],
    );

    return Scaffold(
      body: LoadingManager(
        isLoading: isLoading,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 25,
                ),
                RichText(
                  text: TextSpan(
                    text: 'User:  ',
                    style: const TextStyle(
                      color: Colors.cyan,
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text:
                            user.name == '' ? 'Guest not logged in' : user.name,
                        style: TextStyle(
                          color: color,
                          fontSize: 23,
                          fontWeight: FontWeight.normal,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                    ],
                  ),
                ),
                const Divider(
                  thickness: 2,
                ),
                user.name != ''
                    ? _listTile(
                        title: 'Orders',
                        icon: IconlyLight.bag,
                        onPressed: () {
                          context.go('/OrderScreen');
                        },
                        color: color,
                      )
                    : Container(),
                _listTile(
                  title: 'Viewed',
                  icon: IconlyLight.show,
                  onPressed: () {
                    context.go('/ViewedRecentlyScreen');
                  },
                  color: color,
                ),
                user.name != ''
                    ? _listTile(
                        title: 'Wishlist',
                        icon: IconlyLight.heart,
                        onPressed: () {
                          context.go('/WishlistScreen');
                        },
                        color: color,
                      )
                    : Container(),
                user.name != ''
                    ? _listTile(
                        title: 'User info',
                        icon: IconlyLight.profile,
                        onPressed: () async {
                          context.go('/UserInfoScreen');
                        },
                        color: color,
                      )
                    : Container(),
                user.name != ''
                    ? _listTile(
                        title: 'Forget password',
                        icon: IconlyLight.unlock,
                        onPressed: () {
                          context.go('/ForgetPasswordScreen');
                        },
                        color: color,
                      )
                    : Container(),
                SwitchListTile(
                  title: TextWidget(
                    text: isDark ? 'Dark mode' : 'Light mode',
                    color: color,
                    textSize: 22,
                  ),
                  secondary: Icon(
                    isDark
                        ? Icons.dark_mode_outlined
                        : Icons.light_mode_outlined,
                  ),
                  onChanged: themeStateNotifier.setDarkTheme,
                  value: isDark,
                ),
                const SizedBox(
                  height: 10,
                ),
                _listTile(
                  title: user.name == '' ? 'Login' : 'Logout',
                  icon:
                      user.name == '' ? IconlyLight.login : IconlyLight.logout,
                  onPressed: () {
                    if (user.name == '') {
                      context.go('/LoginScreen');
                      return;
                    }
                    GlobalMethods.warningDialog(
                      title: 'Sign out',
                      subtitle: 'Do you wanna sign out?',
                      fct: () async {
                        await authInstance.signOut();
                        userNotifier.signOut();
                        context.go('/LoginScreen');
                      },
                      context: context,
                    );
                  },
                  color: color,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _listTile({
    required String title,
    required IconData icon,
    required Function onPressed,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: TextWidget(
          text: title,
          color: color,
          textSize: 22,
        ),
        leading: Icon(icon),
        trailing: const Icon(IconlyLight.arrowRight2),
        onTap: () {
          // ignore: avoid_dynamic_calls
          onPressed();
        },
      ),
    );
  }
}
