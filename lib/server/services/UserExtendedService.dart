import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../models/user_description.dart';
import './UserBasicService.dart';

class UserExtendedService {
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
