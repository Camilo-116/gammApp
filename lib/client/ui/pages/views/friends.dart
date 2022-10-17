import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'user.dart';
import '../../pages/home_pages/home.dart';
import '../../pages/home_pages/discover.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({Key? key}) : super(key: key);

  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFB2B2B2),
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          'User',
          style: GoogleFonts.poppins(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        actions: [
          IconButton(
              icon: const Icon(
                Icons.radar,
              ),
              splashRadius: 17,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DiscoverGamers()),
                );
              }),
          IconButton(
            icon: const Icon(
              Icons.notifications,
            ),
            splashRadius: 17,
            onPressed: () {},
          ),
        ],
        centerTitle: true,
        elevation: 2,
      ),
      body: ListView(
        children: [
          buildFriends('DjMariio'),
          buildFriends('El3mpaladorssj'),
          buildFriends('Galoryzen'),
          buildFriends('Booker T'),
          buildFriends('Sameles')
        ],
      ),
    );
  }
}

Widget buildFriends(String Username) => ListTile(
      title: Text(
        Username,
        style: GoogleFonts.poppins(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
      ),
      subtitle: Text(
        'Status',
        style: GoogleFonts.poppins(
            color: Colors.black, fontWeight: FontWeight.normal, fontSize: 16),
      ),
      trailing: Icon(Icons.arrow_forward_ios),
      leading: Image.network(
          'https://cdn-icons-png.flaticon.com/512/149/149071.png'),
      onTap: () {
        print(Username + ' was tapped');
      },
    );
