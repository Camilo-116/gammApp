import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gamma/client/ui/controllers/user_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../server/models/user_model.dart';

class CreatePost extends StatefulWidget {
  CreatePost({
    Key? key,
    required this.user,
  }) : super(key: key);
  UserModel user;

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    log(widget.user.profilePhoto);
    return SafeArea(
        child: Scaffold(
      backgroundColor: const Color.fromARGB(255, 34, 15, 57),
      body: Column(
        children: [
          _buildTextField(widget.user, width, height),
          _buildPostButton(width, height),
        ],
      ),
    ));
  }
}

Widget _buildTextField(UserModel user, double width, double height) {
  UserController userController = Get.find();
  const maxLines = 15;
  return ListTile(
    leading: CircleAvatar(
      backgroundImage: AssetImage(user.profilePhoto),
      maxRadius: width * 0.0888,
    ),
    title: Container(
      margin: const EdgeInsets.all(12),
      height: maxLines * 24.0,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 34, 15, 57),
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
        maxLines: maxLines,
        autocorrect: false,
        enableSuggestions: false,
        keyboardType: TextInputType.emailAddress,
        style: GoogleFonts.hind(
          color: const Color.fromARGB(255, 254, 244, 255),
          fontSize: (16 / 360) * width,
          fontWeight: FontWeight.normal,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          // contentPadding: const EdgeInsets.only(top: 14.0),
          hintText: '¿Qué quieres compartir?',
          hintStyle: GoogleFonts.hind(
              color: const Color.fromARGB(255, 254, 244, 255),
              fontWeight: FontWeight.normal,
              fontSize: (16 / 360) * width),
        ),
      ),
    ),
    trailing: IconButton(
        icon: Icon(
          Icons.send_rounded,
          color: Colors.white,
          size: width * 0.06,
        ),
        onPressed: () {
          print('Post');
        }),
  );
}

Widget _buildPostButton(double width, double height) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      _buildPostActions('Archivos', width, height),
    ],
  );
}

Widget _buildPostActions(String post, double width, double height) {
  return Container(
      width: width * 0.3,
      padding: EdgeInsets.only(top: 0.0132 * height),
      child: TextButton(
        onPressed: () {
          print('$post Column Pressed');
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(
              vertical: height * 0.0132, horizontal: width * 0.0138),
          backgroundColor: const Color.fromARGB(255, 54, 9, 91),
          minimumSize: const Size(150, 50),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        child: Text(
          post,
          textAlign: TextAlign.center,
          style: GoogleFonts.hind(
              color: const Color.fromARGB(255, 241, 219, 255),
              fontWeight: FontWeight.bold,
              fontSize: width * 0.042),
        ),
      ));
}
