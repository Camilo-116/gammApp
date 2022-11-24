import 'package:get/get.dart';

class NotificationController extends GetxController {
  var _notifications = <String>[].obs;

  List<String> get notifications => _notifications;

  void addNotification(String notification) {
    _notifications.add(notification);
  }

  void removeNotification(String notification) {
    _notifications.remove(notification);
  }
}
