import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gamma/client/ui/controllers/authentication_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_indicators/progress_indicators.dart';

import '../signup_page.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key, required this.callback});

  final Function callback;

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  AuthenticationController authController = Get.find();

  // ignore: prefer_final_fields
  bool _isObscure = true;
  bool _rememberMe = false;
  bool _loginPressed = false;
  String? _username;
  String? _password;

  final textControllers = [TextEditingController(), TextEditingController()];

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Obx(
      () => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Conéctate y juega con\ngamers cerca de tí',
              textAlign: TextAlign.center,
              style: GoogleFonts.hind(
                color: Colors.white,
                fontSize: width * (28 / 360),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: (30.0 / 756) * height),
            _buildTF(
                'Nombre de Usuario',
                Icons.person,
                false,
                textControllers[0],
                width,
                height,
                authController.loginErrors['Nombre de Usuario']!),
            SizedBox(height: (20.0 / 756) * height),
            _buildTF('Contraseña', Icons.lock, _isObscure, textControllers[1],
                width, height, authController.loginErrors['Contraseña']!),
            _buildForgotBtn(textControllers, width),
            _buildRememberMeBtn(width, height),
            _buildLoginBtn(textControllers, width, height),
            _buildSignWith(textControllers, width),
          ]),
    );
  }

  Widget _buildTF(
      String nCampo,
      IconData icon,
      bool obscure,
      TextEditingController controller,
      double width,
      double height,
      Map error) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
            Text(
              nCampo,
              style: GoogleFonts.hind(
                color: Colors.white,
                fontSize: (14.0 / 360) * width,
                fontWeight: FontWeight.bold,
              ),
            ),
            (error['error'] != false)
                ? Padding(
                    padding: EdgeInsets.only(left: (10 / 360) * width),
                    child: Text(
                      error['message'].toString(),
                      style: TextStyle(
                        color: const Color.fromARGB(255, 235, 65, 229),
                        fontSize: (8.0 / 360) * width,
                      ),
                    ),
                  )
                : const SizedBox(
                    height: 0,
                  ),
          ],
        ),
        SizedBox(height: (10.0 / 756) * height),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 129, 117, 139),
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            autocorrect: false,
            enableSuggestions: false,
            obscureText: obscure,
            controller: controller,
            keyboardType: TextInputType.emailAddress,
            style: GoogleFonts.hind(
              color: const Color.fromARGB(255, 254, 244, 255),
              fontSize: (16 / 360) * width,
              fontWeight: FontWeight.normal,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              // contentPadding: const EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                icon,
                color: const Color.fromARGB(255, 254, 244, 255),
                size: (25 / 360) * width,
              ),
              hintText: 'Ingresa tu ${nCampo.toLowerCase()}',
              hintStyle: GoogleFonts.hind(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: (16 / 360) * width),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForgotBtn(
      List<TextEditingController> controllers, double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () {
            log('Forgot Password Button Pressed');
          },
          child: Text('¿Olvidaste tu contraseña o usuario?',
              style: GoogleFonts.hind(
                color: const Color.fromARGB(255, 129, 117, 139),
                fontSize: (12 / 360) * width,
                fontWeight: FontWeight.normal,
              )),
        ),
      ],
    );
  }

  Widget _buildLoginBtn(
      List<TextEditingController> controllers, double width, double height) {
    return Container(
        padding: EdgeInsets.only(
            top: (25.0 / 756) * height, bottom: (10 / 756) * height),
        child: SizedBox(
          width: double.infinity,
          child: Obx(
            () => ElevatedButton(
              onPressed: (authController.ongoingLogin)
                  ? null
                  : () {
                      _username = controllers[0].text;
                      _password = controllers[1].text;
                      for (var controller in controllers) {
                        controller.clear();
                      }
                      widget.callback(_username, _password, _rememberMe);
                      authController.ongoingLogin = true;
                    },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all((15.0)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                backgroundColor: const Color.fromARGB(255, 116, 31, 185),
              ),
              child: (authController.ongoingLogin)
                  ? JumpingDotsProgressIndicator(
                      color: const Color.fromARGB(255, 254, 244, 255),
                      fontSize: (18.0 / 360) * width,
                      dotSpacing: (5 / 360) * width,
                    )
                  : Text('Ingresar',
                      style: GoogleFonts.hind(
                        color: const Color.fromARGB(255, 254, 244, 255),
                        fontSize: (18.0 / 360) * width,
                        fontWeight: FontWeight.bold,
                      )),
            ),
          ),
        ));
  }

  Widget _buildSignWith(List<TextEditingController> controllers, double width) {
    return Column(
      children: <Widget>[
        Text(
          '- O bien -',
          style: GoogleFonts.hind(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                text: '¿No tienes una cuenta? ',
                style: GoogleFonts.hind(
                  color: const Color.fromARGB(255, 129, 117, 139),
                  fontSize: (14 / 360) * width,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                log('To signup page');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignupScreen()),
                ).then((value) {
                  for (var controller in controllers) {
                    controller.clear();
                  }
                });
              },
              child: Text(
                'Registrate',
                style: GoogleFonts.hind(
                  color: const Color.fromARGB(255, 235, 65, 229),
                  fontSize: (14 / 360) * width,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildRememberMeBtn(double width, double height) {
    return SizedBox(
      height: (20.0 / 756) * height,
      child: Row(children: <Widget>[
        Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: SizedBox(
              child: Checkbox(
                value: _rememberMe,
                checkColor: const Color.fromARGB(255, 116, 31, 185),
                activeColor: Colors.white,
                onChanged: (value) {
                  setState(() {
                    _rememberMe = value!;
                  });
                },
              ),
            )),
        Text('Mantener sesión iniciada',
            style: GoogleFonts.hind(
              color: Colors.white,
              fontWeight: FontWeight.normal,
              fontSize: (14 / 360) * width,
            ))
      ]),
    );
  }
}
