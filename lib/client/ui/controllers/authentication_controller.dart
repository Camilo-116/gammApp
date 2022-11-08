import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gamma/server/services/UserBasicService.dart';
import 'package:gamma/server/services/UserExtendedService.dart';
import 'package:get/get.dart';

import '../../../server/models/user_model.dart';

class AuthenticationController extends GetxController {
  // ignore: prefer_final_fields
  var _logged = false.obs;

  UserBasicService userBasicService = UserBasicService();
  UserExtendedService userExtendedService = UserExtendedService();

  bool get logged => _logged.value;

  set logged(bool logged) {
    _logged.value = logged;
  }

  /*
  * This method is used to sign in with email and password
  * @param username: Username associated with the account
  * @param password: password of the user
  * @return: 0 if the user is logged in, other number otherwise
  */
  Future<int> login(String username, String password) async {
    /*
    0: Login successful
    1: User not found
    2: Wrong password
    3: Unknown error
    */
    username = username.toLowerCase();
    int credential = 0;
    await FirebaseFirestore.instance
        .collection('userBasic')
        .where('username', isEqualTo: username)
        .get()
        .then((res) async => {
              if (res.docs.isNotEmpty)
                {
                  await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: res.docs[0].data()['email'],
                          password: password)
                      .then((value) => {credential = 0})
                      .catchError((e) => {
                            if (e.code == 'user-not-found')
                              credential = 1
                            else if (e.code == 'wrong-password')
                              credential = 2
                            else
                              credential = 3
                          })
                }
              else
                credential = 1
            });
    return credential;
  }

  /*
  * This method is used to sign up with email and password
  * @param email: Email associated with the account
  * @param password: password of the user
  * @param extraInformation: Extra information about the user such as username, bio...
  * @return: 0 if the user is sign in, other number otherwise
  */
  Future<int> signIn(
      String email, String password, Map extra_information) async {
    /**
   * 0: Sign in successful
   * 1: Email already in use
   * 2: Password is too weak
   * 3: Unknown error
   */
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 2;
      } else if (e.code == 'email-already-in-use') {
        return 1;
      }
      return 3;
    } catch (e) {
      print(e.toString());
      return 3;
    }
    Map user = {
      'name': 'Isaac Blanco',
      'email': email,
      'username': 'elpapitodelbackend',
      'profilePhoto': ''
    };
    String? id = await userBasicService.addUserBasic(user);
    String? idExtended =
        await userExtendedService.addUserExtended(id, extra_information);
    await userBasicService.LinkUserBasicExtended(id, idExtended);
    return 0;
  }

  void logOut() {
    _logged.value = false;
  }
}
