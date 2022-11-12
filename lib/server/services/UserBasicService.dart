import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'UserExtendedService.dart';
import '../models/user_model.dart';

class UserBasicService {
  String id = "";

  Future<UserModel> getUserByUsername(String username) async {
    Map dataUserBasic = {};
    await FirebaseFirestore.instance
        .collection("userBasic")
        .where("username", isEqualTo: username)
        .get()
        .then((res) {
      if (res.docs.isNotEmpty) {
        dataUserBasic = res.docs[0].data();
      }
    });
    return UserModel(
        username: dataUserBasic['username'],
        email: dataUserBasic['email'],
        extendedId: dataUserBasic['user_extended_uuid']);
  }

  Future<String?> addUserBasic(Map userBasic) async {
    log(userBasic['id'].toString());
    await FirebaseFirestore.instance
        .collection('userBasic')
        .add({
          'email': userBasic['email'],
          'status': userBasic['status'],
          'username': userBasic['username'],
        })
        .then((value) => id = value.id)
        .catchError((onError) => log(onError));
    return id;
  }

  Future<void> linkUserBasicExtended(
      String? basicId, String? extendedId) async {
    log(basicId.toString());
    await FirebaseFirestore.instance
        .collection('userBasic')
        .doc(basicId)
        .update({'user_extended_uuid': extendedId});
  }

  Future<void> updateUserBasic(
      String username, Map<String, dynamic> updateInfo) async {
    await FirebaseFirestore.instance
        .collection("userBasic")
        .where("username", isEqualTo: username)
        .get()
        .then((res) async {
      if (res.docs.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection("userBasic")
            .doc(res.docs[0].id)
            .update(updateInfo);
      } else {
        log("User not found");
      }
    });
  }
}
