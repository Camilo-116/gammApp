import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gamma/client/ui/controllers/user_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../server/models/user_model.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({Key? key, this.friends}) : super(key: key);

  final List<UserModel>? friends;

  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  UserController userController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 34, 15, 57),
      body: ListView.builder(
        itemCount: (widget.friends != null)
            ? widget.friends!.length
            : userController.loggedUserFriends.length,
        itemBuilder: (context, index) => buildFriends(
            (widget.friends != null)
                ? widget.friends![index]
                : userController.loggedUserFriends[index],
            context),
      ),
    );
  }
}

Widget buildFriends(UserModel user, BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  return ListTile(
    title: Text(
      user.username,
      style: GoogleFonts.hind(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
    ),
    subtitle: RichText(
      text: TextSpan(children: [
        WidgetSpan(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.00555),
            child: Icon(
              Icons.circle,
              color: (user.status == 'Online')
                  ? Colors.green
                  : (user.status == 'Offline' || user.status == 'Invisible')
                      ? Colors.grey
                      : (user.status == 'Busy')
                          ? Colors.red
                          : Colors.amber,
              size: width * 0.0444,
            ),
          ),
        ),
        TextSpan(
          text: (user.status == 'Invisible') ? 'Offline' : user.status,
          style: GoogleFonts.hind(
              color: Colors.white,
              fontWeight: FontWeight.normal,
              fontSize: width * 0.0444),
        ),
      ]),
    ),
    trailing: const Icon(
      Icons.arrow_forward_ios,
      color: Colors.white,
    ),
    leading: Image.asset(user.profilePhoto),
    onTap: () {
      log('${user.username} was tapped');
    },
  );
}
