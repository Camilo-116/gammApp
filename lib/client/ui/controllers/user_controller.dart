import 'dart:developer';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../server/models/user_model.dart';
import '../../../server/services/UserBasicService.dart';
import '../../../server/services/UserExtendedService.dart';

class UserController extends GetxController {
  var _loggedUsername = "".obs;
  var _loggedUser;

  UserBasicService userBasicService = UserBasicService();
  UserExtendedService userExtendedService = UserExtendedService();

  get loggedUsername => _loggedUsername.value;
  get loggedUser => _loggedUser;

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

  Future<void> logUser(String username) async {
    _loggedUsername.value = username;
    UserModel user = await userBasicService.getUserByUsername(username);
    await FirebaseFirestore.instance
        .collection('userExtended')
        .doc(user.extendedId)
        .get()
        .then((res) {
      user.setValues(res.data()!);
    });
    _loggedUser = user;
  }

  void _addFriends() {
    for (var user in _users) {
      //user.friends.addAll(_users);
      //user.friends.remove(user);
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
