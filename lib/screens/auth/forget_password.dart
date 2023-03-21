// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../../consts/consts.dart';
import '../../services/utils.dart';
import '../../widgets/auth_button.dart';
import '../../widgets/back_widget.dart';
import '../../widgets/text_widget.dart';

class ForgetPasswordScreen extends HookConsumerWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final utils = Utils(context);
    final size = utils.getScreenSize;
    final emailTextController = useTextEditingController();

    Future<void> forgetPassFCT() async {}

    return Scaffold(
      body: Stack(
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
    );
  }
}
