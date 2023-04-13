// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../consts/firebase_consts.dart';
import '../services/global_method.dart';
import 'text_widget.dart';

class GoogleButton extends HookConsumerWidget {
  const GoogleButton({super.key});

  Future<void> _googleSignIn(BuildContext context) async {
    final googleSignIn = GoogleSignIn();
    final googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        try {
          await authInstance.signInWithCredential(
            GoogleAuthProvider.credential(
              idToken: googleAuth.idToken,
              accessToken: googleAuth.accessToken,
            ),
          );
          context.go('/');
        } on FirebaseException catch (error) {
          await GlobalMethods.errorDialog(
            subtitle: '${error.message}',
            context: context,
          );
          // ignore: avoid_catches_without_on_clauses
        } catch (error) {
          await GlobalMethods.errorDialog(
            subtitle: '$error',
            context: context,
          );
        } finally {}
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: Colors.blue,
      child: InkWell(
        onTap: () {
          _googleSignIn(context);
        },
        child: Row(
          children: [
            ColoredBox(
              color: Colors.white,
              child: Image.asset(
                'assets/images/offers/Offer1.jpg',
                width: 40,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            TextWidget(
              text: 'Sign in with google',
              color: Colors.white,
              textSize: 18,
            ),
          ],
        ),
      ),
    );
  }
}
