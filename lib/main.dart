import 'package:flutter/material.dart';
import 'package:gamma/client/ui/controllers/navigation_controller.dart';
import 'package:get/get.dart';

import 'client/ui/app.dart';

void main() {
  Get.put(NavigationController());
  runApp(const MyApp());
}
