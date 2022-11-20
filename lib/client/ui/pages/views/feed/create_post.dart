import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:gamma/client/ui/controllers/post_controller.dart';
import 'package:gamma/client/ui/controllers/user_controller.dart';
import 'package:gamma/client/ui/pages/views/feed/form/create_post_form.dart';
import 'package:gamma/server/services/StorageService.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../server/models/post_model.dart';
import '../../../../../server/models/user_model.dart';

class CreatePost extends StatefulWidget {
  CreatePost({
    Key? key,
  }) : super(key: key);

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  UserController userController = Get.find();
  PostController postController = Get.find();
  StorageService storage = StorageService();

  void _createPost(PostModel post) async {
    await postController.createPost(post).then((res) {
      log('$res');
      if (res) {
        _showBasicFlash('Publicación realizada con éxito');
      } else {
        _showBasicFlash('No se pudo realizar la publicación');
        storage.deleteFile(post.picture).then(
            (res) => (res) ? log('File deleted') : log('File not deleted'));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
      backgroundColor: const Color.fromARGB(255, 34, 15, 57),
      body: CreatePostForm(_createPost),
    ));
  }

  _showBasicFlash(String content) {
    showFlash(
      context: context,
      duration: const Duration(seconds: 2),
      builder: ((context, controller) {
        double width = MediaQuery.of(context).size.width;
        double height = MediaQuery.of(context).size.height;

        return Padding(
          padding: EdgeInsets.only(
            bottom: (20 / 752) * height,
            left: (20 / 360) * width,
            right: (20 / 360) * width,
          ),
          child: Flash(
              controller: controller,
              behavior: FlashBehavior.floating,
              position: FlashPosition.bottom,
              boxShadows: kElevationToShadow[4],
              backgroundColor: Color.fromARGB(189, 15, 11, 18),
              child: FlashBar(
                content: Text(
                  content,
                  style: const TextStyle(color: Colors.white),
                ),
              )),
        );
      }),
    );
  }
}
