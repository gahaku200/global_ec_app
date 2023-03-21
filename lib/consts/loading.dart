// Flutter imports:
import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: ColoredBox(
          color: Colors.black87,
          child: Center(
            child: Text(
              'Loading...',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 23,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
