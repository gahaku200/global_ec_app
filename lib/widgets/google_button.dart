// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'text_widget.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.blue,
      child: InkWell(
        onTap: () {},
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
