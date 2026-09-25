//Initial app
// 1. folder structure
// 2. Firebase set up
// 3. Firebase analytics
// 4. Firebase crashlytics
// 5. Localization
// 6. Theme
// 7. Routing
// 8. Network Caller

import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'app/app.dart';
import 'features/auth/ui/controllers/auth_controller.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  String title = 'New Notification';
  String body = '';

  if (message.notification != null) {
    title = message.notification!.title ?? title;
    body = message.notification!.body ?? body;
  } else if (message.data.isNotEmpty) {
    title = message.data['title'] ?? title;
    body = message.data['body'] ?? body;
  }

  await FirebaseFirestore.instance.collection('notifications').add({
    'title': title,
    'body': body,
    'createdAt': FieldValue.serverTimestamp(),
    'isRead': false,
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthController.getUserData();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await GoogleSignIn.instance.initialize(
    serverClientId: '3764606886-a3vuvq6jluogcitu4u52h9qr2pib9d68.apps.googleusercontent.com',
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);


  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(const CraftyBayApp());
}
