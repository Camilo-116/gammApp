import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gamma/server/services/UserBasicService.dart';
import 'package:gamma/server/services/UserExtendedService.dart';
import 'package:get/get.dart';

class AuthenticationController extends GetxController {
  // ignore: prefer_final_fields
  var _logged = false.obs;
  var _ongoingLogin = false.obs;
  var _ongoingRegister = false.obs;
  var _loginErrors = {
    'Nombre de Usuario': {
      'error': false,
      'message': '',
    },
    'Contraseña': {
      'error': false,
      'message': '',
    },
  }.obs;
  var _signUpErrors = {
    'Nombre': {
      'error': false,
      'message': '',
    },
    'Nombre de Usuario': {
      'error': false,
      'message': '',
    },
    'Correo Electrónico': {
      'error': false,
      'message': '',
    },
    'Contraseña': {
      'error': false,
      'message': '',
    },
    'Confirmar Contraseña': {
      'error': false,
      'message': '',
    },
    'About': {
      'error': false,
      'message': '',
    },
  }.obs;

  UserBasicService userBasicService = UserBasicService();
  UserExtendedService userExtendedService = UserExtendedService();

  bool get logged => _logged.value;
  bool get ongoingLogin => _ongoingLogin.value;
  bool get ongoingRegister => _ongoingRegister.value;
  Map<String, Map<String, Object>> get signUpErrors => _signUpErrors;
  Map<String, Map<String, Object>> get loginErrors => _loginErrors;

  set logged(bool value) => _logged.value = value;
  set ongoingLogin(bool value) => _ongoingLogin.value = value;
  set ongoingRegister(bool value) => _ongoingRegister.value = value;

  void updateSignUpErrors(String campo, Map<String, Object> signUpErrors) {
    _signUpErrors[campo] = signUpErrors;
    _signUpErrors.refresh();
  }

  void updateLoginErrors(String campo, Map<String, Object> loginErrors) {
    _loginErrors[campo] = loginErrors;
    _loginErrors.refresh();
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
    int credential = 0;
    log('username: $username');
    log('password: $password');
    await FirebaseFirestore.instance
        .collection('userBasic')
        .where('username', isEqualTo: username)
        .get()
        .then((res) async {
      if (res.docs.isNotEmpty) {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: res.docs[0].data()['email'], password: password)
            .then((value) => {credential = 0})
            .catchError((e) => {
                  if (e.code == 'user-not-found')
                    credential = 1
                  else if (e.code == 'wrong-password')
                    credential = 2
                  else
                    credential = 3
                });
      } else {
        credential = 1;
      }
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
      String email, String password, Map extraInformation) async {
    /**
   * 0: Sign in successful
   * 1: Email already in use
   * 2: Password is too weak
   * 4: Username already in use
   * 3: Unknown error
   */
    String username = extraInformation['username'];
    return await FirebaseFirestore.instance
        .collection('userBasic')
        .where('username', isEqualTo: username)
        .get()
        .then((res) async {
      if (res.docs.isEmpty) {
        try {
          await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: email, password: password);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            return 2;
          } else if (e.code == 'email-already-in-use') {
            return 1;
          }
          return 3;
        } catch (e) {
          log('Firebase Auth exception: $e');
          return 3;
        }
        Map user = {
          'name': extraInformation['name'],
          'email': email,
          'username': extraInformation['username'],
          'status': 'Offline'
        };
        String? id = await userBasicService.addUserBasic(user);
        String idExtended =
            await userExtendedService.addUserExtended(id!, extraInformation);
        await userBasicService.linkUserBasicExtended(id, idExtended);
        return 0;
      }
      return 4;
    });
  }

  void logOut() {
    _logged.value = false;
  }

  /// This method clears the errors in the sign up form
  void clearSignUpErrors() {
    _signUpErrors = {
      'Nombre': {
        'error': false,
        'message': '',
      },
      'Nombre de Usuario': {
        'error': false,
        'message': '',
      },
      'Correo Electrónico': {
        'error': false,
        'message': '',
      },
      'Contraseña': {
        'error': false,
        'message': '',
      },
      'Confirmar Contraseña': {
        'error': false,
        'message': '',
      },
      'About': {
        'error': false,
        'message': '',
      },
    }.obs;
  }

  /// This method clears the login errors in the form
  void clearLoginErrors() {
    _loginErrors = {
      'Nombre de Usuario': {
        'error': false,
        'message': '',
      },
      'Contraseña': {
        'error': false,
        'message': '',
      },
    }.obs;
  }
}
