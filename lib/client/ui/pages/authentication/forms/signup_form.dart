import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gamma/client/ui/controllers/authentication_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_indicators/progress_indicators.dart';

class SignUpForm extends StatefulWidget {
  final Function callback;

  const SignUpForm({super.key, required this.callback});

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  AuthenticationController authController = Get.find();

  bool _isObscure = true;
  bool _acceptTerms = false;
  String? _name;
  String? _username;
  String? _email;
  String? _password;
  String? _confirmPassword;
  String? _about;

  final textControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Obx(
      () => Column(
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
            _buildTF('Nombre*', TextInputType.name, false, width, height,
                textControllers[0], authController.signUpErrors['Nombre']!),
            SizedBox(height: (15.0 / 756) * height),
            _buildTF(
                'Nombre de Usuario*',
                TextInputType.name,
                false,
                width,
                height,
                textControllers[1],
                authController.signUpErrors['Nombre de Usuario']!),
            SizedBox(height: (15.0 / 756) * height),
            _buildTF(
                'Correo Electrónico*',
                TextInputType.emailAddress,
                false,
                width,
                height,
                textControllers[2],
                authController.signUpErrors['Correo Electrónico']!),
            SizedBox(height: (15.0 / 756) * height),
            _buildTF(
                'Contraseña*',
                TextInputType.visiblePassword,
                _isObscure,
                width,
                height,
                textControllers[3],
                authController.signUpErrors['Contraseña']!),
            SizedBox(height: (15.0 / 756) * height),
            _buildTF(
                'Confirmar Contraseña*',
                TextInputType.visiblePassword,
                _isObscure,
                width,
                height,
                textControllers[4],
                authController.signUpErrors['Confirmar Contraseña']!),
            SizedBox(height: (15.0 / 756) * height),
            _buildTF(
                'Date a conocer, dinos algo de tí',
                TextInputType.multiline,
                false,
                width,
                height,
                textControllers[5],
                authController.signUpErrors['About']!),
            _buildAcceptTermsBtn(width, height),
            _buildRegisterBtn(textControllers, width, height),
          ]),
    );
  }

  Widget _buildTF(
      String nCampo,
      TextInputType type,
      bool obscure,
      double width,
      double height,
      TextEditingController controller,
      Map<String, Object> error) {
    (nCampo == 'About')
        ? nCampo = 'Date a conocer, dinos algo de tí'
        : nCampo = nCampo;
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
            maxLines: (nCampo == 'Date a conocer, dinos algo de tí') ? 10 : 1,
            controller: controller,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(left: (15.0 / 360) * width),
              hintText: (nCampo == 'Confirmar Contraseña')
                  ? 'Ingresa nuevamente tu contraseña'
                  : (nCampo == 'Date a conocer, dinos algo de tí')
                      ? '¿Qué juegos te gustan? ¿Cada cuánto juegas? ¡Lo que se te ocurra!'
                      : 'Ingresa tu ${nCampo.toLowerCase()}',
              hintStyle: GoogleFonts.hind(
                color: const Color.fromARGB(122, 255, 255, 255),
                fontWeight: FontWeight.normal,
                fontSize: (14 / 360) * width,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAcceptTermsBtn(double width, double height) {
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
                value: _acceptTerms,
                checkColor: const Color.fromARGB(255, 116, 31, 185),
                activeColor: Colors.white,
                onChanged: (value) {
                  setState(() {
                    _acceptTerms = value!;
                  });
                },
              ),
            )),
        Text('Aceptar términos y condiciones',
            style: GoogleFonts.hind(
              color: Colors.white,
              fontWeight: FontWeight.normal,
            ))
      ]),
    );
  }

  Widget _buildRegisterBtn(
      List<TextEditingController> controllers, double width, double height) {
    return Container(
      padding: const EdgeInsets.only(top: 0, bottom: 0),
      child: SizedBox(
        width: double.infinity,
        child: Obx(
          () => ElevatedButton(
            onPressed: (authController.ongoingRegister)
                ? null
                : () {
                    if (_acceptTerms) {
                      log('username: ${controllers[1].text}');
                      _name = controllers[0].text;
                      _username = controllers[1].text;
                      _email = controllers[2].text;
                      _password = controllers[3].text;
                      _confirmPassword = controllers[4].text;
                      _about = controllers[5].text;
                      for (var controller in controllers) {
                        _isObscure = true;
                        _acceptTerms = false;
                        controller.clear();
                      }
                      widget.callback(_email, _password, {
                        'name': _name,
                        'username': _username,
                        'confirmation': _confirmPassword,
                        'about': _about
                      });
                      authController.ongoingRegister = true;
                    } else {
                      _dialogBuilder(context);
                    }
                  },
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
            child: (authController.ongoingRegister)
                ? JumpingDotsProgressIndicator(
                    color: const Color.fromARGB(255, 254, 244, 255),
                    fontSize: (18.0 / 360) * width,
                    dotSpacing: (5 / 360) * width,
                  )
                : Text('Registrar',
                    style: GoogleFonts.hind(
                      color: const Color.fromARGB(255, 254, 244, 255),
                      fontSize: (18.0 / 360) * width,
                      fontWeight: FontWeight.bold,
                    )),
          ),
        ),
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        double width = MediaQuery.of(context).size.width;

        return AlertDialog(
          title: const Text(
            'Términos y Condiciones',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color.fromARGB(255, 64, 32, 104),
          content: Text(
            'Para registrate debes aceptar los términos y condiciones de la aplicación.',
            style: GoogleFonts.hind(
              color: Colors.white,
              fontSize: width * 0.0444,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Vale',
                style: GoogleFonts.hind(
                  color: Colors.blue,
                  fontSize: width * 0.0444,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
