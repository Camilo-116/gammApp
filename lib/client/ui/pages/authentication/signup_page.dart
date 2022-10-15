import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _rememberMe = false;
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 89, 147, 218),
                Color.fromARGB(255, 78, 140, 212),
                Color.fromARGB(255, 55, 117, 192),
                Color.fromARGB(255, 37, 103, 177),
              ],
              stops: [0.1, 0.4, 0.7, 0.9],
            ),
          ),
        ),
        Center(
          child: SizedBox(
              height: double.infinity,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(40.0, 40, 40, 30.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Registro de Usuario',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(
                          color: Colors.white,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      // Row(
                      //   children: [
                      //     Column(
                      //       children: [
                      //         _buildTF('Nombre', TextInputType.name, false),
                      //       ],
                      //     ),
                      //     Text('Adios')
                      //   ],
                      // ),
                      _buildTF('Nombre', TextInputType.name, false),
                      const SizedBox(height: 20.0),
                      _buildTF('Nombre de Usuario', TextInputType.name, false),
                      const SizedBox(height: 20.0),
                      _buildTF('Contraseña', TextInputType.visiblePassword,
                          _isObscure),
                      const SizedBox(height: 20.0),
                      _buildTF('Confirmar Contraseña',
                          TextInputType.visiblePassword, _isObscure),
                      _buildRememberMeBtn(),
                      _buildRegisterBtn(),
                    ]),
              )),
        )
      ]),
    );
  }

  Widget _buildRowTF(String nCampo1, TextInputType type1, String nCampo2,
      TextInputType type2, bool obscure) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildTF(nCampo1, type1, obscure),
        const SizedBox(height: 20.0),
        _buildTF(nCampo2, type2, obscure),
      ],
    );
  }

  Widget _buildTF(String nCampo, TextInputType type, bool obscure) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          nCampo,
          style: GoogleFonts.openSans(
            color: Colors.white,
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5.0),
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
              contentPadding: const EdgeInsets.only(left: 15.0),
              hintText: (nCampo == 'Confirmar Contraseña')
                  ? 'Ingresa nuevamente tu contraseña'
                  : 'Ingresa tu ${nCampo.toLowerCase()}',
              hintStyle: GoogleFonts.openSans(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForgotBtn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () {
            log('To login page');
            Navigator.pop(context);
          },
          child: const Text('¿Olvidaste tu contraseña o usuario?',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  fontFamily: 'Montserrat')),
        ),
      ],
    );
  }

  Widget _buildRememberMeBtn() {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 20),
      child: Row(children: <Widget>[
        Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: SizedBox(
              width: 30,
              height: 30,
              child: Checkbox(
                value: !_isObscure,
                checkColor: Colors.green,
                activeColor: Colors.white,
                onChanged: (value) {
                  setState(() {
                    _isObscure = !value!;
                  });
                },
              ),
            )),
        Text('Mostrar contraseñas',
            style: GoogleFonts.openSans(
              color: Colors.white,
              fontWeight: FontWeight.normal,
            ))
      ]),
    );
  }

  Widget _buildRegisterBtn() {
    return Container(
        padding: const EdgeInsets.only(top: 25.0, bottom: 10),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: (() {
              print('Register Button Pressed');
              Navigator.pop(context);
            }),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(15.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              backgroundColor: Colors.white,
            ),
            child: Text('Registrar',
                style: GoogleFonts.openSans(
                  color: Colors.blueAccent,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                )),
          ),
        ));
  }

  Widget _buildSignWith() {
    return Column(
      children: <Widget>[
        Text(
          '- O bien -',
          style: GoogleFonts.openSans(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              text: const TextSpan(
                text: '¿No tienes una cuenta? ',
              ),
            ),
            TextButton(
                onPressed: () {
                  log('Register button pressed');
                },
                child: const Text('Registrate aquí',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontFamily: 'Montserrat',
                      color: Colors.white,
                    ))),
          ],
        )
      ],
    );
  }
}
