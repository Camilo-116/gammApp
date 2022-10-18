import 'package:get/get.dart';

import '../../../server/data/models/user_model.dart';

class UserController extends GetxController {
  // ignore: prefer_final_fields
  var _users = [
    UserModel(
      id: 0,
      name: "Camilo",
      username: "Boorgir",
      email: "cc@un.co",
    ),
    UserModel(
      id: 1,
      name: "Sebastian",
      username: "Sen2Kbron",
      email: "sg@un.co",
    ),
    UserModel(
      id: 2,
      name: "Isaac",
      username: "NuclearHands",
      email: "ib@un.co",
    ),
    UserModel(
      id: 3,
      name: "Raul",
      username: "Galoryzen",
      email: "rl@un.co",
    ),
  ].obs;

  @override
  onInit() {
    super.onInit();
    // _addFriends();
  }

  void _addFriends() {
    for (var user in _users) {
      user.friends = _users;
      user.friends.remove(user);
    }
  }

  RxList<UserModel> get users => _users;
}
