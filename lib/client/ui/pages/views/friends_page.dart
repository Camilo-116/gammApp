import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gamma/client/ui/controllers/user_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../server/data/models/user_model.dart';
import 'user_page.dart';
import '../../pages/home_pages/home.dart';
import '../../pages/home_pages/discover.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({Key? key, required this.user}) : super(key: key);

  final UserModel user;

  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: widget.user.friends.length,
        itemBuilder: (context, index) =>
            buildFriends(widget.user.friends[index]),
      ),
    );
  }
}

Widget buildFriends(UserModel user) => ListTile(
      title: Text(
        user.username,
        style: GoogleFonts.poppins(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
      ),
      subtitle: Text(
        user.status,
        style: GoogleFonts.poppins(
            color: Colors.black, fontWeight: FontWeight.normal, fontSize: 16),
      ),
      trailing: const Icon(Icons.arrow_forward_ios),
      leading: Image.asset(user.profilePhoto),
      onTap: () {
        print(user.username + ' was tapped');
      },
    );
