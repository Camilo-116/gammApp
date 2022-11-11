import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/authentication_controller.dart';
import 'forms/signup_form.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  AuthenticationController authenticationController = Get.find();

  void _signUp(String email, String password, Map extraInformation) async {
    var data = {
      'email': email,
      'password': password,
      'extraInformation': extraInformation,
    };
    log('Sign up data: $data');
    int userCreated = await authenticationController.signIn(
        email, password, extraInformation);
    log('Usercreated: $userCreated');
    setState(() {
      if (userCreated == 0) {
        Navigator.pop(context);
      } else {
        log('Error in creation');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(children: <Widget>[
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 34, 15, 57),
          ),
        ),
        Center(
          child: SizedBox(
              height: double.infinity,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  (40.0 / 360) * width,
                  (40 / 756) * height,
                  (40 / 360) * width,
                  (10.0 / 756) * height,
                ),
                child: SignUpForm(callback: _signUp),
              )),
        ),
        Positioned(
          left: (28 / 360) * width,
          top: (30 / 756) * height,
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ]),
    );
  }
}
