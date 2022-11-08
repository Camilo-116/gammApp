import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'UserExtendedService.dart';
import '../models/user_model.dart';

class UserBasicService {
  String id = "";
  Future<String?> addUserBasic(UserModel userBasic) async {
    log(userBasic.id.toString());
    await FirebaseFirestore.instance
        .collection('userBasic')
        .add({
          'email': userBasic.email,
          'status': userBasic.profilePhoto,
          'username': userBasic.username,
        })
        .then((value) => id = value.id)
        .catchError((onError) => log(onError));
    return id;
  }

  Future<void> LinkUserBasicExtended(
      String? basic_id, String? extended_id) async {
    log(basic_id.toString());
    await FirebaseFirestore.instance
        .collection('userBasic')
        .doc(basic_id)
        .update({'user_extended_uuid': extended_id});
  }
}
