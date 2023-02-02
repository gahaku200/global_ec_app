// import 'package:cloud_firestore/cloud_firestore.dart';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_flavor/flutter_flavor.dart';

// Project imports:
import '../flavors.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    return Scaffold(
      appBar: AppBar(
        title: Text(F.title),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              'Hello ${F.title}',
            ),
            Text(
              FlavorConfig.instance.variables['baseUrl'].toString(),
            ),
            ElevatedButton(
              child: const Text('test'),
              onPressed: () async {
                // final snapShot =
                //     await FirebaseFirestore.instance.collection('chats').get();
                // final pos = snapShot.docs.first.data()['messages'];
              },
            ),
          ],
        ),
      ),
    );
  }
}
