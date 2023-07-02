// ignore_for_file: inference_failure_on_collection_literal, avoid_catches_without_on_clauses

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../../consts/firebase_consts.dart';
import '../../services/global_method.dart';
import '../fetch_screen.dart';
import 'text_widget.dart';

class GoogleButton extends HookConsumerWidget {
  const GoogleButton({super.key});
  static final googleLogin = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  Future<void> _googleSignIn(
    BuildContext context,
    WidgetRef ref,
  ) async {
    try {
      final googleAccount = await googleLogin.signIn();
      if (googleAccount != null) {
        final googleAuth = await googleAccount.authentication;
        if (googleAuth.accessToken != null && googleAuth.idToken != null) {
          try {
            final authResult = await authInstance.signInWithCredential(
              GoogleAuthProvider.credential(
                idToken: googleAuth.idToken,
                accessToken: googleAuth.accessToken,
              ),
            );
            if (authResult.additionalUserInfo!.isNewUser) {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(authResult.user!.uid)
                  .set({
                'id': authResult.user!.uid,
                'name': authResult.user!.displayName,
                'email': authResult.user!.email,
                'shipping-address': '',
                'userWish': [],
                'userCart': [],
                'createdAt': Timestamp.now(),
              });
            }
            ref.read(isFirstProvider.notifier).state = true;
            context.go('/FetchScreen');
          } on FirebaseException catch (error) {
            await GlobalMethods.errorDialog(
              subtitle: '${error.message}',
              context: context,
            );
          } catch (error) {
            await GlobalMethods.errorDialog(
              subtitle: '$error',
              context: context,
            );
          } finally {}
        }
      }
    } catch (e) {
      await GlobalMethods.errorDialog(
        subtitle: '$e',
        context: context,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: Colors.blue,
      child: InkWell(
        onTap: () {
          _googleSignIn(context, ref);
        },
        child: Row(
          children: [
            ColoredBox(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Image.asset(
                  'assets/images/offers/Google.png',
                  width: 32,
                ),
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
