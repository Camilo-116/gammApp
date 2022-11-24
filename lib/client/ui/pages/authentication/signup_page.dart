import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:gamma/client/ui/controllers/user_controller.dart';
import 'package:get/get.dart';

import '../../controllers/authentication_controller.dart';
import 'forms/signup_form.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  AuthenticationController authenticationController = Get.find();
  UserController userController = Get.find();

  void _signUp(String email, String password, Map extraInformation) async {
    if (email.isNotEmpty &&
        password.isNotEmpty &&
        extraInformation['username'].isNotEmpty &&
        extraInformation['name'].isNotEmpty &&
        extraInformation['confirmation'].isNotEmpty) {
      if (password == extraInformation['confirmation']) {
        int userCreated = await authenticationController.signIn(
            email, password, extraInformation);
        setState(() {
          if (userCreated == 0) {
            Navigator.pop(context);
          } else {
            log('UserCreated: $userCreated');
            switch (userCreated) {
              case 1:
                authenticationController.updateSignUpErrors(
                    'Correo Electrónico', {
                  'error': true,
                  'message': 'El email ya se encuentra en uso.'
                });
                break;
              case 2:
                authenticationController.updateSignUpErrors('Contraseña',
                    {'error': true, 'message': 'La contraseña es muy débil.'});
                break;
              case 4:
                authenticationController.updateSignUpErrors('Nombre de Usuario',
                    {'error': true, 'message': 'Ya se encuentra en uso.'});
                break;
              default:
            }
          }
        });
      } else {
        authenticationController.updateSignUpErrors('Confirmar Contraseña',
            {'error': true, 'message': 'Las contraseñas no coinciden.'});
      }
    } else {
      (email.isEmpty)
          ? authenticationController.updateSignUpErrors('Correo Electrónico',
              {'error': true, 'message': 'El campo no puede estar vacío.'})
          : null;
      (password.isEmpty)
          ? authenticationController.updateSignUpErrors('Contraseña',
              {'error': true, 'message': 'El campo no puede estar vacío.'})
          : null;
      (extraInformation['username']!.isEmpty)
          ? authenticationController.updateSignUpErrors('Nombre de Usuario',
              {'error': true, 'message': 'El campo no puede estar vacío.'})
          : null;
      (extraInformation['name']!.isEmpty)
          ? authenticationController.updateSignUpErrors('Nombre',
              {'error': true, 'message': 'El campo no puede estar vacío.'})
          : null;
      (extraInformation['confirmation']!.isEmpty)
          ? authenticationController.updateSignUpErrors('Confirmar Contraseña',
              {'error': true, 'message': 'El campo no puede estar vacío.'})
          : null;
    }
    Future.delayed(const Duration(milliseconds: 300),
        () => authenticationController.ongoingRegister = false);
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
              authenticationController.clearSignUpErrors();
              Navigator.pop(context);
            },
          ),
        ),
      ]),
    );
  }
}
