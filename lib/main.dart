import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gamma/client/ui/controllers/authentication_controller.dart';
import 'package:gamma/client/ui/controllers/navigation_controller.dart';
import 'package:gamma/client/ui/controllers/post_controller.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

import 'config.dart';
import 'client/ui/app.dart';
import 'client/ui/controllers/user_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
        // ignore: prefer_const_constructors
        options: FirebaseOptions(
            apiKey: Configuration.apiKey,
            appId: Configuration.appId,
            messagingSenderId: Configuration.messagingSenderId,
            projectId: Configuration.projectId,
            storageBucket: Configuration.storageBucket));
    log("Firebase initialized");
  } catch (e) {
    log(e.toString());
  }
  Get.put(NavigationController());
  Get.put(AuthenticationController());
  Get.put(UserController());
  Get.put(PostController());
  runApp(const MyApp());
}
