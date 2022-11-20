import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gamma/client/ui/controllers/user_controller.dart';
import 'package:gamma/client/ui/pages/views/user/user_page.dart';
import 'package:gamma/server/services/StorageService.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../server/models/user_model.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({Key? key, this.userUUID}) : super(key: key);

  final String? userUUID;

  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  UserController userController = Get.find();
  StorageService storage = StorageService();

  var friends;

  @override
  Widget build(BuildContext context) {
    (widget.userUUID != null)
        ? friends = userController.getFriends(widget.userUUID!)
        : {};

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 34, 15, 57),
      body: (widget.userUUID != null)
          ? FutureBuilder(
              future: friends,
              builder: (context, snapshot) {
                if (snapshot.hasData && !snapshot.hasError) {
                  var friends = snapshot.data as List<UserModel>;
                  return ListView.builder(
                    itemCount: friends.length,
                    itemBuilder: (context, index) =>
                        buildFriends(friends[index], context),
                  );
                } else {
                  return Stack(children: [
                    Container(
                      color: const Color.fromARGB(255, 34, 15, 57),
                    ),
                    const Center(
                      child: CircularProgressIndicator(
                        color: Color.fromARGB(255, 99, 46, 162),
                      ),
                    ),
                  ]);
                }
              })
          : ListView.builder(
              itemCount: userController.loggedUserFriends.length,
              itemBuilder: (context, index) => buildFriends(
                  userController.loggedUserFriends[index], context),
            ),
    );
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
      leading: FutureBuilder(
          future: storage.downloadURL(user.profilePhoto),
          builder: (context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData && !snapshot.hasError) {
              return CircleAvatar(
                backgroundImage: NetworkImage(snapshot.data!),
                radius: width * 0.0555,
              );
            } else {
              return const CircularProgressIndicator();
            }
          }),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Scaffold(
                    backgroundColor: const Color.fromARGB(255, 34, 15, 57),
                    appBar: AppBar(
                      backgroundColor: const Color.fromARGB(255, 34, 15, 57),
                      title: Text(
                        'Perfil de ${user.username}',
                        style: GoogleFonts.hind(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.0555),
                      ),
                    ),
                    body: UserPage(userUUID: user.id),
                  )),
        );
        log('${user.username} was tapped');
      },
    );
  }
}
