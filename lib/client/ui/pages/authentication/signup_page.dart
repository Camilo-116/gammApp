import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
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
                padding: const EdgeInsets.fromLTRB(40.0, 40, 40, 10.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '\n¡Bienvenido a la mejor comunidad de gamers!',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.hind(
                          color: Color.fromARGB(255, 254, 244, 255),
                          fontSize: 20.0,
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
                      const SizedBox(height: 15.0),
                      _buildTF('Nombre de Usuario', TextInputType.name, false),
                      const SizedBox(height: 15.0),
                      _buildTF('Correo Electrónico', TextInputType.emailAddress,
                          false),
                      const SizedBox(height: 15.0),
                      _buildTF('Contraseña', TextInputType.visiblePassword,
                          _isObscure),
                      const SizedBox(height: 15.0),
                      _buildTF('Confirmar Contraseña',
                          TextInputType.visiblePassword, _isObscure),
                      _buildRememberMeBtn(),
                      _buildRegisterBtn(),
                    ]),
              )),
        ),
        Positioned(
          left: 28,
          top: 30,
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

  Widget _buildTF(String nCampo, TextInputType type, bool obscure) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          nCampo,
          style: GoogleFonts.hind(
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
              hintStyle: GoogleFonts.hind(
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ),
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
                checkColor: Color.fromARGB(255, 116, 31, 185),
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

  Widget _buildRegisterBtn() {
    return Container(
        padding: const EdgeInsets.only(top: 0, bottom: 0),
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
              backgroundColor: Color.fromARGB(255, 116, 31, 185),
            ),
            child: Text('Registrar',
                style: GoogleFonts.hind(
                  color: Color.fromARGB(255, 254, 244, 255),
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                )),
          ),
        ));
  }
}
