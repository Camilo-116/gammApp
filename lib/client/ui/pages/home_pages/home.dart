import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../views/user.dart';
import 'discover.dart';
import 'home_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      drawer: Drawer(
        child: Container(
          color: Colors.grey,
          child: HomeDrawer(),
        ),
      ),
      drawerDragStartBehavior: DragStartBehavior.start,
      drawerEdgeDragWidth: 40,
      appBar: AppBar(
        backgroundColor: const Color(0xFFB2B2B2),
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          'GammApp',
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
      body: post(),
    );
  }

  Widget post() {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: 1,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(12, 5, 12, 2),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              width: 46,
                              height: 46,
                              clipBehavior: Clip.antiAlias,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Image.network(
                                'https://cdn-icons-png.flaticon.com/512/149/149071.png',
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  6, 0, 0, 0),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const UserPage()),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                ),
                                child: Text(
                                  'Username',
                                  style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                            const Expanded(
                              child: Align(
                                alignment: AlignmentDirectional(1, 0),
                                child: Icon(
                                  Icons.keyboard_control,
                                  color: Colors.black,
                                  size: 24,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Image.network(
                        'https://picsum.photos/seed/901/600',
                        width: 100,
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  IconButton(
                                    icon: const Icon(
                                      Icons.favorite_border,
                                      color: Color(0xFFFF0000),
                                      size: 24,
                                    ),
                                    onPressed: () {
                                      print('Like pressed ...');
                                    },
                                  ),
                                  Text(
                                    '1.2 K',
                                    style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.comment_outlined,
                                      color: Colors.black,
                                      size: 24,
                                    ),
                                    onPressed: () {
                                      print('Make a comment...');
                                    },
                                  ),
                                  Text(
                                    '120',
                                    style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.ios_share,
                                      color: Colors.black,
                                      size: 24,
                                    ),
                                    onPressed: () {
                                      print('Share pressed ...');
                                    },
                                  ),
                                  Text(
                                    '15',
                                    style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
