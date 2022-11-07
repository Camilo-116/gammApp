import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../server/data/models/user_model.dart';
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
      backgroundColor: Color.fromARGB(255, 34, 15, 57),
      body: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          buildCover(),
          buildAccountStats(),
          buildEditProfile(),
          buildContent(),
        ],
      ),
    );
  }

  Widget buildCover() => Row(
        children: [
          Container(
            margin: EdgeInsets.only(top: 20, left: 20),
            child: CircleAvatar(
              radius: profileHeight / 2,
              backgroundColor: Color.fromARGB(255, 97, 24, 180),
              child: CircleAvatar(
                  radius: (profileHeight / 2) - 8,
                  backgroundColor: Colors.grey.shade800,
                  backgroundImage: AssetImage(
                    widget.user.profilePhoto,
                  )),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 20),
                child: Text(
                  widget.user.username,
                  style: GoogleFonts.hind(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                      margin: EdgeInsets.only(left: 20, right: 5),
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                      )),
                  Container(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: TextButton(
                        onPressed: () {
                          print('Follow Button Pressed');
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          backgroundColor: Color.fromARGB(255, 54, 9, 91),
                          minimumSize: const Size(100, 40),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                        child: Text(
                          widget.user.status,
                          style: GoogleFonts.hind(
                              color: Color.fromARGB(255, 241, 219, 255),
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      )),
                ],
              ),
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20, top: 10),
                    child: Text(
                      widget.user.email,
                      style: GoogleFonts.hind(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      );

  Widget buildAccountStats() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildStatColumn('Publicaciones', 190),
          buildStatColumn('Seguidores', 1505),
          buildStatColumn('Seguidos', 3054),
        ],
      );

  Widget buildStatColumn(String label, int count) => Container(
      padding: const EdgeInsets.only(top: 10),
      child: TextButton(
        onPressed: () {
          print('Follow Button Pressed');
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          backgroundColor: Color.fromARGB(255, 54, 9, 91),
          minimumSize: const Size(150, 50),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        child: Text(
          count.toString() + '\n' + label,
          textAlign: TextAlign.center,
          style: GoogleFonts.hind(
              color: Color.fromARGB(255, 241, 219, 255),
              fontWeight: FontWeight.bold,
              fontSize: 16),
        ),
      ));

  Widget buildEditProfile() => Padding(
        padding: EdgeInsets.only(top: 20),
        child: Center(
          child: TextButton(
            onPressed: () {
              print('Edit Button Pressed');
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              backgroundColor: Color.fromARGB(255, 54, 9, 91),
              minimumSize: const Size(470, 60),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            child: Text(
              'Editar Perfil',
              style: GoogleFonts.hind(
                  color: Color.fromARGB(255, 241, 219, 255),
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
        ),
      );

  Widget buildContent() => Column(
        children: [
          Divider(),
          Text('Plataformas',
              textAlign: TextAlign.left,
              style: GoogleFonts.hind(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
          Container(
            color: Color.fromARGB(255, 54, 9, 91),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildImg('assets/images/xbox.png'),
                buildImg('assets/images/playstation.png'),
                buildImg('assets/images/switch.png'),
              ],
            ),
          ),
          Divider(),
          Text('Juegos',
              textAlign: TextAlign.left,
              style: GoogleFonts.hind(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
          Container(
            color: Color.fromARGB(255, 54, 9, 91),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildImg('assets/images/rl.png'),
                buildImg('assets/images/valorant.png'),
                buildImg('assets/images/fallguys.png'),
              ],
            ),
          ),
        ],
      );

  Widget buildImg(String img) => ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          img,
          fit: BoxFit.cover,
          width: 100,
          height: 150,
        ),
      );
}
