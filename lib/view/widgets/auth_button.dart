// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'text_widget.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({
    super.key,
    required this.fct,
    required this.buttonText,
    this.primary = Colors.white38,
  });
  final Function fct;
  final String buttonText;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
        ),
        // ignore: unnecessary_lambdas
        onPressed: () {
          // ignore: avoid_dynamic_calls
          fct();
        },
        child: TextWidget(
          text: buttonText,
          textSize: 18,
          color: Colors.white,
        ),
      ),
    );
  }
}
