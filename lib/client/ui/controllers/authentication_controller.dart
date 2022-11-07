import 'package:get/get.dart';

class AuthenticationController extends GetxController {
  // ignore: prefer_final_fields
  var _logged = false.obs;

  bool get logged => _logged.value;

  set logged(bool logged) {
    _logged.value = logged;
  }

  bool login() {
    _logged.value = true;
    return _logged.value;
  }

  void logOut() {
    _logged.value = false;
  }
}
