import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

import '../../controllers/authentication_controller.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _isObscure = true;

  AuthenticationController authentication_controller = Get.find();

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
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '\n¡Bienvenido a la mejor comunidad de gamers!',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.hind(
                          color: const Color.fromARGB(255, 254, 244, 255),
                          fontSize: (20.0 / 360) * width,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: (20.0 / 756) * height),
                      _buildTF(
                          'Nombre', TextInputType.name, false, width, height),
                      SizedBox(height: (15.0 / 756) * height),
                      _buildTF('Nombre de Usuario', TextInputType.name, false,
                          width, height),
                      SizedBox(height: (15.0 / 756) * height),
                      _buildTF('Correo Electrónico', TextInputType.emailAddress,
                          false, width, height),
                      SizedBox(height: (15.0 / 756) * height),
                      _buildTF('Contraseña', TextInputType.visiblePassword,
                          _isObscure, width, height),
                      SizedBox(height: (15.0 / 756) * height),
                      _buildTF(
                          'Confirmar Contraseña',
                          TextInputType.visiblePassword,
                          _isObscure,
                          width,
                          height),
                      _buildRememberMeBtn(width, height),
                      _buildRegisterBtn(width, height),
                    ]),
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

  Widget _buildTF(String nCampo, TextInputType type, bool obscure, double width,
      double height) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          nCampo,
          style: GoogleFonts.hind(
            color: Colors.white,
            fontSize: (14.0 / 360) * width,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: (5.0 / 756) * height),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: const Color.fromARGB(69, 255, 255, 255),
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
            keyboardType: type,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(left: (15.0 / 360) * width),
              hintText: (nCampo == 'Confirmar Contraseña')
                  ? 'Ingresa nuevamente tu contraseña'
                  : 'Ingresa tu ${nCampo.toLowerCase()}',
              hintStyle: GoogleFonts.hind(
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontSize: (14 / 360) * width,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRememberMeBtn(double width, double height) {
    return Padding(
      padding:
          EdgeInsets.only(top: (5 / 756) * height, bottom: (20 / 756) * height),
      child: Row(children: <Widget>[
        Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: SizedBox(
              width: (30 / 360) * width,
              height: (30 / 756) * height,
              child: Checkbox(
                value: !_isObscure,
                checkColor: const Color.fromARGB(255, 116, 31, 185),
                activeColor: Colors.white,
                onChanged: (value) {
                  setState(() {
                    _isObscure = !value!;
                  });
                },
              ),
            )),
        Text('Mostrar contraseñas',
            style: GoogleFonts.hind(
              color: Colors.white,
              fontWeight: FontWeight.normal,
            ))
      ]),
    );
  }

  Widget _buildRegisterBtn(double width, double height) {
    return Container(
        padding: const EdgeInsets.only(top: 0, bottom: 0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: (() async {
              log('Register Button Pressed');
              int userCreated = await authentication_controller.signIn(
                  "elpapitodelbackend@gmail.com", "Isaac123_", {
                "name": "El Manguito dulce",
                "profilePhoto": "Una foto de un mango"
              });
              if (userCreated == 0) {
                Navigator.pop(context);
              } else {
                log('Error');
              }
            }),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: (15.0 / 360) * width,
                vertical: (15 / 756) * height,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              backgroundColor: const Color.fromARGB(255, 116, 31, 185),
            ),
            child: Text('Registrar',
                style: GoogleFonts.hind(
                  color: const Color.fromARGB(255, 254, 244, 255),
                  fontSize: (18.0 / 360) * width,
                  fontWeight: FontWeight.bold,
                )),
          ),
        ));
  }
}
