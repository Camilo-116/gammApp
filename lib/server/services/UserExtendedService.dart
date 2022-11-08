import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../models/user_description.dart';
import '../models/user_model.dart';
import './UserBasicService.dart';

class UserExtendedService {
  /*
  * This method is used to get a username from the database
  * @param username: Username of the user
  * @return UserModel: user with the given username
  */
  Future getUserByUUID(String uuid) async {
    Map dataUserExtended = {};
    await FirebaseFirestore.instance
        .collection("userExtended")
        .doc(uuid)
        .get()
        .then((res) {
      if (res.exists) {
        dataUserExtended = res.data()!;
      }
    });
    return dataUserExtended;
  }

  /*
      UserModel user = UserModel(
      basic_id: basicId,
      extended_id: extendedId,
      email: dataUserBasic['email'],
      username: dataUserBasic['username'],
      profilePhoto: dataUserBasic['profilePhoto'],
      name: dataUserExtended['name'],
      coverPhoto: dataUserExtended['coverPhoto'] ?? "",
      about: dataUserExtended['about'] ?? "",
      status: dataUserBasic['status'],
    );
  */

  Future<String?> addUserExtended(
      String? document_user_id, Map userDescription) async {
    String id = "";
    await FirebaseFirestore.instance
        .collection('userExtended')
        .add({
          'user_uuid': document_user_id,
          'name': userDescription['name'],
          'profilePhoto': userDescription['profilePhoto'],
          'about': userDescription['about'],
          'coverPhoto': userDescription['coverPhoto'],
          'likes': 0,
          'comments': 0,
          'shares': 0,
          'games': [],
          'platforms': [],
          'friends': [],
        })
        .then((value) => id = value.id)
        .catchError((onError) => log(onError));
    return id;
  }
}
