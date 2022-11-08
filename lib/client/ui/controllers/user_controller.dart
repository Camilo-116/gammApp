import 'dart:math';

import 'package:get/get.dart';

import '../../../server/data/models/user_model.dart';

class UserController extends GetxController {
  var status = ['Online', 'Offline', 'Busy', 'Away', 'Invisible'];
  // ignore: prefer_final_fields
  var _users = [
    UserModel(
        id: 0,
        name: "Camilo",
        username: "Boorgir",
        email: "cc@un.co",
        profilePhoto: 'assets/images/user.png'),
    UserModel(
        id: 1,
        name: "Sebastian",
        username: "Sen2Kbron",
        email: "sg@un.co",
        profilePhoto: 'assets/images/user.png'),
    UserModel(
        id: 2,
        name: "Isaac",
        username: "NuclearHands",
        email: "ib@un.co",
        profilePhoto: 'assets/images/user.png'),
    UserModel(
        id: 3,
        name: "Raul",
        username: "Galoryzen",
        email: "rl@un.co",
        profilePhoto: 'assets/images/user.png'),
  ].obs;

  @override
  onInit() {
    super.onInit();
    _addFriends();
    _initStatus();
  }

  void _addFriends() {
    for (var user in _users) {
      user.friends.addAll(_users);
      user.friends.remove(user);
    }
  }

  RxList<UserModel> get users => _users;

  void _initStatus() {
    for (var user in _users) {
      user.status = status[Random().nextInt(status.length)];
    }
  }

  void changeStatus(int id, String status) {
    UserModel user = _users[id];
    user.status = status;
    _users[id] = user;
  }
}
