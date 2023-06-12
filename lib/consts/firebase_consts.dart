// Package imports:
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth authInstance = FirebaseAuth.instance;
final user = authInstance.currentUser;
final uid = user!.uid;
