// Flutter imports:
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../consts/firebase_consts.dart';
import '../providers/dark_theme_provider.dart';
import '../services/global_method.dart';
import '../widgets/text_widget.dart';
import 'loading_manager.dart';

class UserScreen extends HookConsumerWidget {
  UserScreen({super.key});

  final isLoadingProvider = StateProvider((ref) => false);
  final user = authInstance.currentUser;
  final emailProvider = StateProvider((ref) => '');
  final nameProvider = StateProvider((ref) => '');
  final addressProvider = StateProvider((ref) => '');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeState);
    final color = isDark ? Colors.white : Colors.black;
    final addressTextController = useTextEditingController(text: '');
    final isLoading = ref.watch(isLoadingProvider);
    final email = ref.watch(emailProvider);
    final name = ref.watch(nameProvider);
    final address = ref.watch(addressProvider);

    Future<void> getUserData() async {
      ref.read(isLoadingProvider.notifier).state = true;
      if (user == null) {
        ref.read(isLoadingProvider.notifier).state = false;
        return;
      }
      try {
        final uid = user!.uid;
        final DocumentSnapshot userDoc =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();
        ref.read(emailProvider.notifier).state = userDoc.get('email') as String;
        ref.read(nameProvider.notifier).state = userDoc.get('name') as String;
        ref.read(addressProvider.notifier).state =
            userDoc.get('shipping-address') as String;
        addressTextController.text = userDoc.get('shipping-address') as String;
        // ignore: avoid_catches_without_on_clauses
      } catch (error) {
        ref.read(isLoadingProvider.notifier).state = false;
        await GlobalMethods.errorDialog(subtitle: '$error', context: context);
      } finally {
        ref.read(isLoadingProvider.notifier).state = false;
      }
    }

    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          getUserData();
        });
        return;
      },
      [],
    );

    return Scaffold(
      body: LoadingManager(
        isLoading: isLoading,
        child: Center(
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
                          text: name == '' ? 'user' : name,
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
                    text: email == '' ? 'Email' : email,
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
                    subtitle: address,
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
                    title: user == null ? 'Login' : 'Logout',
                    icon: user == null ? IconlyLight.login : IconlyLight.logout,
                    onPressed: () {
                      if (user == null) {
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
      ),
    );
  }

  Future<void> _showAddressDialog(
    BuildContext context,
    WidgetRef ref,
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
              onPressed: () async {
                final uid = user!.uid;
                try {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .update({
                    'shipping-address': addressTextController.text,
                  });

                  Navigator.pop(context);
                  ref.read(addressProvider.notifier).state =
                      addressTextController.text;
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
      onTap: () {
        // ignore: avoid_dynamic_calls
        onPressed();
      },
    );
  }
}
