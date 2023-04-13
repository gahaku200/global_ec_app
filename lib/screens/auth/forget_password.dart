// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:card_swiper/card_swiper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../../consts/consts.dart';
import '../../consts/firebase_consts.dart';
import '../../services/global_method.dart';
import '../../services/utils.dart';
import '../../widgets/auth_button.dart';
import '../../widgets/back_widget.dart';
import '../../widgets/text_widget.dart';
import '../loading_manager.dart';

class ForgetPasswordScreen extends HookConsumerWidget {
  ForgetPasswordScreen({super.key});

  final isLoadingProvider = StateProvider((ref) => false);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final utils = Utils(context);
    final size = utils.getScreenSize;
    final emailTextController = useTextEditingController();
    final isLoading = ref.watch(isLoadingProvider);

    Future<void> forgetPassFCT() async {
      if (emailTextController.text.isEmpty ||
          !emailTextController.text.contains('@')) {
        await GlobalMethods.errorDialog(
          subtitle: 'Please enter a correct email address',
          context: context,
        );
      } else {
        ref.read(isLoadingProvider.notifier).state = true;
        try {
          await authInstance.sendPasswordResetEmail(
            email: emailTextController.text.toLowerCase(),
          );
          await Fluttertoast.showToast(
            msg: 'An email has been sent to your email address',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 10,
            backgroundColor: Colors.grey.shade600,
            textColor: Colors.white,
            fontSize: 16,
          );
        } on FirebaseException catch (error) {
          await GlobalMethods.errorDialog(
            subtitle: '${error.message}',
            context: context,
          );
          ref.read(isLoadingProvider.notifier).state = false;
          // ignore: avoid_catches_without_on_clauses
        } catch (error) {
          await GlobalMethods.errorDialog(
            subtitle: '$error',
            context: context,
          );
          ref.read(isLoadingProvider.notifier).state = false;
        } finally {
          ref.read(isLoadingProvider.notifier).state = false;
        }
      }
    }

    return Scaffold(
      body: LoadingManager(
        isLoading: isLoading,
        child: Stack(
          children: [
            Swiper(
              duration: 800,
              autoplayDelay: 6000,
              itemBuilder: (BuildContext context, int index) {
                return Image.asset(
                  Consts.authImagesPaths[index],
                  fit: BoxFit.fill,
                );
              },
              autoplay: true,
              itemCount: Consts.authImagesPaths.length,
            ),
            Container(
              color: Colors.black.withOpacity(0.7),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: size.height * 0.1,
                  ),
                  const BackWidget(),
                  const SizedBox(
                    height: 20,
                  ),
                  TextWidget(
                    text: 'Forget password',
                    color: Colors.white,
                    textSize: 30,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: emailTextController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Email',
                      hintStyle: TextStyle(color: Colors.white),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  AuthButton(
                    fct: forgetPassFCT,
                    buttonText: 'Reset now',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
