import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../pages/home_pages/home.dart';
import '../../pages/home_pages/discover.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final double coverHeight = 280;
  final double profileHeight = 144;

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
        padding: EdgeInsets.zero,
        children: <Widget>[
          buildTop(),
          buildContent(),
        ],
      ),
    );
  }

  Widget buildTop() {
    final top = coverHeight - profileHeight / 2;
    final bottom = profileHeight / 2;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: bottom),
          child: buildCover(),
        ),
        Positioned(top: top, child: buildProfileImage()),
      ],
    );
  }

  Widget buildCover() => Container(
      color: Colors.grey,
      child: Image.network(
        "https://t4.ftcdn.net/jpg/04/09/70/87/360_F_409708782_HxuxOH8f7xSmj5p4ygbAbuJE74vGGj2N.jpg",
        width: double.infinity,
        height: coverHeight,
        fit: BoxFit.cover,
      ));

  Widget buildProfileImage() => CircleAvatar(
        radius: profileHeight / 2,
        backgroundColor: Colors.grey.shade800,
        backgroundImage: NetworkImage(
          "https://cdn-icons-png.flaticon.com/512/149/149071.png",
        ),
      );

  Widget buildContent() => Column(
        children: [
          const SizedBox(height: 8),
          Text(
            'Username',
            style: GoogleFonts.poppins(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 28),
          ),
          const SizedBox(height: 8),
          Text(
            'Plataformas de juego',
            style: GoogleFonts.poppins(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: 20),
          ),
          Container(
              padding: EdgeInsets.only(top: 2.0),
              child: TextButton(
                onPressed: () {
                  print('Follow Button Pressed');
                },
                child: Text(
                  'Follow',
                  style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: Colors.grey.shade300,
                  minimumSize: Size(100, 40),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              )),
          const SizedBox(height: 16),
          Divider(),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 16),
              Text(
                'Amigos:',
                style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 22),
              ),
              const SizedBox(width: 16),
              Text(
                'Posts:',
                style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 22),
              ),
              const SizedBox(width: 16),
              Text(
                'Likes:',
                style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 22),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Divider(),
          const SizedBox(height: 16),
          Text(
            'Acerca de Username',
            style: GoogleFonts.poppins(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 28),
          ),
          const SizedBox(height: 8),
          Text(
            'Juegos favoritos: \nRocket League\nFIFA 23\nValorant\nLeague of Legends\nAmong Us',
            style: GoogleFonts.poppins(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: 20),
          ),
        ],
      );
}
