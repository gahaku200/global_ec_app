// Flutter imports:
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../provider/dark_theme_provider.dart';
import '../services/global_method.dart';
import '../widgets/text_widget.dart';

class UserScreen extends HookConsumerWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeState);
    final color = isDark ? Colors.white : Colors.black;
    final addressTextController = useTextEditingController(text: '');

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 15,
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
                        text: 'MyName',
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
                  text: 'Email@email.com',
                  color: color,
                  textSize: 18,
                  // isTitle: true,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Divider(
                  thickness: 2,
                ),
                const SizedBox(
                  height: 20,
                ),
                _listTile(
                  title: 'Address 2',
                  subtitle: 'My subtitle',
                  icon: IconlyLight.profile,
                  onPressed: () async {
                    await _showAddressDialog(context, addressTextController);
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
                  onPressed: () {},
                  color: color,
                ),
                SwitchListTile(
                  title: TextWidget(
                    text: isDark ? 'Dark mode' : 'Light mode',
                    color: color,
                    textSize: 18,
                    // isTitle: true,
                  ),
                  secondary: Icon(
                    isDark
                        ? Icons.dark_mode_outlined
                        : Icons.light_mode_outlined,
                  ),
                  onChanged: (bool isDark) {
                    ref.read(themeState.notifier).setDarkTheme(isDark);
                  },
                  value: isDark,
                ),
                _listTile(
                  title: 'Logout',
                  icon: IconlyLight.logout,
                  onPressed: () {
                    GlobalMethods.warningDialog(
                      title: 'Sign out',
                      subtitle: 'Do you wanna sign out?',
                      fct: () {},
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
    TextEditingController addressTextController,
  ) async {
    // ignore: inference_failure_on_function_invocation
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update'),
          content: TextField(
            // onChanged: (value) {
            //   print('addressTextController ${addressTextController.text}');
            // },
            controller: addressTextController,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'Your address',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {},
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  Widget _listTile({
    required String title,
    String? subtitle,
    required IconData icon,
    required Function onPressed,
    required Color color,
  }) {
    return ListTile(
      title: TextWidget(
        text: title,
        color: color,
        textSize: 22,
        // isTitle: true,
      ),
      subtitle: TextWidget(
        text: subtitle ?? '',
        color: color,
        textSize: 18,
      ),
      leading: Icon(icon),
      trailing: const Icon(IconlyLight.arrowRight2),
      onTap: () {},
    );
  }
}
