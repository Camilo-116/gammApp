import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:gamma/client/ui/controllers/authentication_controller.dart';
import 'package:gamma/client/ui/controllers/post_controller.dart';
import 'package:gamma/client/ui/controllers/user_controller.dart';
import 'package:gamma/client/ui/pages/authentication/forms/login_form.dart';
import 'package:gamma/server/services/GpsService.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String username = "elpapitodelbackend";

  AuthenticationController authenticationController = Get.find();
  UserController userController = Get.find();
  PostController postController = Get.find();

  void _login(String username, String password, bool rememberMe) async {
    if (username.isNotEmpty && password.isNotEmpty) {
      int userExist = await authenticationController.login(username, password);
      var data = {
        'username': username,
        'password': password,
      };
      log(data.toString());
      log('userExist: $userExist');
      (userExist == 0)
          ? await userController.logUser(username).catchError((onError) {
              authenticationController.ongoingLogin = false;
              userExist = -1;
              // Future.error(onError);
            })
          : log('Error login');
      setState(() {
        if (userExist == 0) {
          authenticationController.logged = true;
        } else {
          authenticationController.logged = false;
          switch (userExist) {
            case -1:
              log('Error de permisos.');
              break;
            case 1:
              authenticationController.updateLoginErrors('Nombre de Usuario',
                  {'error': true, 'message': 'El usuario no existe.'});
              break;
            case 2:
              authenticationController.updateLoginErrors('Contraseña',
                  {'error': true, 'message': 'La contraseña es incorrecta.'});
              break;
            default:
          }
          log('UserExist: $userExist');
          log('ERROR');
        }
      });
    } else {
      (username.isEmpty)
          ? authenticationController.updateLoginErrors('Nombre de Usuario',
              {'error': true, 'message': 'El campo no puede estar vacío.'})
          : null;
      (password.isEmpty)
          ? authenticationController.updateLoginErrors('Contraseña',
              {'error': true, 'message': 'El campo no puede estar vacío.'})
          : null;
    }
    Future.delayed(const Duration(milliseconds: 300), () {
      authenticationController.ongoingLogin = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: Stack(children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 34, 15, 57),
            ),
          ),
          SizedBox(
              height: double.infinity,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  (40.0 / 360) * width,
                  (70 / 756) * height,
                  (40 / 360) * width,
                  (30.0 / 756) * height,
                ),
                child: LoginForm(callback: _login),
              ))
        ]),
      ),
    );
  }
}
