import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../server/data/models/user_model.dart';
import '../../pages/home_pages/home.dart';
import '../../pages/home_pages/discover.dart';

class UserPage extends StatefulWidget {
  UserPage({
    Key? key,
    required this.user,
  }) : super(key: key);
  UserModel user;
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
          'Usuario',
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
        widget.user.coverPhoto,
        width: double.infinity,
        height: coverHeight,
        fit: BoxFit.cover,
      ));

  Widget buildProfileImage() => CircleAvatar(
        radius: profileHeight / 2,
        backgroundColor: Colors.grey.shade800,
        backgroundImage: NetworkImage(
          widget.user.profilePhoto,
        ),
      );

  Widget buildContent() => Column(
        children: [
          const SizedBox(height: 8),
          Text(
            widget.user.username,
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
              padding: const EdgeInsets.only(top: 2.0),
              child: TextButton(
                onPressed: () {
                  print('Follow Button Pressed');
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: Colors.grey.shade300,
                  minimumSize: const Size(100, 40),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                child: Text(
                  'Seguir',
                  style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
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
            'Acerca de ${widget.user.username}',
            style: GoogleFonts.poppins(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 28),
          ),
          const SizedBox(height: 8),
          Text(
            widget.user.about,
            style: GoogleFonts.poppins(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: 20),
          ),
        ],
      );
}
