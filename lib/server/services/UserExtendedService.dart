import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserExtendedService {
  /*
  * This method is used to get a username from the database
  * @param username: Username of the user
  * @return UserModel: user with the given username
  */
  Future<Map?> getUserByUUID(String uuid) async {
    return await FirebaseFirestore.instance
        .collection("userExtended")
        .doc(uuid)
        .get()
        .then((res) {
      if (res.exists && res.data()!.isNotEmpty) {
        return res.data();
      }
    }).catchError((e) => {});
  }

  /*
  * This method is used to create a new userExtended in the database
  * @param documentUserId: Id of the userBasic that is being extended
  * @param userDescription: UserDescription object that contains the description of the user
  * @return String: Id of the userExtended created
   */
  Future<String> addUserExtended(
      String documentUserId, Map userDescription) async {
    return await FirebaseFirestore.instance
        .collection('userExtended')
        .add({
          'user_uuid': documentUserId,
          'name': userDescription['name'],
          'profilePhoto': 'assets/images/user.png',
          'about': userDescription['about'],
          'coverPhoto': userDescription['coverPhoto'],
          'games': [],
          'platforms': [],
          'friends': [],
        })
        .then((value) => value.id)
        .catchError((onError) => "");
  }

  /*
  * This method is to add one friend to the userExtended friends field
  * @param uuid: UUID of the username 
  * @param friendUUID: UUID of the friend to be added
  * @param friendUsername: Username of the friend to be added
  * @return bool: true if the friend was added, false otherwise
  */
  Future<bool> addFriend(
      String uuid, String friendUUID, String friendUsername) async {
    return await FirebaseFirestore.instance
        .collection('userExtended')
        .doc(uuid)
        .update({
          'friends': FieldValue.arrayUnion([
            {
              "uuid": friendUUID,
              "username": friendUsername,
            }
          ])
        })
        .then((value) => true)
        .catchError((onError) => false);
  }
}
