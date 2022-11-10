import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:gamma/client/ui/controllers/authentication_controller.dart';
import 'package:gamma/client/ui/controllers/user_controller.dart';
import 'package:gamma/client/ui/pages/authentication/forms/login_form.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String username = "elpapitodelbackend";

  AuthenticationController authenticationController = Get.find();
  UserController userController = Get.find();

  void _login(String email, String password, bool rememberMe) async {
    int userExist = await authenticationController.login(email, password);
    var data = {
      'email': email,
      'password': password,
    };
    log(data.toString());
    log('userExist: $userExist');
    setState(() {
      if (userExist == 0) {
        userController.logUser(email);
      } else {
        log(userExist.toString());
        log('ERROR');
      }
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
