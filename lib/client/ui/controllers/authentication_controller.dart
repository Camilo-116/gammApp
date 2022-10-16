import 'package:get/get.dart';

class AuthenticationController extends GetxController {
  // ignore: prefer_final_fields
  var _logged = false.obs;

  bool get logged => _logged.value;

  set logged(bool value) {
    _logged.value = logged;
  }
}
