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
    final addressTextController = useTextEditingController(text: '');
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
                    text: 'Hi,  ',
                    style: const TextStyle(
                      color: Colors.cyan,
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: user.name == '' ? 'user' : user.name,
                        style: TextStyle(
                          color: color,
                          fontSize: 25,
                          fontWeight: FontWeight.normal,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                TextWidget(
                  text: user.email == '' ? 'Email' : user.email,
                  color: color,
                  textSize: 18,
                ),
                user.address != ''
                    ? Column(
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          TextWidget(
                            text: user.address,
                            color: color,
                            textSize: 18,
                          ),
                        ],
                      )
                    : Container(),
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  thickness: 2,
                ),
                _listTile(
                  title: 'Address',
                  icon: IconlyLight.profile,
                  onPressed: () async {
                    await _showAddressDialog(
                      context,
                      ref,
                      addressTextController,
                    );
                  },
                  color: color,
                ),
                _listTile(
                  title: 'Orders',
                  icon: IconlyLight.bag,
                  onPressed: () {
                    context.go('/OrderScreen');
                  },
                  color: color,
                ),
                _listTile(
                  title: 'Viewed',
                  icon: IconlyLight.show,
                  onPressed: () {
                    context.go('/ViewedRecentlyScreen');
                  },
                  color: color,
                ),
                _listTile(
                  title: 'Wishlist',
                  icon: IconlyLight.heart,
                  onPressed: () {
                    context.go('/WishlistScreen');
                  },
                  color: color,
                ),
                _listTile(
                  title: 'Forget password',
                  icon: IconlyLight.unlock,
                  onPressed: () {
                    context.go('/ForgetPasswordScreen');
                  },
                  color: color,
                ),
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

  Future<void> _showAddressDialog(
    BuildContext context,
    WidgetRef ref,
    TextEditingController addressTextController,
  ) async {
    final userNotifier = ref.read(userProvider.notifier);
    // ignore: inference_failure_on_function_invocation
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update'),
          content: TextField(
            controller: addressTextController,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'Your address',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  await userNotifier.updateUserAddress(
                    addressTextController.text,
                  );
                  Navigator.pop(context);
                  // ignore: avoid_catches_without_on_clauses
                } catch (err) {
                  await GlobalMethods.errorDialog(
                    subtitle: err.toString(),
                    context: context,
                  );
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
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
